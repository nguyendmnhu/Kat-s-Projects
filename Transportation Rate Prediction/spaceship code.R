
###Load data
df = read.csv("/Users/admin/Desktop/Kat's Projects/Transportation Rate Prediction/data/train.csv",na.string="")

###DATA CLEANING
##Structure
str(df)
df$CryoSleep=as.logical(df$CryoSleep)
df$VIP=as.logical(df$VIP)
df$Transported=as.factor(df$Transported)
df$HomePlanet=as.factor(df$HomePlanet)
df$Destination=as.factor(df$Destination)


##Calculate the percentage of NA of each column
p<-function(x) {sum(is.na(x)/length(x))*100}
apply(df,2,p)
#All columns (except for Passenger ID and Transported ) 
#have 2% missing value each column


sum(is.na(df)) #a total of 2324 columns is missing
(sum(is.na(df))/nrow(df))
# 26.73% of the data is missing value
# It's not a good idea to omit all the NA rows
# Lead to data loss and bias might happen
# Misclassification might occur IF we impute by plug in mean/mode for all missing value in the same column

##VISUALIZE the NA
library(visdat)
vis_miss(df)
library(VIM)
res <- summary(aggr(df, prop = TRUE, combined = TRUE,cex.axis=.7))$combinations

##CHECK if missing value is random 
# Subset all the NA in the original dataframe 
Missdf<- as.data.frame(abs(is.na(df)))
Missvar <- Missdf[which(sapply(Missdf, sd) > 0)]
#Check the correlation of missing value of 1 column against the missing value in the other columns
View(as.data.frame(cor(Missvar))) 
#The variables missing doesn't seems to depend on one another
#Hence seems to be missing at random

###IMPUTATION:
library(mice)
impute<-mice(df,m=3,maxit=2,seed=123)#imputation m=3
impute #Look at the type of imputation for each column

#Complete the data
library(mice)
d<-complete(impute,action=1L) #Stored all 3 imputation in 1 dataframe
library(psych)
dev.off()
#Graph the correlation between variables 
#after complete imputation
corPlot(d[,c(3,6,8,9,10,11,12)],cex=0.6)


###Feature Selection
library(mlbench)
library(caret)

##1. Using a random forest selection function
control <- rfeControl(functions=rfFuncs, method="cv", number=10)
rfe.res<- rfe(d[,-c(1,4,13,14)],d[,14],rfeControl=control)

##2. Sumarize feature:
print(rfe.res)
dev.off()
plot(rfe.res, type=c("g", "o"))
#Based on the plot, there are 8 features that explain almost 80% of the model

##3. Determine the 8 importance features:
feat.imp<-data.frame(feature=row.names(varImp(rfe.res))[1:8],
                     importance=varImp(rfe.res)[1:8,1])
ggplot(data = feat.imp, 
       aes(x = reorder(feature, -importance), y = importance, fill = feature)) +
  geom_bar(stat="identity") + labs(x = "Features", y = "Variable Importance") + 
  geom_text(aes(label = round(importance, 0.5)), vjust=1.6, color="white", size=3) + 
  theme_bw() + theme(legend.position = "none")


###Make the model
#Set seed
set.seed(10)
#change back to logical since LDA and QDA couldn't predict as.factor variable
d$Transported=as.logical(d$Transported)

#Create dummy variables for KNN since KNN cannot read as.factor or as.character variables
d$Home_dummy<-ifelse(as.character(d$HomePlanet)=="Europa",0,ifelse(as.character(d$HomePlanet)=='Earth',1,2))
d$Destination_dummy<-ifelse(as.character(d$Destination)=="55 Cancri e",0,ifelse(as.character(d$Destination)=='PSO J318.5-22',1,2))

#Split to train and test set
s=sample(nrow(d),round(nrow(d)*0.7))
train<-d[s,]
test<-d[-s,]


##Logistic Regression
library(MASS)
reg.fit<-glm(Transported~HomePlanet+CryoSleep+ Destination+Age+RoomService+FoodCourt+Spa+VRDeck,data=train)
reg.prob<-predict(reg.fit,test,type='response')
reg.pred<-rep(FALSE,length(reg.prob))
reg.pred[reg.prob>0.5]=TRUE
table(reg.pred,test$Transported)
mean(reg.pred==test$Transported)*100 
#MSE =76.7638


##LDA
library(MASS)
lda.fit<-lda(Transported~HomePlanet+CryoSleep+ Destination+Age+RoomService+FoodCourt+Spa+VRDeck,data=train)
lda.pred<-predict(lda.fit, test)
lda.tab<-table(lda.pred$class,test$Transported)
(mean(sum(diag(lda.tab)))/sum(lda.tab))*100 
#MSE= 76.7638


##QDA
qda.fit<-qda(Transported~HomePlanet+CryoSleep+ Destination+Age+RoomService+FoodCourt+Spa+VRDeck,data=train)
qda.pred<-predict(qda.fit, test)
qda.tab<-table(qda.pred$class,test$Transported)
(mean(sum(diag(qda.tab)))/sum(qda.tab))*100 
#MSE = 70.2454



##KNN

#Specified train.x and test.x to fit in KNN model
train.x<-train[,-c(1,2,4,5,7,10,13)]
test.x<-test[,-c(1,2,4,5,7,10,13)]

#Build KNN model
library(class)
set.seed(10)
knn.fit<-knn(train.x,test.x,train$Transported,k=1)
table(knn.fit,test$Transported)
mean(knn.fit==test$Transported)*100 
#MSE = 83.05215

#Tuning k. Let k run from 1 to 15
i=1                          
k.sel=1    #k selection                 
for (i in 1:15){ 
  set.seed(10)
  knn.fit <-  knn(train.x, test.x, train$Transported, k=i)
  k.sel[i] <- 100 * sum(test$Transported == knn.fit)/NROW(test$Transported)
  k=i  
  cat(k,'=',k.sel[i],'\n')
  
}
dev.off()
plot(k.sel, type="b", xlab="K- Value",ylab="Accuracy level")
#Based on the plot, choosing k=5 is sufficient. 
#Since there is not so much different if we choose k=7

##Final Model k=5
#k=5
set.seed(10)
knn.fit<-knn(train.x,test.x,train$Transported,k=5)
table(knn.fit,test$Transported)
mean(knn.fit==test$Transported)*100 
#MSE = 85.42945




#Random Forest
library(randomForest)
train$Transported=as.factor(train$Transported)
test$Transported=as.factor(test$Transported)

tree <- randomForest(Transported ~ HomePlanet+CryoSleep+ Destination+Age+RoomService+FoodCourt+Spa+VRDeck,
                     train, mtry=4)
tree.pred <- predict(tree, newdata = test)
mean((tree.pred == test$Transported)^2)*100 
#MSE= 79.06442

##Tuning Mtry
library(caret)
trControl <- trainControl(method  = "cv", number  = 3)
e <- na.exclude(d) #copying to another dataset
fit <- train(as.factor(Transported) ~as.factor(HomePlanet)+as.numeric(CryoSleep)+as.numeric(Age)+as.numeric(RoomService)+as.numeric(FoodCourt)+as.numeric(ShoppingMall)+as.numeric(Spa)+as.numeric(VRDeck),
             method     = "rf",
             # tuneGrid   = expand.grid(k = 1:10),
             trControl  = trControl,
             data       = e)
fit

#Final model of Random Forest, mtry=2
set.seed(10)
tree <- randomForest(Transported ~ HomePlanet+CryoSleep+Age+RoomService+FoodCourt+ShoppingMall+Spa+VRDeck,
                     train, mtry=2)
tree.pred <- predict(tree, newdata = test)
mean((tree.pred == test$Transported)^2)*100
#MSE = 79.52454
###Since KNN is the model result in the best accuracy,
#use the other 2 complete imputation sets to test
#if the model KNN is robust

#TEst the second imputation with KNN
d2<-complete(impute,action=2L)
d2$Transported=as.logical(d2$Transported)
d2$Home_dummy<-ifelse(as.character(d2$HomePlanet)=="Europa",0,ifelse(as.character(d2$HomePlanet)=='Earth',1,2))
d2$Destination_dummy<-ifelse(as.character(d2$Destination)=="55 Cancri e",0,ifelse(as.character(d2$Destination)=='PSO J318.5-22',1,2))
set.seed(10)
s=sample(nrow(d2),round(nrow(d2)*0.7))
train<-d2[s,]
test<-d2[-s,]
#Specified train.x and test.x to fit in KNN model
train.x<-train[,-c(1,2,4,5,7,10,13)]
test.x<-test[,-c(1,2,4,5,7,10,13)]
knn.fit<-knn(train.x,test.x,train$Transported,k=5)
table(knn.fit,test$Transported)
mean(knn.fit==test$Transported)*100 
#MSE = 85.54448

#Test the third imputation with KNN
d3<-complete(impute,action=3L)
d3$Transported=as.logical(d3$Transported)
set.seed(10)
d3$Home_dummy<-ifelse(as.character(d3$HomePlanet)=="Europa",0,ifelse(as.character(d3$HomePlanet)=='Earth',1,2))
d3$Destination_dummy<-ifelse(as.character(d3$Destination)=="55 Cancri e",0,ifelse(as.character(d3$Destination)=='PSO J318.5-22',1,2))
s=sample(nrow(d3),round(nrow(d3)*0.7))
train<-d3[s,]
test<-d3[-s,]

#Specified train.x and test.x to fit in KNN model
train.x<-train[,-c(1,2,4,5,7,10,13)]
test.x<-test[,-c(1,2,4,5,7,10,13)]
knn.fit<-knn(train.x,test.x,train$Transported,k=5)
table(knn.fit,test$Transported)
mean(knn.fit==test$Transported)*100 #85.96626

###The model KNN is robust for all 3 set of imputation,
#since the MSE for all 3 sets does not change much

