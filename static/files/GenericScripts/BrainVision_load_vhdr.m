%% =========================================================================
%  BrainVision_load_vhdr.m
%
%  Batch-imports BrainVision EEG recordings into EEGLAB and saves each
%  recording as an EEGLAB .set/.fdt dataset.
%
%  Expected directory structure:
%
%    PROJECT_ROOT/
%    └── DATA/
%        ├── S101/
%        ├── S102/
%        └── ...
%
%  Raw filenames may contain any combination of:
%
%    StudyID_SubjID_TaskID_Datatype
%
%  Empty components are omitted automatically.
%
%  Examples:
%
%    S101.vhdr
%    S101_VSL2.vhdr
%    M21_S101_VSL2.vhdr
%    M21_S101_VSL2_EEG.vhdr
%
%  The saved EEGLAB dataset is always named:
%
%    SubjID_TaskID.set
%
%  or, if TaskID is blank:
%
%    SubjID.set
% =========================================================================

clear; clc;

%% Start EEGLAB
[ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;

%% -------------------------------------------------------------------------
%  Collect parameters
% -------------------------------------------------------------------------

prompt = { ...
    'StudyID (leave blank if none):', ...
    'TaskID (leave blank if none):', ...
    'Datatype (leave blank if none):', ...
    'Subject list file:'};

dlgtitle = 'BrainVision import parameters';
dims     = [1 70];

definput = {'', '', '', 'subjectlist.txt'};

my_input = inputdlg(prompt, dlgtitle, dims, definput);

if isempty(my_input)
    error('Import cancelled by user.');
end

DIR = pwd;

studyID        = strtrim(my_input{1});
taskID         = strtrim(my_input{2});
datatype       = strtrim(my_input{3});
subj_list_file = strtrim(my_input{4});

%% -------------------------------------------------------------------------
%  Load subject list
% -------------------------------------------------------------------------

if ~isfile(subj_list_file)
    error('Subject list file not found: %s', subj_list_file);
end

subj_list = importdata(subj_list_file);
nsubj     = length(subj_list);

%% =========================================================================
%  SUBJECT LOOP
% =========================================================================

for subject = 1:nsubj

    subjID = strtrim(subj_list{subject});

    fprintf('\n==============================\n');
    fprintf('Subject %d / %d : %s\n', subject, nsubj, subjID);
    fprintf('==============================\n');

    subject_DIR = fullfile(DIR, 'DATA', subjID);

    %% ---------------------------------------------------------------------
    %  Construct BrainVision filename
    %
    %  Raw filename components are assembled in this order:
    %
    %    StudyID_SubjID_TaskID_Datatype
    %
    %  Empty components are omitted.
    % ----------------------------------------------------------------------

    name_parts = {};

    if ~isempty(studyID)
        name_parts{end+1} = studyID;
    end

    name_parts{end+1} = subjID;

    if ~isempty(taskID)
        name_parts{end+1} = taskID;
    end

    if ~isempty(datatype)
        name_parts{end+1} = datatype;
    end

    fname_base = strjoin(name_parts, '_');

    fname_vhdr = [fname_base '.vhdr'];
    fname_vmrk = [fname_base '.vmrk'];
    fname_eeg  = [fname_base '.eeg'];

    %% ---------------------------------------------------------------------
    %  Verify all BrainVision files exist
    % ----------------------------------------------------------------------

    missing_files = {};

    if ~isfile(fullfile(subject_DIR, fname_vhdr))
        missing_files{end+1} = fname_vhdr;
    end

    if ~isfile(fullfile(subject_DIR, fname_vmrk))
        missing_files{end+1} = fname_vmrk;
    end

    if ~isfile(fullfile(subject_DIR, fname_eeg))
        missing_files{end+1} = fname_eeg;
    end

    if ~isempty(missing_files)

        fprintf(' *** WARNING: missing BrainVision file(s):\n');

        for m = 1:length(missing_files)
            fprintf('     %s\n', missing_files{m});
        end

        fprintf(' *** Skipping %s ***\n', subjID);

        continue
    end

    %% ---------------------------------------------------------------------
    %  Import BrainVision recording
    % ----------------------------------------------------------------------

    fprintf('Loading %s\n', fname_vhdr);

    EEG = pop_loadbv(subject_DIR, fname_vhdr);

    %% ---------------------------------------------------------------------
    %  Set EEGLAB dataset name
    %
    %  StudyID and datatype describe the raw filename but are deliberately
    %  not included in the processed dataset name.
    % ----------------------------------------------------------------------

    if isempty(taskID)
        EEG.setname = subjID;
    else
        EEG.setname = [subjID '_' taskID];
    end

    %% ---------------------------------------------------------------------
    %  Save EEGLAB dataset
    % ----------------------------------------------------------------------

    [ALLEEG, EEG, CURRENTSET] = pop_newset( ...
        ALLEEG, EEG, CURRENTSET, ...
        'setname', EEG.setname, ...
        'save', fullfile(subject_DIR, [EEG.setname '.set']), ...
        'gui', 'off');

    eeglab redraw;

    fprintf('Saved: %s\n', ...
        fullfile(subject_DIR, [EEG.setname '.set']));

end

erplab redraw;

fprintf('\nBrainVision import complete.\n');