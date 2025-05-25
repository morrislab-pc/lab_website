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

We use the an R package called [blogdown](https://bookdown.org/yihui/blogdown/) to create our website. Blogdown creates web content using either [Markdown](https://www.markdownguide.org/getting-started/) or [RMarkdown](https://rmarkdown.rstudio.com) . It produces a static website, meaning the website only consists of static files such as HTML, CSS, JavaScript, and images, etc. Static websites can be hosted on any web server. The website is generated from R Markdown documents. All the pages are built from blogdown and [Hugo](https://gohugo.io/about/what-is-hugo/), the static site generator on which blogdown is based.

To install blogdown and Hugo in RStudio, at the console prompt, type:

`install.packages("blogdown")`

and then

`blogdown::install_hugo("0.84.0")`

`blogdown` was originally released in 2017. Important changes were made in [`blogdown 1.0` released in 2021](https://posit.co/blog/blogdown-v1.0/).

Our website source files are under [version control with git](https://ourcodingclub.github.io/tutorials/git/). We store our website pages in a [GitHub repository](https://github.com/morrislab-pc/lab_website) and we deploy our site using [Netlify](https://www.netlify.com/blog/2016/09/29/a-step-by-step-guide-deploying-on-netlify/).

We use [continuous deployment](https://docs.netlify.com/site-deploys/create-deploys/) to connect our Git repository to our Netlify site and keep the two in sync.

Feel free to explore the tutorial links on this page as well as the other tutorials and guides on our website!
