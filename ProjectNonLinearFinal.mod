#Project

#SETS
set REGION; 							    #Set of regions
set COUNTRY;								#Set of countries
set LOAN_DURATION;							#Set of loans
set GROUP within {COUNTRY,REGION};			#Set of countries within regions

#VARIABLES
var x{COUNTRY,LOAN_DURATION}>=0;			#Amount of money that can be loaned to each country c by loan type l
var y{COUNTRY,LOAN_DURATION} binary;		#decision of wheter to use loan type l for each country c 

#PARAMETERS
param POVERTY{COUNTRY};						#Millions of people below national poverty line
param BUDGET;								#World Banks budget for loans
param MAX_LOAN{COUNTRY,LOAN_DURATION};		#Max amount of loan that can be recieved by a country for a loan type
param INTEREST_RATE{LOAN_DURATION};			#Interest rate of loan type
param RISK{COUNTRY,LOAN_DURATION};			#Country's risk score for each loan type
param QUOTA{REGION};						#Fraction of total loan budget that each region must receive


#OBJECTIVE FUNCTION

maximize PPR: (sum{c in COUNTRY,l in LOAN_DURATION} x[c,l]/POVERTY[c]) / (sum{c in COUNTRY, l in LOAN_DURATION} y[c,l]);

#CONSTRAINTS

subject to TOTAL:
sum{c in COUNTRY, l in LOAN_DURATION} x[c,l] <= BUDGET;

subject to WEIGHTED_PORT_RISK:
sum{c in COUNTRY,l in LOAN_DURATION} x[c,l]*RISK[c,l] >= sum{c in COUNTRY, l in LOAN_DURATION} x[c,l]*3;

subject to PORT_RETURN:
sum{c in COUNTRY, l in LOAN_DURATION} x[c,l]*INTEREST_RATE[l] >= sum{c in COUNTRY, l in LOAN_DURATION} x[c,l]*0.015;

subject to ONE_LOAN{c in COUNTRY}:
sum{l in LOAN_DURATION} y[c,l] <= 1;

subject to SWITCHING{c in COUNTRY, l in LOAN_DURATION}:
x[c,l] <=  MAX_LOAN[c,l]*y[c,l];

subject to REGION_QUOTA{r in REGION}:
sum{(c,r) in GROUP, l in LOAN_DURATION} x[c,l] >= QUOTA[r]*sum{c in COUNTRY, l in LOAN_DURATION} x[c,l];

subject to WITHIN_REGION{r in REGION, (c,r) in GROUP, l in LOAN_DURATION}:
x[c,l] <= QUOTA[r]*(sum{c2 in COUNTRY, l2 in LOAN_DURATION} x[c2,l2])*0.50;






