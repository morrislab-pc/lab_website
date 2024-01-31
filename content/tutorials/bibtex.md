# `bibtex` vs. `biber` and `biblatex` vs. `natbib`
[Original post on stackexchange](https://tex.stackexchange.com/questions/25701/bibtex-vs-biber-and-biblatex-vs-natbib)

## Some Terminology

It's first off important to realize that the term `bibtex`  is often used to refer to various distinct things, and this can lead to some confusion. For example we typically tell new users to "use `bibtex`  for your bibliography" which usually just means don't do it by hand, but instead store your references in a `.bib` file and use some automatic method of formatting citations and bibliography. Additionally, we also talk about a "bibtex file" (i.e. a `.bib` file). Both of these uses are in reality quite vague, and part of the reason for this question is to distinguish among them more carefully.

So in this question we will use the following terms:

- `bibtex` and  `biber` are external programs that process bibliography information and act (roughly) as the interface between your `.bib` file and your LaTeX document.

-  `natbib` and  `biblatex` are LaTeX packages that format citations and bibliographies;  `natbib` works only with `bibtex` , while  `biblatex` (at the moment) works with both `bibtex`  and biber.)


## `natbib`

The  `natbib` package has been around for quite a long time, and although still maintained, it is fair to say that it isn't being further developed. It is still widely used, and very reliable.

### Advantages

- It has a wide range of already developed `.bst` files which conform to many journals and publishers in the sciences.

- The author of the  `natbib` package has written a package called `custom-bib`, which provides a utility called `makebst`. This utility is menu-driven and allows you to interactively generate custom bibliography style files. Bibliography style files generated with `makebst` are very stable and (unsurprisingly, given the authorship) work very well with `natbib`'s citation commands.

- The resulting bibliography code can be pasted directly into a document (often required for journal submissions). 

### Disadvantages

- Because it depends on `bibtex` , its interface requires `.bst` files, which use a postfix language that is difficult to program in for most people. This means that making even minor modifications to an existing style to meet particular formatting requirements can be quite difficult.

- It is designed especially for Author-Year and (to a lesser extent) numeric citation styles that are common in the natural and social sciences. It is not able to do traditional humanities style citation styles such as Author/Title or footnote style citations and bibliographies (including various sorts of ibid tracking).

- Multiple bibliographies in a single document or categorized bibliographies require extra packages.

- By depending on `bibtex`  as a backend, it inherits all of its disadvantages (see below).

You might want to use  `natbib` if:

- there is a  `.bst` file already created for the specific journal you submitting a paper to;

- a journal accepts latex submissions and requires or expects `natbib`. Such journal may not accept  `biblatex` for the bibliography.

# `biblatex`

The  `biblatex` package is being actively developed in conjunction with the  `biber` backend.

### Advantages

#### Humanities style citations

 - `biblatex` is almost required if you need any of the following:

	- humanities style citations (author-title type schemes; citations using ibid etc.)

	- a much wider array of `bibtex`  database fields (again, especially suited for the humanities).

	- Unicode encoded `.bib` files (usable with the  `biber` replacement for `bibtex` ).

	- fine control over your own bibliography styles using regular `latex` methods.

#### Author-year and numeric citations

 - `biblatex` provides the same functionality as  `natbib` for author-year and numeric citations common in the natural and social sciences. It can therefore be used as a replacement for `natbib`.

#### General considerations

- All formatting of citations and bibliography entries is done using regular LaTeX macros. As a consequence, regular LaTeX users are able to make modifications to existing styles quite easily.  `biblatex` also has built in hooks for most kinds of modifications.

- Even though  `biblatex` can use `bibtex`  as a backend, it does no formatting with `.bst` files, but only uses `bibtex`  for sorting.

- Multiple bibliographies and categorized bibliographies are supported directly.

### Available  `biblatex` styles

In addition to the standard styles that are documented in the  `biblatex` manual, CTAN currently lists the following extra style packages for biblatex:

- `biblatex-abnt` ABNT (Brazil­ian As­so­ci­a­tion of Tech­ni­cal Norms) style for `biblatex`.

- `biblatex-apa`: &emsp;APA style for `biblatex`.

- `biblatex-chem`: &emsp;Chemistry styles for `biblatex`.

- `biblatex-chicago`: &emsp;Chicago style files for `biblatex`.

- `biblatex-dw`: &emsp;Humanities styles for `biblatex`.

- `biblatex-historian`: &emsp;A `biblatex` style based on Turabian.

- `biblatex-ieee`: &emsp;IEEE style files for `biblatex`.

- `biblatex-jura`:  &emsp;`biblatex` stylefiles for German legal literature.

- `biblatex-mla`: &emsp;MLA style files for `biblatex`.

- `biblatex-nature`:  &emsp;`biblatex` support for the journal *Nature*.

- `biblatex-philosophy`: &emsp;Styles for using  `biblatex` for work in philosophy.

- `biblatex-science`:  &emsp;`biblatex` support for the journal *Science*.

Many new journal styles are being created for `biblatex`. Given the flexibility of adapting  `biblatex` styles, in many cases it may be quite easy to modify an existing style to accommodate a particular journal's style.

### Disadvantages

- Journals and publishers may not accept documents that use  `biblatex` if they have a house style with its own  `natbib` compatible `.bst` file.

- It is not trivial to include the bibliographies created by  `biblatex` into a document (as many publishers require.) 

## `bibtex` vs. `biber`

Many of the disadvantages of  `natbib` are a consequence of its reliance on `bibtex`  for formatting. This is the main (huge) distinction between the  `natbib` and biblatex, as the latter, even when it uses `bibtex`  as the backend, doesn't use it for formatting, only for sorting. However,  `biblatex` is also designed to use biber, a new backend that adds further functionality to `biblatex`.

### `bibtex`

#### Advantages

- very stable and widely used

#### Disadvantages

- very hard to modify bibliography styles without learning a different language (if using `natbib`; not an issue if using `biblatex`)

- very poor cross-language support and non-European script support. Non-ASCII characters are best avoided. 

### `biber`

#### Advantages

- able to deal with many more entry and field types in the `.bib` file.

- able to deal with UTF-8 encoded `.bib` files.

- better sorting control.

#### Disadvantages

- Only works with biblatex, not with `natbib`.

- Because it does much more than `bibtex`  it is a lot slower. 

## Differences between `.bib` files

As noted at the beginning of this answer, we tend to use the term `bibtex`  file to refer to the `.bib` file itself, which leads to the assumption that tools that manipulate `.bib` files are only available to `bibtex`  users and not  `biber` users. This is simply not the case: tools designed for manipulating `.bib` files such as reference managers and various `.bib` file generation/manipulation tools can be used.

It is the case, however, that as you transition to using all the features of biber/ `biblatex` you may find certain differences in the `.bib` files become more relevant.

A separate question Compatibility of `bibtex`  and  `biblatex` bibliography files? explores some of the differences between traditional `bibtex`  `.bib` files and `.bib` files that have been adapted for use with  `biber` and `biblatex`.

# Latex Filetypes 

[Original post on stackexchange](https://tex.stackexchange.com/questions/7770/file-extensions-related-to-latex-etc)

In addition to the `.tex` and  `.pdf` files, LaTeX  produces and uses lots of other files. Her are some FYI

- .fd: Font definition; used in generating the output.

- `.bst`: BibTeX Style File (e.g., a certain journal's preferred Bibliography layout settings); used by BibTeX when generating the bibliography.

- `.aux`: LaTeX auxiliary file; created when LaTeX is run, these contain information LaTeX records which is then used by either BibTeX or LaTeX itself on later runs (e.g., about cross-references), and can contain other things as well. This file is created by running LaTeX but also used the next time LaTeX is run. It can be deleted, but then you may need to run multiple times in the future to regenerate it.

- `.bbl`: Bibliography; this is what is outputted by BibTeX for insertion into LaTeX the next time LaTeX is run.

- `.blg`: Bibliography (BibTeX) log -- just like `.log` but for BibTeX; generated by BibTeX and can be safely deleted if there's no need to check it for errors.

- `.brf`: BackReference file for the backref package, I think. I'm not very familiar with these, but I suspect they're created by LaTeX when a file using that package is compiled.

- `.cls`: Documentclass (like article, or report - if you have them cluttering up your folders, you must use a lot of custom classes for individual journals or universities, etc.) This is obviously used to generate the output.

- `.dtx`: Documented source file; can be used to generate a LaTeX package or other file along with its associated documentation.

- `.aux`: An auxiliary file that saves information for the creation of ToC, references, indices, bibliographies and other things like that. It is reread in the next compiling to create the ToC, references etc.
Created by `(pdf/xe/lua)(la)tex`

- `.toc`: An auxiliary file that stores the Table of Contents, read in on subsequent runs to create the actual ToC.
Created by `(pdf)latex`, `xe(la)tex`.

- `.lof`: An auxiliary file that stores the List of Figures, read in on subsequent runs to create the actual LoF.
Created by `(pdf)latex`, `xe(la)tex`.

- `.lot`: An auxiliary file that stores the List of Tables, read in on subsequent runs to create the actual LoT.
Created by `(pdf)latex`, `xe(la)tex`.

- `.log`: Stors all messages of the compilation, like errors and warnings. It’s used by most Editors / LaTeX IDEs to show the errors in you document.
Created by `(pdf)latex`,` xe(la)tex`.

- `.pdf`: The common output format for your document.
Created by `pdflatex`, `xelatex`, `ps2pdf`, `dvipdf`.