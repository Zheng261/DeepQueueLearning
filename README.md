1) QueueScraper folder

collectQSData.R: Main file to scrape hourly data from queuestatus, preprocessing, data augmentation. Run the "set up class" scripts first.
collectUntrimmedData.R: Main file to collect untrimmed hourly data from queuestatus.
setUpClassInfo.R: Main file to set up class info (midterms, assn dates, class names, queuestatus pages, etc.).
setUpMoreClassInfo.R: Secondary file to set up class info (midterms, assn dates, class names, queuestatus pages, etc.). 
Other files: Converting datasets into different bucket lengths.


2) RandomForestCode 

randomForest.R: Runs random forest classifier.

3) PredictionCode

Contains all of our models, besides LSTMs. Everything can be run with python3- for example, python3 predict_SVM.py trains an SVM model on the datasets.

4) LSTMs

Contains LSTM models. Run same way as other code.

5) Scheduler

Contains all files regarding our scheduler functions. scheduler.py contains our main file, which uses Gibbs sampling to optimize TA assignments based on cosine correlation. TaAssignments/generateTAAvail.py generates realistic TA constraints so that our simulator can be tested on realistic conditions.

6) Datasets folder

Regular: One hour interval datasets, which is the default from gradescope.

ToDData: Data where office hours periods are separated by time of day. Mornings are defined as 9am-11am, noon 12pm-3pm, afternoon 4pm-7pm, evening 8pm onwards. Aggregating data this way allows us to hopefully reduce variability in entries.

IntData: Data where office hours periods are divided into time chunks (either 2 or 4 hours). We do this in a greedy manner - we go down the list of office hours and start a new interval whenever the last one ends. (ex. If in the regular dataset we have office hours entries at 9am, 10am, 11am, 3pm, 4pm, 8pm, and we want an interval of 2 hours, in our new dataset we have one entry for 9am-10am, one entry for 11am, one entry for 3pm-4pm, and one entry for 8pm). Aggregating data this way allows us to hopefully reduce variability in entries.

DailyData: Data seprarated into days.

FullDataToPredict: Unfiltered, 9AM-10PM hourly data for the classifier to make predictions regarding student demand with (and for scheduler to use)

Guide to features:
[1] "sign_ups" : # sign ups in interval                   
[2] "serves"  : # serves in interval                
[3] "servers"  : # servers in interval, on average                
[4] "average_wait_time" : average wait time within interval 
[5] "average_serve_time"  : average serve time within interval
[6] "day"                : day of entry       
[7] "avgDayServeTime"      : average serve time in the day        
[8] "loadInflux"          	: # sign ups in the interval * average serve time in the day        
[9-11] "daysAfterPrevAssnDue"         "daysUntilNextAssnDue"          "daysTilExam"  : Self explanatory - integers representing these numbers. We cutoff at 20 days (anything above is just 20). We may not use these features, since we have buckets.
[12] "hourOfDay" : hour (1-24) within the day. We may not use this feature, since we have buckets.              
[13] "weekNum"   : week (1-11) of entry
[14-17] "morning"                      "noon"                         "afternoon"                   "evening"   :
Indicator variables. Mornings are defined as 8am-12pm, noon 12pm-4pm, afternoon 4pm-8pm, evening 8pm onwards.
[18-22] "L10daysAfterPrevAssnDue"      "L5daysAfterPrevAssnDue"       "L3daysAfterPrevAssnDue"      "L1daysAfterPrevAssnDue" :
Indicator variables. One or less of these is 1. Buckets are 10-5 days, 4-3 days, 3-1 days, <1 day.
[23-26] "L10daysUntilNextAssnDue"      "L5daysUntilNextAssnDue"       "L3daysUntilNextAssnDue"      "L1daysUntilNextAssnDue" 
Indicator variables. One or less of these is 1. Buckets are 10-5 days, 4-3 days, 3-1 days, <1 day.      
[27-30] "L10daysTilExam"               "L5daysTilExam"                "L3daysTilExam"               "L1daysTilExam" 
Indicator variables. One or less of these is 1. Buckets are 10-5 days, 4-3 days, 3-1 days, <1 day.
[31-32] "isFirstOHWithinLastThreeHour" "isFirstOHWithinLastSixHour"   
Indicator variables. One or less of these is 1. (this OH is not within 0-3 hours of the last OH, or 4-6 hours of the last OH)
[33-34] "isLastOHWithinNextThreeHour"  "isLastOHWithinNextSixHour"    
Indicator variables. One or less of these is 1. (this OH is not within 0-3 hours of the next OH, or 4-6 hours of the next OH)
[35] "NumStudents"  : # students                
[36] "InstructorRating"  : Instructor rating (from carta) for the quarter. If unavailable, extracted from average of ratings in other courses    
[37] "AvgHrsSpent"   : Scraped from carta, self-explanatory.           
[38-41] "ProportionFrosh"              "ProportionGrads"              "ProportionPhDs"   : Scraped from carta, self-explanatory.           
[42] "NumEntriesInInt": Number of entries in the interval described (ex. on this day 3 nonzero entries exist in a "morning" period, as defined above).



7) Class simulator folder 

classSimulator.R launches a GUI to generate an unseen quarter of class based on user-specified parameters, and can be run to predict quarterly OH load for any class with any features and any quarter of 2019. Some changing of directories may be necessary to run this script. 

customPredictFCN.py makes quarterly predictions on custom-made files made by classSimulator.R

customScheduler.py schedules TAs (parameters given in file heading) optimally according to schedule produced by customPredictFCN.py. Some redirecting may be necessary. 


There are other files scattered about - most are self-explanatory in their purpose (ex. CS229poster, progress, etc.)



