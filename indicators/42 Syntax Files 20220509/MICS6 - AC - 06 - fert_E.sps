* Encoding: windows-1252.
* Direct estimation of fertility with sampling errors - Trevor Croft (trevor.croft@icfi.com) June 12, 2014.

* Calculates exposure of all women 15-49 years of age for specified periods preceding the interview.

* Comments begin with a star (*) and end with a full stop (.) at the end of the line.
* If the star is followed by the letters 'AW', the comment explains how to use all-women factors in countries with ever-married samples.

* When using background variables and an ever-married sample it is necessary to replace AWFACTT
* with the all-women factors broken down by the background variables.
* The choice of background variables in countries with ever-married samples is therefore limited by the availability
* of the appropriate all-women in the data file.

get file='wm.sav'.

* drop incomplete interviews.
select if (wm17 = 1).

* following line is a macro defining the subgroup to use -- see fert.sps.
subgroup

* set or recode cluster number.
compute cl = HH1.
formats cl (f4.0).

* Set period for the analysis (in months); change if necessary.
* Programs only work for periods of 60 months or less.
compute period = 36.

* Set number of periods for analysis.
compute maxper = 5.

compute age5 = 0.
formats age5 (f1.0).
variable labels age5 "Mother's age at time of the birth".
value labels age5
         1 '15-19'
         2 '20-24'
         3 '25-29'
         4 '30-34'
         5 '35-39'
         6 '40-44'
         7 '45-49'
.

compute colper = 0.
variable label colper "Number of years preceding the survey".
formats colper (f1.0).
* Correct the value labels if the length or number of periods is changed.
value labels colper
         0 '0-2'
         1 '3-5'
         2 '6-8'
         3 '9-11'
         4 '12-14'
.

define expos (!positional !tokens(1) /!positional !tokens(2))
* Set upper and lower limits for date of analysis period.
compute upplim = wdoi - (period * colper) - 1.

* Calculate age of woman and her 5-year age group (3 = 15-19, etc).
compute age = upplim - wdob.
compute age5 = trunc(age/60).

* Calculate exposure in months in the current age group and previous age group during the analysis period.

* higexp = exposure in current age group during the analysis period in months.
* lowexp = exposure in previous age group during the analysis period in months.
compute higexp = age - (age5 * 60) + 1.
if (higexp > period) higexp = period.
compute lowexp = 0.
if (higexp < period) lowexp = period - higexp.

* Create a weight equal to exposure in current age group.
compute rweight = higexp * wmweight.

* AW - use the inflation factor to compute the weight.
* AW - replace AWFACTT by appropriate all-women factors if necessary.
** compute rweight = higexp * (AWFACTT/100) * wmweight.

* Weight by exposure in current age group.
weight by rweight.

* This sets 15-19 = 1, rather than 3 as above.
* Other age groups are similarly affected (i.e., 20-24 becomes 2 instead of 4).
compute age5 = age5 - 2.

* Create a temporary filter; women younger than 15 are excluded.
* Select 5 periods for tabulation.
temporary.
select if (0 <= colper & colper < maxper & age5 > 0).

* Output high end exposure to aggregate file.
aggregate outfile = !1
  /break = cl colper age5
  /exposure = n(higexp).

* Create a weight equal to exposure in previous age-group.
compute rweight = lowexp * wmweight.

* AW - use the inflation factor to compute the weight.
* AW - replace AWFACTT by appropriate all-women factors if necessary.
** compute rweight = lowexp * (AWFACTT/100) * wmweight.

* Weight by exposure in previous age group.
weight by rweight.

* Reduce age group by one (i.e., the value of age5 for women 15-19 drops from 1 to 0;.
* the value of age5 for women 20-24 drops from 2 to 1, and so one for the other age groups.
compute age5 = age5 - 1.

* Create a temporary filter; women younger than 20 are excluded.
temporary.
select if (0 <= colper & colper < maxper & age5 > 0 & lowexp > 0).

* Output low end exposure to aggregate file.
aggregate outfile = !2
  /break = cl colper age5
  /exposure = n(lowexp).

* Define period for next iteration.
compute colper = colper + 1.

!enddefine.

* Run exposure macro for each period.
* Add in a line for each period used to match number given in maxper.
expos 'higexp1.sav' 'lowexp1.sav'.
expos 'higexp2.sav' 'lowexp2.sav'.
expos 'higexp3.sav' 'lowexp3.sav'.
expos 'higexp4.sav' 'lowexp4.sav'.
expos 'higexp5.sav' 'lowexp5.sav'.

* Merge all exposure for all periods.
* Add in 2 lines for each period used to match number given in maxper.
add files
  /file = 'higexp1.sav'
  /file = 'lowexp1.sav'
  /file = 'higexp2.sav'
  /file = 'lowexp2.sav'
  /file = 'higexp3.sav'
  /file = 'lowexp3.sav'
  /file = 'higexp4.sav'
  /file = 'lowexp4.sav'
  /file = 'higexp5.sav'
  /file = 'lowexp5.sav'.

* Convert exposure from months to years.
compute exposure = exposure / 12.

aggregate outfile = 'exposure.sav'
  /break = cl colper age5
  /exposure = sum(exposure).

new file.

* Erase all temporary files used.
* Add in 2 lines for each period used to match number given in maxper.
erase file='higexp1.sav'.
erase file='lowexp1.sav'.
erase file='higexp2.sav'.
erase file='lowexp2.sav'.
erase file='higexp3.sav'.
erase file='lowexp3.sav'.
erase file='higexp4.sav'.
erase file='lowexp4.sav'.
erase file='higexp5.sav'.
erase file='lowexp5.sav'.