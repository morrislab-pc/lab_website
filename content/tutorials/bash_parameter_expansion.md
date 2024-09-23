# Parameter Expansion

Bash **parameter expansion** is a powerful feature in bash that allows you to manipulate variables by extracting, modifying, or transforming their values. It offers various ways to work with strings, making it easier to perform tasks like substring extraction, replacement, and file path manipulation. In the case of extracting the base name from a file like `S101_VSL2.erp`, parameter expansion helps us by removing specific parts of the filename.

### Extracting the Base Name Using Parameter Expansion

In the context of your question, you want to extract the base name (e.g., `S101`) from a file named `S101_VSL2.erp`. This is done using bash parameter expansion by removing the part of the string after the first underscore (`_`). Here's how it works:

#### Syntax of Parameter Expansion for Substring Removal:
- **`${var%%pattern}`**: This removes the *longest* match of `pattern` from the end of the string stored in the variable `var`.
- **`${var%pattern}`**: This removes the *shortest* match of `pattern` from the end of the string.
- **`${var##pattern}`**: This removes the *longest* match of `pattern` from the beginning of the string.
- **`${var#pattern}`**: This removes the *shortest* match of `pattern` from the beginning of the string.

For example:
```bash
file="S101_VSL2.erp"
base_name="${file%%_*}"
```

### Explanation of `${file%%_*}`:
1. **`%%`**: This operator removes the longest match of the pattern from the end of the string.
2. **`_*`**: The pattern here is an underscore (`_`) followed by any characters (`*`), which matches everything after the first underscore.
3. **`${file%%_*}`**: This removes everything from the first underscore onward, leaving just the part before the underscore (`S101` in this case).

### Example:

```bash
file="S101_VSL2.erp"
base_name="${file%%_*}"
echo "$base_name"
```

**Output:**
```
S101
```

This extracts the base name `S101` from the filename `S101_VSL2.erp` by removing the underscore and everything that follows.

### How It Helps in Your Script:
In your script, you can use this technique to extract the base name (like `S101`, `S102`) from filenames like `S101_VSL2.erp`. This allows you to construct the correct directory path for each file and move it accordingly.

### Other Useful Parameter Expansions:

- **Remove File Extension**: You can also use parameter expansion to strip file extensions:
  ```bash
  filename="S101_VSL2.erp"
  name_without_extension="${filename%.erp}"
  echo "$name_without_extension"
  ```
  **Output**:
  ```
  S101_VSL2
  ```

- **Get File Extension**:
  ```bash
  filename="S101_VSL2.erp"
  extension="${filename##*.}"
  echo "$extension"
  ```
  **Output**:
  ```
  erp
  ```

Bash parameter expansion is a versatile tool, allowing you to perform many operations directly in the shell without relying on external commands like `sed` or `awk`, making your scripts more efficient.

## Shortest vs Longest Match

The concepts of **longest** and **shortest match** in bash **parameter expansion** refer to how much of the string is matched and removed based on the pattern you provide.

When using the `%%` or `##` operators for removing portions of a string, you can think of the string being scanned, and bash will match the pattern either **once** (shortest match) or as much as possible (longest match).

### Let's break down the differences:

#### 1. **Shortest Match (`%` and `#`)**:
- **`${var%pattern}`**: Removes the shortest match of the pattern from the end of the string.
- **`${var#pattern}`**: Removes the shortest match of the pattern from the beginning of the string.

#### 2. **Longest Match (`%%` and `##`)**:
- **`${var%%pattern}`**: Removes the longest match of the pattern from the end of the string.
- **`${var##pattern}`**: Removes the longest match of the pattern from the beginning of the string.

### Example: Removing From the End of a String

Let's say you have a filename:
```bash
filename="S101_VSL2_ELS_BIN.txt"
```

#### Using Shortest Match (`%`):

```bash
result="${filename%_*}"
echo "$result"
```

- **Pattern Explanation**: The `%_*` means "find the shortest match of an underscore followed by anything" at the end of the string.
- **What Happens**: The `%` operator matches only the last underscore and removes everything after it. So it removes `"_BIN.txt"`, leaving:
  
**Result**:
```
S101_VSL2_ELS
```

#### Using Longest Match (`%%`):

```bash
result="${filename%%_*}"
echo "$result"
```

- **Pattern Explanation**: The `%%_*` means "find the longest match of an underscore followed by anything" at the end of the string.
- **What Happens**: The `%%` operator matches the first underscore and everything after it. So it removes `"_VSL2_ELS_BIN.txt"`, leaving:
  
**Result**:
```
S101
```

### Example: Removing From the Beginning of a String

Now, let's use the same filename but try removing from the beginning of the string.

#### Using Shortest Match (`#`):

```bash
result="${filename#*_}"
echo "$result"
```

- **Pattern Explanation**: The `#*_` means "find the shortest match of anything up to the first underscore" at the beginning of the string and remove it.
- **What Happens**: The `#` operator matches `S101_` (up to the first underscore) and removes it, leaving:
  
**Result**:
```
VSL2_ELS_BIN.txt
```

#### Using Longest Match (`##`):

```bash
result="${filename##*_}"
echo "$result"
```

- **Pattern Explanation**: The `##*_` means "find the longest match of anything up to the last underscore" at the beginning of the string and remove it.
- **What Happens**: The `##` operator matches everything up to the last underscore (`S101_VSL2_ELS_`) and removes it, leaving:
  
**Result**:
```
BIN.txt
```

### Summary of Longest vs. Shortest Match:

- **Shortest match (`%` or `#`)**: Stops at the first occurrence of the pattern (i.e., first underscore or similar).
- **Longest match (`%%` or `##`)**: Goes as far as possible, removing the longest portion of the string that fits the pattern.

This gives you flexibility in controlling how much of the string is removed based on your needs. You can extract the desired part of the string either by trimming only a small portion or by removing the largest possible match.