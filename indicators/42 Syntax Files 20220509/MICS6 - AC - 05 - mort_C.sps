* Encoding: windows-1252.
* Direct estimation of mortality with sampling errors - Trevor Croft (trevor.croft@icfi.com) Jan 5, 2014.
* Calculation of probabilities and rates.

* Combine the deaths and exposure system files.
match files
  /file='deaths.sav'
  /rename=(agedth=agemnth)
  /file='exposure.sav'
  /rename=(ageexp=agemnth)
  /by cl colper agemnth.

* Need to transform the file created above to include records for all combinations of cluster (cl), period (colper), and age group (agemnth).
* Currently the above file is missing records where there was no exposure for a particular age group in a particular period for a particular cluster.
* To get around this problem, the data is transposed to create a file where the rows become variables for each value of colper and agemnth,
* and then transpose this back to the original format, but keeping the empty entries as records in the output (this is done using the /null=keep parameter below).

casestovars /id=cl /index=colper agemnth /groupby=variable.
varstocases /index=colper(5) agemnth(8) /make deaths from deaths.0.0 to deaths.4.7 /make exposure from exposure.0.0 to exposure.4.7 /null=keep.
* In the above, change the value colper(5) to match the number of periods given in mort_d and mort_d.
* Also change deaths.4.7 and exposure.4.7 to deaths.x.7 and exposure.x.7, where x is the number of periods minus 1.

* Now adjust the colper (coded 1-5) and agemnth (coded 1-8) variables back to match their original coding (0-4 and 0-7 respectively).
compute colper = colper-1.
compute agemnth = agemnth - 1.

* Check for empty cells.
recode deaths (sysmis = 0).
recode exposure (sysmis = 0).
execute.

* Rename the numbers of deaths and exposure to be cluster variables deaths_cl and exposure_cl.
rename variables deaths=deaths_cl exposure=exposure_cl.

* Combine deaths and exposure for all clusters for totals.
aggregate
  /break = colper agemnth
  /deaths = sum(deaths_cl)
  /exposure = sum(exposure_cl).

* Compute cluster totals as total minus this cluster.
compute deaths_cl = deaths - deaths_cl.
compute exposure_cl = exposure - exposure_cl.

* Compute probabilities.
compute probs = 1000*deaths/exposure.
compute probs_cl = 1000*deaths_cl/exposure_cl.

variable labels
  deaths 'Deaths'
  exposure 'Exposure'
  probs 'Probability'
  deaths_cl 'Deaths (cluster)'
  exposure_cl 'Exposure (cluster)'
  probs_cl 'Probability (cluster)'.

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


* Calculate cumulative probability of surviving to the end of each age group (nP0).
if (agemnth = 0) probsurv = (1000-probs).
if (agemnth = 0) probsurv_cl = (1000-probs_cl).
if (agemnth > 0) probsurv = (lag(probsurv) * (1000-probs))/1000.
if (agemnth > 0) probsurv_cl = (lag(probsurv_cl) * (1000-probs_cl))/1000.
* For agegroup 4 (12-23) upwards, calculate probability of surviving from
* age 12 months to the end of each age group (nP12) to get the child
* mortality rate. Therefore, reset cumulative probability for age group
* 12-23 months to start cumulating from that age group on.
if (agemnth = 4) probsrv2 = (1000-probs).
if (agemnth = 4) probsrv2_cl = (1000-probs_cl).
if (agemnth > 4) probsrv2 = (lag(probsrv2) * (1000-probs))/1000.
if (agemnth > 4) probsrv2_cl = (lag(probsrv2_cl) * (1000-probs_cl))/1000.

* nn = (Neonatal) probability of surviving 1st month.
if (agemnth = 0) nn = 1000 - probsurv.
if (agemnth = 0) nn_cl = 1000 - probsurv_cl.
if (agemnth > 0) nn = lag(nn).
if (agemnth > 0) nn_cl = lag(nn_cl).

* imr = (infant) probability of surviving 1st year.
if (agemnth = 3) imr = 1000-probsurv.
if (agemnth = 3) imr_cl = 1000-probsurv_cl.
if (agemnth > 3) imr = lag(imr).
if (agemnth > 3) imr_cl = lag(imr_cl).

*pnn = difference bewtween imr and nn.
if (agemnth = 3) pnn = imr - nn.
if (agemnth = 3) pnn_cl = imr_cl - nn_cl.
if (agemnth > 3) pnn = lag(pnn).
if (agemnth > 3) pnn_cl = lag(pnn_cl).

* cmr = (childhood) probability of surviving from 1st year through 5th year.
if (agemnth = 7) cmr = 1000 - probsrv2.
if (agemnth = 7) cmr_cl = 1000 - probsrv2_cl.

* u5mr = (Under 5) probability of surviving from birth through 5th year.
if (agemnth = 7) u5mr = 1000 - probsurv.
if (agemnth = 7) u5mr_cl = 1000 - probsurv_cl.

execute.

variable labels
  nn 'Neonatal mortality rate'
 /pnn 'Post neonatal mortality rate'
 /imr 'Infant mortality rate'
 /cmr 'Child mortality rate'
 /u5mr 'Under five mortality rate'
 /nn_cl 'Neonatal mortality rate (cluster)'
 /pnn_cl 'Post neonatal mortality rate (cluster)'
 /imr_cl 'Infant mortality rate (cluster)'
 /cmr_cl 'Child mortality rate (cluster)'
 /u5mr_cl 'Under five mortality rate (cluster)'.

* Drop all cases except those for age group 7 as all rates are now in this record.
select if agemnth = 7.

* Calculate squares of differences for each rate.
compute nn_sqdif = (nn - nn_cl)**2.
compute pnn_sqdif = (pnn - pnn_cl)**2.
compute imr_sqdif = (imr - imr_cl)**2.
compute cmr_sqdif = (cmr - cmr_cl)**2.
compute u5mr_sqdif = (u5mr - u5mr_cl)**2.

execute.

* Sum squares of dffierences to produce variance.
aggregate outfile = 'variances.sav'
  /break = colper
  /nn = mean(nn)
  /pnn = mean(pnn)
  /imr = mean(imr)
  /cmr = mean(cmr)
  /u5mr = mean(u5mr)
  /nn_var = sum(nn_sqdif)
  /pnn_var = sum(pnn_sqdif)
  /imr_var = sum(imr_sqdif)
  /cmr_var = sum(cmr_sqdif)
  /u5mr_var = sum(u5mr_sqdif)
  /ncl = nu(cl).

* Open results file.
get file = 'variances.sav'.

* Convert output so that each indicator is a separate row.
varstocases /make Estimate from nn to u5mr /make Variance from nn_var to u5mr_var /index=Rate.

* Compute variances = (N-1)/N * sum of squares of differences.
compute Variance = Variance * (ncl-1) / ncl.

* Compute standard error, relative error and confidence intervals.
compute SE = sqrt(Variance).
compute RE = SE/Estimate.
compute Rm2SE = Estimate - 2*SE.
compute Rp2SE = Estimate + 2*SE.

variable labels 
  Colper " "
 /Rate " "
 /Estimate "Estimate (R)"
 /Variance "Variance" 
 /SE "Standard error (SE)"
 /RE "Relative error (RE)"
 /Rm2SE "R-2SE"
 /Rp2SE "R+2SE".

value labels Rate 1 "Neonatal mortality rate" 2 "Post-neonatal mortality rate" 3 "Infant mortality rate" 4 "Child mortality rate" 5 "Under five mortality rate".

CTABLES
  /TABLE colper[C]>Rate[C] by Estimate[s][mean '' f4.0]+Variance[s][mean '' f4.0]+SE[s][mean '' f4.1]+RE[s][mean '' f5.2]+Rm2SE[s][mean '' f4.0]+Rp2SE[s][mean '' f4.0]
  /SLABELS VISIBLE=NO
  /TITLES CORNER="Periods of analysis of 5 years" TITLE="Table: Child mortality sampling errors"
   "Infant and under-five mortality rates by 5 year periods " + subgroupname +", "+ surveyname.

new file.

erase file = 'deaths.sav'.
erase file = 'exposure.sav'.