#saveRDS(sparseDayHourFrame[0,],"11.16colnames.rdat")
correctCols = readRDS("11.16colnames.rdat")

for (class in c(1:nrow(ClassesList))) {
  df = read.csv(paste0(ClassesList[class,"ClassNum"],ClassesList[class,"QuarterYear"],"dataset.csv"))
  df = df[,-1]
  correctCols = rbind(correctCols,df)
  ClassesInfo$TotalOHHours[class] = nrow(df)
  ClassesInfo$TotalServed[class] = sum(df$serves)
  ClassesInfo$TotalLoadInflux[class] = sum(df$avgDayServeTime * df$sign_ups)
}
boxplot(correctCols$loadInflux)

#9am-11am #200
cor.test(correctCols$servers,correctCols$hourOfDay)
cor.test(correctCols$servers,correctCols$day)

cor.test(correctCols$loadInflux, correctCols$daysAfterPrevAssnDue, method=c("pearson"))
cor.test(correctCols$loadInflux, correctCols$daysUntilNextAssnDue, method=c("pearson"))
cor.test(correctCols$loadInflux, correctCols$daysTilExam, method=c("pearson"))
cor.test(correctCols$loadInflux,correctCols$hourOfDay, method=c("pearson"))
cor.test(correctCols$loadInflux,correctCols$servers, method=c("pearson"))
cor.test(correctCols$loadInflux,correctCols$weekNum, method=c("pearson"))
cor.test(correctCols$loadInflux,correctCols$day, method=c("pearson"))
cor.test(correctCols$loadInflux,correctCols$NumStudents, method=c("pearson"))
cor.test(correctCols$loadInflux,correctCols$ProportionFrosh, method=c("pearson"))
correctCols$loadInfluxCategorical = 0
for (row in c(1:nrow(correctCols))) {
  if(correctCols[row,"loadInflux"] < 60) {
    correctCols[row,"loadInfluxCategorical"] = "Low"
  } else if (correctCols[row,"loadInflux"] < 150) {
    correctCols[row,"loadInfluxCategorical"] = "Medium"
  } else if (correctCols[row,"loadInflux"] < 300) {
    correctCols[row,"loadInfluxCategorical"] = "High"
  } else if (correctCols[row,"loadInflux"] >= 300) {
    correctCols[row,"loadInfluxCategorical"] = "Very High"
  }
}
correctCols[1,]
colnames(correctCols)
rf.mdl <- randomForest(x=correctCols[,c(13:40)], y=as.factor(correctCols[,"loadInfluxCategorical"]), ntree=1500, na.action=na.omit, importance=TRUE, progress="window")

boxplot(correctCols$loadInflux)
summary(correctCols$loadInflux)

ClassesList
ClassesInfo <- ClassesList[,c(1,2,27,28)]
ClassesInfo$TotalOHHours = 0
ClassesInfo$TotalServed = 0
ClassesInfo$TotalLoadInflux = 0 
#ClassesInfo$NumTAs = c(13,16,13,13,11,6,6,20,9,17)
ClassesInfo$TotalLoadInflux = round(ClassesInfo$TotalLoadInflux,2)
colnames(ClassesInfo) = 0

write.csv(ClassesInfo,"12.18ClassesInfo.csv")
