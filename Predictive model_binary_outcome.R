#SVM with binary outcome 
rm(list = ls())
#install.packages("tidyverse")
#install.packages("caret")
#install.packages('ppcor')
library(ppcor)
library(tidyverse)
library(readxl)
library(parallel)
library(caret)
library(lattice)
library(readstata13)

options(scipen = 999)
set.seed(27)
setwd("D:\\Yonsei\\2018³â 2ÇÐ±â\\Mortality and providing social support")

rawdata=read.dta13('mortalitydata13.dta')
table(rawdata$death_t)
library(car)
rawdata$death_t = car::recode(rawdata$death_t, '1=2;2=3')
table(rawdata$death_t)
rawdata$sex = as.numeric(rawdata$sex)
rawdata$mortality = as.factor(rawdata$mortality)
levels(rawdata$mortality)
dat= subset(rawdata[c('mortality', 'n_broker','pcs','mcs','sex','comorbidity','mstatus_i','shealth', 'cesd_c')])
dat = subset(dat, rawdata$age>75)
dat = na.omit(dat)
table(dat$mortality)
table(dat$death_t)


dat$mortality = as.factor(dat$mortality)
levels(dat$mortality)
library(caret) # Confusion matrix


library(plyr)   # progress bar
library(caret)  # confusion matrix


dat     <- dat[sample(nrow(dat)),]
dat = na.omit(dat)
folds  <- cut(seq(1,nrow(dat)),breaks=10,labels=FALSE)
result <- list()
actval = list()
models = list()
acc = NULL
# False positive rate
fpr <- NULL

# False negative rate
fnr <- NULL
# Initialize progress bar
pbar <- create_progress_bar('text')
pbar$init(10)

m = glm(mortality~., family=binomial, data = dat)
summ = summary(m)
coef = as.data.frame(summ$coefficients)
estimates = NULL
pvalue = NULL

for(i in 1:10){
  testIndexes <- which(folds==i,arr.ind=TRUE)
  testData    <- dat[testIndexes, ]
  trainData   <- dat[-testIndexes, ]
  model       <- glm(mortality~n_broker+cesd_c+shealth+pcs+mcs+as.numeric(mstatus_i)+comorbidity,family=binomial,data=trainData)
  models[[i]] = summary(model)
  summ = summary(model)
  coef = as.data.frame(summ$coefficients)
  estimates[i] = coef[2,1]
  pvalue[i] = coef[2,4]
  result_prob <- predict(model, testData, type = 'response')
  results = ifelse(result_prob >0.5, 1, 0)
  actval[[i]] = testData$mortality
  results = as.factor(results)
  levels(results) = c(0,1)
  result[[i]] = results
  results
  
  
  # Accuracy calculation
  misClasificError <- mean(testData$mortality != results)
  
  # Collecting results
  acc[i] <- 1-misClasificError
  
  levels(results)
  levels(testData$mortality)
  
  cm <- confusionMatrix(data=results, reference=testData$mortality)
  fpr[i] <- cm$table[2]/(nrow(dat)-nrow(trainData))
  fnr[i] <- cm$table[3]/(nrow(dat)-nrow(trainData))
  pbar$step()
}

# Average accuracy of the model
mean(acc)
acc
actval
result
pvalue

models[[10]]

par(mfcol=c(1,2))

# Histogram of accuracy
hist(acc,xlab='Accuracy',ylab='Freq',
     col='cyan',border='blue',density=30)

# Boxplot of accuracy
boxplot(acc,col='cyan',border='blue',horizontal=T,xlab='Accuracy',
        main='Accuracy CV')

# Confusion matrix and plots of fpr and fnr
mean(fpr)
mean(fnr)
hist(fpr,xlab='% of fnr',ylab='Freq',main='FPR',
     col='cyan',border='blue',density=30)
hist(fnr,xlab='% of fnr',ylab='Freq',main='FNR',
     col='cyan',border='blue',density=30)

results
cor.test(as.numeric(results), as.numeric(dat$mortality))

#data_all
set.seed(100)
set.seed(123)
training.samples <- dat$mortality %>% 
  createDataPartition(p = 0.8, list = FALSE)
train.data  <- dat[training.samples, ]
test.data <- dat[-training.samples, ]

# Dumy code categorical predictor variables
x <- model.matrix(mortality~., train.data)[,-1]
# Convert the outcome (class) to a numerical variable
y <- ifelse(train.data$mortality == "pos", 1, 0)

library(glmnet)
# Find the best lambda using cross-validation
set.seed(123) 
cv.lasso <- cv.glmnet(x, y, alpha = 1, family = "binomial")
# Fit the final model on the training data
model <- glmnet(x, y, alpha = 1, family = "binomial",
                lambda = cv.lasso$lambda.min)
# Display regression coefficients
coef(model)
# Make predictions on the test data
x.test <- model.matrix(diabetes ~., test.data)[,-1]
probabilities <- model %>% predict(newx = x.test)
predicted.classes <- ifelse(probabilities > 0.5, "pos", "neg")
# Model accuracy
observed.classes <- test.data$diabetes
mean(predicted.classes == observed.classes)

