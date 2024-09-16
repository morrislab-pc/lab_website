# Read function arguments from list

To have your function read both arguments from lists within a MATLAB loop, you can follow this approach:

1. **Prepare your data**: Assume you have two lists. The first list, `arg1_list`, contains the first arguments for each iteration. The second list, `arg2_list`, contains lists of integers that will be passed as the second argument.

2. **Loop through the lists**: In your loop, you'll iterate over these lists and pass the corresponding elements to your function.

Here’s an example:

```matlab
% Define your lists
arg1_list = {'A', 'B', 'C'};  % First argument list
arg2_list = {[1, 2, 3], [4, 5, 6], [7, 8, 9]};  % List of lists for second argument

% Define a sample function that takes two arguments
my_function = @(arg1, arg2) fprintf('First argument: %s, Second argument: %s\n', arg1, mat2str(arg2));

% Loop through the lists
for i = 1:length(arg1_list)
    % Retrieve arguments from lists
    arg1 = arg1_list{i};
    arg2 = arg2_list{i};
    
    % Call the function with the retrieved arguments
    my_function(arg1, arg2);
end
```

In this example:

- `arg1_list` is a cell array where each element corresponds to the first argument for each iteration.
- `arg2_list` is a cell array where each element is itself an array (the list of integers).

The loop iterates over the indices of these lists, retrieves the appropriate elements, and passes them to `my_function`.

This approach should work well for your needs. Let me know if you need further customization or clarification!

# Read in text file as list of lists

To set up a text file containing integers so that MATLAB can read it in as a list of lists (i.e., a cell array where each cell contains an array of integers), you should format the text file in a way that each line corresponds to a list of integers. MATLAB will then read each line as a separate list.

Here’s how you can structure the text file and read it into MATLAB:

### Step 1: Structure the Text File

Create a text file where each line contains a series of integers separated by spaces (or another delimiter like commas). For example:

**`data.txt`**:
```
1 2 3 4
5 6 7 8
9 10 11 12
```

Each line in this file represents a list of integers.

### Step 2: Read the File in MATLAB

You can read this file into MATLAB using the `textscan` function, which will allow you to process each line as a separate list:

```matlab
% Open the file
fileID = fopen('data.txt', 'r');

% Read the file line by line into a cell array, where each cell contains a numeric array
list_of_lists = {};

while ~feof(fileID)
    line = fgetl(fileID);  % Read a line from the file
    if ischar(line)  % Check if the line is a string (i.e., not the end of the file)
        list_of_lists{end+1} = str2num(line);  % Convert the line to a numeric array and store it in the cell array
    end
end

% Close the file
fclose(fileID);

% Display the result
disp(list_of_lists);
```

### Step 3: Verify the Result

After running the above code, `list_of_lists` will be a cell array where each cell contains a numeric array corresponding to each line of integers in the text file. For example:

```matlab
list_of_lists =
    [1x4 double]    % [1 2 3 4]
    [1x4 double]    % [5 6 7 8]
    [1x4 double]    % [9 10 11 12]
```

### Notes:

- **Delimiter**: If your integers are separated by commas or another delimiter instead of spaces, modify the `str2num` function to `str2double` with appropriate parsing, or use `textscan` with a specific delimiter.
  
- **Empty Lines**: Ensure that your text file does not contain empty lines, as this might result in empty cells in the output array.

This approach should allow you to read a text file formatted as described into MATLAB as a list of lists.