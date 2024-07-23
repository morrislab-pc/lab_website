---
date: "`r Sys.Date()`"
draft: false
image: img/tutorials/model-fit.png
showonlyimage: false
title: Model Fitting Tutorial
weight: 0
slug: model-fitting-tutorial
---

"All models are wrong but some are useful."  *George Box*
<!--more-->

"Everything should be as simple as it can be, but not simpler." *Albert Einstein*

&nbsp;

A statistical model is means to capture the structure of the data as simply as possible. Put another way, our goal is to find the model that most efficiently and accurately summarizes how the data were generated.

&nbsp;

# Linear Mixed Effects Models

[Introduction to linear mixed models](https://ourcodingclub.github.io/tutorials/mixed-models/)

[Mixed Models with R](https://m-clark.github.io/mixed-models-with-R/)

[*R for Statistical Learning* by David Dalpiaz. Chapter 4 Modeling Basics in R](https://daviddalpiaz.github.io/r4sl/modeling-basics-in-r.html)

[*Statistical Thinking for the 21st Century* by Russell A. Poldrack. Chapter 5 Fitting models to data.](https://statsthinking21.github.io/statsthinking21-core-site/fitting-models.html)

[*Data Science with R* by Garrett Grolemund. Chapter 3 Model Fitting.](https://garrettgman.github.io/model-fitting/)

# Dealing with Problems in model fitting

## Heteroskedasticity

Heteroscedasticity means unequal scatter. In regression analysis, we talk about heteroscedasticity in the context of the residuals or error term. Specifically, heteroscedasticity is a systematic change in the spread of the residuals over the range of measured values. Heteroscedasticity is a problem because ordinary least squares (OLS) regression assumes that all residuals are drawn from a population that has a constant variance (homoscedasticity).

[*Heteroscedasticity in Regression Analysis* By Jim Frost](https://statisticsbyjim.com/regression/heteroscedasticity-regression/)