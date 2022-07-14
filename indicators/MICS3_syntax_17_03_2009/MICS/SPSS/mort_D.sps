* Direct estimation of mortality.  Trevor Croft, Sept 1, 2006.
* Calculation of deaths -- see mort.sps.

get file='bh.sav'.

* following line is a macro defining the subgroup to use -- see mort.sps.
subgroup

* Define lower limits of age categories for calculating probabilities
* i.e. 0, 1, 3, 6, 12, 24, 36, 48.
compute agegr$01 = 0.
compute agegr$02 = 1.
compute agegr$03 = 3.
compute agegr$04 = 6.
compute agegr$05 =12.
compute agegr$06 =24.
compute agegr$07 =36.
compute agegr$08 =48.
compute agegr$09 =60.

* Set width of each period for analysis (in months).
* Program works for minimum period of twelve months.
compute period = 60.

* Set number of periods for analysis.
compute maxper = 6.

* Set upper and lower limits for date of analysis period.
compute upplim = cmcdoiw - 1.
compute lowlim = cmcdoiw - (maxper * period) - 1.

* Select only dead children born in the periods of analysis.
select If (lowlim <= ccdob & ccdob <= upplim & BH5 = 2).

compute ageatdth = 0.
if (BH9U = 1) ageatdth = trunc(BH9N*12/365).
if (BH9U = 2) ageatdth = BH9N.
if (BH9U = 3) ageatdth = BH9N*12.
if (BH9U = 9) ageatdth = 0.
if (BH9U = 1 and BH9N = 99) ageatdth = 0.
if (BH9U = 2 and BH9N = 99) ageatdth = 1.
if (BH9U = 3 and BH9N = 99) ageatdth = 24.

* Assign deaths to age groups. Note that for compatability with WFS and DHS
* surveys, once deaths are assigned to an age group, only the information
* on the age group of death is used NOT the actual age at death.
compute j = 0.

* Age at death = 0 months.
if (agegr$01 <= ageatdth & ageatdth < agegr$02) j = 1.
* Age at death = 1-2 months.
if (agegr$02 <= ageatdth & ageatdth < agegr$03) j = 2.
* Age at death = 4-5 months.
if (agegr$03 <= ageatdth & ageatdth < agegr$04) j = 3.
* Age at death = 6-11 months.
if (agegr$04 <= ageatdth & ageatdth < agegr$05) j = 4.
* Age at death = 12-23 months.
if (agegr$05 <= ageatdth & ageatdth < agegr$06) j = 5.
* Age at death = 24-35 months.
if (agegr$06 <= ageatdth & ageatdth < agegr$07) j = 6.
* Age at death = 36-47 months.
If (agegr$07 <= ageatdth & ageatdth < agegr$08) j = 7.
* Age at death = 48-59 months.
If (agegr$08 <= ageatdth & ageatdth < agegr$09) j = 8.

compute agedth = j - 1.
formats agedth(f1.0).

* Select children who died under age 5.
select If (j <> 0).

* Determine period of birth and death.
compute perborn = trunc((cmcdoiw-1 - ccdob)/period).

* Calculate lower bound for the date of the period in which the child was born (limlow).
compute limlow = cmcdoiw  - (perborn+1) * period.

* Calculate earliest date death could occur in age group j.

* ie month of birth.
if (j = 1) agei = ccdob + agegr$01.
* ie month of birth + 1 month.
if (j = 2) agei = ccdob + agegr$02.
* ie month of birth + 3 months.
if (j = 3) agei = ccdob + agegr$03.
* ie month of birth + 6 months.
if (j = 4) agei = ccdob + agegr$04.
* ie month of birth + 12 months.
if (j = 5) agei = ccdob + agegr$05.
* ie month of birth + 24 months.
if (j = 6) agei = ccdob + agegr$06.
* ie month of birth + 36 months.
if (j = 7) agei = ccdob + agegr$07.
* ie month of birth + 48 months.
if (j = 8) agei = ccdob + agegr$08.

* Calculate date of start of next age group.
* (i.e. upper bound on date of death in age group j).

* ie month of birth + 1 month.
if (j = 1) nxtage = ccdob + agegr$02.
* ie month of birth + 3 months.
if (j = 2) nxtage = ccdob + agegr$03.
* ie month of birth + 6 months.
if (j = 3) nxtage = ccdob + agegr$04.
* ie month of birth + 12 months.
if (j = 4) nxtage = ccdob + agegr$05.
* ie month of birth + 24 months.
if (j = 5) nxtage = ccdob + agegr$06.
* ie month of birth + 36 months.
if (j = 6) nxtage = ccdob + agegr$07.
* ie month of birth + 48 months.
if (j = 7) nxtage = ccdob + agegr$08.
* ie month of birth + 60 months.
if (j = 8) nxtage = ccdob + agegr$09.

* Calculate upper bound for the date of the period in which the child was born (limupp).
compute limupp = limlow + period.
compute n = 1.

* number of periods in which death could occur.
compute iter  = 0.

* Death occurs in same period of birth.
if (limlow <= ccdob & nxtage <= limupp)  iter = 1.

* Death could occur in period of birth or in the next period.
if (agei < limupp & limupp <= nxtage) iter = 2.

* Death occurs in period after birth.
if (ccdob < limupp & limupp <= agei) iter = 1.

* Set perborn to period of death, i.e. next period.
if (ccdob < limupp & limupp <= agei) perborn = perborn - 1.

* All deaths to children born in the most recent period must occur in the most recent period.
if (perborn = 0) iter = 1.

if (iter <> 0) n = n / iter.

* Colper defines columns for table = time periods.
compute colper = perborn.
format colper (f1.0).

* Weight the data. Multiplied by 1000 to effectively
* allow more decimal places in the tabulation. Deaths that could have
* occured in either of two time periods are assigned 1/2 to each period (n).
compute rweight = n * wmweight.
weight by rweight.

* Tabulate deaths that occured to children born in the last 5 periods by age at death and period.
temporary.
select if (iter <> 0 & 0 <= colper & colper < 5).
aggregate outfile = 'tmp1.sav'
  /break = agedth colper
  /deaths = n(agedth).

* Retabulate deaths that could have occurred in the next period, in that period.
if (iter = 2) colper = colper - 1.
temporary.
select if (iter = 2 & 0 <= colper & colper < 5).
aggregate outfile = 'tmp2.sav'
  /break = agedth colper
  /deaths = n(agedth).

* Combine the two system files of death into one file.
add files 
  /file='tmp1.sav'
  /file='tmp2.sav'.

aggregate outfile = 'deaths.sav'
  /break = agedth colper
  /deaths = sum(deaths).

new file.

erase file = 'tmp1.sav'.
erase file = 'tmp2.sav'.