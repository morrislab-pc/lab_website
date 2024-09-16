# Parameter expansion

Parameter expansion is a powerful feature in shell scripting, particularly in shells like Bash and Zsh, that allows you to manipulate the values of variables in various ways. It's a method of substituting the value of a variable or parameter with a modified version of that value according to specific rules or patterns.

### Basic Example

In its simplest form, parameter expansion is used to retrieve the value of a variable:

```bash
name="Alice"
echo "Hello, ${name}!"
```

This would output:

```
Hello, Alice!
```

### Advanced Parameter Expansion

Parameter expansion allows you to perform more complex manipulations on the value of a variable:

1. **Default Values:**
   - `${var:-default}`: Use `default` if `var` is unset or null.
   - `${var:=default}`: Assign `default` to `var` if it is unset or null.

   Example:
   ```bash
   name=
   echo ${name:-"Default Name"}  # Outputs "Default Name"
   ```

2. **String Length:**
   - `${#var}`: Returns the length of the string stored in `var`.

   Example:
   ```bash
   name="Alice"
   echo ${#name}  # Outputs 5
   ```

3. **Substring Extraction:**
   - `${var:offset}`: Extracts a substring starting from `offset`.
   - `${var:offset:length}`: Extracts a substring of `length` starting from `offset`.

   Example:
   ```bash
   name="Alice"
   echo ${name:1:3}  # Outputs "lic"
   ```

4. **Substring Replacement:**
   - `${var/pattern/replacement}`: Replaces the first occurrence of `pattern` with `replacement`.
   - `${var//pattern/replacement}`: Replaces all occurrences of `pattern` with `replacement`.

   Example:
   ```bash
   text="apple apple orange"
   echo ${text/apple/grape}  # Outputs "grape apple orange"
   echo ${text//apple/grape} # Outputs "grape grape orange"
   ```

5. **Remove Prefix/Suffix:**
   - `${var#pattern}`: Removes the shortest match of `pattern` from the beginning of `var`.
   - `${var##pattern}`: Removes the longest match of `pattern` from the beginning of `var`.
   - `${var%pattern}`: Removes the shortest match of `pattern` from the end of `var`.
   - `${var%%pattern}`: Removes the longest match of `pattern` from the end of `var`.

   Example:
   ```bash
   filename="report.pdf"
   echo ${filename%.pdf}  # Outputs "report"
   ```

### Zsh-Specific Parameter Expansions

Zsh offers even more powerful parameter expansions:

1. **Array Join:**
   - `${(j:sep:)array}`: Joins the elements of `array` using `sep` as a separator.

   Example:
   ```bash
   arr=("one" "two" "three")
   echo ${(j:-)arr}  # Outputs "one-two-three"
   ```

2. **Modifiers for Transformations:**
   - `${(U)var}`: Converts the value of `var` to uppercase.
   - `${(L)var}`: Converts the value of `var` to lowercase.

   Example:
   ```bash
   word="hello"
   echo ${(U)word}  # Outputs "HELLO"
   ```

### Summary

Parameter expansion is a versatile tool in shell scripting that allows you to manipulate variables in numerous ways, making your scripts more powerful and flexible. It provides ways to set default values, extract substrings, modify strings, and perform many other operations on variables directly within your shell commands.