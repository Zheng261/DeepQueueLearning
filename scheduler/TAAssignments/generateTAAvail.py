#12 days
#9am to 11pm
import collections 
import random
## Start is the index (indexing from 1) from 12AM that we are scheduling TAs at the earliest
## 1 = 12am

def generateTAAvail(numTAs, start, end, numWeeks, daysPerWeek, possClassLengths, possNumClasses, possClassTimes, possClassStartHours, offDay):
	def generateRandomClassTimes():	
		### Classes can happen in either MWF, MW, TT, daily, or one day only. 
		### We say "classes" can start between 8AM and 7PM (classes also generalize to lab meetings, athletics events, part-time work, etc.) 
		### We say students take anything from 6-12 "classes".
		### "Classes" can take up a block lasting from anything between 1 and 3 hours.  
		numClasses = random.sample(possNumClasses,1)
		hoursDead = []
		for i in range(numClasses[0]):
			classTimes = random.sample(possClassTimes,1)[0]
			classStart = random.sample(possClassStartHours,1)[0]
			classLength = random.sample(possClassLengths,1)[0]
			for time in classTimes:
				hoursDead += range(classStart+24*time,classStart+classLength+1+24*time)
				hoursDead += range(classStart+24*time+7*24,classStart+classLength+1+24*time+7*24)
		return set(hoursDead)

	def generateOffDays():
		#days = range(1,daysPerWeek+1)
		#offDay = random.sample(days,1)[0]
		offDays = set([offDay+(x*7) for x in range(numWeeks)])
		return offDays


	TAtoAvailDays = collections.defaultdict(lambda:[])
	for i in range(numTAs):
		TAtoAvailDays[i] = []

	numDays = numWeeks*daysPerWeek
	for i in range(numTAs):
		classTimes = generateRandomClassTimes()
		offDays = generateOffDays()
		for day in range(numDays):
			if day not in offDays:
				for times in range(start,end+1):
					proposedTime = day*24+times
					if (proposedTime not in classTimes):
						TAtoAvailDays[i].append(proposedTime)
	# 	print(len(TAtoAvailDays[i]))
	# print("TA availability: {}".format(TAtoAvailDays))
	return TAtoAvailDays







# generateTAAvail(10)







