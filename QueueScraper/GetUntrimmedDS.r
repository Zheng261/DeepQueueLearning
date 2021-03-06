setwd("/Users/ZhengYan/Desktop/CS221")

#class = 1
#Interval = "hour"
getQueueStatusFull <- function(class,Interval,MetaInterval = 1) {
  Start = as.POSIXct(ClassesList[class,"W1"])
  End = as.POSIXct(ClassesList[class,"FinalsDate"])
  Queue = ClassesList[class,"QueueStatus"]
  MonStart = substr(format(Start,"%B"),0,3)
  MonEnd = substr(format(End,"%B"),0,3)
  DayStart = format(Start,"%d")
  DayEnd = format(End,"%d")
  YearStart = format(Start,"%Y")
  YearEnd = format(End,"%Y")
  site = paste0('http://queuestatus.com/queues/',Queue,'/statistics/get_chart_data?metrics%5B%5D=sign_ups&metrics%5B%5D=serves&metrics%5B%5D=servers&metrics%5B%5D=average_wait_time&metrics%5B%5D=average_serve_time&')
  URL = paste0(site,'increment=',Interval,'&start_time=',MonStart,"+",DayStart,"%2C+",YearStart,"&end_time=",MonEnd,"+",DayEnd,"%2C+",YearEnd)
  queueStatus = tryCatch(jsonlite::fromJSON(URL), error = function(e) NULL)
  dayHourFrame <- data.frame(queueStatus$data[-1,-1])
  colnames(dayHourFrame) <- queueStatus$data[1,-1]
  rownames(dayHourFrame) <- queueStatus$data[-1,1]
  
  #### Takes away all entries where we have everything = 0 #####
  sparseDayHourFrame <- dayHourFrame
  #[apply(dayHourFrame, 1, function(x) { sum(x == 0) } ) != 5,]
  sparseDayHourFrame$day = 0
  sparseDayHourFrame$sign_ups = as.numeric(as.character(sparseDayHourFrame$sign_ups))
  sparseDayHourFrame$serves = as.numeric(as.character(sparseDayHourFrame$serves))
  sparseDayHourFrame$servers = as.numeric(as.character(sparseDayHourFrame$servers))
  sparseDayHourFrame$average_wait_time = as.numeric(as.character(sparseDayHourFrame$average_wait_time))
  sparseDayHourFrame$average_serve_time = as.numeric(as.character(sparseDayHourFrame$average_serve_time))
  sparseDayHourFrame$avgDayServeTime = 0
  sparseDayHourFrame$loadInflux = 0
  sparseDayHourFrame$daysAfterPrevAssnDue = 0
  sparseDayHourFrame$daysUntilNextAssnDue = 0
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
  
  if (Interval == "hour") {
    ### Morning is 8AM to 11AM (8-11)###
    sparseDayHourFrame$morning = 0
    ### Noon is 12PM to 3PM (12-15)###
    sparseDayHourFrame$noon = 0
    ### Afternoon is 4PM to 7PM (16-19)###
    sparseDayHourFrame$afternoon = 0
    ### Evening is 8PM to 12AM (20-23) (12 is just a fringe case, hopefully TAs dont actually stay that long)###
    sparseDayHourFrame$evening = 0
  }
  
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
  weekList <- ClassesList[class,c(3:13)]
  weekList <- weekList[which(weekList[1,] != "2030-4-20")]
  
  #### Assignment numbers of the year ####
  assnList <- ClassesList[class,c(14:23)]
  assnList <- assnList[which(assnList[1,] != "2030-4-20")]
  
  midtermDates <- ClassesList[class,c("MidtermDate1","MidtermDate2")]
  ### Takes out all dates that aren't really midterm dates
  midtermDates = midtermDates[which(midtermDates[1,] != "2030-4-20")]
  
  ### Gets date of final
  finalDates <- ClassesList[class,c("FinalsDate")]
  midtermDates = c(midtermDates, finalDates)
  
  for (entry in c(1:nrow(sparseDayHourFrame))){
    time <- strptime(rownames(sparseDayHourFrame)[entry],format="%b %d, %Y %I:%M %p")
    

    ### Figures out if this is the first OH within the last four hours
    if (Interval == "hour") {
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
    ###### Calculates average serve time that day ######
    otherEntriesInDay = which(substr(rownames(sparseDayHourFrame),0,6)==substr(rownames(sparseDayHourFrame)[entry],0,6))
    ServeTimesThatDay = sparseDayHourFrame[otherEntriesInDay,"average_serve_time"]
    ServeTimesThatDay = ServeTimesThatDay[ServeTimesThatDay != 0]
    avgServeTime = -1
    ### If someone queued up and literally no one served them the entire day, this is kinda bad, but we just say 15 cuz y not
    if (length(ServeTimesThatDay) < 1) {
      avgServeTime = -1
    } else {
      avgServeTime = mean(ServeTimesThatDay)
    }
    sparseDayHourFrame$avgDayServeTime[entry] = avgServeTime
    sparseDayHourFrame$loadInflux[entry] = sparseDayHourFrame$sign_ups[entry] * avgServeTime
    
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
  
  sparseDayHourFrame$NumStudents = ClassesList[class,"NumStudents"]
  sparseDayHourFrame$InstructorRating = ClassesList[class,"InstructorRating"]
  sparseDayHourFrame$AvgHrsSpent = ClassesList[class,"AvgHrsSpent"]
  sparseDayHourFrame$ProportionFrosh = ClassesList[class,"ProportionFrosh"]
  sparseDayHourFrame$ProportionGrads = ClassesList[class,"ProportionGrads"]
  sparseDayHourFrame$ProportionPhDs = ClassesList[class,"ProportionPhDs"]
  
  sparseDayHourFrame$index = 0
  for (entry in c(1:nrow(sparseDayHourFrame))) {
    day = (sparseDayHourFrame$day[entry]-1)
    if (day == -1) {
      day = 6
    }
    sparseDayHourFrame$index[entry] = ((WeekNum)%%2)*7*24 + day*24 + sparseDayHourFrame$hourOfDay[entry]
  }
  nameAppend = "FullDataToPredict/Full"
  if (MetaInterval != 1) {
    nameAppend = paste0(MetaInterval,"HrEntry")
  }
  if (Interval != "hour") {
    nameAppend = paste0(nameAppend,"Daily")
  }
  write.csv(sparseDayHourFrame,paste0(nameAppend,ClassesList[class,"ClassNum"],ClassesList[class,"QuarterYear"],"dataset.csv"))
}

MetaInterval = 1
for (class in c(1:nrow(ClassesList))) {
  print(class)
  getQueueStatusFull(class,Interval="hour",MetaInterval)
}

