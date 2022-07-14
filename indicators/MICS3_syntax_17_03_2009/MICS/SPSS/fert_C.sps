* Direct estimation of mortality.  Trevor Croft, Jan 3, 2007.
* Calculation of probabilities and rates -- see fert.sps.

* Calculates age-specific fertility rates for all women 15-49 years
* of age for specified periods preceeding the interview.

* Match births and exposure in each age group.
match files
  /file='births.sav'
  /file='exposure.sav'
  /by colper age5.

* Sort according to period first and then age.
sort cases by colper age5.

* Set the value of births equal to 0 if its current value is system missing.
if (sysmis(births)) births=0.

* Calculate age-specific fertility rates.
compute asfr = 1000 * births / exposure.

* Accumulate age-specific fertility rates.
if (age5 = 1) sumasfr  = asfr.
if (age5 > 1) sumasfr  = asfr + lag(sumasfr).

* Calculate total fertility rate.
compute tfr  = 5 * sumasfr / 1000.

variable labels 
  age5 ""
 /births "Births"
 /exposure "Exposure"
 /asfr "Age Specific Fertility Rate"
 /tfr "Total Fertility Rate"
.

* Tabulates ASFR.
tables
  /observation=births exposure asfr tfr
  /table=(births+exposure+asfr) > age5 + tfr by colper
  /statistics
  mean(births (f5.0) '')
  mean(exposure (f5.0) '')
  mean(asfr (f5.0) '')
  max(tfr (f5.1) '')
  /title="Table FR.1: Births, exposure, and age specific fertility rates (ASFR) for three-year periods preceding the survey, " +
          "by mother's age at the time of the birth, and total fertility rate (TFR) " + subgroupname + ". Country, Year".

* Delete working files.
new file.

erase file='births.sav'.
erase file='exposure.sav'.
