---
date: '2022-06-02'
draft: false
image: img/tutorials/python-205851.png
showonlyimage: false
title: Python Tutorials
slug: python
weight: 0
---

In the lab we use a set of [Python](https://www.python.org/doc/essays/blurb/) libraries, within [OpenSesame](https://osdoc.cogsci.nl) to program our studies.  
 
<!--more-->

Python is a popular programming language with a  simple, easy to learn syntax that emphasizes readability. 

[Anaconda](https://www.anaconda.com/products/distribution) is a distribution of Python for scientific computing. Anaconda has many very useful third-party libraries such as [Numpy](https://numpy.org), [Pandas](https://pandas.pydata.org), and [Matplotlib](https://matplotlib.org) built in, so installing Anaconda is much easier than the regular Python installation. 

[Anaconda Navigator](https://docs.anaconda.com/anaconda/navigator/) is a GUI tool that is included in the Anaconda distribution and makes it easy to configure, install, and launch tools such as [Jupyter Notebook](https://jupyter.org), an open-source web application that allows data scientists to create and share documents that integrate live code, equations, computational output, visualizations, and other multimedia resources, along with explanatory text in a single document.  [This article](https://odsc.medium.com/why-you-should-be-using-jupyter-notebooks-ea2e568c59f2) explains the benefits of using Jupyter.

To get started with Python follow [this (excellent!) Python tutorial](https://learnpythontherightway.com/#read).



[LinkedIn Learning](https://ihelp.providence.edu/services/linkedin-learning/) is available to all faculty, staff, and students at PC. Access it by logging into to your LinkedIn account with your Providence College email. 

#### LinkedIn Learning Tutorials

[Python for Non Programmers](https://www.linkedin.com/learning/python-for-non-programmers)

[Learning Python](https://www.linkedin.com/learning/learning-python-14393370)


### Python for Data Analysis

In our lab we use python for programming our studies and R for analysing our data, but we can also analyse our data with Python. The following textbook is a great introduction to python for data analysis.

[Reproducible Data Science with Python by Valentin Danchev](https://valdanchev.github.io/reproducible-data-science-python/intro.html)

This textbook provides an accessible introduction to open, reproducible, and ethical data analysis using hands-on Python coding, modern open-source computational tools, and data science techniques. Topics include open reproducible research workflows, data wrangling, exploratory data analysis, data visualisation, pattern discovery (e.g., clustering), prediction & machine learning, causal inference, and network analysis.

----

# Conda vs Homebrew for python

Both **Conda** and **Homebrew** provide ways to manage Python installations on macOS, but they serve slightly different purposes and come with their own sets of advantages and disadvantages. Let’s explore both options in detail to help you decide which is more suitable for your workflow.

---

### **Using Conda**

Conda is a powerful package, environment, and dependency manager. It’s designed to manage not only Python but also other languages and packages like R, C, and more. It excels at creating isolated environments for specific projects, with different Python versions and dependencies.

#### **Advantages of Conda**:

1. **Environment Management**:
   - Conda excels at creating **isolated environments**. Each environment can have its own Python version and set of packages, which allows you to work on multiple projects with conflicting dependencies without interference.
   - For example, you can create environments with different Python versions (3.8, 3.9, 3.11) and switch between them easily.

   ```bash
   conda create --name py39 python=3.9
   conda activate py39
   ```