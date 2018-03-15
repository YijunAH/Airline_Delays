Airline Delay Data Analysis

date: 03/10/2018
author: Yijun Guo (yumao77@gmail.com)

### 1. Loading libraries and acquire some basic information related to the dataset

setwd('~/Documents/DataScience/R/r-bootcamp-2017-master/data/')

air<-read.csv('airline.csv')

library(ggplot2)
library(gridExtra)
library(dplyr)
library(reshape2)
library(GGally)

# dim(air)
# over 500,000 observations and with 29 variables

str(air)

# Origin: just one level: SFO
# UniqueCarrier: 21 levels

unique(air$Year)
# data from 2005 to 2008

unique(air$Month)
# table(air$Year, air$Month)
# 12 months data included in each year

# range(air$WeatherDelay, na.rm=TRUE)

# range(air$CarrierDelay, na.rm=TRUE)

# range(air$DepTime, na.rm=TRUE)

# head(air, 10)

# names(air)
# types of delay: CarrierDelay, WeatherDelay, NASDelay, SecurityDelay, LateAircraftDelay
# NASDelay: National Air System Delay (info from: https://www.transtats.bts.gov/Fields.asp?Table_ID=236)

# airNA<-na.omit(air)
# 540,000 down to 427,000. 
# over 20% of all the rows have NA in them


### 2. Brief look at DepDelay and ArrDelay

# cor.test(air$DepDelay, air$ArrDelay)
# Cor==0.94
# strong corelation between DepDelay and ArrDelay

range(air$ArrDelay, na.rm=TRUE)
range(air$DepDelay, na.rm=TRUE)
# both of them have quite extreme values

ggplot(aes(x= air$ArrDelay), data=air)+geom_histogram()+xlim(c(-60,180))
ggplot(aes(x= air$DepDelay), data=air)+geom_histogram()+xlim(c(-60,180))
# both are long-tailed data

ggplot(aes(x=DepDelay, y=ArrDelay), data=air) + geom_point()
# took quite a long time to generate plot.
# In order to make some quick plotting, subset air data

set.seed(200)
# make the subset reproducible
airsub <- air[sample(1:nrow(air), 10000, replace = FALSE), ]

P1<-ggplot(aes(x=Distance, y=DepDelay), data=airsub) + 
  geom_point(alpha=0.1, color='blue') + ylim(c(-50,100)) + theme_bw()
# would longer/shorter distance cause DepDelay? Not clear from this graph
# distance: no data was collected from ~1000 to 1500
P2<-ggplot(aes(x=Distance, y=ArrDelay), data=airsub) + 
  geom_point(alpha=0.1, color='red') + ylim(c(-50,100)) + theme_bw()
# would longer/shorter distance cause ArrDelay? Not clear from this graph

P1P2<-grid.arrange(P1, P2, ncol=2)
ggsave('DistanceDelay.png', P1P2, width = 12, height = 6)
# It seems that ArrDelay is smaller than DepDelay

# mean(airsub$DepDelay, na.rm = TRUE)
# median(airsub$DepDelay, na.rm = TRUE)
# mean(airsub$ArrDelay, na.rm = TRUE)
# median(airsub$ArrDelay, na.rm = TRUE)
# mean of DepDelay (10.59) is higher than mean of ArrDelay (8.97)
# Both DepDelay and ArrDelay have median of -1


### 3. Do DepDelay happens more during weekends/weekdays? a perticular month? a perticular year? 
# DayOfWeek, DayOfMonth, Month, Year
P3<-ggplot(aes(x=as.factor(DayOfWeek), y=DepDelay), data=airsub) + 
  geom_boxplot() + theme_classic() + ylim(c(-5,15)) + xlab('Day of Week') + 
  ylab('Departure Delay in Mins')
P4<-ggplot(aes(x=as.factor(Month), y=DepDelay), data=airsub) + 
  geom_boxplot() + theme_classic() + ylim(c(-5,15)) + xlab('Month') + 
  ylab('Departure Delay in Mins')
P5<-ggplot(aes(x=as.factor(Year), y=DepDelay), data=airsub) + geom_boxplot()+
  ylim(c(-5,15)) + theme_classic() + xlab('Year') + 
  ylab('Departure Delay in Mins')

ggplot(aes(x=as.factor(DayofMonth), y=DepDelay), data=airsub) + geom_boxplot()+
  ylim(c(-5,15)) + theme_classic() + xlab('Day Of Month') + 
  ylab('Departure Delay in Mins')

P3P4P5<-grid.arrange(P3, P4, P5, ncol=3)
# ggsave('DayMonthYear.png', P3P4P5, width = 20, height = 7)

# Day of Week: Tues flights are more likely to depart on time (early) Fri, Sat and Sun shows boarder distribution in DepDelay
# Month: Apr, Sept and Oct flights are more likely to depart on time
# Year: 2005 shows narrower distritbution

airYearDepDelaySummary<-air%>%
  group_by(Year)%>%
  summarise(mean=mean(DepDelay, na.rm=T), 
            median=median(DepDelay, na.rm=T),
            n=n())%>%
  arrange(desc(mean))%>%
  ungroup()

ggplot(aes(x=Year, y= mean), data=airYearDepDelaySummary, fill="Black") + 
  geom_bar(stat = "identity") + 
  geom_bar(aes(x=Year, y= median), stat = "identity", fill="Red") + theme_bw()
# DepDelay increases every year

ggplot(aes(x=Year, y=n), data=airYearDepDelaySummary)+ geom_bar(stat = "identity") + 
  coord_cartesian(ylim = c(100000, 150000))
# Number of flights shows steady growth over years

# From previous analysis, it seems Tues flights are more likely to depart on time.
# But is this due to less flights on Tues?
P6<-ggplot(aes(x=as.factor(DayOfWeek)), data=air)+geom_bar()+ theme_classic() + xlab('Day Of Week') + 
  ylab('Number of Flights') + coord_cartesian(ylim = c(50000, 80000))
# No. Tuesday actually have similar flights comparing with other weekdays
# Sat. has less flights scheduled.

# Same as before. Apr, Sept and Oct have more or less flights?
P7<-ggplot(aes(x=as.factor(Month)), data=air, fill=black) + geom_bar() + theme_classic() + 
  xlab('Month') + ylab('Number of Flights') + coord_cartesian(ylim = c(30000, 50000))
# Apr have slightly less flights. Sept and Oct have similar flights as Nov and Dec
# Surprisingly, it is not Dec. but maybe due to vacation and semester start, Jul and Aug have the most flight No.

P8<-ggplot(aes(x=as.factor(Year)), data=air)+geom_bar()+ theme_classic() + xlab('Year') + 
  ylab('Number of Flights') + coord_cartesian(ylim = c(100000, 150000))

P6P7P8<-grid.arrange(P6, P7, P8, ncol=3)
# ggsave('DayMonthYearNumberofFlights.png', P6P7P8, width = 20, height = 7)


### 4. Does the departure time affect departure delay? Does 'when to fly' matters?
ggplot(aes(x=DepTime, y=DepDelay), data=air) + geom_point(alpha=0.1) +
  ylim(c(-5,15))
# No flights from ~30 to 530
# test<-subset(airsub, DepTime>600&DepTime<2100)
# cor.test(test$DepTime, test$DepDelay)
# very little effect


### 5. Does it matter where you are going? (Dest)
unique(air$Dest)
# 82 levels

airDestDepDelaySummary<-air%>%
  group_by(Dest)%>%
  summarise(mean=mean(DepDelay, na.rm=T), 
            median=median(DepDelay, na.rm=T),
            n=n())%>%
  arrange(desc(n))%>%
  ungroup()

airDestDepDelaySummary<-airDestDepDelaySummary[1:10, ]

ggplot(aes(x=Dest, y= mean), data=airDestDepDelaySummary, fill="Black") + 
  geom_bar(stat = "identity") + 
  geom_bar(aes(x=Dest, y= median), stat = "identity", fill="Red") + theme_bw() + 
  xlab('Destination') + ylab('Departure Delay in Mins') + 
  ggtitle('Mean and Median of Departure Delay with Top 10 Destination')
# ggsave('DestDelay.png', width=8, height=6)
# Black:mean
# Red: Median


### 6. Would different carrier cause different DepDelay?
### Mean, median, SD and n of each UniqueCarrier

ggplot(aes(x=UniqueCarrier), data=airsub) + geom_bar() + theme_bw()
# two huge bar (OO and UA)
# although there are 21 UniqueCarrier, top few carrier counts for over 90% of the data

ggplot(aes(x=UniqueCarrier, y=DepDelay), data=airsub)+ 
  geom_boxplot() + ylim(c(-10,20))
# Different carrier show clear difference in DepDelay

airCarrierDepDelaySummary<-air%>%
  group_by(UniqueCarrier)%>%summarise(
    mean=mean(DepDelay, na.rm=T),
    median=median(DepDelay, na.rm=T),
    sd=sd(DepDelay, na.rm=T),
    n=n())%>% 
  arrange(desc(n))%>%
  ungroup()
# two most fly carrier: UA and OO

airCarrierDepDelaySummarySmall<-airCarrierDepDelaySummary[1:10, ]

ggplot(aes(x=UniqueCarrier, y= mean), data=airCarrierDepDelaySummarySmall, fill="Black") + 
  geom_bar(stat = "identity") + 
  geom_bar(aes(x=UniqueCarrier, y= median), stat = "identity", fill="Red") + theme_bw() + 
  xlab('Carrier') + ylab('Departure Delay in Mins') + 
  ggtitle('Mean and Median of Departure Delay with Each Carrier')
# ggsave('MeanMedianDepDelayCarrier.png', width=8, height=6)
# OO and US have median of zero
# Black bar: mean
# Red bar: median

### 7. t-test on UA and OO
UAdelay<-subset(air, UniqueCarrier=='UA')$DepDelay
OOdelay<-subset(air, UniqueCarrier=='OO')$DepDelay
ttestUAOO<-t.test(UAdelay, OOdelay, alternative = "two.sided")
ttestUAOO
# t = -20.583, df = 326100, p-value < 2.2e-16
# The two-sample t-test shows that the two carriers, UA and OO, significantly differ from each other regarding the DepDelay


### 8. Delay reason analysis with top 8 Carrier

# From the dataset, we saw there are different reasons cause flight delay. What are the most common ones?
# Types of delay:
# CarrierDelay, WeatherDelay, NASDelay, SecurityDelay, LateAircraftDelay
Top8Carrier<-head(unique((airCarrierDepDelaySummary$UniqueCarrier)), 8)
Top8Carrier
# the eight most frequent flight carrier: UA OO AA US DL AS CO NW
airTop8Carrier<-subset(air, UniqueCarrier %in% Top8Carrier)

DelayReasonAnalysis<-airTop8Carrier%>%
  group_by(UniqueCarrier, Year)%>%summarise(
    CarrierDelay=mean(CarrierDelay, na.rm=T),
    WeatherDelay=mean(WeatherDelay, na.rm=T),
    NASDelay=mean(NASDelay, na.rm=T),
    SecurityDelay=mean(SecurityDelay, na.rm=T),
    LateAircraftDelay=mean(LateAircraftDelay, na.rm=T),
    n=n())%>%
  arrange(desc(n))%>%
  ungroup()

DelayReasonAnalysisLong<-melt(DelayReasonAnalysis,
                        id.vars=c('UniqueCarrier','Year','n'),
                        measure.vars=c('CarrierDelay', 'WeatherDelay', 'NASDelay', 
                                       'SecurityDelay', 'LateAircraftDelay'),
                        variable.name=c('DelayReasons'),
                        value.name=c("DelayMins"))
# ID variables - all the variables to keep but not split apart on
# Name of the destination column that will identify the original
# column that the measurement came from

ggplot(aes(x=UniqueCarrier, y= DelayMins, fill=DelayReasons), 
       data= DelayReasonAnalysisLong) + 
  facet_grid(~Year)+geom_bar(stat = "identity")+theme_bw() + 
  xlab('Carrier From 2005 to 2008') + ylab('Departure Delay in Mins') + 
  ggtitle('Departure Delay Reason Analysis from 2005 to 2008')
ggsave('DelayReasonsYear.png', width=16, height=6)
# For most carrier, lateAircraft delay is the main delay reason
## Carrier 'OO' takes more carrier delay comparing with other popular carrier
# In 2008, there are longer departure delay happened comparing with 2005, 2006, 2007


### 9. Build a ArrDelay model with DepDelay, Distance and UniqueCarrier

airlm1<-subset(air, !is.na(air$DepDelay))

airlm2<-subset(airlm1, !is.na(air$ArrDelay))

airlm3<-subset(airlm2, UniqueCarrier%in%Top8Carrier)

ArrDelay_model<-(lm(ArrDelay ~ DepDelay + as.factor(Year)+ Distance + 
                      UniqueCarrier + Dest, data= airlm3))

summary(ArrDelay_model)
# R-squared:  0.8942