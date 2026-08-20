%% =========================================================================
%  create_M21_PC_chan_locs.m
%
%  Creates a custom .ced channel-location file for the Providence College
%  31-channel EEG montage used in M21.
%
%  Source coordinates: Standard-10-10-Cap33.ced
%  Output: M21_PC_31ch.ced
% =========================================================================

clear; clc;

%% Paths
eeglab_dir = '/Users/jmorris/Documents/MATLAB/eeglab2024.2';

src_ced = fullfile( ...
    eeglab_dir, ...
    'sample_locs', ...
    'Standard-10-10-Cap33.ced');

out_ced = fullfile( ...
    eeglab_dir, ...
    'sample_locs', ...
    'M21_PC_31ch.ced');

%% Providence College channel order
% Taken directly from reref_eq_pchpl.txt

your_labels = { ...
    'Fp1','Fz','F3','F7','FT9','FC5','FC1','C3','T7','TP9', ...
    'CP5','CP1','Pz','P3','P7','O1','Oz','O2','P4','P8', ...
    'CP6','CP2','Cz','C4','T8','FT10','FC6','FC2','F4','F8','FP2'};

n_total = length(your_labels);

%% Load source coordinates

fprintf('Loading source coordinates from:\n  %s\n\n', src_ced);

ced = readlocs(src_ced);
ced_labels = {ced.labels};

%% Build new channel-location structure

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

    % Case-insensitive label matching
    idx = find(strcmpi(ced_labels, your_labels{i}));

    if isempty(idx)
        error( ...
            'No coordinate found for electrode "%s" in source .ced file.', ...
            your_labels{i});
    end

    if length(idx) > 1
        error( ...
            'Multiple coordinates found for electrode "%s".', ...
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

    fprintf( ...
        '  Ch %2d: %-5s -> matched "%s"  X=%.4f Y=%.4f Z=%.4f\n', ...
        i, your_labels{i}, ced_labels{idx}, ...
        src.X, src.Y, src.Z);
end

%% Write .ced file

fid = fopen(out_ced, 'w');

if fid == -1
    warning( ...
        'Could not write to %s — saving to current directory instead.', ...
        out_ced);

    out_ced = fullfile(pwd, 'M21_PC_31ch.ced');
    fid = fopen(out_ced, 'w');

    if fid == -1
        error('Could not open output file for writing: %s', out_ced);
    end
end

fprintf(fid, ...
    'number\tlabels\ttheta\tradius\tX\tY\tZ\tsph_theta\tsph_phi\tsph_radius\n');

for i = 1:n_total

    ch = new_chanlocs(i);

    fprintf(fid, ...
        '%d\t%s\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\n', ...
        i, ch.labels, ...
        ch.theta, ch.radius, ...
        ch.X, ch.Y, ch.Z, ...
        ch.sph_theta, ch.sph_phi, ch.sph_radius);
end

fclose(fid);

%% Verify output

fprintf('\nVerifying output file:\n');

verify = readlocs(out_ced);

fprintf('  Channels read back: %d\n', length(verify));
fprintf('  First channel: %s\n', verify(1).labels);
fprintf('  Last channel:  %s\n', verify(end).labels);

fprintf('\nOutput written to:\n  %s\n', out_ced);