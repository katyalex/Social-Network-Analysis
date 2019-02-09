rm(list = ls())
library(survival)
#install.packages('survminer')
library(survminer)
library(dplyr)
library(plyr)
library(car)
library(psych)
library(reshape)
library(foreign)
library(ggplot2)
library(psych)
library(survival)
#install.packages('eha')
#install.packages('reshape')
library(eha)
library(reshape)
library(e1071)


library(haven)
setwd("")
data = read.csv('import.dataset', header = T)

subdata = subset(data, wave==1)


datamat1 = as.matrix(data1[f2])

postest1 = matrix(0, nrow = 8, ncol = 6)
colnames(postest1)= c('model', 'chi2', 'Log-likelihood ratio', 'BIC', 'p-value(Chi2)', 'Df')
classprobs1 = matrix(NA, nrow = 8, ncol = 8)


#Check LCA model
class1 = list()
lcadata1 = matrix(NA, nrow = nrow(datamat1), ncol = 8)
colnames(lcadata1)=c(1:8)
set.seed(545)
lcabox = list()
for (i in  1:nrow(postest1)) {
  postest1[i,1] = i
  print(paste0('Model ', i))
  lca = lca(datamat1, i, niter=1000, verbose = F, matchdata = T)
  lcabox[[i]] = lca
  mod = summary(lca)
  #lcaboot2 = bootstrap.lca(lca, nsamples = 10, lcaiter = 50, verbose = F)
  postest1[i,2] = format(round(mod$chisq, 3), nsmall = 2)
  postest1[i,3] = format(round(mod$lhquot,3), nsmall = 2)
  postest1[i,4] = format(round(mod$bic, 1), nsmall = 2)
  postest1[i,5] = format(round(mod$pvalchisq, 3), nsmall = 2)
  postest1[i,6] = format(round(mod$df, 1), nsmall = 0)
  class1[[i]] = as.data.frame(format(round(lca$p, 3)))
  lcadata1[,i] = lca$matching
  colnames(class1[[i]]) = c('p_strain_from','p_support_from','f_support_from','f_strain_from',
                            'to_child', 'from_child')
  for (k in 1:nrow(classprobs1)) {
    classprobs1[i, k] = lca$classprob[k]
  }
}

set.seed(1211)

#Plot results of best class (men)
library(ggplot2)
library(plotly)
library(reshape2)
lca = c(1:3)
lca1 = class1[[3]]
class4 = cbind(lca, lca1)
class4$lca = car::recode(class4$lca, '3=1;1=3')
class4$lca
colnames(class4) = c('lca', 'p_support_to', 'p_support_from','p_strain_to','p_strain_from', 'f_strain_to', 'f_strain_from',
                     'to_child', 'from_child')
df = melt(class4, id.var = 'lca')
p <- ggplot(df, aes(lca, value)) + 
  geom_bar(aes(fill = variable), position="dodge", stat="identity", colour='black')+
  scale_fill_brewer(palette="Paired")+
  geom_hline(yintercept = 7)
p

#Subset class variable
class = lcadata1[,3]
w11 = cbind(data1, class)

data = rbind(w11, w13, w14)

summary(data$censor)
table(data$censor)

library(car)
data$censor = as.numeric(as.character(data$censor))
class(data$censor)
describe(data$censor)
data$mortality = car::recode(data$censor, '3:4=1')
data$time2 = as.numeric(as.character(data$censor))
data$mortality = as.numeric(as.character(data$mortality))
data$time2 = car::recode(data$time2, '0=4;3=2;4=3')
#how many cases have events at same point in time
table(data$time2)
table(data$censor)

#Calculate the median survival time
describe(data$time)
data$idcount <- c(1:length(data$nid))
data <- data[order(-data$time2,data$mortality),]
data$order <- c(1:length(data$nid))
death=read.csv('death.csv')
colnames(death) = 'death'

#Model Building, Estimation, and Assessment of Fit to the Data

null = survfit(formula = Surv(time2, mortality)~1, data = data)
summary(null)
plot(null)
table(data$sex, data$edu)
table(data$shealth, data$mortality)
summary(data$cesd)
p

data$cesd_i = car::recode(data$cesd, '0:16=0;17:60=1')
data$shealth_i= car::recode(data$shealth, "1:3=0;4:5=1")
data$age_i = car::recode(data$age, '42:59=1;60:69=2;70:79=3;80:89=4;90:100=5')
data$mmse = as.numeric(data$mmse)
class(data$shealth)
data$class = car::recode(data$class, '3=1;1=3')
coxmodel1 <- coxph(formula = Surv(time2, mortality) ~ factor(class),data = data)
