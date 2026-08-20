%% =========================================================================
%  create_M21_chan_locs.m
%  Creates a custom .ced channel location file for the Hampshire 32-channel
%  EEG cap used in M21 studies.
%
%  Source coordinates: Standard-10-10-Cap33.ced (EEGLAB sample_locs)
%  Canonical order: defined by reref_eq_brainvision_hampshire.txt
%
%  Output: M21_Hampshire_32ch.ced  saved to the EEGLAB sample_locs folder
%  (or current directory if that path is not writable)
%
%  After running, update the pipeline script to reference this file:
%    chan_locs_file = fullfile(eeglab_dir, 'sample_locs', 'M21_Hampshire_32ch.ced');
% =========================================================================

clear; clc;

%% -------------------------------------------------------------------------
%  Paths
% -------------------------------------------------------------------------
eeglab_dir   = '/Users/jmorris/Documents/MATLAB/eeglab2024.2';
src_ced      = fullfile(eeglab_dir, 'sample_locs', 'Standard-10-10-Cap33.ced');
out_ced      = fullfile(eeglab_dir, 'sample_locs', 'M21_Hampshire_32ch.ced');

%% -------------------------------------------------------------------------
%  Canonical channel list for this cap
%  Positions 1-27:  scalp EEG electrodes (from reref file nch1-nch27)
%  Positions 28-32: non-EEG channels (no scalp coordinates)
% -------------------------------------------------------------------------
your_labels = { ...
    'FP1','Fz','F3','F7','FC5','FC1','C3','T7','CP5','CP1', ...
    'Pz','P3','P7','O1','O2','P4','P8','CP6','CP2','CZ', ...
    'C4','T8','FC6','FC2','F4','F8','FP2', ...
    'Mastoid R','Mastoid L','HEOG R','HEOG L','VEOG L'};

n_scalp   = 27;   % channels with coordinates
n_total   = 32;   % total channels including non-EEG

%% -------------------------------------------------------------------------
%  Load source coordinate file
% -------------------------------------------------------------------------
fprintf('Loading source coordinates from:\n  %s\n\n', src_ced);
ced = readlocs(src_ced);
ced_labels = {ced.labels};

%% -------------------------------------------------------------------------
%  Build the new chanlocs structure
% -------------------------------------------------------------------------
new_chanlocs = struct( ...
    'labels',     cell(1, n_total), ...
    'theta',      cell(1, n_total), ...
    'radius',     cell(1, n_total), ...
    'X',          cell(1, n_total), ...
    'Y',          cell(1, n_total), ...
    'Z',          cell(1, n_total), ...
    'sph_theta',  cell(1, n_total), ...
    'sph_phi',    cell(1, n_total), ...
    'sph_radius', cell(1, n_total));

fprintf('Mapping coordinates:\n');
for i = 1:n_total
    new_chanlocs(i).labels = your_labels{i};

    if i <= n_scalp
        % Find coordinate in source file (case-insensitive)
        idx = find(strcmpi(ced_labels, your_labels{i}));

        if isempty(idx)
            error('No coordinate found for electrode "%s" in source .ced file.', ...
                your_labels{i});
        end

        src = ced(idx);
        new_chanlocs(i).theta      = src.theta;
        new_chanlocs(i).radius     = src.radius;
        new_chanlocs(i).X          = src.X;
        new_chanlocs(i).Y          = src.Y;
        new_chanlocs(i).Z          = src.Z;
        new_chanlocs(i).sph_theta  = src.sph_theta;
        new_chanlocs(i).sph_phi    = src.sph_phi;
        new_chanlocs(i).sph_radius = src.sph_radius;

        fprintf('  Ch %2d: %-10s -> matched ced label "%s" (pos %d)  X=%.4f Y=%.4f Z=%.4f\n', ...
            i, your_labels{i}, ced_labels{idx}, idx, src.X, src.Y, src.Z);
    else
        % Non-EEG channel — leave coordinates empty
        new_chanlocs(i).theta      = [];
        new_chanlocs(i).radius     = [];
        new_chanlocs(i).X          = [];
        new_chanlocs(i).Y          = [];
        new_chanlocs(i).Z          = [];
        new_chanlocs(i).sph_theta  = [];
        new_chanlocs(i).sph_phi    = [];
        new_chanlocs(i).sph_radius = [];

        fprintf('  Ch %2d: %-10s -> non-EEG, no coordinates\n', i, your_labels{i});
    end
end

%% -------------------------------------------------------------------------
%  Write the .ced file
%  Format: tab-separated, one row per channel
%  Columns: number label theta radius X Y Z sph_theta sph_phi sph_radius
% -------------------------------------------------------------------------

% Try to write to sample_locs; fall back to current directory
fid = fopen(out_ced, 'w');
if fid == -1
    warning('Could not write to %s — saving to current directory instead.', out_ced);
    out_ced = fullfile(pwd, 'M21_Hampshire_32ch.ced');
    fid = fopen(out_ced, 'w');
    if fid == -1
        error('Could not open output file for writing: %s', out_ced);
    end
end

% Header line
fprintf(fid, 'number\tlabels\ttheta\tradius\tX\tY\tZ\tsph_theta\tsph_phi\tsph_radius\n');

for i = 1:n_total
    ch = new_chanlocs(i);
    if i <= n_scalp
        fprintf(fid, '%d\t%s\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\n', ...
            i, ch.labels, ...
            ch.theta, ch.radius, ...
            ch.X, ch.Y, ch.Z, ...
            ch.sph_theta, ch.sph_phi, ch.sph_radius);
    else
        % Non-EEG: write label but leave coordinates blank
        fprintf(fid, '%d\t%s\t\t\t\t\t\t\t\t\n', i, ch.labels);
    end
end

fclose(fid);

%% -------------------------------------------------------------------------
%  Verify by reading back
% -------------------------------------------------------------------------
fprintf('\n\nVerifying output file:\n');
verify = readlocs(out_ced);
fprintf('  Channels read back: %d\n', length(verify));
fprintf('  First scalp channel: %s  X=%.4f\n', verify(1).labels, verify(1).X);
fprintf('  Last scalp channel:  %s  X=%.4f\n', verify(27).labels, verify(27).X);
fprintf('  First non-EEG:       %s\n', verify(28).labels);

fprintf('\nOutput written to:\n  %s\n', out_ced);
fprintf('\nTo use in the pipeline, update chan_locs_file to:\n');
fprintf('  chan_locs_file = fullfile(eeglab_dir, ''sample_locs'', ''M21_Hampshire_32ch.ced'');\n');
