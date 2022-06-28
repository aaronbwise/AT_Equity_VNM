* Encoding: UTF-8.

recode HHAGE (15 thru 19 = 1) (20 thru 24 = 2) (25 thru 49 = 3) (50 thru hi = 4) into HHAGEx.
variable labels HHAGEx "Age of household head".
value labels HHAGEx 1"15-19" 2 "20-24" 3 "25-49" 4 "50+".

recode HHAGE (15 thru 19 = 1) (20 thru 24 = 2) (25 thru 29 = 3) (30 thru 34 = 4) (35 thru 39 = 5) (40 thru 44 = 6) (45 thru 49 = 7) (50 thru 59 = 8) (60 thru 69 = 9) (70 thru highest = 10) into HHAGEy.
variable labels HHAGEy "Age of household head".
value labels HHAGEy 1 "15-19" 2 "20-24" 3 "25-29" 4 "30-34" 5 "35-39" 6 "40-44" 7 "45-49" 8 "50-59" 9 "60-69" 10 "70+".