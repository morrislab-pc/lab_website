You can use a `for` loop in your bash script to iterate over all the `.txt` files and extract the desired lines into new files with the first four characters of the original filename. Here's an example of how you can achieve this:

```bash
#!/bin/bash

# Loop through all .txt files in the current directory
for file in *.txt
do
  # Extract the first 4 characters from the filename
  new_file="${file:0:4}.txt"
  
  # Use awk to extract lines starting with "bin" and save to new file
  awk '/^	bin/ {print}' "$file" > "$new_file"
  
  # Print a message indicating the process
  echo "Extracted lines from $file into $new_file"
done
```

### Explanation:
- `for file in *.txt`: Loops over all `.txt` files in the directory.
- `new_file="${file:0:4}.txt"`: Extracts the first 4 characters of the filename and appends `.txt` to create the new filename.
- `awk '/^	bin/ {print}' "$file" > "$new_file"`: Runs the `awk` command on each file to extract lines starting with "bin" and outputs them to the new file.
- `echo "Extracted lines from $file into $new_file"`: Prints a message for each processed file.

You can adjust the directory or file patterns as necessary.

To process files like `S201_VSL2_ELS_BIN.txt`, `S202_VSL2_ELS_BIN.txt`, etc., by specifying only the `S201`, `S202`, etc. part, you can pass these base names (e.g., `S201`, `S202`) as arguments to your script. Then, the script will use those base names to find and process the matching files.

Here's how you can modify your script to take `S201`, `S202`, etc. as arguments:

```bash
#!/bin/bash

# Check if at least one argument is provided
if [ "$#" -eq 0 ]; then
  echo "Usage: $0 S201 [S202 ...]"
  exit 1
fi

# Loop through all provided arguments (S201, S202, etc.)
for base_name in "$@"
do
  # Find the corresponding file with that base name
  file="${base_name}_VSL2_ELS_BIN.txt"

  # Check if the file exists
  if [ -f "$file" ]; then
    # Create a new output file with just the base name
    new_file="${base_name}.txt"

    # Use awk to extract lines starting with "bin" and save to new file
    awk '/^	bin/ {print}' "$file" > "$new_file"

    # Print a message indicating the process
    echo "Extracted lines from $file into $new_file"
  else
    echo "File $file not found!"
  fi
done
```

### Explanation:
1. **Arguments Check**: The script checks if at least one argument is provided. If no arguments are given, it shows usage instructions and exits.
2. **For Loop**: The `for base_name in "$@"` loop iterates over all arguments provided to the script, where each argument is expected to be something like `S201`, `S202`, etc.
3. **Filename Construction**: It uses the base name to construct the full filename (e.g., `S201_VSL2_ELS_BIN.txt`).
4. **File Existence Check**: The `if [ -f "$file" ]` check ensures that the file exists before trying to process it.
5. **AWK Command**: The `awk` command extracts the relevant lines and saves them to a new file, named just `S201.txt`, `S202.txt`, etc.

### Example usage:
```bash
./script.sh S201 S202
```

This will process the files `S201_VSL2_ELS_BIN.txt` and `S202_VSL2_ELS_BIN.txt` and create `S201.txt` and `S202.txt` with the extracted lines.

If you want to provide the arguments to the script via a text file, you can use `cat` or read the file within the script and process its contents. The text file would contain the base names (like `S201`, `S202`, etc.), one per line. Then the script can read these base names and process each one.

Here’s how you can modify the script to read the base names from a file:

### Example script to read arguments from a text file:

```bash
#!/bin/bash

# Check if the argument (text file) is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 filename_with_base_names.txt"
  exit 1
fi

# Check if the file exists
if [ ! -f "$1" ]; then
  echo "File $1 not found!"
  exit 1
fi

# Loop through each line in the file
while IFS= read -r base_name; do
  # Skip empty lines
  if [ -z "$base_name" ]; then
    continue
  fi

  # Construct the filename based on the base name
  file="${base_name}_VSL2_ELS_BIN.txt"

  # Check if the file exists
  if [ -f "$file" ]; then
    # Create a new output file with just the base name
    new_file="${base_name}.txt"

    # Use awk to extract lines starting with "bin" and save to new file
    awk '/^	bin/ {print}' "$file" > "$new_file"

    # Print a message indicating the process
    echo "Extracted lines from $file into $new_file"
  else
    echo "File $file not found!"
  fi
done < "$1"
```

### Steps:

1. **Text File Input**: The script expects a text file as an argument. This text file should contain the base names (e.g., `S201`, `S202`, etc.), one on each line.
2. **Read File Line-by-Line**: The `while IFS= read -r base_name` loop reads each line from the provided text file.
3. **Filename Construction**: The script constructs the full filename (`S201_VSL2_ELS_BIN.txt`, `S202_VSL2_ELS_BIN.txt`, etc.) using the base name from each line.
4. **Process Each File**: The script processes each file and saves the extracted lines into an output file (`S201.txt`, `S202.txt`, etc.).

### Example Usage:

1. Create a text file `base_names.txt`:
   ```
   S201
   S202
   S203
   ```

2. Run the script like this:
   ```bash
   ./script.sh base_names.txt
   ```

This will read the base names from `base_names.txt`, find files like `S201_VSL2_ELS_BIN.txt` and `S202_VSL2_ELS_BIN.txt`, and output them to `S201.txt`, `S202.txt`, etc.

If each `${base_name}_VSL2_ELS_BIN.txt` file is in a separate directory named `${base_name}`, you can modify the script to navigate into each directory and find the file. You can use the base name to construct both the directory and file paths.

Here's how you can adjust the script to handle that:

### Updated Script:

```bash
#!/bin/bash

# Check if the argument (text file) is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 filename_with_base_names.txt"
  exit 1
fi

# Check if the file with base names exists
if [ ! -f "$1" ]; then
  echo "File $1 not found!"
  exit 1
fi

# Loop through each line in the file
while IFS= read -r base_name; do
  # Skip empty lines
  if [ -z "$base_name" ]; then
    continue
  fi

  # Construct the directory and filename paths
  directory="${base_name}"
  file="${directory}/${base_name}_VSL2_ELS_BIN.txt"

  # Check if the directory exists
  if [ ! -d "$directory" ]; then
    echo "Directory $directory not found!"
    continue
  fi

  # Check if the file exists in the directory
  if [ -f "$file" ]; then
    # Create a new output file with just the base name
    new_file="${base_name}.txt"

    # Use awk to extract lines starting with "bin" and save to new file
    awk '/^	bin/ {print}' "$file" > "$new_file"

    # Print a message indicating the process
    echo "Extracted lines from $file into $new_file"
  else
    echo "File $file not found in directory $directory!"
  fi
done < "$1"
```

### Key Changes:
1. **Directory Path**: The script constructs the directory path as `${base_name}` and the full file path as `${directory}/${base_name}_VSL2_ELS_BIN.txt`.
2. **Directory Check**: Before looking for the file, the script checks if the directory exists using `[ -d "$directory" ]`.
3. **File Check**: It checks if the file exists within the directory using `[ -f "$file" ]`.

### Example Directory Structure:

```
S201/
    S201_VSL2_ELS_BIN.txt
S202/
    S202_VSL2_ELS_BIN.txt
...
```

### Example Usage:

1. Your `base_names.txt` would look like this:
   ```
   S201
   S202
   S203
   ```

2. Run the script:
   ```bash
   ./script.sh base_names.txt
   ```

This script will search for `S201_VSL2_ELS_BIN.txt` in the `S201/` directory, `S202_VSL2_ELS_BIN.txt` in the `S202/` directory, and so on. It will then extract the relevant lines and save them to `S201.txt`, `S202.txt`, etc.