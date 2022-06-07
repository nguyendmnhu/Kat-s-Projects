##############################################################################
##########                Apply Probability and Statistics II     ############
##########                        MATH 161B - Project             ############
##########    Team 4: Nhung Luong, Le Dao, Dang Minh Nhu Nguyen   ############
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

##Try to rewrite the code with for loop

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
# min_observation is 43

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
par(mfrow=c(1,2))
#Check Homogeneity
plot(anova,1)
#Check assumptions
plot(anova,2)

#Shapiro test
aov_residuals <- residuals(object = anova)
shapiro.test(x = aov_residuals )

#Levine test:
library(car)
leveneTest(charges ~ smoker*children, data = new_data)

#The assumptions are not violated, interpret the model:
summary(anova)

#Tukey's pairwise if p above significant
TukeyHSD(anova,which='smoker')$smoker



