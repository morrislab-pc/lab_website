%% =========================================================================
%  ERP_grand_average.m
%
%  Creates a grand-average ERP from individual subject .erp files.
%
%  Expected directory structure:
%
%    PROJECT_ROOT/
%    └── DATA/
%        ├── S101/
%        ├── S102/
%        └── ...
%
%  Subject ERP filenames are assumed to follow:
%
%    SubjID[_TaskID][_Extension].erp
%
%  Examples:
%
%    S101.erp
%    S101_VSL2.erp
%    S101_VSL2_binop.erp
%
%  Run after reviewing individual ERPs and finalising the subject list.
%
%  Output:
%    <GrandAverageName>.erp
%
%  Requires: EEGLAB with ERPLAB
% =========================================================================

clear; clc;

%% Start EEGLAB / ERPLAB
[ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;
ALLERP     = buildERPstruct([]);
CURRENTERP = 0;

%% -------------------------------------------------------------------------
%  Collect parameters
% -------------------------------------------------------------------------

prompt = { ...
    'StudyID (optional; used only for documentation):', ...
    'TaskID (leave blank if none):', ...
    'Subject list file:', ...
    'ERP filename extension after subject/task IDs (leave blank if none):', ...
    'Grand-average output name (no extension):'};

dlgtitle = 'Grand average parameters';
dims     = [1 72];

definput = { ...
    '', ...
    '', ...
    'subjectlist.txt', ...
    '', ...
    'Grand_Average'};

my_input = inputdlg(prompt, dlgtitle, dims, definput);

if isempty(my_input)
    error('Grand-average creation cancelled by user.');
end

DIR             = pwd;
studyID         = strtrim(my_input{1});
taskID          = strtrim(my_input{2});
subj_list_fname = strtrim(my_input{3});
erp_ext         = strtrim(my_input{4});
ga_name         = strtrim(my_input{5});

%% -------------------------------------------------------------------------
%  Validate inputs
% -------------------------------------------------------------------------

if ~isfile(subj_list_fname)
    error('Subject list file not found: %s', subj_list_fname);
end

if isempty(ga_name)
    error('Grand-average output name cannot be blank.');
end

subj_list = importdata(subj_list_fname);

if ischar(subj_list)
    subj_list = cellstr(subj_list);
end

nsubj = length(subj_list);

if nsubj == 0
    error('Subject list is empty: %s', subj_list_fname);
end

%% -------------------------------------------------------------------------
%  Build optional filename suffixes
% -------------------------------------------------------------------------

if isempty(taskID)
    task_pfx = '';
else
    task_pfx = ['_' taskID];
end

if isempty(erp_ext)
    erp_sfx = '';
else
    erp_sfx = ['_' erp_ext];
end

%% -------------------------------------------------------------------------
%  Load individual ERP files
% -------------------------------------------------------------------------

valid_erpsets   = [];
loaded_subjects = {};
missing_subjects = {};

fprintf('\n========================================\n');
fprintf('Grand-average setup\n');
fprintf('========================================\n');

if ~isempty(studyID)
    fprintf('StudyID: %s\n', studyID);
end

if isempty(taskID)
    fprintf('TaskID: [none]\n');
else
    fprintf('TaskID: %s\n', taskID);
end

if isempty(erp_ext)
    fprintf('ERP extension: [none]\n');
else
    fprintf('ERP extension: %s\n', erp_ext);
end

fprintf('Subject list: %s\n\n', subj_list_fname);

for subject = 1:nsubj

    subjID      = strtrim(subj_list{subject});
    subject_DIR = fullfile(DIR, 'DATA', subjID);

    fname = [subjID task_pfx erp_sfx '.erp'];
    fpath = fullfile(subject_DIR, fname);

    if ~isfile(fpath)
        fprintf(' *** WARNING: %s not found — skipping %s ***\n', ...
            fpath, subjID);
        missing_subjects{end+1} = subjID; %#ok<AGROW>
        continue
    end

    fprintf('Loading %s\n', fname);

    ERP = pop_loaderp( ...
        'filename', fname, ...
        'filepath', subject_DIR);

    CURRENTERP         = CURRENTERP + 1;
    ALLERP(CURRENTERP) = ERP;

    valid_erpsets(end+1)   = CURRENTERP; %#ok<AGROW>
    loaded_subjects{end+1} = subjID;      %#ok<AGROW>
end

%% -------------------------------------------------------------------------
%  Verify that at least one ERP was loaded
% -------------------------------------------------------------------------

if isempty(valid_erpsets)
    error('No valid ERP files were found.');
end

fprintf('\nLoaded %d of %d requested subjects.\n', ...
    length(valid_erpsets), nsubj);

if ~isempty(missing_subjects)
    fprintf('Missing/skipped subjects: %s\n', ...
        strjoin(missing_subjects, ', '));
end

%% -------------------------------------------------------------------------
%  Create grand average
% -------------------------------------------------------------------------

fprintf('\nCreating grand average from %d ERP sets...\n', ...
    length(valid_erpsets));

ERP = pop_gaverager(ALLERP, ...
    'Erpsets',   valid_erpsets, ...
    'Criterion', 100, ...
    'SEM',       'on', ...
    'Warning',   'on', ...
    'Weighted',  'on');

%% -------------------------------------------------------------------------
%  Save grand average
% -------------------------------------------------------------------------

ERP = pop_savemyerp(ERP, ...
    'erpname',  ga_name, ...
    'filename', [ga_name '.erp'], ...
    'filepath', DIR, ...
    'Warning',  'on');

CURRENTERP         = CURRENTERP + 1;
ALLERP(CURRENTERP) = ERP;

erplab redraw;

fprintf('\nGrand average complete.\n');
fprintf('Subjects included: %d\n', length(valid_erpsets));
fprintf('Saved: %s\n', fullfile(DIR, [ga_name '.erp']));
