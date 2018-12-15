library(fgui)

SimulateNewClass <- function(ClassNum = "CS107", 
                             QuarterYear = "Winter2019", 
                             #AssnList = AssnList, 
                             #MidtermList = MidtermList, 
                             #FinalsList = FinalsList, 
                             NumStudents = 200, 
                             InstructorRating = 4.0, 
                             AvgHrsSpent = 15, 
                             ProportionFrosh = 0.20, 
                             ProportionGrads = 0.15, 
                             ProportionPhDs = 0.05) {
  class = 1
  index = 1
  if (QuarterYear == "Winter2019") {
    winterData <- read.csv("FullDataToPredict/FullCS107Winter2018dataset.csv")
  } else {
    winterData <- read.csv("FullDataToPredict/FullCS107Spring2018dataset.csv")
  }
  rownames(winterData) = winterData$X
  winterData = winterData[,which(colnames(winterData) != "X")]
  TempStuffList = data.frame(matrix(ncol=21,nrow=1))
  colnames(TempStuffList) <- c("ClassNum","QuarterYear","W1","W2","W3","W4","W5","W6","W7","W8","W9","W10","W11",
                             "QueueStatus","NumStudents","InstructorRating","AvgHrsSpent","ProportionFrosh","ProportionGrads","ProportionPhDs")
  TempStuffList[index,c("ClassNum","QuarterYear")]= c(ClassNum,QuarterYear)
  TempStuffList[index,"W1"] = YearList[which(YearList[,"QuarterYear"]==TempStuffList[index,"QuarterYear"]),c("W1")]
  TempStuffList[index,c(3:13)] = findAllWeeks(TempStuffList[index,"W1"],as.logical(YearList[which(YearList[,"QuarterYear"]==TempStuffList[index,"QuarterYear"]),c("W9break?")]))
  TempStuffList[index,"QueueStatus"] = 0
  TempStuffList[index,"NumStudents"] = NumStudents
  TempStuffList[index,"InstructorRating"] = InstructorRating
  TempStuffList[index,"AvgHrsSpent"] = AvgHrsSpent
  TempStuffList[index,"ProportionFrosh"] = ProportionFrosh
  TempStuffList[index,"ProportionGrads"] = ProportionGrads
  TempStuffList[index,"ProportionPhDs"] = ProportionPhDs
  
  sparseDayHourFrame = winterData
  sparseDayHourFrame$sign_ups = 0
  sparseDayHourFrame$servers = 0
  sparseDayHourFrame$serves = 0
  sparseDayHourFrame$average_wait_time = 0
  sparseDayHourFrame$average_serve_time = 0
  sparseDayHourFrame$loadInflux = 0
  sparseDayHourFrame$daysTilExam = 0
  sparseDayHourFrame$weekNum = 0
  sparseDayHourFrame$hourOfDay = 0
  
  sparseDayHourFrame$monday = 0
  sparseDayHourFrame$tuesday = 0
  sparseDayHourFrame$wednesday = 0
  sparseDayHourFrame$thursday = 0
  sparseDayHourFrame$friday = 0
  sparseDayHourFrame$saturday = 0
  sparseDayHourFrame$sunday = 0
  
  ### Morning is 8AM to 11AM (8-11)###
  sparseDayHourFrame$morning = 0
  ### Noon is 12PM to 3PM (12-15)###
  sparseDayHourFrame$noon = 0
  ### Afternoon is 4PM to 7PM (16-19)###
  sparseDayHourFrame$afternoon = 0
  ### Evening is 8PM to 12AM (20-23) (12 is just a fringe case, hopefully TAs dont actually stay that long)###
  sparseDayHourFrame$evening = 0
  
  sparseDayHourFrame$L10daysAfterPrevAssnDue = 0
  sparseDayHourFrame$L5daysAfterPrevAssnDue = 0
  sparseDayHourFrame$L3daysAfterPrevAssnDue = 0
  sparseDayHourFrame$L1daysAfterPrevAssnDue = 0
  
  sparseDayHourFrame$L10daysUntilNextAssnDue = 0
  sparseDayHourFrame$L5daysUntilNextAssnDue = 0
  sparseDayHourFrame$L3daysUntilNextAssnDue = 0
  sparseDayHourFrame$L1daysUntilNextAssnDue = 0
  
  sparseDayHourFrame$L10daysTilExam = 0
  sparseDayHourFrame$L5daysTilExam = 0
  sparseDayHourFrame$L3daysTilExam = 0
  sparseDayHourFrame$L1daysTilExam = 0
  
  #### Week numbers of the year ####
  weekList <- TempStuffList[class,c(3:13)]
  weekList <- weekList[which(weekList[1,] != "2030-4-20")]
  
  ### Gets date of stuff
  midtermDates <- MidtermList
  finalDates <- FinalsList
  assnList <- AssnList
  
  for (entry in c(1:nrow(sparseDayHourFrame))){
    time <- strptime(rownames(sparseDayHourFrame)[entry],format="%b %d, %Y %I:%M %p")
    time$year <- time$year+1
    
    ### Figures out if this is the first OH within the last four hours
   
      sparseDayHourFrame$hourOfDay[entry] = time$hour
      if (time$hour <= 11) {
        sparseDayHourFrame$morning[entry] = 1
      } else if (time$hour <= 15) {
        sparseDayHourFrame$noon[entry] = 1
      } else if (time$hour <= 19) {
        sparseDayHourFrame$afternoon[entry] = 1
      } else if (time$hour <= 24) {
        sparseDayHourFrame$evening[entry] = 1
      }
    
    sparseDayHourFrame$day[entry] = time$wday
    if (sparseDayHourFrame$day[entry] == 1) {
      sparseDayHourFrame$monday[entry] = 1
    } else if (sparseDayHourFrame$day[entry] == 2) {
      sparseDayHourFrame$tuesday[entry] = 1
    } else if (sparseDayHourFrame$day[entry] == 3) {
      sparseDayHourFrame$wednesday[entry] = 1
    } else if (sparseDayHourFrame$day[entry] == 4) {
      sparseDayHourFrame$thursday[entry] = 1
    } else if (sparseDayHourFrame$day[entry] == 5) {
      sparseDayHourFrame$friday[entry] = 1
    } else if (sparseDayHourFrame$day[entry] == 6) {
      sparseDayHourFrame$saturday[entry] = 1
    } else if (sparseDayHourFrame$day[entry] == 0) {
      sparseDayHourFrame$sunday[entry] = 1
    }

    DaysAfterPrevDue = -1
    DaysBeforeNextDue = -1 
    WeekNum = 1
    
    for (weekIndex in 1:length(weekList)) {
      weekDate = as.POSIXct(weekList[weekIndex][1,1])
      days = weekDate - time
      daysBeforeOrAfter <- ceiling(as.numeric(days,units="days"))
      if (daysBeforeOrAfter >= 1) {
        break;
      }
      WeekNum = weekIndex
    }
    
    for (assn in assnList) {
      assnDate = as.POSIXct(assn)
      days = assnDate - time
      daysBeforeOrAfter <- ceiling(as.numeric(days,units="days"))
      if (daysBeforeOrAfter < 0) {
        DaysAfterPrevDue = -1*daysBeforeOrAfter
      }
      if (daysBeforeOrAfter >= 0) {
        DaysBeforeNextDue = daysBeforeOrAfter
        break;
      }
    }
    
    if (DaysAfterPrevDue < 0) {
      DaysAfterPrevDue = -1
    }
    if (DaysBeforeNextDue < 0) {
      DaysBeforeNextDue = -1
    }
    
    daysTilExam = 1000
    for (midterm in midtermDates) {
      weekDate = as.POSIXct(midterm)
      days = weekDate - time
      daysBeforeOrAfter <- ceiling(as.numeric(days,units="days"))
      if (daysBeforeOrAfter >= 0 & daysBeforeOrAfter < daysTilExam) {
        daysTilExam = daysBeforeOrAfter
      }
    }
    if (daysTilExam == 1000) {
      daysTilExam = -1
    }
    
    if (DaysAfterPrevDue <= 1) {
      sparseDayHourFrame$L1daysAfterPrevAssnDue[entry] = 1
    } else if (DaysAfterPrevDue <= 3) {
      sparseDayHourFrame$L3daysAfterPrevAssnDue[entry] = 1
    } else if (DaysAfterPrevDue <= 5) {
      sparseDayHourFrame$L5daysAfterPrevAssnDue[entry] = 1
    } else if (DaysAfterPrevDue <= 10) {
      sparseDayHourFrame$L10daysAfterPrevAssnDue[entry] = 1
    }
    if (DaysBeforeNextDue <= 1) {
      sparseDayHourFrame$L1daysUntilNextAssnDue[entry] = 1
    } else if (DaysBeforeNextDue <= 3) {
      sparseDayHourFrame$L3daysUntilNextAssnDue[entry] = 1
    } else if (DaysBeforeNextDue <= 5) {
      sparseDayHourFrame$L5daysUntilNextAssnDue[entry] = 1
    } else if (DaysBeforeNextDue <= 10) {
      sparseDayHourFrame$L10daysUntilNextAssnDue[entry] = 1
    }
    if (daysTilExam <= 1) {
      sparseDayHourFrame$L1daysTilExam[entry] = 1
    } else if (daysTilExam <= 3) {
      sparseDayHourFrame$L3daysTilExam[entry] = 1
    } else if (daysTilExam <= 5) {
      sparseDayHourFrame$L5daysTilExam[entry] = 1
    } else if (daysTilExam <= 10) {
      sparseDayHourFrame$L10daysTilExam[entry] = 1
    }
    sparseDayHourFrame$daysAfterPrevAssnDue[entry] = DaysAfterPrevDue
    sparseDayHourFrame$daysUntilNextAssnDue[entry] = DaysBeforeNextDue
    sparseDayHourFrame$weekNum[entry] = WeekNum
    sparseDayHourFrame$daysTilExam[entry] = daysTilExam
  }
  sparseDayHourFrame = subset(sparseDayHourFrame,hourOfDay > 8)
  sparseDayHourFrame = subset(sparseDayHourFrame,hourOfDay < 22)
  sparseDayHourFrame = subset(sparseDayHourFrame,saturday == 0)
  
  sparseDayHourFrame$NumStudents = NumStudents
  sparseDayHourFrame$InstructorRating = InstructorRating
  sparseDayHourFrame$AvgHrsSpent = AvgHrsSpent
  sparseDayHourFrame$ProportionFrosh = ProportionFrosh
  sparseDayHourFrame$ProportionGrads = ProportionGrads
  sparseDayHourFrame$ProportionPhDs = ProportionPhDs
  
  sparseDayHourFrame$index = 0
  for (entry in c(1:nrow(sparseDayHourFrame))) {
    day = (sparseDayHourFrame$day[entry]-1)
    if (day == -1) {
      day = 6
    }
    sparseDayHourFrame$index[entry] = ((WeekNum)%%2)*7*24 + day*24 + sparseDayHourFrame$hourOfDay[entry]
  }
  #write.csv(sparseDayHourFrame,paste0("Custom/Custom",TempStuffList[class,"ClassNum"],TempStuffList[class,"QuarterYear"],"dataset.csv"))
  write.csv(sparseDayHourFrame,paste0("Custom/CustomCS","dataset.csv"))
  return(1)
}

#MidtermList =  c("2019-4-28","2019-5-25")
#FinalsList = c("2019-6-14")
## Spring 2018 (extrapolated but likely wrong)
#AssnList =  c("2019-4-11","2019-4-18","2019-4-26","2019-5-8","2019-5-15","2019-6-1","2019-6-9")

MidtermList =  c("2019-2-1", "2019-3-15")
FinalsList = c("2019-3-21")
AssnList = c("2019-1-17","2019-1-24","2019-1-31","2019-2-6","2019-2-13","2019-2-20","2019-2-27","2019-3-4","2019-3-11")

SimulateNewClass(ClassNum = "CS107", 
                 QuarterYear = "Winter2019",
                 NumStudents = 1000, 
                 InstructorRating = 4.0, 
                 AvgHrsSpent = 15, 
                 ProportionFrosh = 0.05, 
                 ProportionGrads = 0.90, 
                 ProportionPhDs = 0.01)


res <- gui(SimulateNewClass, argOption=list(QuarterYear=c("Winter2019","Spring2019"), output=1, closeOnExec=TRUE))

res


