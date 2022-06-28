* Encoding: windows-1252.
* Direct estimation of fertility with sampling errors - Trevor Croft (trevor.croft@icfi.com) June 12, 2014.

* Calculates age-specific fertility rates for all women 15-49 years
* of age for specified periods preceeding the interview.

* Match births and exposure in each age group.
match files
  /file='births.sav'
  /file='exposure.sav'
  /by cl colper age5.
* Because of the structure of the data, may need to add records to force entries for all age groups and periods.
* For example, if there are five periods of 3 years, then structure of the data will be as follows:
*               Period
*     Age    0=0-2 1=3-5  2=6-8  3=9-11  4=12-14
* 1=15-19    X        X        X        X         X
* 2=20-24    X        X        X        X         X
* 3=25-29    X        X        X        X         X
* 4=30-34    X        X        X        X         X
* 5=35-39    X        X        X        X         X
* 6=40-44    X        X        X        X         0
* 7=45-49    X        X        0        0         0
* To check, run a crosstab to see what the structure looks like.
crosstabs age5 by colper.

* Need to add in entries for cells that are empty for the next step, but first ...

* Need to transform the file created above to include records for all combinations of cluster (cl), period (colper), and age group (agemnth).
* Currently the above file is missing records where there was no exposure for a particular age group in a particular period for a particular cluster.
* To get around this problem, the data is transposed to create a file where the rows become variables for each value of colper and agemnth,
* and then transpose this back to the original format, but keeping the empty entries as records in the output (this is done using the /null=keep parameter below).
casestovars /id=cl /index=colper age5 /groupby=variable.

* Now add in the cells that were missing from the crosstab above.
compute births.2.7 = 0.
compute births.3.7 = 0.
compute births.4.6 = 0.
compute births.4.7 = 0.
compute exposure.2.7 = 0.
compute exposure.3.7 = 0.
compute exposure.4.6 = 0.
compute exposure.4.7 = 0.

* And now use the match files command (with only the current file) to reorder the new variables into the correct order before the next step.
match files file=* /keep cl
  births.0.1 to births.2.6 births.2.7 births.3.1 to births.3.6 births.3.7 births.4.1 to births.4.5 births.4.6 births.4.7
  exposure.0.1 to exposure.2.6 exposure.2.7 exposure.3.1 to exposure.3.6 exposure.3.7 exposure.4.1 to exposure.4.5 exposure.4.6 exposure.4.7.

* And now restructure the data back to the original format, but now with entries for every cluster, every age group and every time period.
varstocases /index=colper(5) age5(7) /make births from births.0.1 to births.4.7 /make exposure from exposure.0.1 to exposure.4.7 /null=keep.
* In the above, change the value colper(5) to match the number of periods given in fert_b and fert_e.
* Also change births.4.7 and exposure.4.7 to births.x.7 and exposure.x.7, where x is the number of periods minus 1.

* Now adjust the colper (coded 1-5) back to match its original coding (0-4).
compute colper = colper-1.

* Sort according to period first and then age.
sort cases by cl colper age5.

* Set the value of births equal to 0 if its current value is system missing.
if (sysmis(births)) births=0.
if (sysmis(exposure)) exposure=0.
execute.

* Rename the numbers of births and exposure to be cluster variables births_cl and exposure_cl.
rename variables births=births_cl exposure=exposure_cl.

* Combine births and exposure for all clusters for totals.
aggregate
  /break = colper age5
  /births = sum(births_cl)
  /exposure = sum(exposure_cl).

* Compute cluster totals as total minus this cluster.
compute births_cl = births - births_cl.
compute exposure_cl = exposure - exposure_cl.

* Calculate age-specific fertility rates.
if (exposure > 0) asfr = 1000 * births / exposure.
if (exposure_cl > 0) asfr_cl = 1000 * births_cl / exposure_cl.
* Recode missing data to 0.
if (sysmis(asfr)) asfr=0.
if (sysmis(asfr_cl)) asfr_cl=0.
execute.

* Sum ASFRs in preparation of calculating TFR..
aggregate outfile = 'asfr_sum.sav'
  /break = cl colper
  /asfr = sum(asfr)
  /asfr_cl = sum(asfr_cl).

* And add to the cluster by cluster estimates.
add files 
 /file = *
 /file = 'asfr_sum.sav'
 /by cl colper.

do if sysmis(age5).
* label last age group as tfr.
+ compute age5 = 8.
* Convert sum of ASFRs to be the TFR.
compute asfr  = 5 * asfr / 1000.
compute asfr_cl  = 5 * asfr_cl / 1000.
end if.

* Calculate squares of differences for each rate.
compute asfr_sqdif = (asfr - asfr_cl)**2.
execute.

* Sum squares of dffierences to produce variance.
aggregate outfile = 'fert_variances.sav'
  /break = colper age5
  /estimate = mean(asfr)
  /est_var = sum(asfr_sqdif)
  /ncl = nu(cl).

* Open results file.
get file = 'fert_variances.sav'.

* Compute variances = (N-1)/N * sum of squares of differences.
compute variance = est_var * (ncl-1) / ncl.

* Compute standard error, relative error and confidence intervals.
compute SE = sqrt(variance).
if (estimate > 0) RE = SE/estimate.
compute Rm2SE = estimate - 2*SE.
if (Rm2SE < 0) Rm2SE = 0.
compute Rp2SE = estimate + 2*SE.
execute.

value labels 
  age5 1 '15-19' 2 '20-24' 3 '25-29' 4 '30-34' 5 '35-39' 6 '40-44' 7 '45-49' 8 'TFR'
 /colper 0 '0-2' 1 '3-5' 2 '6-8' 3 '9-11' 4 '12-14'. 
variable labels 
  age5 " "
 /colper " "
 /estimate "Fertility Rate"
 /variance "Variance" 
 /SE "Standard error (SE)"
 /RE "Relative error (RE)"
 /Rm2SE "R-2SE"
 /Rp2SE "R+2SE".

* Tabulates ASFR and TFR and sampling errors.
ctables
  /table colper[c]>age5[c] by estimate[s][mean,'',f8.3]+variance[s][mean,'',f8.3]+SE[s][mean,'',f8.3]+RE[s][mean,'',f8.3]+Rm2SE[s][mean,'',f8.3]+Rp2SE[s][mean,'',f8.3]
  /categories var=all empty=exclude missing=exclude
  /slabels position=row
  /titles title = "Table: Sampling errors, age specific fertility rates and total fertility rate"	
                   "Age specific fertility rates and total fertility rates, " + surveyname.	



* Delete working files.
new file.

erase file='births.sav'.
erase file='exposure.sav'.