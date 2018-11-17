#saveRDS(sparseDayHourFrame[0,],"11.16colnames.rdat")
correctCols = readRDS("11.16colnames.rdat")
for (class in c(1:nrow(ClassesList))) {
  df = read.csv(paste0(ClassesList[class,"ClassNum"],ClassesList[class,"QuarterYear"],"dataset.csv"))
  df = df[,-1]
  correctCols = rbind(correctCols,df)
}
correctCols$loadInfluxCategorical = 0
for (row in c(1:nrow(correctCols))) {
  if(correctCols[row,"loadInflux"] < 60) {
    correctCols[row,"loadInfluxCategorical"] = "Low"
  } else if (correctCols[row,"loadInflux"] >= 60) {
    correctCols[row,"loadInfluxCategorical"] = "High"
  }
}
rf.mdl <- randomForest(x=correctCols[,c(9:14)], y=as.factor(correctCols[,"loadInfluxCategorical"]), ntree=3000, na.action=na.omit, importance=TRUE, progress="window")

boxplot(correctCols$loadInflux)
