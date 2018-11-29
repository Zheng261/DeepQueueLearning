#saveRDS(sparseDayHourFrame[0,],"11.16colnames.rdat")
correctCols = readRDS("11.16colnames.rdat")

for (class in c(1:nrow(ClassesList))) {
  df = read.csv(paste0("ToDData/ToD",ClassesList[class,"ClassNum"],ClassesList[class,"QuarterYear"],"dataset.csv"))
  df = df[,-1]
  correctCols = rbind(correctCols,df)
}

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

colnames(correctCols)
rf.mdl <- randomForest(x=correctCols[,c(13:40)], y=as.factor(correctCols[,"loadInfluxCategorical"]), ntree=1500, na.action=na.omit, importance=TRUE, progress="window")

boxplot(correctCols$loadInflux)
summary(correctCols$loadInflux)
