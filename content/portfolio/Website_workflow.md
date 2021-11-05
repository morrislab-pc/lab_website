# To start a new website:

1. Carefully pick a theme at <https://themes.gohugo.io>, and find the link to its GitHub repository, which is of the form `https://github.com/user/repo`.

2. Create a new project in RStudio, and type the code `blogdown::new_site(theme = 'user/repo')` in the R console, where `user/repo` is from the link in Step 1.

3. Play with the new site for a while and if you do not like it, you can repeat the above steps, otherwise edit the options in `config.toml`.

4. If you do not understand certain options, go to the documentation of the theme, which is often the README page of the GitHub repository. Not all options have to be changed.

# To edit a website:

1. Click the RStudio addin "Serve Site" to preview the site in RStudio Viewer. This only needs to be done **once** every time you open the RStudio project or restart your R session. Do not click the `Knit` button on the RStudio toolbar.

2. Edit the `config.toml` or `config.yaml` file.

2. Use the "New Post" addin to create a new post or page, then start writing the content.

3. Use the "Update Metadata" addin to modify the YAML metadata if necessary.

# To publish a website:

1.  Upload all source files of your website to a GitHub repository.

2. Do not put the `public/` directory under version control because it will be automatically generated.

3. Netlify supports GIT repositories hosted on GitHub, GitLab, and BitBucket.

4. With any of these accounts, log into Netlify from and follow the guide to create a new site from your GIT repository.

5. With this approach, you do not need to run `blogdown::hugo_build()` locally, because the website will be built on Netlify via Hugo.

2. Hugo uses a special file and folder structure to create your website (Figure 2.1). The rest of this chapter will give more details on the following files and folders:

- `config.toml`
- `content/`
- `static/`
- `themes/`
- `layouts/`
