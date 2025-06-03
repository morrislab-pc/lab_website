---
date: "2016-11-05T18:25:22+05:30"
draft: false
image: img/tutorials/pchpl_logo_chrome_2.png
showonlyimage: false
title: Website Info
slug: website_info
---



Do you want to contribute to the lab website?  Great!

<!--more-->


The PCHPL website serves as a repository for much of the information you will need to work effectively and productively in the lab. Creating new content for the website and updating what is already here is an ongoing process and we would love for you to get involved in this necessary part of the lab workflow.  Here's what you will need to know to get started:

To create our website, we used an R package called [blogdown](https://bookdown.org/yihui/blogdown/) along with the static site generator [Hugo](https://gohugo.io/about/what-is-hugo/). 

Blogdown creates web content using either [Markdown](https://www.markdownguide.org/getting-started/) or [RMarkdown](https://rmarkdown.rstudio.com) and produces a static website, meaning the website only consists of static files such as HTML, CSS, JavaScript, and images, etc. Static websites can be hosted on any web server. 

Our website source files are under [version control with git](https://ourcodingclub.github.io/tutorials/git/). We store our website pages in a [GitHub repository](https://github.com/morrislab-pc/lab_website) and we deploy our site using [Netlify](https://www.netlify.com/blog/2016/09/29/a-step-by-step-guide-deploying-on-netlify/).

We use [continuous deployment](https://docs.netlify.com/site-deploys/create-deploys/) to connect our Git repository to our Netlify site and keep the two in sync.


Here's a breakdown of the steps we used to build and deploy our site:

1. [Set up your environment](https://hugo-apero-docs.netlify.app/start/setup/):

Install and load the `blogdown` package in R: `install.packages("blogdown")` then `library(blogdown)`. 

You'll also need to have Hugo installed separately 

`blogdown::install_hugo()`. 

2. [Create a new website](https://hugo-apero-docs.netlify.app/start/create-site/):

Use blogdown to create the website by typing the code below in the R console.  For our website I used the `creative portfolio` theme.

```
	new_site(theme = "kishaningithub/hugo-creative-portfolio-theme", 
             format = "yaml", 
             sample = FALSE, 
             empty_dirs = TRUE)`
```

Write your website content using either markdown or RMarkdown files.  Your web content goes in the `content\portfolio` directory and images should be put in the `static\img` directory.

If you use RMarkdown, you can include R code chunks to generate dynamic content or analysis results on your website. 

To preview your site locally, type:

`blogdown::serve_site()`



3. [Push to GitHub](https://hugo-apero-docs.netlify.app/start/deploy/#push-to-github): 

To [push](https://www.atlassian.com/git/tutorials/syncing/git-push) your site to GitHub 

- Click the `Git` tab in upper right pane

- Check the `Staged` box to `stage` or tag any files with changes you want to[commit](https://www.atlassian.com/git/tutorials/saving-changes/git-commit).

- Type a message in `Commit message`, such as “commit my website”. and Click  `Commit`

The `usethis` package has a function, `browse_github()`, for easily opening a new browser window to visit the GitHub repository associated with your current website project:

```
	install.packages("usethis")
	usethis::browse_github()
```

4. Deploy your website:

You can deploy your website using a service like Netlify which is a popular choice for deploying Hugo websites, as it simplifies the deployment process. 

Setup a free [Netlify account](https://app.netlify.com/signup).  Select to sign up using your existing GitHub account (no need to create another account), so select `GitHub` (you may need to sign in), and click to `Authorize Netlify`

Log in, and select: `New site from Git > Continuous Deployment: GitHub`.

Select your website repository on GitHub and select `Deploy Site`.

Every time you push any changes to your site to GitHub, Netlify will detect the push, re-build, then update your published site; this is  [continuous deployment](https://www.netlify.com/blog/enhance-your-development-workflow-with-continuous-deployment/).

5.  [Optional. Change site name](https://hugo-apero-docs.netlify.app/start/deploy/#rename-your-site)

With a new site, Netlify will deploy your site and assign you a random subdomain name of the form `random-word-12345.netlify.app`. To change it, Navigate to your site on Netlify, and click on `Settings > Site information > Change site name`.




Feel free to explore the tutorial links on this page as well as the other tutorials and guides on our website!
