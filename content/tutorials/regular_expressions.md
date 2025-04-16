---
title: Regular Expressions
author: Joanna Morris
date: '2022-06-03'
slug: [eeglab-erplab]
image: img/tutorials/regex.png
showonlyimage: false
categories: []
tags: []
---


Regular expressions (regex) are powerful tools for **searching**, **matching**, and **cleaning** text data. They are especially useful for psychology students—whether undergraduates, graduate students, or lab members—working with survey data, open-ended responses, or behavioral experiments.

<!--more-->

## ✅ When Regex Is Useful

### 1. Cleaning Survey or Experimental Data
- Remove unwanted characters (e.g., extra spaces, punctuation, line breaks)
- Standardize response formats (e.g., convert `"yes"`, `"Yes"`, and `"YES"` to the same value)

### 2. Analyzing Open-Ended Responses
- Automatically find key phrases in text (e.g., responses mentioning "anxiety" or "stress")

### 3. Recoding or Tagging Variables
- Identify and label entries based on content (e.g., classify responses as “positive” or “negative”)

### 4. Filtering Log Files or Experimental Output
- Extract events from EEG, fMRI, or behavioral logs (e.g., match all trials with a specific stimulus)

### 5. Writing Scripts for Stimulus Presentation
- Select or randomize files based on filename patterns (e.g., match all `.wav` files that start with `stim_`)

### 6. Literature Review and Meta-Analysis
- Search large bodies of text (e.g., abstracts or full articles) for phrases like "working memory" or "statistical learning"

---

## 🧪 Example

You have 500 open-text responses to the question:

> *“How are you feeling today?”*

You can use regex to find responses that mention:
- `tired`
- `exhausted`
- `fatigued`

Even if they vary in casing (e.g., "Tired", "exHAUSTED") or are embedded in sentences.

---

## 💡 Why It Matters

Learning regular expressions makes you a **more efficient and independent researcher**, especially when working with:
- **Qualitative data**
- **Large datasets**
- **Automated text coding**
- **Experiment scripting** (e.g., PsychoPy, OpenSesame, E-Prime)

---

# ✅ Regular Expression (Regex) Cheat Sheet

A quick reference for building regular expressions — useful for coding, text analysis, and platforms like Canvas, Python, and R.

---

## 🔤 Character Classes

| Pattern | Meaning                              |
|---------|--------------------------------------|
| `.`     | Any character (except newline)       |
| `\w`    | Word character: `[a-zA-Z0-9_]`        |
| `\W`    | Non-word character: `[^a-zA-Z0-9_]`   |
| `\d`    | Digit: `[0-9]`                        |
| `\D`    | Non-digit: `[^0-9]`                   |
| `\s`    | Whitespace: space, tab, newline, etc.|
| `\S`    | Non-whitespace                       |

---

## 🔢 Quantifiers

| Pattern   | Meaning                           |
|-----------|-----------------------------------|
| `*`       | 0 or more times                   |
| `+`       | 1 or more times                   |
| `?`       | 0 or 1 time (optional)            |
| `{n}`     | Exactly n times                   |
| `{n,}`    | n or more times                   |
| `{n,m}`   | Between n and m times             |

---

## 📦 Anchors

| Pattern | Meaning               |
|---------|-----------------------|
| `^`     | Start of string       |
| `$`     | End of string         |
| `\b`    | Word boundary         |
| `\B`    | Not a word boundary   |

---

## 🔀 Groups & Alternation

| Pattern       | Meaning                                  |
|---------------|------------------------------------------|
| `(abc)`       | Group exact pattern                      |
| `a|b`         | Match either `a` or `b`                  |
| `[abc]`       | Match any one character: a, b, or c      |
| `[^abc]`      | Match any character **except** a, b, or c|

---

## 📐 Escaping Special Characters

| Character | Escaped Form |
|-----------|--------------|
| `.`       | `\.`         |
| `+`       | `\+`         |
| `*`       | `\*`         |
| `?`       | `\?`         |
| `|`       | `\|`         |
| `(` `)`   | `\(` `\)`    |
| `{` `}`   | `\{` `\}`    |
| `[` `]`   | `\[` `\]`    |
| `\`       | `\\`         |

---

## 🎛 Flags (If Supported)

| Flag   | Meaning                            |
|--------|------------------------------------|
| `(?i)` | Case-insensitive matching          |
| `(?m)` | Multiline mode (`^`/`$` match line ends) |
| `(?s)` | Dot matches newline (`.` includes `\n`) |

---

## 🧪 Common Examples

| Pattern                  | Matches                                  |
|--------------------------|------------------------------------------|
| `(?i)\btype\s+(i|1)\b`   | Type I, type 1 (case-insensitive)        |
| `\b\d{4}\b`              | Any 4-digit number (e.g., "2024")        |
| `\s+`                    | One or more whitespace characters        |
| `\b(yes|no|maybe)\b`     | Matches the word "yes", "no", or "maybe" |
| `^Hello`                 | "Hello" only at the start of the line    |

---

> ✅ Pro Tip: Use `.*` to allow any number of characters between key words, and `\s*` to allow optional spaces.

[Download Dave Child's regex cheatsheet](/static/files/davechild_regular-expressions.pdf)