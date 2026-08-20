# General EEG/ERP Processing Pipeline

## Purpose

This README documents the general BrainVision → EEGLAB → ERPLAB workflow for studies collected using the supported Hampshire College (`hc`) and Providence College (`pc`) EEG configurations.

The recommended preprocessing script for new processing is:

`ERP_pipeline.m`

The older `M21_VSL2_pipeline.m` should be retained as a legacy/version-1 script for reproducibility. Its bad-channel procedure is hard-coded around the Hampshire montage and should not be used for Providence data without modification.

---

## 1. Recommended workflow

```text
ONE-TIME SETUP
    Create montage-specific channel-location files
        Hampshire:  M21_Hampshire_32ch.ced
        Providence: M21_PC_31ch.ced
                  |
                  v
RAW BRAINVISION DATA
    .vhdr + .vmrk + .eeg
                  |
                  v
M21_VSL2_load_vhdr.m
                  |
                  v
CONTINUOUS EEGLAB DATA
    Sxxx_VSL2.set + Sxxx_VSL2.fdt
                  |
                  v
ERP_pipeline.m
                  |
                  v
SUBJECT ERP
    Sxxx_VSL2.erp
                  |
          +-------+-------+
          |               |
          v               v
      QC review     M21_VSL2_arj_from_log.m
          |               |
          +-------+-------+
                  |
                  v
Finalize preprocessing/exclusion decisions
                  |
                  v
channel order is restored inside `ERP_pipeline.m`
                  |
                  v
task-specific bin operations, if required
                  |
                  v
Sxxx_VSL2_binop.erp
                  |
          optional final
          channel-order check
                  |
          +-------+-------+
          |               |
          v               v
M21_grand_average.m   M21_measure_amp.m
          |               |
          v               v
   group ERP       long-format CSV
                          |
                          v
                       R/lme4
```

Do not run `M21_VSL2_pipeline.m` and `ERP_pipeline.m` sequentially. They are alternative preprocessing pipelines.

---

## 2. Software requirements

MATLAB with:

- EEGLAB
- ERPLAB
- BrainVision import support (`pop_loadbv`)
- clean_rawdata
- ICLabel
- EEGLAB `sample_locs` directory

The pipeline was written for EEGLAB 2024.x and ERPLAB 10.x.

---

## 3. Project directory structure

The main processing scripts assume MATLAB's current directory is the project root:

```text
PROJECT_ROOT/
├── ERP_pipeline.m
├── study/task-specific utility scripts as needed
│
├── BDF.txt                         # or another user-selected BDF filename
├── reref_eq_brainvision_hampshire.txt
├── reref_eq_pchpl.txt
├── subjectlist.txt                 # or another user-selected subject list
│
└── DATA/
    ├── S101/
    │   ├── S101_VSL2.vhdr
    │   ├── S101_VSL2.vmrk
    │   ├── S101_VSL2.eeg
    │   ├── S101_VSL2.set
    │   └── S101_VSL2.fdt
    ├── S102/
    └── ...
```

`ERP_pipeline.m` itself is study/task-generic. `StudyID`, `TaskID`, subject-list filename, BDF filename, downsample rate, epoch window, artifact threshold, and artifact window are entered at runtime. Study-specific downstream utilities such as bin-operation scripts may still have task-specific names or equations.

Subject-list files contain one subject ID per line:

```text
S101
S102
S103
```

---

## 4. EEG montages

### Hampshire College (`hc`)

32 channels total:

```text
1-27   scalp EEG
28     Mastoid R
29     Mastoid L
30     HEOG R
31     HEOG L
32     VEOG L
```

Canonical order:

```text
FP1 Fz F3 F7 FC5 FC1 C3 T7 CP5 CP1 Pz P3 P7 O1 O2
P4 P8 CP6 CP2 CZ C4 T8 FC6 FC2 F4 F8 FP2
Mastoid R Mastoid L HEOG R HEOG L VEOG L
```

Channel-location file:

```text
M21_Hampshire_32ch.ced
```

Rereference equation:

```text
reref_eq_brainvision_hampshire.txt
```

Scalp channels used for epoch-level artifact rejection:

```text
1:27
```

### Providence College (`pc`)

The Providence rereference equation outputs 31 named scalp EEG channels:

```text
Fp1 Fz F3 F7 FT9 FC5 FC1 C3 T7 TP9 CP5 CP1 Pz P3 P7
O1 Oz O2 P4 P8 CP6 CP2 Cz C4 T8 FT10 FC6 FC2 F4 F8 FP2
```

Channel-location file:

```text
M21_PC_31ch.ced
```

Rereference equation:

```text
reref_eq_pchpl.txt
```

Scalp channels used for epoch-level artifact rejection:

```text
1:31
```

---

## 5. One-time channel-location setup

### Hampshire

Use `M21_create_chan_locs.m` to create:

```text
M21_Hampshire_32ch.ced
```

The script maps the 27 scalp electrodes to EEGLAB standard 10-10 coordinates and retains the five mastoid/EOG channels without scalp coordinates.

Before running it, confirm the EEGLAB path, for example:

```matlab
eeglab_dir = '/Users/jmorris/Documents/MATLAB/eeglab2024.2';
```

The preferred output location is:

```text
<EEGLAB>/sample_locs/M21_Hampshire_32ch.ced
```

### Providence

Create the corresponding Providence location file:

```text
M21_PC_31ch.ced
```

using the 31-channel order listed above and standard EEGLAB 10-10 coordinates.

All 31 PC output channels are treated as scalp EEG channels.

The preferred location is:

```text
<EEGLAB>/sample_locs/M21_PC_31ch.ced
```

---

## 6. Required v2 pipeline location-selection code

`ERP_pipeline.m` should select the channel-location and rereference files according to the recording site.

The location-dependent section should be:

```matlab
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

if ~isfile(chan_locs_file)
    error('Channel locations file not found:\n  %s', chan_locs_file);
end

if ~isfile(reref_file)
    error('Re-reference file not found:\n  %s', reref_file);
end
```

This replaces any version of the script that always assigns `M21_Hampshire_32ch.ced` regardless of location.

### Recommended additional safeguard

After loading the starting `.set` file, verify that the selected location agrees with the number of channels in the recording:

```matlab
if EEG.nbchan ~= chan_num
    error(['Channel-count mismatch for %s: location "%s" expects %d ' ...
           'channels, but the loaded dataset contains %d.'], ...
           subjID, location, chan_num, EEG.nbchan);
end
```

This prevents a Hampshire dataset from accidentally being processed as PC, or vice versa.

---

## 7. Import BrainVision files

### Script

`M21_VSL2_load_vhdr.m`

BrainVision recordings consist of three linked files:

```text
S101_VSL2.vhdr
S101_VSL2.vmrk
S101_VSL2.eeg
```

Keep all three together.

The loader:

1. constructs the expected filenames;
2. verifies that `.vhdr`, `.vmrk`, and `.eeg` all exist;
3. imports the `.vhdr` with `pop_loadbv`;
4. assigns the EEGLAB dataset name;
5. saves the imported EEGLAB dataset.

### Important directory convention

The current loader uses:

```matlab
subject_DIR = [DIR filesep subjID];
```

whereas the main pipeline uses:

```matlab
subject_DIR = fullfile(DIR, 'DATA', subjID);
```

For a consistent project structure, the recommended change to the loader is:

```matlab
subject_DIR = fullfile(DIR, 'DATA', subjID);
```

After that change, run the loader from the M21 project root like the other scripts.

If the loader is left unchanged, it must instead be run from the directory immediately containing the subject folders (normally `M21/DATA/`).

### Filename parameters

The loader constructs raw filenames from `StudyID`, subject ID, `TaskID`, and `datatype`.

Check the actual raw filename before accepting the dialog defaults.

For raw files named:

```text
S101_VSL2.vhdr
S101_VSL2.vmrk
S101_VSL2.eeg
```

the appropriate filename components are approximately:

```text
StudyID:   [blank]
TaskID:    VSL2
datatype:  [blank]
```

Do not enter `M21` as StudyID unless the raw file itself is named with the `M21_` prefix.

### QC after import

Before batch preprocessing, inspect several imported datasets and confirm:

- expected channel count;
- expected channel labels/order;
- expected sampling rate;
- plausible recording duration;
- event markers are present;
- event codes are correct;
- `.set` and `.fdt` files are present.

---

## 8. Recommended preprocessing pipeline

### Script

`ERP_pipeline.m`

Use this generic version for new processing across studies that use one of the supported HC or PC acquisition configurations.

### Why v2 is preferred

The legacy `M21_VSL2_pipeline.m` works around missing coordinates in the Hampshire mastoid/EOG channels by temporarily reducing the dataset to channels 1–27 before bad-channel detection and then restoring channels 28–32.

That logic is Hampshire-specific. It is not appropriate for PC because PC channels 28–31 are genuine scalp electrodes.

The v2 pipeline instead uses `pop_clean_rawdata` directly on the appropriately defined montage and is therefore the appropriate architecture for supporting both recording sites.

Retain the older pipeline for provenance/reproducibility, but do not use it for new PC processing without rewriting its Stage 3 logic.

---

## 9. Runtime parameters

When `ERP_pipeline.m` starts, enter the parameters for the current study/task.

The generic defaults are intentionally neutral:

```text
StudyID:                    [blank]
TaskID:                     [blank]
Location:                   hc
Subject list:               subjectlist.txt
Bin descriptor file:        BDF.txt
Downsample:                 200 Hz
Epoch:                      -200 to 1000 ms
Artifact threshold:         ±100 µV
Artifact window:            -100 to 600 ms
```

Set `StudyID` and `TaskID` according to the files being processed. If `TaskID` is blank, the input filename is based on the subject ID alone. The subject-list and BDF filenames are also supplied at runtime, so the preprocessing script itself does not depend on M21 or VSL2.

## 10. Preprocessing stages


The v2 pipeline starts from:

```text
DATA/S101/S101_VSL2.set
DATA/S101/S101_VSL2.fdt
```

and performs the following stages.

### Stage 2: filter, resample, locations, rereference, and bins

Default filtering:

```text
0.1-30 Hz
4th-order Butterworth
DC removal on
```

Default resampling:

```text
200 Hz
```

The pipeline then:

1. attaches the location-appropriate `.ced` file;
2. applies the site-specific rereference equation;
3. creates an ERPLAB event list;
4. applies `M21_VSL2_BDF.txt`.

Intermediate suffixes include:

```text
_FLT
_RSP
_REF
_ELS
_BIN
```

### Stage 3: automated bad-channel detection

The v2 pipeline uses `pop_clean_rawdata`.

Current settings are:

```text
FlatlineCriterion       15
ChannelCriterion        0.65
LineNoiseCriterion      7
Highpass                off
BurstCriterion          off
WindowCriterion         off
BurstRejection          off
Distance                Euclidian
```

Because BurstCriterion and WindowCriterion are off, this stage is intended for automated bad-channel identification rather than ASR-based removal of time segments.

Removed channels are logged for later review and interpolation.

### Stage 4: ICA

The pipeline runs extended `runica` and then ICLabel.

Automatic IC rejection:

```text
Muscle       >= .90
Eye          >= .90
Line noise   >= .90
```

The supplied threshold matrix does not automatically reject Brain, Heart, Channel Noise, or Other components.

Rejected components are removed with `pop_subcomp`.

### Stage 5: interpolate rejected scalp channels

Channels removed during automated bad-channel detection are restored with spherical interpolation.

Interpolation is one reason channel order must be checked later: a restored channel may be appended rather than returned to its original index.

### Stage 6: epoch and artifact rejection

Default epoch:

```text
-200 to 1000 ms
```

Prestimulus baseline correction is applied by `pop_epochbin(...,'pre')`.

Default artifact-rejection criterion:

```text
Threshold:       ±100 µV
Window:          -100 to 600 ms
```

The current corrected channel selection is:

```matlab
if strcmp(location, 'hc')
    arj_channels = 1:27;
elseif strcmp(location, 'pc')
    arj_channels = 1:31;
else
    error('Unknown data collection location: %s', location);
end
```

Thus:

```text
HC: artifact rejection is based only on scalp channels 1-27.
PC: artifact rejection is based on all 31 scalp channels.
```

Mastoid/EOG channels in the HC recordings remain in the dataset but do not determine whether an epoch is rejected by the amplitude criterion.

The pipeline logs the channel indices used for artifact rejection.

### Stage 6: ERP average

Only good epochs are averaged.

Final subject ERP:

```text
DATA/S101/S101_VSL2.erp
```

---

## 11. Pipeline outputs and QC files

The pipeline produces study-level files including:

```text
<StudyID>_<TaskID>_pipeline_log.txt
<StudyID>_<TaskID>_ICA_log.csv
<StudyID>_<TaskID>_removed_channels.txt
<StudyID>_<TaskID>_trial_counts.csv
<StudyID>_<TaskID>_summary_stats.txt
```

It also creates subject-level artifact summaries such as:

```text
DATA/S101/S101_VSL2_ARJ_SUM.txt
```

Review these before moving to group-level analysis.

---

## 12. Artifact-rejection QC

### Script

`M21_VSL2_arj_from_log.m`

This is a post-processing QC/exclusion-analysis utility. It does not alter the EEG or ERP files.

It reads:

```text
<StudyID>_<TaskID>_pipeline_log.txt
```

and calculates rejection percentages for the specified Familiar and Unfamiliar bin combinations.

The current script uses:

```text
Familiar:     b1 + b2 + b13 + b14
Unfamiliar:   b7 + b8 + b19 + b20
```

and calculates:

```text
Familiar rejection %
Unfamiliar rejection %
Overall rejection %
```

The current default exclusion flag is:

```text
overall rejection > 35%
```

The script also performs a paired t-test comparing Familiar and Unfamiliar rejection rates.

### Important

Before each analysis, inspect the hard-coded settings near the top of the script, including:

```matlab
LOG_FILE
OUTPUT_CSV
EXCLUDE_SUBJECTS
ARJ_THRESHOLD
```

For example, a hard-coded subject exclusion from a previous analysis should not automatically carry over into a new analysis.

Treat this script as a QC and exclusion-decision aid, not as an automatic subject-removal procedure.

---

## 13. Review individual subjects before continuing

Before bin operations or group analysis, inspect:

- pipeline completion status;
- removed-channel log;
- number and identity of interpolated channels;
- ICA components removed;
- subject `*_ARJ_SUM.txt` files;
- accepted trial counts;
- artifact-rejection percentages;
- individual ERP waveforms;
- event/bin integrity.

Use these checks to finalize subject inclusion/exclusion decisions.

---

## 14. Channel-order restoration

Channel order is now restored **inside `ERP_pipeline.m` immediately after interpolation**.

Before bad-channel removal, the pipeline saves the authoritative channel labels and channel-location structure. After `eeg_interp`, it reorders the interpolated data by label and restores the original `chanlocs` structure.

Therefore, a separate channel-reordering script is **not required for newly processed data**.

`M21_VSL2_reorder_channels.m` may be retained as a legacy repair/QC utility for ERP files that were processed with older pipelines before automatic channel-order restoration was incorporated.

---

## 15. Create derived bins

### Script

`M21_VSL2_binop.m`

Input:

```text
S101_VSL2.erp
```

Output:

```text
S101_VSL2_binop.erp
```

The script uses three sequential bin-operation files:

```text
m21_VSL2_binop_pass1.txt
m21_VSL2_binop_pass2.txt
m21_VSL2_binop_pass3.txt
```

The three passes are required because later derived bins depend on bins created in earlier passes.

Current sequence:

```text
Pass 1: 24 → 36 bins
Pass 2: 36 → 68 bins
Pass 3: 68 → 72 bins
```

After bin operations, the channel-reorder script may be run again as a final verification, provided the reorder script supports the relevant montage.

---

## 16. Finalize subject lists

Do not automatically use the original `all` subject list for group analysis.

After preprocessing QC, create the final subject-list file(s) required for the analysis.

The same inclusion/exclusion decisions should be used consistently for:

- grand averages;
- amplitude extraction;
- behavioral/individual-difference merges;
- statistical models in R.

---

## 17. Grand averages

### Script

`M21_grand_average.m`

This loads the requested individual ERP files and creates an ERPLAB grand average.

For derived-bin ERPs, use an extension such as:

```text
binop
```

so that the script loads:

```text
S101_VSL2_binop.erp
```

Use the finalized subject list appropriate to the analysis.

The script requests weighted averaging and SEM.

---

## 18. Export mean ERP amplitudes

### Script

`M21_measure_amp.m`

This script exports baseline-adjusted mean ERP amplitude in long format for statistical analysis in R.

Specify:

- StudyID;
- TaskID;
- recording location;
- finalized subject list;
- ERP extension;
- bins;
- measurement window;
- baseline.

Example:

```text
ERP extension:  binop
Bins:           25:40
Window:         [75 175]
Baseline:       [-100 0]
```

The script uses:

```text
HC: channels 1:27
PC: channels 1:31
```

and exports a long-format CSV with measurement label:

```text
mean_amp
```

---

## 19. Intermediate files

The preprocessing pipeline saves intermediate EEGLAB datasets with suffixes indicating processing stage:

```text
_FLT   filtered
_RSP   resampled
_REF   rereferenced
_ELS   event list created
_BIN   bins assigned
_CLN   bad channels removed
_ICA   ICA artifact components removed
_INT   channels interpolated
_EPC   epoched
_ARJ   artifact-rejected epochs flagged
```

These files are useful for troubleshooting and reproducibility but can consume substantial disk space.

The principal subject-level ERP outputs are:

```text
S101_VSL2.erp
S101_VSL2_binop.erp
```

---

## 20. Recommended QC checkpoints

### After BrainVision import

Confirm:

- correct number of channels;
- correct channel labels/order;
- correct sampling rate;
- events are present and correct;
- recording duration is plausible;
- `.set` and `.fdt` exist.

### After preprocessing

Confirm:

- every expected subject completed;
- bad-channel removal is plausible;
- ICA rejection is plausible;
- interpolated channels are documented;
- artifact-rejection counts are reasonable;
- expected bins contain trials;
- individual ERP waveforms are plausible.

### After channel reordering

Verify several ERP files manually:

```matlab
ERP = pop_loaderp( ...
    'filename', 'S106_VSL2.erp', ...
    'filepath', fullfile(pwd,'DATA','S106'));

{ERP.chanlocs.labels}
```

All subjects from the same recording site should have the same canonical channel order.

### Before statistics

Confirm that the same finalized subject list and exclusion rules are used for all corresponding analyses.

---

## 21. Current script status

### Recommended for new processing

```text
ERP_pipeline.m
```

This is the study/task-generic preprocessing pipeline. It selects the correct montage-specific `.ced` and rereference files from the `location` value entered at runtime.

### Legacy / retain for reproducibility

```text
M21_VSL2_pipeline.m
```

Its Stage 3 bad-channel workaround assumes the Hampshire configuration:

```text
1-27   located scalp channels
28-32  unlocated mastoid/EOG channels
```

It should not be used unchanged for Providence data.

### Utility scripts

```text
M21_VSL2_load_vhdr.m
M21_VSL2_arj_from_log.m
M21_VSL2_reorder_channels.m
M21_VSL2_binop.m
M21_grand_average.m
M21_measure_amp.m
M21_create_chan_locs.m
```

---

## 22. Remaining items to verify before PC batch processing

The core HC/PC distinction is now clear, but three implementation details should be verified before processing a new Providence batch:

1. **PC channel-location file**

   Confirm that `M21_PC_31ch.ced` has been created and that all 31 labels map correctly to the PC channel order.

2. **v2 pipeline montage selection**

   Confirm that `ERP_pipeline.m` selects `M21_PC_31ch.ced` for `location = 'pc'` and `M21_Hampshire_32ch.ced` for `location = 'hc'`.

3. **Channel-reorder script**

   Confirm that `M21_VSL2_reorder_channels.m` supports the PC 31-channel montage before applying it to PC ERPs. The existing Hampshire canonical order must not be imposed on PC data.

---

## 23. Minimal operating procedure

### Hampshire

```text
1. Create M21_Hampshire_32ch.ced once.
2. Import BrainVision files with M21_VSL2_load_vhdr.m.
3. Run ERP_pipeline.m with location = hc.
4. Review logs, ARJ summaries, ICA, trial counts, and individual ERPs.
5. Run M21_VSL2_arj_from_log.m.
6. Finalize preprocessing/exclusion decisions.
7. Proceed directly to any task-specific bin operations required for the study.
9. Optionally verify channel order again.
10. Finalize analysis subject list(s).
11. Run M21_grand_average.m.
12. Run M21_measure_amp.m.
13. Analyze the exported CSV in R.
```

### Providence

```text
1. Create M21_PC_31ch.ced once.
2. Confirm v2 selects the PC .ced file and reref_eq_pchpl.txt.
3. Import BrainVision files with M21_VSL2_load_vhdr.m.
4. Run ERP_pipeline.m with location = pc.
5. Review logs, ARJ summaries, ICA, trial counts, and individual ERPs.
6. Run M21_VSL2_arj_from_log.m as appropriate for the analysis.
7. Finalize preprocessing/exclusion decisions.
8. Proceed directly to any task-specific bin operations required for the study.
10. Finalize analysis subject list(s).
11. Run M21_grand_average.m.
12. Run M21_measure_amp.m.
13. Analyze the exported CSV in R.
```

---

## 24. Key principle

The recording site must determine three separate things consistently:

```text
                    Hampshire (hc)             Providence (pc)

Channel count       32                         31
Scalp EEG            1-27                       1-31
Location file       M21_Hampshire_32ch.ced     M21_PC_31ch.ced
Rereference file    reref_eq_brainvision_      reref_eq_pchpl.txt
                    hampshire.txt
ARJ channels        1:27                       1:31
```

Any script that assumes a fixed Hampshire channel structure should be checked before it is used on Providence data.