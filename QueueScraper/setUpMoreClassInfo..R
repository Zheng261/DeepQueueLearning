index = 1
NewClassesList = ClassesList[0,]

###### CS161 SPRING 2017 #######
ClassesListModel = ClassesList[1,]
ClassesListModel[index,c("ClassNum","QuarterYear")]= c("CS161","Spring2017")
ClassesListModel[index,"W1"] = YearList[which(YearList[,"QuarterYear"]==ClassesListModel[index,"QuarterYear"]),c("W1")]
ClassesListModel[index,c("MidtermDate1","MidtermDate2")] = c("2017-5-3","2030-4-20")
ClassesListModel[index,"FinalsDate"] = c("2017-6-9")
## Spring 2017 assignments 
ClassesListModel[index,c(14:23)] = c("2017-4-14","2017-4-21","2017-4-28","2017-5-8","2017-5-19","2017-5-26","2017-6-2","2030-4-20","2030-4-20","2030-4-20")
ClassesListModel[index,c(3:13)] = findAllWeeks(ClassesListModel[index,"W1"],as.logical(YearList[which(YearList[,"QuarterYear"]==ClassesListModel[index,"QuarterYear"]),c("W9break?")]))
ClassesListModel[index,"QueueStatus"] = 94
ClassesListModel[index,"NumStudents"] = 93
## Mary Wooters
ClassesListModel[index,"InstructorRating"] = 4.0
ClassesListModel[index,"AvgHrsSpent"] = 10.12
ClassesListModel[index,"ProportionFrosh"] = 0.04
ClassesListModel[index,"ProportionGrads"] = 0.27
ClassesListModel[index,"ProportionPhDs"] = 0.08
NewClassesList = rbind(NewClassesList,ClassesListModel)

###### CS161 Autumn 2017 #######
ClassesListModel = ClassesList[1,]
ClassesListModel[index,c("ClassNum","QuarterYear")]= c("CS161","Autumn2017")
ClassesListModel[index,"W1"] = YearList[which(YearList[,"QuarterYear"]==ClassesListModel[index,"QuarterYear"]),c("W1")]
ClassesListModel[index,c("MidtermDate1","MidtermDate2")] = c("2017-10-30","2030-4-20")
ClassesListModel[index,"FinalsDate"] = c("2017-12-13")
### Autumn 2017 assignments
ClassesListModel[index,c(14:23)] = c("2017-10-6","2017-10-13","2017-10-20","2017-10-27","2017-11-10","2017-11-19","2017-12-1","2030-4-20","2030-4-20","2030-4-20")
ClassesListModel[index,c(3:13)] = findAllWeeks(ClassesListModel[index,"W1"],as.logical(YearList[which(YearList[,"QuarterYear"]==ClassesListModel[index,"QuarterYear"]),c("W9break?")]))
ClassesListModel[index,"QueueStatus"] = 130
ClassesListModel[index,"NumStudents"] = 64
ClassesListModel[index,"InstructorRating"] = 4.5
ClassesListModel[index,"AvgHrsSpent"] = 10.12
ClassesListModel[index,"ProportionFrosh"] = 0.04
ClassesListModel[index,"ProportionGrads"] = 0.27
ClassesListModel[index,"ProportionPhDs"] = 0.08
NewClassesList = rbind(NewClassesList,ClassesListModel)


###### CS110 Spring 2018 #######
ClassesListModel = ClassesList[1,]
ClassesListModel[index,c("ClassNum","QuarterYear")]= c("CS110","Spring2018")
ClassesListModel[index,"W1"] = YearList[which(YearList[,"QuarterYear"]==ClassesListModel[index,"QuarterYear"]),c("W1")]
ClassesListModel[index,c("MidtermDate1","MidtermDate2")] = c("2018-5-11","2030-4-20")
ClassesListModel[index,"FinalsDate"] = c("2018-6-11")
## Spring 2018 assignments (EXTRAPOLATED FROM 2017)
ClassesListModel[index,c(14:23)] = c("2018-4-12","2018-4-19","2018-5-1","2018-5-10","2018-5-17","2018-5-24","2018-6-1","2018-6-7","2030-4-20","2030-4-20")
ClassesListModel[index,c(3:13)] = findAllWeeks(ClassesListModel[index,"W1"],as.logical(YearList[which(YearList[,"QuarterYear"]==ClassesListModel[index,"QuarterYear"]),c("W9break?")]))
ClassesListModel[index,"QueueStatus"] = 203
ClassesListModel[index,"NumStudents"] = 187
## Jerry Cain (yeet Jerry)
ClassesListModel[index,"InstructorRating"] = 4.5
ClassesListModel[index,"AvgHrsSpent"] = 16.6
ClassesListModel[index,"ProportionFrosh"] = 0.08
ClassesListModel[index,"ProportionGrads"] = 0.18
ClassesListModel[index,"ProportionPhDs"] = 0.02
NewClassesList = rbind(NewClassesList,ClassesListModel)

###### CS110 Autumn 2018 #######
ClassesListModel = ClassesList[1,]
ClassesListModel[index,c("ClassNum","QuarterYear")]= c("CS110","Autumn2018")
ClassesListModel[index,"W1"] = YearList[which(YearList[,"QuarterYear"]==ClassesListModel[index,"QuarterYear"]),c("W1")]
ClassesListModel[index,c("MidtermDate1","MidtermDate2")] = c("2018-11-1","2030-4-20")
ClassesListModel[index,"FinalsDate"] = c("2018-12-13")
### Autumn 2018 assignments
### Mapreduce assignment due date extrapolated from the past
ClassesListModel[index,c(14:23)] = c("2018-10-3","2018-10-10","2018-10-21","2018-10-30","2018-11-7","2018-11-14","2018-11-29","2018-12-6","2030-4-20","2030-4-20")
ClassesListModel[index,c(3:13)] = findAllWeeks(ClassesListModel[index,"W1"],as.logical(YearList[which(YearList[,"QuarterYear"]==ClassesListModel[index,"QuarterYear"]),c("W9break?")]))
ClassesListModel[index,"QueueStatus"] = 262
ClassesListModel[index,"NumStudents"] = 116
## Jerry Cain (yeet Jerry)
ClassesListModel[index,"InstructorRating"] = 4.5
ClassesListModel[index,"AvgHrsSpent"] = 16.6
ClassesListModel[index,"ProportionFrosh"] = 0.08
ClassesListModel[index,"ProportionGrads"] = 0.18
ClassesListModel[index,"ProportionPhDs"] = 0.02
NewClassesList = rbind(NewClassesList,ClassesListModel)

### 3 hours of TAing per week for each TA. Depends on class! TAs - 2 hour slot, 1 hour slot 
### Blot out 2 hours 
### Possible class times - MWF or TT 
### Block out actual lecture time 
###### CS229 Autumn 2018 #######
ClassesListModel = ClassesList[1,]
ClassesListModel[index,c("ClassNum","QuarterYear")]= c("CS229","Autumn2018")
ClassesListModel[index,"W1"] = YearList[which(YearList[,"QuarterYear"]==ClassesListModel[index,"QuarterYear"]),c("W1")]
ClassesListModel[index,c("MidtermDate1","MidtermDate2")] = c("2018-11-7","2018-11-8")
ClassesListModel[index,"FinalsDate"] = c("2030-4-20")
### Autumn 2018 assignments
ClassesListModel[index,c(14:23)] = c("2018-10-17","2018-10-31","2018-11-14","2018-12-5","2030-4-20","2030-4-20","2030-4-20","2030-4-20","2030-4-20","2030-4-20")
ClassesListModel[index,c(3:13)] = findAllWeeks(ClassesListModel[index,"W1"],as.logical(YearList[which(YearList[,"QuarterYear"]==ClassesListModel[index,"QuarterYear"]),c("W9break?")]))
ClassesListModel[index,"QueueStatus"] = 251
ClassesListModel[index,"NumStudents"] = 634
## Andrew Ng?
ClassesListModel[index,"InstructorRating"] = 4.1
ClassesListModel[index,"AvgHrsSpent"] = 15.3
ClassesListModel[index,"ProportionFrosh"] = 0.04
ClassesListModel[index,"ProportionGrads"] = 0.49
ClassesListModel[index,"ProportionPhDs"] = 0.21
NewClassesList = rbind(NewClassesList,ClassesListModel)


###### CS224N Winter 2017 #######
ClassesListModel = ClassesList[1,]
ClassesListModel[index,c("ClassNum","QuarterYear")]= c("CS224N","Winter2017")
ClassesListModel[index,"W1"] = YearList[which(YearList[,"QuarterYear"]==ClassesListModel[index,"QuarterYear"]),c("W1")]
ClassesListModel[index,c("MidtermDate1","MidtermDate2")] = c("2017-2-14","2030-4-20")
ClassesListModel[index,"FinalsDate"] = c("2017-3-21")
### Autumn 2018 assignments
ClassesListModel[index,c(14:23)] = c("2017-1-26","2017-2-9","2017-2-25","2017-3-17","2030-4-20","2030-4-20","2030-4-20","2030-4-20","2030-4-20","2030-4-20")
ClassesListModel[index,c(3:13)] = findAllWeeks(ClassesListModel[index,"W1"],as.logical(YearList[which(YearList[,"QuarterYear"]==ClassesListModel[index,"QuarterYear"]),c("W9break?")]))
ClassesListModel[index,"QueueStatus"] = 68
ClassesListModel[index,"NumStudents"] = 414
## Andrew Ng?
ClassesListModel[index,"InstructorRating"] = 4.0
ClassesListModel[index,"AvgHrsSpent"] = 13.7
ClassesListModel[index,"ProportionFrosh"] = 0.03
ClassesListModel[index,"ProportionGrads"] = 0.54
ClassesListModel[index,"ProportionPhDs"] = 0.11
NewClassesList = rbind(NewClassesList,ClassesListModel)


###### CS224N Winter 2018 #######
ClassesListModel = ClassesList[1,]
ClassesListModel[index,c("ClassNum","QuarterYear")]= c("CS224N","Winter2018")
ClassesListModel[index,"W1"] = YearList[which(YearList[,"QuarterYear"]==ClassesListModel[index,"QuarterYear"]),c("W1")]
ClassesListModel[index,c("MidtermDate1","MidtermDate2")] = c("2018-2-13","2030-4-20")
ClassesListModel[index,"FinalsDate"] = c("2018-3-21")
### Autumn 2018 assignments
ClassesListModel[index,c(14:23)] = c("2018-1-25","2018-2-9","2018-2-27","2018-3-18","2030-4-20","2030-4-20","2030-4-20","2030-4-20","2030-4-20","2030-4-20")
ClassesListModel[index,c(3:13)] = findAllWeeks(ClassesListModel[index,"W1"],as.logical(YearList[which(YearList[,"QuarterYear"]==ClassesListModel[index,"QuarterYear"]),c("W9break?")]))
ClassesListModel[index,"QueueStatus"] = 164
ClassesListModel[index,"NumStudents"] = 274
ClassesListModel[index,"InstructorRating"] = 4.2
ClassesListModel[index,"AvgHrsSpent"] = 13.7
ClassesListModel[index,"ProportionFrosh"] = 0.03
ClassesListModel[index,"ProportionGrads"] = 0.54
ClassesListModel[index,"ProportionPhDs"] = 0.11
NewClassesList = rbind(NewClassesList,ClassesListModel)

### 3 hours of TAing per week for each TA. Depends on class! TAs - 2 hour slot, 1 hour slot 
### Blot out 2 hours 
### Possible class times - MWF or TT 
### Block out actual lecture time 

###### CS221 Autumn 2017 #######
ClassesListModel = ClassesList[1,]
ClassesListModel[index,c("ClassNum","QuarterYear")]= c("CS221","Autumn2017")
ClassesListModel[index,"W1"] = YearList[which(YearList[,"QuarterYear"]==ClassesListModel[index,"QuarterYear"]),c("W1")]
ClassesListModel[index,c("MidtermDate1","MidtermDate2")] = c("2017-11-27","2030-4-20")
ClassesListModel[index,"FinalsDate"] = c("2017-12-14")
ClassesListModel[index,c(14:23)] = c("2017-10-3","2017-10-9","2017-10-16","2017-10-23","2017-10-30","2017-11-6","2017-11-13","2017-12-7","2030-4-20","2030-4-20")
ClassesListModel[index,c(3:13)] = findAllWeeks(ClassesListModel[index,"W1"],as.logical(YearList[which(YearList[,"QuarterYear"]==ClassesListModel[index,"QuarterYear"]),c("W9break?")]))
ClassesListModel[index,"QueueStatus"] = 129
ClassesListModel[index,"NumStudents"] = 438
ClassesListModel[index,"InstructorRating"] = 4.5
ClassesListModel[index,"AvgHrsSpent"] = 12.2
ClassesListModel[index,"ProportionFrosh"] = 0.02
ClassesListModel[index,"ProportionGrads"] = 0.40
ClassesListModel[index,"ProportionPhDs"] = 0.10
NewClassesList = rbind(NewClassesList,ClassesListModel)


###### CS221 Autumn 2016 #######
##### Assignments expected to be same as 2018 #####
ClassesListModel = ClassesList[1,]
ClassesListModel[index,c("ClassNum","QuarterYear")]= c("CS221","Autumn2016")
ClassesListModel[index,"W1"] = YearList[which(YearList[,"QuarterYear"]==ClassesListModel[index,"QuarterYear"]),c("W1")]
ClassesListModel[index,c("MidtermDate1","MidtermDate2")] = c("2016-11-27","2030-4-20")
ClassesListModel[index,"FinalsDate"] = c("2016-12-14")
ClassesListModel[index,c(14:23)] = c("2016-10-3","2016-10-9","2016-10-16","2016-10-23","2016-10-30","2016-11-6","2016-11-13","2016-12-7","2030-4-20","2030-4-20")
ClassesListModel[index,c(3:13)] = findAllWeeks(ClassesListModel[index,"W1"],as.logical(YearList[which(YearList[,"QuarterYear"]==ClassesListModel[index,"QuarterYear"]),c("W9break?")]))
ClassesListModel[index,"QueueStatus"] = 45
ClassesListModel[index,"NumStudents"] = 386
ClassesListModel[index,"InstructorRating"] = 4.5
ClassesListModel[index,"AvgHrsSpent"] = 12.2
ClassesListModel[index,"ProportionFrosh"] = 0.02
ClassesListModel[index,"ProportionGrads"] = 0.40
ClassesListModel[index,"ProportionPhDs"] = 0.10
NewClassesList = rbind(NewClassesList,ClassesListModel)


###### CS231N Spring 2018
ClassesListModel = ClassesList[1,]
ClassesListModel[index,c("ClassNum","QuarterYear")]= c("CS231N","Spring2018")
ClassesListModel[index,"W1"] = YearList[which(YearList[,"QuarterYear"]==ClassesListModel[index,"QuarterYear"]),c("W1")]
ClassesListModel[index,c("MidtermDate1","MidtermDate2")] = c("2018-5-9","2030-4-20")
ClassesListModel[index,"FinalsDate"] = c("2018-6-12")
ClassesListModel[index,c(14:23)] = c("2018-4-20","2018-5-4","2018-5-26","2018-6-5","2018-10-30","2030-4-20","2030-4-20","2030-4-20","2030-4-20","2030-4-20")
ClassesListModel[index,c(3:13)] = findAllWeeks(ClassesListModel[index,"W1"],as.logical(YearList[which(YearList[,"QuarterYear"]==ClassesListModel[index,"QuarterYear"]),c("W9break?")]))
ClassesListModel[index,"QueueStatus"] = 207
ClassesListModel[index,"NumStudents"] = 432
ClassesListModel[index,"InstructorRating"] = 4.3
ClassesListModel[index,"AvgHrsSpent"] = 12.38
ClassesListModel[index,"ProportionFrosh"] = 0.02
ClassesListModel[index,"ProportionGrads"] = 0.52
ClassesListModel[index,"ProportionPhDs"] = 0.27
NewClassesList = rbind(NewClassesList,ClassesListModel)

###### CS124 Winter 2017
ClassesListModel = ClassesList[1,]
ClassesListModel[index,c("ClassNum","QuarterYear")]= c("CS124","Winter2017")
ClassesListModel[index,"W1"] = YearList[which(YearList[,"QuarterYear"]==ClassesListModel[index,"QuarterYear"]),c("W1")]
ClassesListModel[index,c("MidtermDate1","MidtermDate2")] = c("2030-4-20","2030-4-20")
ClassesListModel[index,"FinalsDate"] = c("2017-3-20")
ClassesListModel[index,c(14:23)] = c("2017-1-20","2017-1-27","2017-2-2","2017-2-10","2017-2-17","2017-2-28","2017-3-7","2017-3-14","2030-4-20","2030-4-20")
ClassesListModel[index,c(3:13)] = findAllWeeks(ClassesListModel[index,"W1"],as.logical(YearList[which(YearList[,"QuarterYear"]==ClassesListModel[index,"QuarterYear"]),c("W9break?")]))
ClassesListModel[index,"QueueStatus"] = 70
ClassesListModel[index,"NumStudents"] = 154
ClassesListModel[index,"InstructorRating"] = 4.5
ClassesListModel[index,"AvgHrsSpent"] = 8.8
ClassesListModel[index,"ProportionFrosh"] = 0.02
ClassesListModel[index,"ProportionGrads"] = 0.20
ClassesListModel[index,"ProportionPhDs"] = 0.04
NewClassesList = rbind(NewClassesList,ClassesListModel)


###### CS124 Winter 2018
ClassesListModel = ClassesList[1,]
ClassesListModel[index,c("ClassNum","QuarterYear")]= c("CS124","Winter2018")
ClassesListModel[index,"W1"] = YearList[which(YearList[,"QuarterYear"]==ClassesListModel[index,"QuarterYear"]),c("W1")]
ClassesListModel[index,c("MidtermDate1","MidtermDate2")] = c("2030-4-20","2030-4-20")
ClassesListModel[index,"FinalsDate"] = c("2018-3-19")
ClassesListModel[index,c(14:23)] = c("2018-1-19","2018-1-26","2018-2-1","2018-2-9","2018-2-16","2018-2-27","2018-3-6","2018-3-13","2030-4-20","2030-4-20")
ClassesListModel[index,c(3:13)] = findAllWeeks(ClassesListModel[index,"W1"],as.logical(YearList[which(YearList[,"QuarterYear"]==ClassesListModel[index,"QuarterYear"]),c("W9break?")]))
ClassesListModel[index,"QueueStatus"] = 180
ClassesListModel[index,"NumStudents"] = 205
ClassesListModel[index,"InstructorRating"] = 4.5
ClassesListModel[index,"AvgHrsSpent"] = 8.8
ClassesListModel[index,"ProportionFrosh"] = 0.02
ClassesListModel[index,"ProportionGrads"] = 0.20
ClassesListModel[index,"ProportionPhDs"] = 0.04
NewClassesList = rbind(NewClassesList,ClassesListModel)
ClassesList = rbind(ClassesList,NewClassesList)

