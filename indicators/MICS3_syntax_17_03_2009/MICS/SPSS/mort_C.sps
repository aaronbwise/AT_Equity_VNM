* Direct estimation of mortality.  Trevor Croft, Sept 1, 2006.
* Calculation of probabilities and rates -- see mort.sps.

* Combine the deaths and exposure system files.
match files
  /file='deaths.sav'      /rename=(agedth=agemnth)
  /file='exposure.sav'  /rename=(ageexp=agemnth)
  /by=agemnth colper.

recode deaths (sysmis = 0).
compute probs = 1000*deaths/exposure.

variable labels
  deaths 'Deaths'
  exposure 'Exposure'
  probs 'Probability'.

sort cases by colper agemnth.

variable labels agemnth  "Age in months".
value labels
 /agemnth
     0 "0"
     1 "1-2"
     2 "3-5"
     3 "6-11"
     4 "12-23"
     5 "24-35"
     6 "36-47"
     7 "48-59".

variable labels colper "Periods of analysis of 5 years".
value labels
 /colper
     0 "0-4"
     1 "5-9"
     2 "10-14"
     3 "15-19"
     4 "20-24".

CTABLES
  /TABLE (deaths[S]+exposure[S]+probs[S]) > agemnth[C] BY colper[C]
  /TITLE TITLE="Table CM.03w: Child mortality: Deaths, Exposure and Probabilities " + subgroupname + ". Country, Year".

* Calculate cumulative probability of surviving to the end of each age group (nP0).
if (agemnth = 0) probsurv = (1000-probs).
if (agemnth > 0) probsurv = (lag(probsurv) * (1000-probs))/1000.
* For agegroup 4 (12-23) upwards, calculate probability of surviving from
* age 12 months to the end of each age group (nP12) to get the child
* mortality rate. Therefore, reset cumulative probability for age group
* 12-23 months to start cumulating from that age group on.
if (agemnth = 4) probsrv2 = (1000-probs).
if (agemnth > 4) probsrv2 = (lag(probsrv2) * (1000-probs))/1000.

* nn = (Neonatal) probability of surviving 1st month, infant = probability of surviving 1st year.
if (agemnth = 0) nn = 1000 - probsurv.
if (agemnth > 0) nn = lag(nn).
if (agemnth = 3) imr = 1000-probsurv.
if (agemnth > 3) imr = lag(imr).
if (agemnth = 3) pnn = imr - nn.
if (agemnth > 3) pnn = lag(pnn).
if (agemnth = 7) cmr = 1000 - probsrv2.
if (agemnth = 7) u5mr = 1000 - probsurv.

execute.

variable labels
  nn 'Neonatal mortality'
 /pnn 'Post neonatal mortality'
 /imr 'Infant mortality'
 /cmr 'Child mortality'
 /u5mr 'Under five mortality'.

select if (agemnth = 7).
CTABLES
  /TABLE colper[C] by nn[s]+pnn[s]+imr[s]+cmr[s]+u5mr[s]
  /TITLE TITLE="Table CM.03: Child mortality"
   "Infant and under-five mortality rates by 5 year periods " + subgroupname + ". Country, Year".

new file.

erase file = 'deaths.sav'.
erase file = 'exposure.sav'.