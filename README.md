# Exploratory Data Analysis(EDA) on Airplane Delay Reasons, Distributions and Trends

(Please wait a few seconds for figures to show up)
Exploratory data analysis on airline dataset and build a prediction model on arrival delay

# General Background/Research Purpose

Airplane delay can be very frustrating to deal with. No one want to wait for hours in a crowded airport and wasting their vocation time or work time. That is why I am interested in doing exploratory data analysis with this airline dataset. The questions I want to answer are: what causes departure delay? Are delays getting better over the years or worse? Which carriers have longer delays and which ones have shorter delays? Are Nov. and Dec. the worst month to fly due to crowded holiday travel and unpredictable winter weather? Does the final destination(where you want to go) determine whether you can arrive on time?

# Brief Background Information about the datasets

The airline dataset contains over 500,000 observations and with 29 variables (columns)

It contains information of the flights which departs from San Francisco (SFO) to 82 different airports from 2005 to 2008

Goal: do exploratory data analysis and build a prediction model for arrival delay

# Data Analysis Method

I divided my study into XX sections. In section 1, I loaded airline dataset and required libraries to do data analysis and cleaning. Since I was looking into building a prediction model for arrival delay, it is common sense that departure delay could have great impact on arrival delay. We confirmed this in section 2. We also looked at if longer travel distance could cause departure/arrival delay. While most of the flights actually departs on time or even early (within 5 mins),  distance seems have little or no effect towards causing delay. (Fig. 1) Departure delay is more significant comparing with arrival delay

![DistanceDelay](doc/DistanceDelay.png?raw=true "DistanceDelay")

Fig. 1 Distance plotted against DepDelay (left, blue dots) and ArrDelay (right, red dots)

In section 3, I asked the question “Which day/month/year is bad for travel and why?” I looked into this question by making box plot of departure delay in mins Vs the seven different days in a week, 12 month in a year, and the four consecutive years in the dataset using ggplot2. For Fig. 2, it seems like Tuesday in a week is particular good for travel (short delay) which the rest of the days shows almost identical departure delay median. Friday and Sunday shows the same median comparing with other days, however, these two shows broader delay distribution (indicating longer delays are more likely to get longer). Looking at different months,  Apr. Sept. and Oct. clearly indicate smaller median. And Nov. and Dec. do not show significant more delays if just looking at the their departure delay median. From 2005 to 2008, the departure median stay the same. While giving a close look into the data, I notice that 2005 shows narrower inter-quartile range, 2006-2008 have similar broader inter-quartile range. Gathering date/time related data analysis, I started asking the question ‘Do longer delays happens in a particular day or month or year due to more flights on that particular time or these two are not related?’ 

![DayMonthYear](doc/DayMonthYear.png?raw=true "DayMonthYear")

Fig. 2 Box plot of departure delay Vs. day of week (left), 12 months in a year (middle) and 2005-2008(right).

Again looking at the box plot which summarize number of flights on each day/month/year in Fig. 3, weekdays have similar number of flights scheduled. It is the weekend (especially Sat.) which has less flights scheduled. Apr. does have slightly less flight scheduled. While Sept. and Oct. are as busy as Nov. and Dec. Feb. has less flights due to the fact that it is a shorter month. To my surprise, Nov. and Dec. are not the two busiest month in a year. It is Jun. and Jul. which are the busiest month maybe due to summer vocation season and end of semesters. From 2005 to 2008, there is steady growth (around 2%) for the number of flights each year.

![DayMonthYearNumberofFlights](doc/DayMonthYearNumberofFlights.png?raw=true "DayMonthYearNumberofFlights")

Fig. 3 Box plot of number of flights in each day of week (left), 12 months in a year (middle) and 2005-2008(right).

In section 4, I looked at if departure time shows great impact in departure delay. Moving to the next step, I explored the effect of destination towards delay. I summarized results and took a closer look at the ten most popular ten places from SFO. As I expected, Los Angles is the most commonly flew place from SFO. In Fig. 4, Most of these destinations shows departure delay around 10 min (mean) and -1 min (median).

![DestDelay](doc/DestDelay.png?raw=true "DestDelay")

Fig. 4 Mean and median of departure delay (in mins) with the top ten popular destination from SFO. Black bar is the mean and red bar is the median. If there is no bar, it means it is zero, like “ORD” in this plot

Since I looked at different destination, we next think about whether different carrier can result difference in departure delay. I always heard different carriers bragge about their being the most ‘on-time airline’ . In this dataset, the top three most popular carriers are “UA” (United Airline), “OO” (SkyWest Airlines) and “AA” (American Airline), these three have very similar delay performance. It is “NW” (Northwest Airlines) which shows smaller median and mean in departure delay. In section 7, I ran two-sample t-test on subsets which carriers are “UA” or “OO” (the two most popular carriers), the t-test shows that these two carriers UA and OO, significantly different from each other regarding the departure delay. Thus, in the later section (building linear regression model on arrival delay), we need to include ‘UniqueCarrier’ in our prediction model.

![MeanMedianDepDelayCarrier](doc/MeanMedianDepDelayCarrier.png?raw=true "MeanMedianDepDelayCarrier")

Fig. 5 Mean and median of departure delay (in mins) with the top ten popular carriers from SFO. Black bar is the mean and red bar is the median. If there is no bar, it means it is zero, like “OO”, “US” and “WN” in this plot


Carrier related delay, weather related delay, NAS(National Air System Delay: https://www.transtats.bts.gov/Fields.asp?Table_ID=236) delay, security related delay, late aircraft delay, there are different reasons behind departure or arrival delay. But what are the most common ones? Due to weather in Nov. and Dec.? Due to the previous late aircraft? In section 8, I explored the reason behind flight delay with the top eight most flew carrier in different years. In 2008, the mean of departure delay get significantly longer while from 2005 to 2007 for all carriers, the mean stay almost unchanged. For each carrier, from 2005 to 2008, the main delay reason stay almost the same. For most carrier, late aircraft delay is their main delay reason. ‘OO’ shows more carrier delay than other carriers. ‘AS’ has a obvious more deal due to late aircraft. Through out the years and different carriers, the delay due to security is negligible. Security crews at SFO airport is efficient in examining luggage.

![DelayReasonsYear](doc/DelayReasonsYear.png?raw=true "DelayReasonsYear")

Fig. 6 Box plot of departure delay reason from 2005 to 2008.

In section 9, we build a prediction model (y=Arrival Delay), based on variables we notice that are crucial (x= departure delay, distance, UniqueCarrier, Destination, Distance). The resulted R-squared reached 0.89.

# Conclusions

The initial motivation of doing exploratory data analysis on the airline dataset was to look at different factors which can cause departure and arrival delay. We looked into factors like travel distance, departure time, destination, travel time (weekday/weekend, month , year) and organized these interesting findings via reshape 2, dplyr and ggplot2 packages. The number of flights out does not necessarily related to delays. In other word, busy days do not correlate with delay (looking at Tuesday in a week and Sept. Oct. in a year). Nov. and Dec. are not as bad as I thought it would be for travel by air. These two months shows similar inter-quartile range comparing with Feb. Mar. May. and Jun. Over the years, there are more flight scheduled, although the median of departure delay stay the same, long delays temps to go longer. This drags the mean of departure delay increases over the years from 2005 to 2008. Different carriers behave differently in terms of delay time and delay reasons. Northwest Airlines (NW) shows the smallest median and mean in departure delay. The determinate reason behind delay for the most popular eight carriers we examined are carrier delay, weather delay and due to late aircraft. And among these three reasons,  late aircraft delay is their main delay reason. In the end of this study, we build a prediction model using linear regression via employing departure delay, distance, UniqueCarrier, and destination in the model. The resulted R-squared reached 0.89.

# References

The airline on-time performance data used in this study can be found at 


The page also provides descriptions of each of the 29 variables associated with each flight. 

