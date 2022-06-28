* Encoding: UTF-8.
* Direct estimation of fertility. 

* Calculates births to women 15-49 for specified periods preceding the interview.

* Set upper and lower limits for date of analysis period.
compute upplim = wdoi - 1.
compute lowlim = wdoi - (maxper * period).

* Weight Data.
weight by wmweight.

* Compute mother's age at the time of birth.
compute agembm = (BH4C - wdob).

* The two in the following equation creates age groups 1-7 instead of 3-9.
compute age5 = trunc(agembm/60) - 2.
formats age5 (f1.0).
variable labels age5 "Mother's age at time of the birth".
value labels age5
         1 '15-19'
         2 '20-24'
         3 '25-29'
         4 '30-34'
         5 '35-39'
         6 '40-44'
         7 '45-49'.

* Determine period of birth.
compute colper = trunc((upplim - BH4C)/period).
formats colper (f1.0).
variable labels colper "Number of years preceding the survey".
* Correct the value labels if the length or number of periods is changed.
value labels colper
         0 '0-2'
         1 '3-5'
         2 '6-8'
         3 '9-11'
         4 '12-14'.

* Select only children born in the periods of analysis.
select if (lowlim <= BH4C & BH4C <= upplim and age5 > 0).

* Aggregate births by age group to the file BIRTHS.SAV.
aggregate outfile = 'births.sav'
  /break = colper age5
  /births = n(age5).
