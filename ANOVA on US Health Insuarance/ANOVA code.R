##############################################################################
##########                Apply Probability and Statistics II     ############
##########    ANALYSIS OF VARIANCE ON THE US HEALTH INSUARANCE    ############
####################                                   #######################
##############################################################################

#Step 1: Load data
setwd('/Users/dangnguyen/Desktop/161B Project')
data<-data.frame(read.csv("insurance.csv"))

#Map all of family that has more than 2 children and assigned the value to 3
data$children<-replace(data$children,data$children>2,3) 
attach(data)


library(dplyr) 
StatSum<-data %>%
  group_by(smoker,children) %>%
  summarise(mean=mean(charges),sd=sd(charges),.groups='drop'
  )
StatSum

###Visualize data
#Line plot
library("ggpubr")
ggboxplot(data, x = "children", y = "charges", color = "smoker",
          palette = c("#00AFBB", "#E7B800"))

ggline(data, x="children",y="charges",color="smoker",
       add = c("mean_se"))


#Identify the minimum observation
smoke <- c('yes','no')
observation <- c()
d <- c() #hold data filtered
co=0
for (i in sort(unique(children))){
  for (j in smoke){
    observation <- c(observation,nrow(data[smoker==j & children==i,]))
  }
}
observation
min(observation)

# For loop to extract each level of factor
t=c('yes','no')
d1=data[data$smoker==t[1]& data$children==0,] 
d2=data[data$smoker==t[1]& data$children==1,]
d3=data[data$smoker==t[1]& data$children==2,]
d4=data[data$smoker==t[1]& data$children==3,]

d5=data[data$smoker==t[2]& data$children==0,]
d6=data[data$smoker==t[2]& data$children==1,]
d7=data[data$smoker==t[2]& data$children==2,]
d8=data[data$smoker==t[2]& data$children==3,]

#Subset 9 observations for each level
library(data.table)
c=9
set.seed(10)
d1 <- data.table(d1)
d1<-d1[sample(.N, c)]
d2 <- data.table(d2)
d2<-d2[sample(.N, c)]
d3 <- data.table(d3)
d3<-d3[sample(.N, c)]
d4 <- data.table(d4)
d4<-d4[sample(.N, c)]
d5 <- data.table(d5)
d5<-d5[sample(.N, c)]
d6 <- data.table(d6)
d6<-d6[sample(.N, c)]
d7 <- data.table(d7)
d7<-d7[sample(.N, c)]
d8 <- data.table(d8)
d8<-d8[sample(.N, c)]

#Create a new data frame that contains 9 observation of each level
new_data=data.frame(rbind(d1,d2,d3,d4,d5,d6,d7,d8))

##Generate frequency tables: (Check if all level have 9 observation)
table(new_data$smoker,new_data$children) 

##Checking the structures
str(new_data)
new_data$children=as.factor(new_data$children)
new_data$smoker=as.factor(new_data$smoker)

#Build anova model
anova<-aov(log(charges)~smoker*children,data=new_data)

#Check the assumptions
# 1, Independent variables
plot(anova$residuals)
# => The points are randomly scattered all over the plot => smoker and children are independent.

#2, Normality: By plot and by Shapiro Testt
qqnorm(anova$residuals)
qqline(anova$residuals)
# => The tails quite off, process to Shapiro Test. 
# Shapiro Test has Null Hypothesis that the samples come from a normal distribution
shapiro.test(anova$residuals)
#p-value > 0.05 => Fail to reject H0. The data is normal

#3, Equal Variance/Homogeneity: By plot and Levene's test
boxplot(log(charges)~smoker*children)
# => The variance within each group are violate the homogeneity assumptions, process to Levene's Test.
#Levene's test has Null Hypothesis that the sample variances are equal
library(car)
leveneTest(log(charges) ~ smoker*children, data = new_data)
#Optional: bartlett.test(charges ~ interaction(smoker,children), data = new_data)
# p-value > 0.05 => Fail to reject H0. The variance are equal.


#Performing ANOVA:
summary(anova)
# P-value of children is larger than 0.05 => Fail to reject H0A
# P-value of smoker is significantly small => Reject H0B
# P-value of interaction between children and smoker is greater than 0.05 => Fail to reject H0AB


#Tukey's Test if there is significant different in price between yes/no smoking
TukeyHSD(anova,which='smoker')$smoker
# => P-adj is significantly small. There is a different in insuarance price between group of smoking and non-smoking
