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

ClassesList = rbind(ClassesList,NewClassesList)
