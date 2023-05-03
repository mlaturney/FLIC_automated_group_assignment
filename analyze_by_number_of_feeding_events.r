## Attach the R image that contains the relevant functions and load packages.
attach("FLICFunctions",pos=2)
require(ggplot2)
require(stats)

## Create the parameters used for the analysis.
## For a single well, start with the default Single Well Chamber
## set up. (but adjust as necessary)
p<-ParametersClass.SingleWell()

p=ParametersClass.SingleWell()
p=SetParameter(p, Feeding.Interval.Minimum = 10)
p=SetParameter(p, Feeding.Threshold.Value = 10)
p=SetParameter(p, Tasting.Threshold.Interval=c(01,02))
p=SetParameter(p, Feeding.Minevents = 6)
p=SetParameter(p, Signal.Threshold = 10)

## Read in the data, and store them in a dummy variable called 'dfm.'  
dfm<-DFMClass(1,p)
dfm<-DFMClass(2,p)
dfm<-DFMClass(3,p)
dfm<-DFMClass(4,p)
monitors<-c(1,2,3,4)

##To analyze individual well data, gives when/how long/intensity of each feeding event for a given well (specify the well # of interest)
Feeding.Durations.Well(dfm = DFM1,2,3,4)

## Export to a csv file with summary data - this will be located in the same folder as this one.
Feeding.Summary.Monitors(monitors,p,range = c(0,20))

#read in the old feeding summary
feedings<-read.csv(file="~/Desktop/FLICproject/FeedingSummary_DFM1_4.csv", header=TRUE)

#add columns to data frame
max_num_events<-max(feedings[4])
for (i in 1:max_num_events){
  name<-paste("event",toString(i), sep=" ")
  feedings[,name]<-0
}

#list of DFMS
dfms<-list(DFM1,DFM2,DFM3,DFM4)
num_dfms=length(dfms)
#go though each DFM and add event durations from each well
row_num<-0
for (dfm in 1:num_dfms){
  for (well in 1:12){
    events<-Feeding.Durations.Well(dfms[[dfm]],well)
    if (events==0) {
      row_num<-row_num+1
    }
    else{
      event_durations<-events[,3]
      num_events=length(event_durations)
      row_num<-row_num+1
      col_num<-40
      for (event in 1:num_events){
        feedings[row_num,col_num]<-event_durations[event]
        col_num<-col_num+1
      }
    }
  }
}

#save new feeding summary
write.csv(feedings,file="~/Desktop/FLICproject/feeding_summary_date.csv")
