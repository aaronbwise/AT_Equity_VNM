* Maternal mortality calculations (03/02/06).

* open Household member data file.
get file='hl.sav'.

* Select women aged 15 to 49.
* select if (hl4 = 2 & hl5 >= 15 & hl5 <= 49).
* Select all adult household members.
select if (hl5 >= 15).

* Compute age in 5 year groups.
compute age5 = trunc(hl5/5)-2.
recode age5 (10 thru hi=10).
variable labels age5 'Respondent age'.
value labels age5
  1 '15-19'
  2 '20-24'
  3 '25-29'
  4 '30-34'
  5 '35-39'
  6 '40-44'
  7 '45-49'
  8 '50-54'
  9 '55-59'
 10 '60+'.

weight by hhweight.

recode mm6 (sysmis=0).
recode mm8 (sysmis=0).
recode mm9 (sysmis=0).

* Drop special values.
select if (mm6 < 97 & mm8 < 97 & mm9 < 97).

* Drop outliers on number of maternal deaths.
select if (mm9 < 9).

aggregate
  /outfile='aggr.sav'
  /break=age5
  /resp 'Number of adult household respondents' = N
  /sisters 'Sisters who reached age 15' = sum(mm6) 
  /deadsis 'Sisters who reached age 15 and who died' = sum(mm8) 
  /matdeath 'Maternal deaths' = sum(mm9).

compute total = 0.
value label total 0 'Total'.

aggregate
  /outfile='aggrt.sav'
  /break=total
  /resp=N
  /sisters 'Sisters who reached age 15' = sum(mm6) 
  /deadsis 'Sisters who reached age 15 and who died' = sum(mm8) 
  /matdeath 'Maternal deaths' = sum(mm9).

get file='Aggr.sav'.
add files
  /file = *
  /file = 'aggrt.sav'.

* Adjusted numer of sisters who reached age 15.
* If the age range of respondents stops at 59, remove the lag(resp,7) and the lag(sisters,7) parameters below.
* If the age range of respondents stops at 49, remove the lag(resp,6)+lag(resp,5) and the lag(sisters,6)+lag(sisters,5) parameters below as well.
do if (total = 0).
+ compute resp35up = lag(resp,7)+lag(resp,6)+lag(resp,5)+lag(resp,4)+lag(resp,3)+lag(resp,2)+lag(resp,1).
+ compute sis35up  = lag(sisters,7)+lag(sisters,6)+lag(sisters,5)+lag(sisters,4)+lag(sisters,3)+lag(sisters,2)+lag(sisters,1).
end if.

sort cases by age5 (A).
compute sisadj = sisters.
if (age5 = 1) sisadj = sisters * lag(sis35up,1) / lag(resp35up,1).
if (age5 = 2) sisadj = sisters * lag(sis35up,2) / lag(resp35up,2).
if (age5 = 3) sisadj = sisters * lag(sis35up,3) / lag(resp35up,3).
sort cases by total (A).
* If the age range of respondents stops at 59, remove the lag(sisadj,10) parameters below.
* If the age range of respondents stops at 49, remove the lag(sisadj,8)+lag(sisadj,9) parameters below.
if (total = 0) sisadj = lag(sisadj,1)+lag(sisadj,2)+lag(sisadj,3)+lag(sisadj,4)+lag(sisadj,5)+lag(sisadj,6)+lag(sisadj,7)+lag(sisadj,8)+lag(sisadj,9)+lag(sisadj,10).
Variable label sisadj 'Sisters who reached age 15 (adjusted)'.

if (age5 = 1) adjfact = 0.107.
if (age5 = 2) adjfact = 0.206.
if (age5 = 3) adjfact = 0.343.
if (age5 = 4) adjfact = 0.503.
if (age5 = 5) adjfact = 0.664.
if (age5 = 6) adjfact = 0.802.
if (age5 = 7) adjfact = 0.900.
if (age5 = 8) adjfact = 0.958.
if (age5 = 9) adjfact = 0.986.
if (age5 = 10) adjfact = 1.000.
format adjfact (f5.3).
Variable label adjfact 'Adjustment factor'.

compute unitrisk = sisadj * adjfact.
* If the age range of respondents stops at 59, remove the lag(unitrisk,10) parameters below.
* If the age range of respondents stops at 49, remove the lag(unitrisk,8)+lag(unitrisk,9) parameters below.
if (total = 0) unitrisk = lag(unitrisk,1)+lag(unitrisk,2)+lag(unitrisk,3)+lag(unitrisk,4)+lag(unitrisk,5)+lag(unitrisk,6)+lag(unitrisk,7)+lag(unitrisk,8)+lag(unitrisk,9)+lag(unitrisk,10).
variable label unitrisk 'Sister units of risk exposure'.

if (unitrisk > 0) liferisk = matdeath / unitrisk.
variable label liferisk 'Lifetime risk of maternal death'.

if (deadsis > 0) pcmatdth = 100 * matdeath / deadsis.
variable label pcmatdth 'Percent of dead sisters dying of maternal causes'.

* Change this constant to the TFR for 10-14 years ago.
* THIS PARAMETER IS COUNTRY SPECIFIC !!!!.
if (total = 0) tfr1014 = 2.75.
variable label tfr1014 'Total fertility rate 10-14 years ago'.

if (total = 0) mmr = 100000 * (1 - exp( (1/tfr1014) * ln(1-liferisk) ) ).
variable label mmr 'Maternal mortality ratio *'.

tables
  /format blank
  /observation= resp sisters deadsis matdeath sisadj adjfact unitrisk liferisk pcmatdth tfr1014 mmr
  /table=age5 + total  BY resp + sisters + sisadj + deadsis + matdeath + adjfact + unitrisk + liferisk + pcmatdth + tfr1014 + mmr
  /statistics
  mean( resp    ( F6.0 ) '')
  mean( sisters ( F6.0 ) '')
  mean( sisadj  ( F6.0 ) '')
  mean( deadsis ( F6.0 ) '')
  mean( matdeath( F6.0 ) '')
  mean( adjfact ( F6.3 ) '')
  mean( unitrisk( F6.0 ) '')
  mean( liferisk( F6.3 ) '')
  mean( pcmatdth( F6.1 ) '')
  mean( tfr1014 ( F6.2 ) '')
  mean( mmr     ( F6.0 ) '')
  /title  "Table RH.6: Maternal mortality ratio"
	"Lifetime risk of maternal death and proportion of dead sisters dying of maternal causes, Country, Year"
  /caption "* MICS Indicator 3; MDG Indicator 16".

new file.
erase file = 'aggr.sav'.
erase file = 'aggrt.sav'.