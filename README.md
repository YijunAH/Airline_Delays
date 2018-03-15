# Exploratory Data Analysis (EDA) on Airplane Delay Reasons, Distributions and Trends

(Please wait a few seconds for figures to show up)

Exploratory data analysis on airline dataset and build a prediction model on arrival delay using linear regression

# General Background/Research Purpose

Airplane delay can be very frustrating to deal with. No one wants to wait for hours in a crowded airport and wasting their vocation time or work time. That is why I am interested in doing exploratory data analysis with this airline dataset. The questions I want to answer in this study are: what causes departure/arrival delay? Are delays getting better over the years or worse? Which carriers have longer delays? Are Nov. and Dec. the worst month to fly due to holiday travel, vocation season and unpredictable winter weather? Does the final destination (where you want to go) determine whether you can arrive on time? Which airports are better at dealing delays, big/popular ones or smaller/less crowded ones?

# Brief Background Information about the datasets

The airline dataset contains over 500,000 observations and with 29 variables (columns)

It contains information of the flights which departs from San Francisco (SFO) to 82 different airports with 21 different carriers from 2005 to 2008

Goal: do exploratory data analysis and build a prediction model for arrival delay

# Data Analysis Method

I divided my study into nine sections in total. In section 1, I loaded airline dataset and imported required libraries to do data analysis and cleaning. Since I was looking into building a prediction model for arrival delay (ArrDelay), it is common sense that departure delay (DepDelay) could have great impact on arrival delay (if the airplane departs late, it would arrive late most likely). We get this confirmed in section 2. ArrDelay shows strong correlation with DepDelay (0.94). We also looked at if longer travel distance could cause departure/arrival delay. In Fig. 1, while most of the flights actually departs on time or even early (within 5 mins),  distance seems have little or no effect towards causing delay. Departure delay, with its mean at 10.59 mins, is more significant comparing with arrival delay, 8.97 mins.

![DistanceDelay](doc/DistanceDelay.png?raw=true "DistanceDelay")

Fig. 1 Distance plotted against DepDelay (left, blue dots) and ArrDelay (right, red dots)

In section 3, I asked the question “Which days/months/years are bad/good for travel and why?” I digged into this question by making box plot of departure delay against seven days in a week, 12 months in a year, and the four consecutive years in the dataset using ggplot2. In Fig. 2, it seems like Tuesday is particular good for travel (smaller median in DepDelay),  while the rest of the six days shows identical DepDelay median (-1 min). Friday and Sunday shows the same median comparing with other days except Tuesday, however, these two shows broader DepDelay distribution (indicating longer delays are more likely to get longer). Looking at different months,  Apr. Sept. and Oct. have smaller median, while Nov. and Dec. do not show significant more delays by looking at the their DepDelay median. From 2005 to 2008, the departure median stay the same. Giving a closer look at the data, I noticed that 2005 shows narrower inter-quartile range, 2006-2008 have similar broader inter-quartile range. Gathering all the information collected so far, I started asking the question ‘Do longer delays happens due to more flights on that particular time or these two are not related?’

![DayMonthYear](doc/DayMonthYear.png?raw=true "DayMonthYear")

Fig. 2 Box plot of departure delay (DepDelay in mins) Vs. seven days of a week (left), 12 months in a year (middle) and 2005-2008(right).

To answer this question, I made bar plots which summarize number of flights on each day/month/year in following Fig. 3. Weekdays have similar number of flights scheduled. It is the weekend (especially Sat.) which has less flights scheduled. Apr. does have slightly less flight scheduled, while Sept. and Oct. are as busy as Nov. and Dec. Feb. has less flights due to the fact that it is a shorter month. To my surprise, Nov. and Dec. are not the two busiest month in a year. It is Jul. and Aug. which are the busiest months in a year maybe due to vocation season, graduating season, and moving season. From 2005 to 2008, the number of flights on each year shows steady growth (around 2%). To quickly answer the previous question above, longer departure delays do not necessarily bind to more flights out on that particular time.

![DayMonthYearNumberofFlights](doc/DayMonthYearNumberofFlights.png?raw=true "DayMonthYearNumberofFlights")

Fig. 3 Bar plots of number of flights in seven days of a week (left), 12 months in a year (middle) and from 2005 to 2008(right).

In section 4, I looked at if departure time has certain impact in departure delay. I do not see strong correlation between these two factors. Moving to the next step, I explored the effect of destination towards delay. I summarized results and took a closer look at the ten most popular ten places where people flew from SFO, Fig. 4. As I expected, Los Angles(LAX) is the most commonly flew place from SFO, followed by Las Vegas(LAS). Most of these destinations have departure delay around 10 min (mean) and -1 min (median).

![DestDelay](doc/DestDelay.png?raw=true "DestDelay")

Fig. 4 Mean and median of departure delay (in mins) with the top ten popular destination from SFO. Black bar is the mean of departure delay and red bar is the median of departure delay. If there is no bar (like “ORD” in this plot), it means it is zero.

Since I looked at the effect of different destinations, the next thing I want to look at is whether different carrier can result difference in departure delay. I always hear different carriers brag about themselves being the most ‘on-time airline’. In this dataset, the top three most flew carriers are “UA” (United Airline), “OO” (SkyWest Airlines) and “AA” (American Airline). In Fig. 5 we see that these three have very similar departure delay behavior. It is the “NW” (Northwest Airlines) which shows much smaller median and mean in departure delay. In section 7, I ran two-sample t-test on subsets which carriers are either “UA” or “OO” (the two most popular carriers). The resulting t-test shows that these two carriers, significantly different from each other regarding the departure delay. Thus, in the later section (building linear regression model on arrival delay), we should include ‘UniqueCarrier’ in our prediction model.

![MeanMedianDepDelayCarrier](doc/MeanMedianDepDelayCarrier.png?raw=true "MeanMedianDepDelayCarrier")

Fig. 5 Mean and median of departure delay (in mins) with the top ten popular carriers from SFO. Black bar is the mean of departure delay and red bar is the median of departure delay. If there is no bar (like “OO”, “US” and “WN” in this plot), it means it is zero.


Carrier related delay, weather related delay, NAS(National Air System Delay: https://www.transtats.bts.gov/Fields.asp?Table_ID=236) delay, security related delay, late aircraft delay, there are different reasons behind departure or arrival delay. But what are the most common ones? Due to weather in Nov. and Dec.? Due to the previous late aircraft? In section 8, I explored the reason behind flight delay with the top eight most flew carrier in different years. In 2008, the mean of departure delay get significantly longer while from 2005 to 2007 for all carriers, the mean stay almost unchanged. For each carrier, from 2005 to 2008, the main delay reason stay almost the same. For most carrier, late aircraft delay is their main delay reason. ‘OO’ shows more carrier delay than other carriers. ‘AS’ has a obvious more deal due to late aircraft. Through out the years and different carriers, the delay due to security is negligible. Security crews at SFO airport is efficient in examining luggage.

![DelayReasonsYear](doc/DelayReasonsYear.png?raw=true "DelayReasonsYear")

Fig. 6 Box plot of departure delay reason from 2005 to 2008.

In section 9, we build a prediction model (y=Arrival Delay), based on variables we notice that are crucial (x= departure delay, distance, UniqueCarrier, Destination, Distance). The resulted R-squared reached 0.89.

# Conclusions

The initial motivation of doing exploratory data analysis on the airline dataset was to look at different factors which can cause departure and arrival delay. We looked into factors like travel distance, departure time, destination, travel time (weekday/weekend, month , year) and organized these interesting findings via reshape 2, dplyr and ggplot2 packages. The number of flights out does not necessarily related to delays. In other word, busy days do not correlate with delay (looking at Tuesday in a week and Sept. Oct. in a year). Nov. and Dec. are not as bad as I thought it would be for travel by air. These two months shows similar inter-quartile range comparing with Feb. Mar. May. and Jun. Over the years, there are more flight scheduled, although the median of departure delay stay the same, long delays temps to go longer. This drags the mean of departure delay increases over the years from 2005 to 2008. Different carriers behave differently in terms of delay time and delay reasons. Northwest Airlines (NW) shows the smallest median and mean in departure delay. The determinate reason behind delay for the most popular eight carriers we examined are carrier delay, weather delay and due to late aircraft. And among these three reasons,  late aircraft delay is their main delay reason. In the end of this study, we build a prediction model using linear regression via employing departure delay, distance, UniqueCarrier, and destination in the model. The resulted R-squared reached 0.89.

# References

The airline dataset used in this study can be found at https://github.com/YijunAH/Airline_Delays/tree/master/doc

It is a zip file called 'airline.csv.zip'

This page: https://www.transtats.bts.gov/Fields.asp?Table_ID=236 provides descriptions of each of the 29 variables associated with each flight in this airline dataset. 
