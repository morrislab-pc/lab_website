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

# Linear Models

We use regression to predict a dependent variable from one or more independent variables.  Regression gives us an equation that describes the *form* of the relationship between dependent and independent variables and predicts the *value* of the dependent variable based on the independent variable(s)

## Ordinary Least Squares (OLS) regression
Ordinary least squares fits models of the form:

![](/img/tutorials/eqn1.png)

where \\(n\\) is the number of **observations** and \\(k\\) is the number of **predictor variables**.

\\(\hat{Y}_i\\) is the predicted value of the dependent variable for observation \\(i\\)

\\(X_{ki}\\) is the value of the \\(k\\)th independent variable for \\(X = i\\).

\\(\hat{\beta}_0\\) is the predicted value of \\(Y\\) when all the predictor variables are \\(0\\), i.e. the **intercept**.

\\(\hat{\beta}_k\\) is the slope representing  the change in \\(Y\\) for a unit change in \\(X_k\\), i.e .the **regression coeffient** for the \\(k\\)th predictor.

You can use the `lm()` function in R to fit an OLS regression model, and the `summary()` function to obtain model parameters and summary statistics.

### Statistical assumptions underlying OLS regression

- **Normality**: For fixed values of \\(X_{1 \dots n}\\), \\(Y\\) is normally distributed 

- **Independence**: The values of Y for a given X are independent of each other

- **Linearity**: The relationship between the independent variables and the dependent variable is linear

- **Homoscedasticity**: The variance of dependent variable is constant across all levels of the independent variable.

![](/img/tutorials/regression1.png)

When there is more than one predictor, we are dealing with multiple linear regression. When there is more than one independent variable, the regression coefficients indicate the increase in the dependent variable  for a unit change in the independent variable, holding the other independent variables constant.

- 
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

### How to transform your data to address heteroscedasticity

[Data Transformation](http://sciences.usca.edu/biology/zelmer/305/trans/)