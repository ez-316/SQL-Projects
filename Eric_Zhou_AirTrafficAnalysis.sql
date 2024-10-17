SET GLOBAL sql_mode = 'ONLY_FULL_GROUP_BY';
USE airtraffic;

-- SQL Project: AirTraffic Analysis --

/*
The managers of a Mutual Fund want to know 
some basic details about the airtraffic data.

What investment guidance would you give to the fund managers based on your 
results?

Please uncover any seasonal trends, top airports, and year-over-year airline performances to provide useful and/or actionable insights.
*/


# The number of flights that were in 2018 and 2019 separately
# There were 3218653 flights in 2018, including cancelled
SELECT
	COUNT(*) AS FlightCount2018
FROM 
	flights
WHERE 
	YEAR(FlightDate)  = 2018;

#There were 3302708 flights in 2019, including cancelled
SELECT
	COUNT(*) AS FlightCount2019
FROM
	flights
WHERE 
	YEAR(FlightDate)  = 2019;


# The number of flights that are cancelled or departed late over both years
# There were 2633237 flights in 2018 and 2019 that were either cancelled or departed late
SELECT 
	COUNT(*) AS FlightCountCDL
FROM 
	flights
WHERE 
	Cancelled > 0 OR DepDelay > 0;
    

# The number of flights that were cancelled broken down by the reason for cancellation.
SELECT
	CancellationReason, 
    COUNT(*) AS FlightCancelled
FROM 
	flights
WHERE 
	Cancelled > 0
GROUP BY 
	CancellationReason;


# The total number of flights and percentage of flights cancelled for each month of 2019

/*
	Based on the results obtained, it is evident that airline
revenue tends to exhibit seaonal patterns.
	The airline or the customers tend to cancel most of their flights
during the month of April (%2.710 cancel rate), and then the cancel rate drop, 
to all year low until the month of December (%0.507 cancel rate), 
possibly due to end of the year holiday season.
	The cancel rate rises again after December and 
peaks again in April.

Month Cancelled Total %Cancelled 
12	1397	275371	0.507
11	1580	266878	0.592
10	2291	283815	0.807
9	3318	268625	1.235
8	3624	290493	1.248
7	4523	291955	1.549
6	6172	282653	2.184
1	5788	262165	2.208
2	5502	237896	2.313
5	6912	285094	2.424
3	7079	283648	2.496
4	7429	274115	2.710

*/

SELECT 
	*
FROM 
	PercentFlightCancelledPerMonth2019;

DROP TABLE IF EXISTS 
	PercentFlightCancelledPerMonth2019;
CREATE TABLE 
	PercentFlightCancelledPerMonth2019 (FlightMonth INT, FlightsCancelled2019 INT, FlightsTotal2019 INT, PercentFlightCancelled2019 DEC(10, 3));

INSERT INTO 
	PercentFlightCancelledPerMonth2019 (FlightMonth, FlightsCancelled2019, FlightsTotal2019, PercentFlightCancelled2019) 
VALUES 
(1, 5788, 262165, 5788/262165*100),
(2, 5502, 237896, 5502/237896*100),
(3, 7079, 283648, 7079/283648*100),
(4, 7429, 274115, 7429/274115*100),
(5, 6912, 285094, 6912/285094*100),
(6, 6172, 282653, 6172/282653*100),
(7, 4523, 291955, 4523/291955*100),
(8, 3624, 290493, 3624/290493*100),
(9, 3318, 268625, 3318/268625*100),
(10, 2291, 283815, 2291/283815*100),
(11, 1580, 266878, 1580/266878*100),
(12, 1397, 275371, 1397/275371*100);

# 55615 FlightCancelled2019 Total
SELECT 
	COUNT(*) AS FlightCancelled2019
FROM 
	flights
WHERE 
	YEAR(FlightDate) = 2019 AND Cancelled > 0;

#55615 FlightCancelled2019, grouped by month
SELECT 
	MONTH(FlightDate) AS FlightMonth, 
    COUNT(*) AS FlightCancelled2019
FROM 
	flights
WHERE 
	YEAR(FlightDate) = 2019 AND Cancelled > 0
GROUP BY 
	FlightMonth
ORDER BY 
	FlightMonth;
    
/*
Flights cancelled per month in 2019
1	5788
2	5502
3	7079
4	7429
5	6912
6	6172
7	4523
8	3624
9	3318
10	2291
11	1580
12	1397
*/

# 3302708 FlightTotal2019
SELECT 
	COUNT(*) AS FlightTotal2019
FROM 
	flights
WHERE 
	YEAR(FlightDate) = 2019;

#3302708 FlightTotal2019, grouped by month
SELECT 
	MONTH(FlightDate) AS FlightMonth, 
    COUNT(*) AS FlightTotal2019
FROM 
	flights
WHERE 
	YEAR(FlightDate) = 2019
GROUP BY 
	FlightMonth
ORDER BY 
	FlightMonth;
    
/*
Total Flights per month in 2019
1	262165
2	237896
3	283648
4	274115
5	285094
6	282653
7	291955
8	290493
9	268625
10	283815
11	266878
12	275371
*/


# Create two new tables, one for each year (2018 and 2019) showing the total miles traveled and number of flights broken down by airline.

SELECT 
	AirlineName, 
    SUM(Distance) AS TotalMiles, 
    COUNT(*) AS NumFlights
FROM 
	flights
WHERE 
	YEAR(FlightDate) = 2018
GROUP BY 
	AirlineName;
    
/*
AirLineName	            TotalMiles	NumFlights
Delta Air Lines Inc.	842409169	949283
American Airlines Inc.	933094276	916818
Southwest Airlines Co.	1012847097	1352552
*/

SELECT 
	AirlineName, 
    SUM(Distance) AS TotalMiles, 
    COUNT(*) AS NumFlights
FROM 
	flights
WHERE 
	YEAR(FlightDate) = 2019
GROUP BY 
	AirlineName;
    
/*
AirLineName	            TotalMiles	NumFlights
Delta Air Lines Inc.	889277534	991986
American Airlines Inc.	938328443	946776
Southwest Airlines Co.	1011583832	1363946
*/

DROP TABLE IF EXISTS 
	Flight2018;
CREATE TABLE 
	Flight2018 (AirlineName VARCHAR(255), TotalMiles2018 FLOAT, NumFlights2018 INT);
INSERT INTO 
	Flight2018 (AirlineName, TotalMiles2018, NumFlights2018)
VALUES
("Delta Air Lines Inc.", 842409169, 949283),
("American Airlines Inc.", 933094276, 916818),
("Southwest Airlines Co.", 1012847097,1352552);

SELECT 
	*
FROM 
	flight2018;

DROP TABLE IF EXISTS 
	Flight2019;
CREATE TABLE 
	Flight2019 (AirlineName VARCHAR(255), TotalMiles2019 FLOAT, NumFlights2019 INT);
INSERT INTO 
	Flight2019 (AirlineName, TotalMiles2019, NumFlights2019) 
VALUES
("Delta Air Lines Inc.", 889277534, 991986),
("American Airlines Inc.", 938328443, 946776),
("Southwest Airlines Co.", 1011583832,1363946);
SELECT 
	*
FROM 
	flight2019;


# Using the new tables to find the year-over-year percent change in total flights and miles traveled for each airline.

SELECT 
	flight2018.AirlineName,
    flight2018.TotalMiles2018, 
    flight2019.TotalMiles2019,
    (flight2019.TotalMiles2019 - flight2018.TotalMiles2018) / flight2018.TotalMiles2018 * 100 AS YOY_Miles_Percent_Change,
    flight2018.NumFlights2018,
    flight2019.NumFlights2019,
	(flight2019.NumFlights2019 - flight2018.NumFlights2018) / flight2018.NumFlights2018 * 100 AS YOY_Flight_Percent_Change
FROM 
	flight2018
JOIN
	flight2019
ON 
	flight2018.AirlineName = flight2019.AirlineName;

/*
YOY_Miles_Percent_Change 2018-2019
Delta Air Lines Inc.	5.5636090715215785	
American Airlines Inc.	0.5609482511109017
Southwest Airlines Co.	-0.1247272164782731

YOY_Flight_Percent_Change 2018-2019
Delta Air Lines Inc.	4.4984
American Airlines Inc.	3.2676
Southwest Airlines Co.	0.8424
*/

/*
What investment guidance would I give to the fund managers based on my 
results?
	I would suggest the fund managers to allocate more fundings
    for Delta Air Lines based on the trend that DAL had the largest
    year-over-year percent change in both total flights (4.498%) and 
    miles (5.564%) from 2018 - 2019 compared to the other 2 airlines,
    which is indicative of larger net revenue return in the year 2020.
*/

# The names of the 10 most popular destination airports overall
# Slow, ~22.9 seconds
SELECT 
	airports.AirportName, 
	COUNT(*) AS DestAirportCount
FROM 
	airports
JOIN 
	flights
ON 
	airports.AirportID = flights.DestAirportID
GROUP BY 
	airports.AirportName
ORDER BY 
	DestAirportCount DESC
LIMIT 10;

/*
TOP 10 MOST POPULAR DESTINATION AIRPORTS
Hartsfield-Jackson Atlanta International	595527
Dallas/Fort Worth International	314423
Phoenix Sky Harbor International	253697
Los Angeles International	238092
Charlotte Douglas International	216389
Harry Reid International	200121
Denver International	184935
Baltimore/Washington International Thurgood Marshall	168334
Minneapolis-St Paul International	165367
Chicago Midway International	165007
*/

# Using a subquery to aggregate & limit the flight data before join with the airport information, optimizing query runtime.
# Much faster, ~2.9 seconds
SELECT 
	airports.AirportName, 
    Top10DestAirport.DestAirportCount
FROM 
	airports
JOIN
	(SELECT 
		DestAirportID, 
        COUNT(*) AS DestAirportCount
	 FROM 
		flights
	 GROUP BY 
		DestAirportID
	 ORDER BY 
		DestAirportCount DESC
	 LIMIT 10) AS Top10DestAirport
ON 
	airports.AirportID = Top10DestAirport.DestAirportID
ORDER BY 
	Top10DestAirport.DestAirportCount DESC;
    
/*
TOP 10 MOST POPULAR DESTINATION AIRPORTS
Hartsfield-Jackson Atlanta International	595527
Dallas/Fort Worth International	314423
Phoenix Sky Harbor International	253697
Los Angeles International	238092
Charlotte Douglas International	216389
Harry Reid International	200121
Denver International	184935
Baltimore/Washington International Thurgood Marshall	168334
Minneapolis-St Paul International	165367
Chicago Midway International	165007
*/

/*
The fund managers are interested in operating costs for each airline. 
But there isn't actual cost or revenue information available, but I can 
infer a general overview of how each airline's costs compare by 
looking at data that reflects equipment and fuel costs.
*/

/*
A flight's tail number is the actual number affixed to the fuselage 
of an aircraft, much like a car license plate. As such, each plane has 
a unique tail number and the number of unique tail numbers for each 
airline should approximate how many planes the airline operates in total. 
Using this information, I can determine the number of unique aircrafts each airline 
operated in total over 2018-2019.
*/

/*
TailNumUnique ~ # of planes an airline operates
AirlineName				TailNumUnique	
American Airlines Inc.	993
Delta Air Lines Inc.	988
Southwest Airlines Co.	754
*/

SELECT 
	AirlineName, 
    COUNT(DISTINCT Tail_Number) AS TailNumUnique
FROM 
	flights
GROUP BY 
	AirlineName
ORDER BY 
	TailNumUnique DESC;

/*
Similarly, the total miles traveled by each airline gives an idea of 
total fuel costs and the distance traveled per plane gives an approximation 
of total equipment costs. I can find the average distance traveled per aircraft 
for each of the three airlines
*/
SELECT 
	AirlineName, 
    SUM(Distance) AS TotalMiles
FROM 
	flights
GROUP BY 
	AirlineName
ORDER BY 
	TotalMiles DESC;
/*
TotalMiles ~ Fuel costs
AirlineName				TotalMiles
Southwest Airlines Co.	2024430929
American Airlines Inc.	1871422719
Delta Air Lines Inc.	1731686703
*/

SELECT 
	AirlineName, 
    SUM(Distance)/COUNT(DISTINCT Tail_Number) AS AvgMiles
FROM 
	flights
GROUP BY 
	AirlineName
ORDER BY 
	AvgMiles DESC;
/*
AvgMiles ~ Equipment costs
AirlineName				AvgMiles
Southwest Airlines Co.	2684921.656498674
American Airlines Inc.	1884615.0241691843
Delta Air Lines Inc.	1752719.335020243
*/    

/*
	From the results, it is almost certain that Delta Air Lines Inc. has the
lowest operating costs. 
	Although Southwest Airlines has 754 unique planes, which is lower than
Delta Airlines and American Airlines, but DAL has the lowest total miles 
(proportional to fuel costs) travelled compared to the other 2 airlines 
at 1731686703 miles, and it also has the lowest average miles 
(proportional to equipment costs) ahead of its competitors 
at 1752719.335 miles per plane.
	The extra planes owned by DAL does not contribute to the operation costs.
    
TailNumUnique ~ # of planes an airline operates
AirlineName				TailNumUnique	
American Airlines Inc.	993
Delta Air Lines Inc.	988
Southwest Airlines Co.	754

TotalMiles ~ Fuel costs
AirlineName				TotalMiles
Southwest Airlines Co.	2024430929
American Airlines Inc.	1871422719
Delta Air Lines Inc.	1731686703

AvgMiles ~ Equipment costs
AirlineName				AvgMiles
Southwest Airlines Co.	2684921.656498674
American Airlines Inc.	1884615.0241691843
Delta Air Lines Inc.	1752719.335020243
*/

/*
It would be great to investigate into the top
airlines and major airports in terms of on-time performance as well. 

To do so, I will consider early departures and arrivals 
(negative values) as on-time (0 delay) in my calculations.
*/

/*
I will look into on-time performance more granularly in relation 
to the time of departure. We can break up the departure times into 
three categories as follows:

CASE
    WHEN HOUR(CRSDepTime) BETWEEN 7 AND 11 THEN "1-morning"
    WHEN HOUR(CRSDepTime) BETWEEN 12 AND 16 THEN "2-afternoon"
    WHEN HOUR(CRSDepTime) BETWEEN 17 AND 21 THEN "3-evening"
    ELSE "4-night"
END AS "time_of_day"

Now I can find the average departure delay for each time-of-day across the 
whole data set.
*/
SELECT
	AVG(DepDelay) AS AvgDepDelay, 
    CASE
		WHEN HOUR(CRSDepTime) BETWEEN 7 AND 11 THEN "1-morning"
		WHEN HOUR(CRSDepTime) BETWEEN 12 AND 16 THEN "2-afternoon"
		WHEN HOUR(CRSDepTime) BETWEEN 17 AND 21 THEN "3-evening"
		ELSE "4-night"
	END AS time_of_day
FROM
    flights
WHERE 
	DepDelay > 0
GROUP BY
	time_of_day
ORDER BY
	time_of_day;
/*
AvgDepDelay time_of_day
25.8731	1-morning
29.9219	2-afternoon
35.9136	3-evening
29.5602	4-night

Evenings seem to be the rush hours when there
are more delays while mornings have the least delays
*/


# The average departure delay for each airport and time-of-day combination.
SELECT
	DISTINCT OriginAirportID,
	AVG(DepDelay) AS AvgDepDelay, 
    CASE
		WHEN HOUR(CRSDepTime) BETWEEN 7 AND 11 THEN "1-morning"
		WHEN HOUR(CRSDepTime) BETWEEN 12 AND 16 THEN "2-afternoon"
		WHEN HOUR(CRSDepTime) BETWEEN 17 AND 21 THEN "3-evening"
		ELSE "4-night"
	END AS time_of_day
FROM
    flights
WHERE
	DepDelay > 0
GROUP BY
	time_of_day, 
    OriginAirportID
ORDER BY
	OriginAirportID;

# Limiting my average departure delay analysis to morning delays and airports with at least 10,000 flights.
SELECT
	DISTINCT OriginAirportID,
    COUNT(*) AS FlightCount,
	AVG(DepDelay) AS AvgDepDelay
FROM
    flights
WHERE 
	(DepDelay > 0 AND HOUR(CRSDepTime) BETWEEN 7 AND 11)
GROUP BY
	OriginAirportID
HAVING 
	FlightCount >= 10000
ORDER BY
	AvgDepDelay DESC;


# The top-10 airports/cities (with >10000 flights) with the highest average morning delay.

SELECT 
	airports.AirportName, 
    airports.City, 
    MorningDelayedFlightsOver10000.AvgDepDelay
FROM
	airports
JOIN
(SELECT
	DISTINCT OriginAirportID,
    COUNT(*) AS FlightCount,
	AVG(DepDelay) AS AvgDepDelay
FROM
    flights
WHERE 
	(DepDelay > 0 AND HOUR(CRSDepTime) BETWEEN 7 AND 11)
GROUP BY
	OriginAirportID
HAVING 
	FlightCount >= 10000
ORDER BY
	AvgDepDelay DESC
LIMIT 10) AS MorningDelayedFlightsOver10000
ON 
	airports.AirportID = MorningDelayedFlightsOver10000.OriginAirportID
ORDER BY
	MorningDelayedFlightsOver10000.AvgDepDelay DESC;
/*
Top 10 Airports with the highest average morning delays (with >10000 flights)
AirportName					City			AvgDepDelay
Chicago O'Hare International	Chicago, IL	33.6865
LaGuardia	New York, NY	33.6838
Philadelphia International	Philadelphia, PA	31.7330
Dallas/Fort Worth International	Dallas/Fort Worth, TX	31.5933
Seattle/Tacoma International	Seattle, WA	28.8792
Minneapolis-St Paul International	Minneapolis, MN	28.4931
Los Angeles International	Los Angeles, CA	26.8112
Salt Lake City International	Salt Lake City, UT	25.7589
Orlando International	Orlando, FL	25.6610
San Diego International	San Diego, CA	24.3445
*/