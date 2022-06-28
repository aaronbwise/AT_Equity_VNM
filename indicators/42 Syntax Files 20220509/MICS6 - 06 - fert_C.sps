* Encoding: windows-1252.
* Direct estimation of fertility.

* v03 - 2020-04-09. Labels in French and Spanish have been removed.

* Calculates age-specific fertility rates for all women 15-49 years
* of age for specified periods preceeding the interview.

* Match births and exposure in each age group.
match files
  /file='births.sav'
  /file='exposure.sav'
  /file='exposuretotal.sav'
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

* Calculate total fertility rate.
* The total fertility rate (TFR) is calculated by summing the age-specific fertility rates (sumasfr) calculated for each of the 5-year age groups of women,
* from age 15 through to age 49. The TFR denotes the average number of children to which a woman will have given birth by the end of her reproductive
* years (by age 50) if current fertility rates prevailed.
compute tfr  = 5 * sumasfr / 1000.

* The general fertility rate (GFR) is the number of live births to women age 15-49 years during a specified period,
* divided by the average number of women in the same age group during the same period, expressed per 1,000 women.
do if (age5 = 7).
compute gfr = 1000 * cum_births / cum_expos.
end if.

compute cbr = asfr * nwm/pop .
formats cbr (f7.4).

variable labels
  age5 ""
 /births "Births"
 /exposure "Exposure"
 /asfr "Age Specific Fertility Rate"
 /tfr "TFR (15-49 years) [B]"
 /gfr "GFR [C]"
 /cbr "CBR [D]".

* Tabulates ASFR.
* CBR not included as it can not be properly calculated for variable welevel.
* Ctables command in English.
ctables
  /table births [s][mean '' comma5.0]>age5 [c]+exposure [s][mean '' comma5.0]>age5 [c] +  asfr [s][mean '' comma5.0]>age5 [c]+tfr [s][maximum '' f5.1]+gfr [s][mean '' f5.1]  by colper [c]
  /categories var=all empty=exclude missing=exclude
  /slabels position=row
  /titles title = "Table TM.0: Adolescent birth rate and total fertility rate"
                   "Adolescent birth rates and total fertility rates " + subgroupname + ", " + surveyname.
