* Direct estimation of fertility. 

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

if (age5 = 1) cum_births  = births.
if (age5 = 1) cum_expos  = exposure.
if (age5 > 1) cum_births  = births + lag(cum_births).
if (age5 > 1) cum_expos  = exposure + lag(cum_expos).

* Calculate total fertility rate and general fertility rate.
compute tfr  = 5 * sumasfr / 1000.
compute gfr = 1000 * cum_births / lag(cum_expos).

variable labels 
  age5 ""
 /births "Births"
 /exposure "Exposure"
 /asfr "Age Specific Fertility Rate"
 /tfr "Total Fertility Rate"
 /gfr "General Fertility Rate (GFR)"
.

* Tabulates ASFR.
ctables
  /table births[s][mean,'',f5.0]>age5[c]+exposure[s][mean,'',f5.0]>age5[c] + asfr[s][mean,'',f5.0]>age5[c]+tfr[s][maximum,'',f5.1]+gfr[s][maximum,'',f5.1] by colper[c]
  /categories var=all empty=exclude missing=exclude
  /slabels position=row
  /title title = "Table RH.1: Adolescent birth rate and total fertility rate"	
                   "Adolescent birth rates and total fertility rates, " + surveyname.	

* Delete working files.
new file.

erase file='births.sav'.
erase file='exposure.sav'.
