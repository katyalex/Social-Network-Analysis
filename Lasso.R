
##Lasso feature selection 
##install.packages("glmnet")
set.seed(100)
library(glmnet)
library(Matrix)
`%ni%`<-Negate(`%in%`)

#Build model 
x <- model.matrix(train_all$mortality ~. , train_all) [,-1]
Y <- as.factor(train_all$mortality)

#Logistic regression model with all the features to see which features influence DV most 
glmmod <- glmnet(x[train,], y[train],  family="binomial", alpha = 1)
plot(glmmod, xvar="lambda") # Plots coefficient path
coef(glmmod) # Lists out coeffieicnts for each lambda

# cv.glmnet() uses crossvalidation to estimate optimal lambda
cv.out = cv.glmnet(x, y,
                   family = "binomial",
                   type.measure = "class",
                   nfolds = 5,
                   grouped = F,
                   alpha = 1)

plot(cv.out) # Plot CV-MSPE

summary(cv.out)
fit = cv.out$glmnet.fit
summary(fit)

best.lambda <- cv.out$lambda.min
best.lambda
lambda_1se <- cv.out$lambda.1se
lambda_1se
coef(cv.out)
c = coef(cv.out, s=best.lambda, exact = TRUE) # Print out coefficients at optimal lambda
c
inds<-which(c!=0)
variables<-row.names(c)[inds]
variables<-variables[variables %ni% '(Intercept)']
variables


data_lasso <- train_all[, c("mortality", variables )]
test_lasso = test_all[, c("mortality", variables)]
dataset_lasso = rbind(data_lasso, test_lasso) 
test_lasso[,-1]
#predict on test set
test_lasso1 = data.matrix(test_lasso)
test_lasso1

sapply(test_lasso1, class)
test_lasso = data.matrix(test_all)
x_test = model.matrix(test_lasso$mortality ~. , test_lasso) [,-1]
test_lasso
x_test
lasso_prob = predict(cv.out, newx = x[test,], s=best.lambda, type = "response")

lasso_predict <- rep("no",nrow(dat[ytest]))
lasso_predict[lasso_prob>.5] <- "yes"
min(cv.out$cvm)# minimum MSE
plot(cv.out$cvm)
cv.out$glmnet.fit
cv.out$lambda.min
lasso.coef  <- predict(cv.out, type = 'coefficients', s = best.lambda)[1:6,]
lasso.coef
cv.out$cvm[cv.out$lambda == cv.out$lambda.1se]  # 1 st.error of min MSE
#confusion matrix
# Make predictions on the test data
x.test <- model.matrix(mortality ~., test.data)[,-1]
probabilities <- cv.out %>% predict(newx = x[test,])
predicted.classes <- ifelse(probabilities > 0.5, "pos", "neg")
length(predicted.classes)
# Model accuracy
observed.classes <- dat$mortality
mean(predicted.classes == observed.classes)
