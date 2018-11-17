install.packages("RCurl")
library(RCurl)
library(jsonlite)
library(plyr)
library(dplyr)
library(httr)
library(lubridate)
library(randomForest)

### Sets work directory to be options folder
setwd("/Users/ZhengYan/Desktop/CS221")

### Code adapted from https://datawookie.netlify.com/blog/2015/01/downloading-options-data-in-r-an-update/
### into a much nicer, more condensed version. 
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
YearList[1,] = c("Winter2017",'2017-1-9','2017-3-13',FALSE)
YearList[2,] = c("Spring2017",'2017-4-3','2017-6-5',FALSE)
YearList[3,] = c("Autumn2017",'2017-9-25','2017-12-4',TRUE)
YearList[4,] = c("Winter2018",'2018-1-8','2018-3-12',FALSE)
YearList[5,] = c("Spring2018",'2018-4-2','2018-6-4',FALSE)
YearList[6,] = c("Autumn2018",'2018-9-24','2018-12-3',TRUE)

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
## Spring 2017 (extrapolated)
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
#class = 1
#Interval = "hour"
getQueueStatus <- function(class,Interval) {

  Interval = "hour"
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
  sparseDayHourFrame <- dayHourFrame[apply(dayHourFrame, 1, function(x) { sum(x == 0) } ) != 5,]
  sparseDayHourFrame$day = 0
  sparseDayHourFrame$sign_ups = as.numeric(as.character(sparseDayHourFrame$sign_ups))
  sparseDayHourFrame$serves = as.numeric(as.character(sparseDayHourFrame$serves))
  sparseDayHourFrame$servers = as.numeric(as.character(sparseDayHourFrame$servers))
  sparseDayHourFrame$average_wait_time = as.numeric(as.character(sparseDayHourFrame$average_wait_time))
  sparseDayHourFrame$average_serve_time = as.numeric(as.character(sparseDayHourFrame$average_serve_time))
  sparseDayHourFrame$avgDayServeTime = 0
  sparseDayHourFrame$loadInflux = 0
  sparseDayHourFrame$hourOfDay = 0
  sparseDayHourFrame$weekNum = 0
  sparseDayHourFrame$daysAfterPrevAssnDue = 0
  sparseDayHourFrame$daysUntilNextAssnDue = 0
  sparseDayHourFrame$daysTilExam = 0
  sparseDayHourFrame$isFirstOHWithinLastThreeHour = 1
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
    if (entry != 1) {
      LastTime <- strptime(rownames(sparseDayHourFrame)[entry-1],format="%b %d, %Y %I:%M %p")
      hoursElapsed = time - LastTime
      hoursSinceLast = as.numeric(hoursElapsed,units="hours")
      if (hoursSinceLast >= 3) {
        sparseDayHourFrame$isFirstOHWithinLastThreeHour[entry] = 1
      } else {
        sparseDayHourFrame$isFirstOHWithinLastThreeHour[entry] = 0
      }
    } 
    sparseDayHourFrame$hourOfDay[entry] = time$hour
    sparseDayHourFrame$day[entry] = time$wday
    ###### Calculates average serve time that day ######
    otherEntriesInDay = which(substr(rownames(sparseDayHourFrame),0,6)==substr(rownames(sparseDayHourFrame)[entry],0,6))
    ServeTimesThatDay = sparseDayHourFrame[otherEntriesInDay,"average_serve_time"]
    ServeTimesThatDay = ServeTimesThatDay[ServeTimesThatDay != 0]
    avgServeTime = -1
    ### If someone queued up and literally no one served them the entire day, this is kinda bad
    if (length(ServeTimesThatDay) < 1) {
      avgServeTime = 100
    } else {
      avgServeTime = mean(ServeTimesThatDay)
    }
    sparseDayHourFrame$avgDayServeTime[entry] = avgServeTime
    sparseDayHourFrame$loadInflux[entry] = sparseDayHourFrame$sign_ups[entry] * avgServeTime
    
    DaysAfterPrevDue = -1
    DaysBeforeNextDue = -1 
    WeekNum = 11
    
    for (weekIndex in 1:length(weekList)) {
      weekDate = as.POSIXct(weekList[weekIndex][1,1])
      days = weekDate - time
      daysBeforeOrAfter <- ceiling(as.numeric(days,units="days"))
      if (daysBeforeOrAfter >= -1) {
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
    
    sparseDayHourFrame$daysAfterPrevAssnDue[entry] = DaysAfterPrevDue
    sparseDayHourFrame$daysUntilNextAssnDue[entry] = DaysBeforeNextDue
    sparseDayHourFrame$weekNum[entry] = WeekNum
    sparseDayHourFrame$daysTilExam[entry] = daysTilExam
  }
  
  sparseDayHourFrame$NumStudents = ClassesList[class,"NumStudents"]
  sparseDayHourFrame$InstructorRating = ClassesList[class,"InstructorRating"]
  sparseDayHourFrame$AvgHrsSpent = ClassesList[class,"AvgHrsSpent"]
  sparseDayHourFrame$ProportionFrosh = ClassesList[class,"ProportionFrosh"]
  sparseDayHourFrame$ProportionGrads = ClassesList[class,"ProportionGrads"]
  sparseDayHourFrame$ProportionPhDs = ClassesList[class,"ProportionPhDs"]
  write.csv(sparseDayHourFrame,paste0(ClassesList[class,"ClassNum"],ClassesList[class,"QuarterYear"],"dataset.csv"))
}

for (class in c(1:nrow(ClassesList))) {
  getQueueStatus(class,Interval="hour")
}
