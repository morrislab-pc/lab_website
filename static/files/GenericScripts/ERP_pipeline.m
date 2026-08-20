%% =========================================================================
%  ERP_pipeline.m
%  General EEGLAB/ERPLAB preprocessing pipeline:
%  load .set → filter → bad channels → ICA → interpolate → epoch →
%  artifact rejection → average
%
%  Supports two acquisition configurations:
%    hc = Hampshire College montage
%    pc = Providence College montage
%  StudyID, TaskID, subject list, BDF, epoch parameters, and artifact
%  thresholds are supplied at runtime.
%
%  Starting point: subjID_taskID.set  (unfiltered continuous EEG)
%  Expected location: DATA/subjID/subjID_taskID.set
%
%  Prerequisites: create the montage-specific .ced file(s) once:
%    M21_Hampshire_32ch.ced  for Hampshire (hc)
%    M21_PC_31ch.ced         for Providence (pc)
%
%  Outputs
%  -------
%    <studyID>_<taskID>_pipeline_log.txt     — per-subject processing log
%    <studyID>_<taskID>_ICA_log.csv          — ICA components removed per subject
%    <studyID>_<taskID>_removed_channels.txt — bad channels per subject
%    <studyID>_<taskID>_trial_counts.csv     — accepted trials per condition
%    <studyID>_<taskID>_summary_stats.txt    — means/ranges for Methods section
%
%  Requires: EEGLAB with ERPLAB plug-in, ICLabel plug-in
%  Tested with: EEGLAB 2024.x, ERPLAB 10.x
% =========================================================================

%% -------------------------------------------------------------------------
%  0. Housekeeping
% -------------------------------------------------------------------------
clear; clc;
[ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;
ALLERP     = buildERPstruct([]);
CURRENTERP = 0;

%% -------------------------------------------------------------------------
%  1. Single dialog — collect all parameters up front
% -------------------------------------------------------------------------
prompt = { ...
    'StudyID:', ...
    'TaskID (leave blank if none):', ...
    'Data collection location (pc | hc):', ...
    'Subject list file (one ID per line):', ...
    'Bin descriptor file (BDF, full filename):', ...
    'Downsample to (Hz):', ...
    'Epoch window (ms), e.g.  -200 1000:', ...
    'Artifact-rejection threshold (µV), e.g.  100:', ...
    'Artifact-rejection window (ms), e.g.  -100 600:', ...
    'EEGLAB directory (folder containing sample_locs/):'};
dlgtitle = 'Pipeline parameters';
dims     = [1 72];
definput = { ...
    '', '', 'hc', 'subjectlist.txt', 'BDF.txt', ...
    '200', '-200 1000', '100', '-100 600', '/Users/jmorris/Documents/MATLAB/eeglab2024.2'};
my_input = inputdlg(prompt, dlgtitle, dims, definput);

if isempty(my_input)
    error('Pipeline cancelled by user.');
end

DIR      = pwd;
studyID  = strtrim(my_input{1});
taskID   = strtrim(my_input{2});
location = lower(strtrim(my_input{3}));
srate    = str2double(my_input{6});

epoch_vec  = str2num(my_input{7});  %#ok<ST2NM>
arj_thresh = str2double(my_input{8});
arj_win    = str2num(my_input{9});  %#ok<ST2NM>
eeglab_dir = strtrim(my_input{10});

if numel(epoch_vec) ~= 2 || numel(arj_win) ~= 2
    error('Epoch window and artifact window must each be two numbers.');
end
if isnan(srate) || srate <= 0
    error('Downsample rate must be a positive number.');
end

subj_list = importdata(strtrim(my_input{4}));
nsubj     = length(subj_list);
bdf_file  = fullfile(DIR, strtrim(my_input{5}));

if ~isfile(bdf_file)
    error('Bin descriptor file not found: %s', bdf_file);
end

%% Location-dependent settings

if strcmp(location, 'hc')

    % Hampshire College:
    % 27 scalp EEG + 5 mastoid/EOG = 32 total channels
    chan_num = 32;

    chan_locs_file = fullfile( ...
        eeglab_dir, ...
        'sample_locs', ...
        'M21_Hampshire_32ch.ced');

    reref_file = fullfile( ...
        DIR, ...
        'reref_eq_brainvision_hampshire.txt');

elseif strcmp(location, 'pc')

    % Providence College:
    % 31 scalp EEG channels
    chan_num = 31;

    chan_locs_file = fullfile( ...
        eeglab_dir, ...
        'sample_locs', ...
        'M21_PC_31ch.ced');

    reref_file = fullfile( ...
        DIR, ...
        'reref_eq_pchpl.txt');

else

    error( ...
        'Unknown data collection location "%s". Use "hc" or "pc".', ...
        location);

end

%% Verify required files exist

if ~isfile(chan_locs_file)
    error( ...
        'Channel locations file not found:\n  %s', ...
        chan_locs_file);
end

if ~isfile(reref_file)
    error( ...
        'Re-reference file not found:\n  %s', ...
        reref_file);
end

%% Filename prefix used in every output file
if isempty(taskID)
    task_pfx = '';
else
    task_pfx = ['_' taskID];
end
study_tag = [studyID task_pfx];

%% -------------------------------------------------------------------------
%  2. Open output files
% -------------------------------------------------------------------------
log_fname   = fullfile(DIR, [study_tag '_pipeline_log.txt']);
chan_fname   = fullfile(DIR, [study_tag '_removed_channels.txt']);
trial_fname  = fullfile(DIR, [study_tag '_trial_counts.csv']);

fid_log   = fopen(log_fname,  'w');
fid_chan  = fopen(chan_fname,  'w');
fid_trial = fopen(trial_fname, 'w');

if any([fid_log fid_chan fid_trial] == -1)
    error('Could not open one or more output files for writing. Check folder permissions.');
end

fprintf(fid_log, 'Pipeline log — %s\n', study_tag);
fprintf(fid_log, 'Run: %s\n', datestr(now));
fprintf(fid_log, 'Location: %s   Channels: %d   Srate: %d Hz\n', ...
    location, chan_num, srate);
fprintf(fid_log, 'Epoch: [%d %d] ms   ARJ threshold: +/-%d uV   ARJ window: [%d %d] ms\n\n', ...
    epoch_vec(1), epoch_vec(2), arj_thresh, arj_win(1), arj_win(2));

fprintf(fid_chan, 'Bad-channel removal log — %s\n', study_tag);
fprintf(fid_chan, 'Run: %s\n\n', datestr(now));

%% -------------------------------------------------------------------------
%  3. Initialise accumulators
% -------------------------------------------------------------------------
ICA_log = table( ...
    strings(nsubj, 1), ...
    nan(nsubj, 1), ...
    strings(nsubj, 1), ...
    'VariableNames', {'Subject', 'N_Removed_ICs', 'Status'});

trial_header_written = false;
bin_labels           = {};
ica_removed_vec      = nan(nsubj, 1);
all_trial_counts     = [];

%% =========================================================================
%  MAIN SUBJECT LOOP
%
%  Suffix chain built up across stages:
%    (none) = loaded from subjID_taskID.set
%    _FLT   = band-pass filtered
%    _RSP   = resampled
%    _REF   = re-referenced
%    _ELS   = event list created
%    _BIN   = bins assigned
%    _CLN   = bad channels removed (automated)
%    _ICA   = ICA artefact components removed
%    _INT   = bad channels interpolated
%    _EPC   = epoched
%    _ARJ   = artifact-rejected epochs flagged
% =========================================================================

%% -------------------------------------------------------------------------
%  Pre-flight check: verify channel locations file exists.
% -------------------------------------------------------------------------
if ~isfile(chan_locs_file)
    fclose(fid_log); fclose(fid_chan); fclose(fid_trial);
    error('Channel locations file not found:\n  %s\nCreate the appropriate HC or PC .ced file first.', ...
        chan_locs_file);
end
fprintf('Pre-flight check passed: channel locations file found.\n');

for subject = 1:nsubj

    subjID      = strtrim(subj_list{subject});
    subject_DIR = fullfile(DIR, 'DATA', subjID);

    fprintf('\n\n==============================\n');
    fprintf('Subject %d / %d : %s\n', subject, nsubj, subjID);
    fprintf('==============================\n');
    fprintf(fid_log, '\n--- Subject %s ---\n', subjID);

    ICA_log.Subject(subject) = string(subjID);

    % ------------------------------------------------------------------
    %  Check starting .set/.fdt files exist
    %  Expected: DATA/subjID/subjID_taskID.set
    % ------------------------------------------------------------------
    fname_base = [subjID task_pfx];          
    fname_set  = [fname_base '.set'];
    fname_fdt  = [fname_base '.fdt'];

    if ~isfile(fullfile(subject_DIR, fname_set)) || ...
       ~isfile(fullfile(subject_DIR, fname_fdt))
        fprintf(' *** WARNING: %s or .fdt not found — skipping %s ***\n', fname_set, subjID);
        fprintf(fid_log, '  SKIPPED — %s or .fdt not found\n', fname_set);
        ICA_log.Status(subject) = "skipped - set file missing";
        continue
    end

    % ------------------------------------------------------------------
    %  Load starting .set file
    % ------------------------------------------------------------------
    fprintf('\n-- Loading %s --\n', fname_set);
    EEG = pop_loadset('filename', fname_set, 'filepath', subject_DIR);

    % Verify that the selected recording site matches the loaded dataset.
    if EEG.nbchan ~= chan_num
        error(['Subject %s: channel-count mismatch. Location "%s" expects ' ...
               '%d channels, but the loaded dataset contains %d.'], ...
               subjID, location, chan_num, EEG.nbchan);
    end

    EEG.setname = fname_base;
    EEG.datfile = fname_fdt;
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET, ...
        'setname', EEG.setname, ...
        'gui', 'off');
    eeglab redraw;
    fprintf(fid_log, '  Loaded: %s\n', fname_set);

    % ------------------------------------------------------------------
    %  STAGE 2: Filter -> Resample -> Channel locations -> Re-reference
    %           -> Event list -> Bin list
    % ------------------------------------------------------------------
    fprintf('\n-- Stage 2: Filter / resample / ref / bins --\n');

    % Band-pass filter (0.1-30 Hz, 4th-order Butterworth, DC removed)
    EEG = pop_basicfilter(EEG, 1:chan_num, ...
        'Boundary', 'boundary', ...
        'Cutoff',   [0.1 30], ...
        'Design',   'butter', ...
        'Filter',   'bandpass', ...
        'Order',    4, ...
        'RemoveDC', 'on');
    EEG.setname = [fname_base '_FLT'];
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET, ...
        'setname', EEG.setname, ...
        'save', fullfile(subject_DIR, [EEG.setname '.set']), ...
        'gui', 'off');

    % Downsample
    EEG = pop_resample(EEG, srate);
    EEG.setname = [fname_base '_FLT_RSP'];
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET, ...
        'setname', EEG.setname, ...
        'save', fullfile(subject_DIR, [EEG.setname '.set']), ...
        'gui', 'off');

    % Channel locations — must be added before pop_clean_rawdata (Stage 3)
    % Uses the montage-specific .ced file selected for HC or PC above.
    EEG = pop_chanedit(EEG, 'lookup', chan_locs_file);
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET, ...
        'setname', EEG.setname, ...
        'save', fullfile(subject_DIR, [EEG.setname '.set']), ...
        'gui', 'off');

    % Re-reference
    EEG = pop_eegchanoperator(EEG, reref_file, 'Saveas', 'off');
    EEG.setname = [fname_base '_FLT_RSP_REF'];
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET, ...
        'setname', EEG.setname, ...
        'save', fullfile(subject_DIR, [EEG.setname '.set']), ...
        'gui', 'off');

    % Create event list
    EEG = pop_creabasiceventlist(EEG, ...
        'AlphanumericCleaning', 'on', ...
        'BoundaryNumeric',      {-99}, ...
        'BoundaryString',       {'boundary'}, ...
        'Eventlist', fullfile(subject_DIR, [fname_base '_ELS.txt']));
    EEG.setname = [fname_base '_FLT_RSP_REF_ELS'];
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET, ...
        'setname', EEG.setname, ...
        'save', fullfile(subject_DIR, [EEG.setname '.set']), ...
        'gui', 'off');

    % Assign bins
    EEG = pop_binlister(EEG, ...
        'BDF',       bdf_file, ...
        'ExportEL',  fullfile(subject_DIR, [fname_base '_ELS_BIN.txt']), ...
        'IndexEL',   1, ...
        'SendEL2',   'EEG&Text', ...
        'UpdateEEG', 'on', ...
        'Voutput',   'EEG');
    EEG.setname = [fname_base '_FLT_RSP_REF_ELS_BIN'];
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET, ...
        'setname', EEG.setname, ...
        'save', fullfile(subject_DIR, [EEG.setname '.set']), ...
        'gui', 'off');
    eeglab redraw;
    fprintf(fid_log, '  Stage 2 done: filter / resample / ref / bins\n');

    % ------------------------------------------------------------------
    %  STAGE 3: Automated bad-channel removal
    %
    %  Uses the montage-specific channel-location file selected above.
    %
    %  Hampshire:
    %    channels 1-27 have scalp coordinates;
    %    channels 28-32 are mastoid/EOG channels without scalp coordinates.
    %
    %  Providence:
    %    all 31 channels are scalp EEG channels with coordinates.
    %
    %  BurstCriterion and WindowCriterion are off, so no time segments are
    %  removed at this stage.
    % ------------------------------------------------------------------
    fprintf('\n-- Stage 3: Automated bad-channel removal --\n');
    
    % Save authoritative channel order before bad-channel removal.
    % eeg_interp may append restored channels rather than returning them
    % to their original array positions.
    original_chanlocs = EEG.chanlocs;
    original_labels   = {EEG.chanlocs.labels};

    EEG = pop_clean_rawdata(EEG, ...
        'FlatlineCriterion',  15, ...
        'ChannelCriterion',   0.65, ...
        'LineNoiseCriterion', 7, ...
        'Highpass',           'off', ...
        'BurstCriterion',     'off', ...
        'WindowCriterion',    'off', ...
        'BurstRejection',     'off', ...
        'Distance',           'Euclidian');


    EEG.setname = [fname_base '_FLT_RSP_REF_ELS_BIN_CLN'];
    EEG = pop_saveset(EEG, ...
        'filename', [EEG.setname '.set'], ...
        'filepath', subject_DIR);
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET, ...
        'setname', EEG.setname, 'gui', 'off');

    % Log removed channels
    fprintf(fid_chan, 'Subject: %s\n', subjID);
    if isfield(EEG, 'etc') && isfield(EEG.etc, 'clean_channel_mask')
        bad_idx = find(~EEG.etc.clean_channel_mask);
        if isempty(bad_idx)
            fprintf(fid_chan, '  No channels removed.\n\n');
            fprintf(fid_log,  '  Stage 3: no channels removed\n');
        else
            has_rc = isfield(EEG, 'chaninfo') && ...
                     isfield(EEG.chaninfo, 'removedchans') && ...
                     isstruct(EEG.chaninfo.removedchans) && ...
                     ~isempty(EEG.chaninfo.removedchans);
            for ci = 1:length(bad_idx)
                if has_rc && ci <= length(EEG.chaninfo.removedchans)
                    lbl = EEG.chaninfo.removedchans(ci).labels;
                else
                    lbl = '(label unavailable)';
                end
                fprintf(fid_chan, '  Removed ch %d: %s\n', bad_idx(ci), lbl);
            end
            fprintf(fid_chan, '\n');
            fprintf(fid_log, '  Stage 3: removed %d channel(s)\n', length(bad_idx));
        end
    else
        fprintf(fid_chan, '  clean_channel_mask not found — inspect manually.\n\n');
        fprintf(fid_log,  '  Stage 3: clean_channel_mask unavailable\n');
    end
    eeglab redraw;

    % ------------------------------------------------------------------
    %  STAGE 4: ICA
    %  Decompose with runica (extended mode), classify with ICLabel,
    %  flag components: muscle >= 0.90, eye >= 0.90, line noise >= 0.90
    % ------------------------------------------------------------------
    fprintf('\n-- Stage 4: ICA --\n');

    EEG = pop_runica(EEG, ...
        'icatype',   'runica', ...
        'extended',  1, ...
        'rndreset',  'yes', ...
        'interrupt', 'on');

    EEG = pop_iclabel(EEG, 'default');

    EEG = pop_icflag(EEG, ...
        [NaN NaN; ...   % Brain       — keep all
         0.90  1; ...   % Muscle      — remove if p >= 0.90
         0.90  1; ...   % Eye         — remove if p >= 0.90
         NaN NaN; ...   % Heart       — keep
         0.90  1; ...   % Line noise  — remove if p >= 0.90
         NaN NaN; ...   % Channel noise
         NaN NaN]);     % Other

    rejected_ICs = find(EEG.reject.gcompreject);
    n_removed    = length(rejected_ICs);

    ICA_log.N_Removed_ICs(subject) = n_removed;
    ICA_log.Status(subject)        = "processed";
    ica_removed_vec(subject)       = n_removed;

    fprintf('  %d ICA component(s) removed\n', n_removed);
    if n_removed > 0
        ic_str = strjoin(arrayfun(@num2str, rejected_ICs, 'UniformOutput', false), ', ');
    else
        ic_str = 'none';
    end
    fprintf(fid_log, '  Stage 4: %d component(s) removed (%s)\n', n_removed, ic_str);

    EEG = pop_subcomp(EEG, rejected_ICs, 0);
    EEG.setname = [fname_base '_FLT_RSP_REF_ELS_BIN_CLN_ICA'];
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET, ...
        'setname', EEG.setname, ...
        'save', fullfile(subject_DIR, [EEG.setname '.set']), ...
        'gui', 'off');
    eeglab redraw;

% ------------------------------------------------------------------
% STAGE 5: Interpolate channels removed in Stage 3
%          and restore original channel order
% ------------------------------------------------------------------

fprintf('\n-- Stage 5: Interpolation --\n');

if isfield(EEG, 'chaninfo') && ...
        isfield(EEG.chaninfo, 'removedchans') && ...
        isstruct(EEG.chaninfo.removedchans) && ...
        ~isempty(EEG.chaninfo.removedchans)

    n_interp = length(EEG.chaninfo.removedchans);

    fprintf('  Interpolating %d removed channel(s)\n', n_interp);
    fprintf(fid_log, ...
        '  Stage 5: interpolating %d channel(s)\n', n_interp);

    EEG = eeg_interp( ...
        EEG, ...
        EEG.chaninfo.removedchans, ...
        'spherical');

else

    fprintf('  No removed channels — skipping interpolation\n');
    fprintf(fid_log, ...
        '  Stage 5: no interpolation needed\n');

end

% Restore original channel order by label.
current_labels = {EEG.chanlocs.labels};

reorder = zeros(1, length(original_labels));

for i = 1:length(original_labels)

    idx = find(strcmpi( ...
        current_labels, ...
        original_labels{i}));

    if isempty(idx)
        error( ...
            'Subject %s: channel "%s" missing after interpolation.', ...
            subjID, original_labels{i});
    end

    if length(idx) > 1
        error( ...
            'Subject %s: duplicate channel label "%s".', ...
            subjID, original_labels{i});
    end

    reorder(i) = idx;
end

EEG.data     = EEG.data(reorder, :);
EEG.chanlocs = original_chanlocs;
EEG.nbchan   = length(original_chanlocs);

fprintf('  Channel order restored to original montage.\n');
fprintf(fid_log, ...
    '  Stage 5: channel order restored to original montage\n');

EEG.setname = ...
    [fname_base '_FLT_RSP_REF_ELS_BIN_CLN_ICA_INT'];

[ALLEEG, EEG, CURRENTSET] = pop_newset( ...
    ALLEEG, EEG, CURRENTSET, ...
    'setname', EEG.setname, ...
    'save', fullfile( ...
        subject_DIR, ...
        [EEG.setname '.set']), ...
    'gui', 'off');

eeglab redraw;

    % ------------------------------------------------------------------
    %  STAGE 6: Epoch -> Artifact rejection -> Average
    % ------------------------------------------------------------------
    fprintf('\n-- Stage 6: Epoch / artifact rejection / average --\n');

    % Epoch and apply prestimulus baseline correction
    EEG = pop_epochbin(EEG, epoch_vec, 'pre');
    EEG.setname = [fname_base '_FLT_RSP_REF_ELS_BIN_CLN_ICA_INT_EPC'];
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET, ...
        'setname', EEG.setname, ...
        'save', fullfile(subject_DIR, [EEG.setname '.set']), ...
        'gui', 'off');
    eeglab redraw;

    % ------------------------------------------------------------------
    % Artifact rejection — amplitude threshold on scalp EEG channels only
    %
    % Hampshire:
    %   channels 1-27  = scalp EEG
    %   channels 28-32 = Mastoid R/L, HEOG R/L, VEOG L
    %
    % Providence:
    %   channels 1-31  = scalp EEG
    % ------------------------------------------------------------------

    if strcmp(location, 'hc')
        arj_channels = 1:27;
    elseif strcmp(location, 'pc')
        arj_channels = 1:31;
    else
        error('Unknown data collection location: %s', location);
    end

    fprintf('  Artifact rejection channels: %s\n', mat2str(arj_channels));
    fprintf(fid_log, ...
        '  Stage 6 artifact rejection channels: %s\n', ...
        mat2str(arj_channels));

    EEG = pop_artextval(EEG, ...
        'Channel',   arj_channels, ...
        'Flag',      1, ...
        'LowPass',  -1, ...
        'Threshold', [-arj_thresh arj_thresh], ...
        'Twindow',   arj_win);

    EEG.setname = [fname_base '_FLT_RSP_REF_ELS_BIN_CLN_ICA_INT_EPC_ARJ'];
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET, ...
        'setname', EEG.setname, ...
        'save', fullfile(subject_DIR, [EEG.setname '.set']), ...
        'gui', 'off');

    % Artifact summary to text file
    EEG = pop_summary_AR_eeg_detection(EEG, ...
        fullfile(subject_DIR, [subjID task_pfx '_ARJ_SUM.txt']));
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET, ...
        'setname', EEG.setname, ...
        'save', fullfile(subject_DIR, [EEG.setname '.set']), ...
        'gui', 'off');
    eeglab redraw;

    % Average — good epochs only, include SEM
    ERP = pop_averager(EEG, ...
        'Criterion',       'good', ...
        'ExcludeBoundary', 'on', ...
        'SEM',             'on');

    ERP.erpname = [subjID task_pfx];
    pop_savemyerp(ERP, ...
        'erpname',  ERP.erpname, ...
        'filename', [ERP.erpname '.erp'], ...
        'filepath', subject_DIR, ...
        'warning',  'off');

    CURRENTERP         = CURRENTERP + 1;
    ALLERP(CURRENTERP) = ERP;
    eeglab redraw;
    erplab redraw;

    % ------------------------------------------------------------------
    %  Collect trial counts per bin
    % ------------------------------------------------------------------
    if isfield(ERP, 'ntrials') && isfield(ERP.ntrials, 'accepted')
        counts = ERP.ntrials.accepted;   % 1 x nBins

        % Accumulate for summary statistics
        if isempty(all_trial_counts)
            all_trial_counts = counts;
        else
            all_trial_counts = [all_trial_counts; counts]; %#ok<AGROW>
        end

        % Write CSV header from first valid subject's bin descriptions
        if ~trial_header_written
            if isfield(ERP, 'bindescr') && ~isempty(ERP.bindescr)
                bin_labels = ERP.bindescr;
            else
                bin_labels = arrayfun(@(b) sprintf('Bin%d', b), ...
                    1:length(counts), 'UniformOutput', false);
            end
            fprintf(fid_trial, 'Subject');
            fprintf(fid_trial, ',%s', bin_labels{:});
            fprintf(fid_trial, '\n');
            trial_header_written = true;
        end

        fprintf(fid_trial, '%s', subjID);
        fprintf(fid_trial, ',%d', counts);
        fprintf(fid_trial, '\n');

        fprintf(fid_log, '  Stage 6: accepted trials per bin: %s\n', num2str(counts));
    else
        fprintf(fid_log, '  Stage 6: ntrials.accepted not available\n');
    end

    fprintf(fid_log, '  COMPLETED\n');

end  % subject loop

%% =========================================================================
%  Post-loop: write ICA log and summary statistics
% =========================================================================

%% ICA log CSV
ica_log_fname = fullfile(DIR, [study_tag '_ICA_log.csv']);
writetable(ICA_log, ica_log_fname);
fprintf('\nICA log saved: %s\n', ica_log_fname);

%% Summary statistics (for the Methods section)
sum_fname = fullfile(DIR, [study_tag '_summary_stats.txt']);
fid_sum   = fopen(sum_fname, 'w');

fprintf(fid_sum, 'Summary statistics for Methods section\n');
fprintf(fid_sum, 'Study: %s   Task: %s\n', studyID, taskID);
fprintf(fid_sum, 'Run: %s\n\n', datestr(now));

% ICA
valid_ica = ica_removed_vec(~isnan(ica_removed_vec));
if ~isempty(valid_ica)
    fprintf(fid_sum, '--- ICA components removed ---\n');
    fprintf(fid_sum, '  N subjects: %d\n',    length(valid_ica));
    fprintf(fid_sum, '  Mean:  %.1f\n',        mean(valid_ica));
    fprintf(fid_sum, '  SD:    %.1f\n',        std(valid_ica));
    fprintf(fid_sum, '  Range: %d - %d\n\n',  min(valid_ica), max(valid_ica));
    fprintf('\nICA components removed: M = %.1f, SD = %.1f, range %d-%d\n', ...
        mean(valid_ica), std(valid_ica), min(valid_ica), max(valid_ica));
end

% Trial counts per bin
if ~isempty(all_trial_counts)
    fprintf(fid_sum, '--- Accepted trials per condition ---\n');
    for b = 1:size(all_trial_counts, 2)
        col = all_trial_counts(:, b);
        col = col(~isnan(col));
        if ~isempty(bin_labels)
            lbl = bin_labels{b};
        else
            lbl = sprintf('Bin %d', b);
        end
        fprintf(fid_sum, '  %s\n',              lbl);
        fprintf(fid_sum, '    N:     %d\n',     length(col));
        fprintf(fid_sum, '    Mean:  %.1f\n',   mean(col));
        fprintf(fid_sum, '    SD:    %.1f\n',   std(col));
        fprintf(fid_sum, '    Range: %d - %d\n', min(col), max(col));
    end
end

fclose(fid_sum);

%% Close all open output files
fclose(fid_log);
fclose(fid_chan);
fclose(fid_trial);

fprintf('\n\nAll output files written to: %s\n', DIR);
fprintf('  %s\n', log_fname);
fprintf('  %s\n', chan_fname);
fprintf('  %s\n', trial_fname);
fprintf('  %s\n', ica_log_fname);
fprintf('  %s\n', sum_fname);
fprintf('\nPipeline complete.\n');

%% =========================================================================
%  Run the appropriate downstream grand-average and measurement scripts
%  after reviewing individual ERPs and finalising subject inclusion.
% =========================================================================
