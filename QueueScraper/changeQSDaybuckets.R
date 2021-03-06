changeDays <- function() {
  correctCols = readRDS("11.26DataRangeColnames.rdat")
  for (class in c(1:nrow(ClassesList))) {
    newDHFrame = correctCols
    fileName = paste0(ClassesList[class,"ClassNum"],ClassesList[class,"QuarterYear"],"dataset.csv")
    sparseDayHourFrame = read.csv(paste0("Regular/",fileName))
    rownames(sparseDayHourFrame) = sparseDayHourFrame[,1]
    sparseDayHourFrame = sparseDayHourFrame[,-1]
    entry = 1
    while (entry <= nrow(sparseDayHourFrame)) {
      startNew = FALSE
      nextUp = sparseDayHourFrame[entry,]
      dayfirstent = nextUp[1,"day"]
      weekfirstent = nextUp[1,"weekNum"]
      time <- strptime(rownames(sparseDayHourFrame)[entry],format="%b %d, %Y %I:%M %p")
      numEntriesInInt = 1
      ### Loops within interval
      for (timeWithin in c(1:24)) {
        nextEntry = entry+timeWithin
        ## If we're still within physical bounds
        if (nextEntry <= nrow(sparseDayHourFrame)) {

          daythisent = sparseDayHourFrame[nextEntry,"day"]
          weekthisent = sparseDayHourFrame[nextEntry,"weekNum"]
          
          ## If we are not within the time period requested
          if (daythisent != dayfirstent | weekfirstent != weekthisent) {
            startNew = TRUE
            entry = nextEntry
            break
          }
          numEntriesInInt = numEntriesInInt + 1
          
          ### If we haven't hit the end of the interval or end of the data frame yet, add info to existing row
          nextUp[1,c("sign_ups","serves","loadInflux","average_wait_time","average_serve_time")] = nextUp[1,c("sign_ups","serves","loadInflux","average_wait_time","average_serve_time")] + sparseDayHourFrame[nextEntry,c("sign_ups","serves","loadInflux","average_wait_time","average_serve_time")]
        } else {
          entry = entry + 1
        }
      }
      nextUp[1,c("servers","average_wait_time","average_serve_time")] = nextUp[1,c("servers","average_wait_time","average_serve_time")]/numEntriesInInt
      nextUp[1,c("NumEntriesInInt")] = numEntriesInInt
      newDHFrame = rbind(newDHFrame,nextUp)
    }
    write.csv(newDHFrame,paste0("DailyData/",fileName))
  }
}
changeDays()
