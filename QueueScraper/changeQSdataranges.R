#sparseDayHourFrame$NumEntriesInInt = 0
#saveRDS(sparseDayHourFrame[0,],"11.26DataRangeColnames.rdat")
changeInterval <- function(MetaInterval = 2,ClassesList = ClassesList) {
  correctCols = readRDS("11.26DataRangeColnames.rdat")

  for (class in c(1:nrow(ClassesList))) {
    newDHFrame = correctCols
    
    fileName = paste0(ClassesList[class,"ClassNum"],ClassesList[class,"QuarterYear"],"dataset.csv")
    sparseDayHourFrame = read.csv(fileName)
    rownames(sparseDayHourFrame) = sparseDayHourFrame[,1]
    sparseDayHourFrame = sparseDayHourFrame[,-1]
    entry = 1
    
    while (entry <= nrow(sparseDayHourFrame)) {
      startNew = FALSE
      nextUp = sparseDayHourFrame[entry,]
      time <- strptime(rownames(sparseDayHourFrame)[entry],format="%b %d, %Y %I:%M %p")
      numEntriesInInt = 1
      ### Loops within interval
      for (timeWithin in c(1:(MetaInterval))) {
        nextEntry = entry+timeWithin
        ## If we're still within physical bounds
        if (nextEntry <= nrow(sparseDayHourFrame)) {
          NextTime <- strptime(rownames(sparseDayHourFrame)[nextEntry],format="%b %d, %Y %I:%M %p")
          hoursElapsed = NextTime - time
          hoursUntilNext = as.numeric(hoursElapsed,units="hours")
          ## If we have a 2 hour interval, we just want 2 entries - so time elapsed will be 2
          if (hoursUntilNext >= MetaInterval) {
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
      nextUp[1,c("average_wait_time","average_serve_time")] = nextUp[1,c("average_wait_time","average_serve_time")]/numEntriesInInt
      nextUp[1,c("NumEntriesInInt")] = numEntriesInInt
      newDHFrame = rbind(newDHFrame,nextUp)
    }
    write.csv(newDHFrame,paste0(MetaInterval,"Hr",fileName))
  }
}

changeInterval(MetaInterval = 4)

