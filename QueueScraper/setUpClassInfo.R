setwd("/Users/ZhengYan/Desktop/CS221")

## Unsure if we need this anymore ## 
fixJSON <- function(json){
  gsub('([^,{:]+):', '"\\1":', json)
}

findAllWeeks <- function(weekOne, w9break = FALSE) {
  weekList <- c(weekOne)
  for (i in c(2:11)) {
    lastWeek = as.POSIXct(weekList[i-1])
    if (w9break & i == 9) {
      lastWeek = lastWeek + weeks(1)
    }
    weekList = c(weekList, strftime(lastWeek + weeks(1)))
  }
  return(weekList)
}

### Fills in information about each year
YearList = data.frame(matrix(ncol=4,nrow=6))
colnames(YearList) <- c("QuarterYear","W1","W10","W9break?")

####queue signups continue right into finals
YearList[1,] = c("Winter2017",'2017-1-9','2017-3-22',FALSE)
YearList[2,] = c("Spring2017",'2017-4-3','2017-6-5',FALSE)
YearList[3,] = c("Autumn2017",'2017-9-25','2017-12-4',TRUE)
YearList[4,] = c("Winter2018",'2018-1-8','2018-3-22',FALSE)
YearList[5,] = c("Spring2018",'2018-4-2','2018-6-4',FALSE)
YearList[6,] = c("Autumn2018",'2018-9-24','2018-12-3',TRUE)


YearList[7,] = c("Autumn2016",'2016-9-26','2018-12-6',TRUE)
YearList[8,] = c("Winter2016",'2017-1-9','2018-3-25',FALSE)
YearList[9,] = c("Spring2016",'2017-4-3','2018-6-14',FALSE)

YearList[10,] = c("Winter2019",'2019-1-9','2019-3-25',FALSE)
YearList[11,] = c("Spring2019",'2019-4-3','2019-6-5',FALSE)

#### List of classes we care about ####
ClassesList = data.frame(matrix(ncol=33,nrow=5))
#"Cs107 fall-winter-spring 2017, winter-spring 2018, cs110 spring 2017-fall 2018, CS 145 fall 2017-2018, CS 161 fall-spring 2017- fall 2018, CS 221-229 fall 2018, CS 230 fall-spring-winter 2018"

colnames(ClassesList) <- c("ClassNum","QuarterYear","W1","W2","W3","W4","W5","W6","W7","W8","W9","W10","W11",
                           "Assn1","Assn2","Assn3","Assn4","Assn5","Assn6","Assn7","Assn8","Assn9","Assn10",
                           "MidtermDate1","MidtermDate2","FinalsDate","QueueStatus","NumStudents","InstructorRating","AvgHrsSpent","ProportionFrosh","ProportionGrads","ProportionPhDs")

######## CS 107 SPRING 2017 #######
index = 1
ClassesList[index,c("ClassNum","QuarterYear")]= c("CS107","Spring2017")
ClassesList[index,"W1"] = YearList[which(YearList[,"QuarterYear"]==ClassesList[index,"QuarterYear"]),c("W1")]
ClassesList[index,c("MidtermDate1","MidtermDate2")] = c("2017-4-28","2017-5-25")
ClassesList[index,"FinalsDate"] = c("2017-6-14")
## Spring 2017 assignments (extrapolated)
ClassesList[index,c(14:23)] = c("2017-4-11","2017-4-18","2017-4-26","2017-5-8","2017-5-15","2017-5-27","2017-6-9","2030-4-20","2030-4-20","2030-4-20")
ClassesList[index,c(3:13)] = findAllWeeks(ClassesList[index,"W1"],as.logical(YearList[which(YearList[,"QuarterYear"]==ClassesList[index,"QuarterYear"]),c("W9break?")]))
ClassesList[index,"QueueStatus"] = 83
ClassesList[index,"NumStudents"] = 184
ClassesList[index,"InstructorRating"] = 4.3
ClassesList[index,"AvgHrsSpent"] = 16.35
ClassesList[index,"ProportionFrosh"] = 0.29
ClassesList[index,"ProportionGrads"] = 0.14
ClassesList[index,"ProportionPhDs"] = 0.05

######## CS 107 AUTUMN 2017 #######
index = 2
ClassesList[index,c("ClassNum","QuarterYear")]= c("CS107","Autumn2017")
ClassesList[index,"W1"] = YearList[which(YearList[,"QuarterYear"]==ClassesList[index,"QuarterYear"]),c("W1")]
ClassesList[index,c("MidtermDate1","MidtermDate2")] = c("2017-11-3","2030-4-20")
ClassesList[index,"FinalsDate"] = c("2017-12-13")
## Autumn 2017 (extrapolated but likely wrong)
ClassesList[index,c(14:23)] = c("2017-10-1","2017-10-8","2017-10-15","2017-10-22","2017-10-29","2017-11-9","2017-11-27","2030-4-20","2030-4-20","2030-4-20")
ClassesList[index,c(3:13)] = findAllWeeks(ClassesList[index,"W1"],as.logical(YearList[which(YearList[,"QuarterYear"]==ClassesList[index,"QuarterYear"]),c("W9break?")]))
ClassesList[index,"QueueStatus"] = 139
ClassesList[index,"NumStudents"] = 172
ClassesList[index,"InstructorRating"] = 4.1
ClassesList[index,"AvgHrsSpent"] = 16.35
ClassesList[index,"ProportionFrosh"] = 0.29
ClassesList[index,"ProportionGrads"] = 0.14
ClassesList[index,"ProportionPhDs"] = 0.05

######## CS 107 WINTER 2018 #######
index = 3
ClassesList[index,c("ClassNum","QuarterYear")]= c("CS107","Winter2018")
ClassesList[index,"W1"] = YearList[which(YearList[,"QuarterYear"]==ClassesList[index,"QuarterYear"]),c("W1")]
ClassesList[index,c("MidtermDate1","MidtermDate2")] = c("2018-3-1","2030-4-20")
ClassesList[index,"FinalsDate"] = c("2018-3-21")
## Winter 2018 (extrapolated but likely wrong)
ClassesList[index,c(14:23)] = c("2018-1-17","2018-1-24","2018-2-1","2018-2-13","2018-2-20","2018-3-4","2018-3-17","2030-4-20","2030-4-20","2030-4-20")
ClassesList[index,c(3:13)] = findAllWeeks(ClassesList[index,"W1"],as.logical(YearList[which(YearList[,"QuarterYear"]==ClassesList[index,"QuarterYear"]),c("W9break?")]))
ClassesList[index,"QueueStatus"] = 171
ClassesList[index,"NumStudents"] = 206
ClassesList[index,"InstructorRating"] = 4.7
ClassesList[index,"AvgHrsSpent"] = 16.35
ClassesList[index,"ProportionFrosh"] = 0.29
ClassesList[index,"ProportionGrads"] = 0.14
ClassesList[index,"ProportionPhDs"] = 0.05

######## CS 107 SPRING 2018 #######
index = 4
ClassesList[index,c("ClassNum","QuarterYear")]= c("CS107","Spring2018")
ClassesList[index,"W1"] = YearList[which(YearList[,"QuarterYear"]==ClassesList[index,"QuarterYear"]),c("W1")]
ClassesList[index,c("MidtermDate1","MidtermDate2")] = c("2018-4-28","2018-5-25")
ClassesList[index,"FinalsDate"] = c("2018-6-14")
## Spring 2018 (extrapolated but likely wrong)
ClassesList[index,c(14:23)] = c("2018-4-11","2018-4-18","2018-4-26","2018-5-8","2018-5-15","2018-5-27","2018-6-9","2030-4-20","2030-4-20","2030-4-20")
ClassesList[index,c(3:13)] = findAllWeeks(ClassesList[index,"W1"],as.logical(YearList[which(YearList[,"QuarterYear"]==ClassesList[index,"QuarterYear"]),c("W9break?")]))
ClassesList[index,"QueueStatus"] = 196
ClassesList[index,"NumStudents"] = 202
ClassesList[index,"InstructorRating"] = 4.4
ClassesList[index,"AvgHrsSpent"] = 16.35
ClassesList[index,"ProportionFrosh"] = 0.29
ClassesList[index,"ProportionGrads"] = 0.14
ClassesList[index,"ProportionPhDs"] = 0.05

######## CS 107 AUTUMN 2018 #######
index = 5
ClassesList[index,c("ClassNum","QuarterYear")]= c("CS107","Autumn2018")
ClassesList[index,"W1"] = YearList[which(YearList[,"QuarterYear"]==ClassesList[index,"QuarterYear"]),c("W1")]
ClassesList[index,c("MidtermDate1","MidtermDate2")] = c("2018-11-2","2030-4-20")
ClassesList[index,"FinalsDate"] = c("2018-12-14")
## Autumn 2018 
ClassesList[index,c(14:23)] = c("2018-10-1","2018-10-8","2018-10-15","2018-10-22","2018-10-29","2018-11-9","2018-11-27","2030-4-20","2030-4-20","2030-4-20")
## Figures out the rest of the weeks
ClassesList[index,c(3:13)] = findAllWeeks(ClassesList[index,"W1"],as.logical(YearList[which(YearList[,"QuarterYear"]==ClassesList[index,"QuarterYear"]),c("W9break?")]))
ClassesList[index,"QueueStatus"] = 261
ClassesList[index,"NumStudents"] = 220
ClassesList[index,"InstructorRating"] = 4.5
ClassesList[index,"AvgHrsSpent"] = 16.35
ClassesList[index,"ProportionFrosh"] = 0.29
ClassesList[index,"ProportionGrads"] = 0.14
ClassesList[index,"ProportionPhDs"] = 0.05

#saveRDS(ClassesList,"11.26CS107ClassesListInfo.RDAT")
