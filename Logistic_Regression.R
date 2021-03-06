---
title: "ShrutiR"
author: "Rajani, Shruti"
date: "11/5/2018"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

```{r}
system.df<- read.csv('SystemAdministrators.csv')
summary(system.df)

library(caret)
library(ggplot2)
library(caret)
library(forecast)
```

#Q1 Using ggplot2 package, create a scatter plot of Experience vs. Training using color or symbol to distinguish programmers who completed the task from those who did not complete it.

```{r}
ggplot(system.df, aes(Experience,Training, color=Completed.task))+ggtitle("Scatter Plot-Experience Vs Training on Completed.Task") + geom_point(shape=23,alpha = 0.8)
```

#Q1 Which predictor(s) appear(s) potentially useful for classifying task completion?

##EXPERIENCE as a predictor appears potentially useful for classifying task completion. 
##As the unit of experience increases, we observe more number of 'YES' indicating that more people completed the task.Whereas more units of training does not show a clear indication if the task is completed. There is a positive correlation in the scatter plot. There are near about 3 values of training which contains both YES and NO for Task completition which does not help us in predicting. With increased unit of experience, we see majorly YES except a few No indicating that more experience leads to more task completiton.

##EXTRA USING REG
##In our example, we have a value of 75.06 on 74 degrees of freedom. Including the variables (Experience and training) decreased the deviance to 35.713 points on 72 degrees of freedom, a significant reduction in deviance. The Residual Deviance has reduced by 39.347 with a loss of two degrees of freedom.In other words,Null deviance of 75.06 shows the badness of fit which is not explained by the model. Also, Residual deviance of 35.71 is still not explained after we include the variables.
##Also, *** besides the experience in p value shows that it is statistically significant as well. Both the predictors are used but further in questions but experience is more useful.
##using Stepwise selection to support the answer
```{r}
logit.reg <- glm(Completed.task ~ ., data = system.df, family = "binomial") 
summary(logit.reg)
exp(coef(logit.reg))
a <- step(logit.reg, direction = "both")
summary(a)
```

#Q2 Run a logistic regression model with both predictors using the entire dataset as training data. Generate a confusion matrix and answer the following: among those who completed the task, what is the percentage of programmers incorrectly classified as failing to complete the task?
```{r}
logit.reg <- glm(Completed.task ~ ., data = system.df, family = "binomial") 
summary(logit.reg)
exp(coef(logit.reg))
```
### Evaluate Performance of the Logit Model
### Predict propensities
```{r}
logit.reg.pred <- predict(logit.reg, system.df[, -3], type = "response")
```
# generate confusion matrix
```{r}
table(system.df$Completed.task, logit.reg.pred > 0.5)
```
#Incorrect Classification
```{r}
prop.table(table(system.df$Completed.task, logit.reg.pred > 0.5))
```
###CALCULATION FOR INCORRECT CLASSIFICATION : Actual yes predicted wrong/ Actual Yes 
## = (5/15)*100 i.e 33.33% or using prop = (0.06666667/.2)*100 = 33.33%

#Q3 How much experience must be accumulated by a programmer with 6 training credits before his or her estimated probability of completing the task exceeds 0.6? (Hint: in a logistic regression you can write the left hand-side of the regression equation as the log of odds).
```{r}
p=0.6
Training <- 6
#odds=p/(1-p)
#log(p/(1-p))= β0 + β1*x1 + … + βk*xk

LHS<- log(p/(1-p))
log(exp(coef(logit.reg)))

#β0<-(coef(logit.reg)[1])
#β1<-(coef(logit.reg)[2])
#β2<-(coef(logit.reg)[3])
β0<--10.9813
β1<-1.1269
β2<-.1805

#LHS = β0 + β1*Experience + β2*Training
ans<-((LHS-(β2*6)-β0)/β1)
ans
```
