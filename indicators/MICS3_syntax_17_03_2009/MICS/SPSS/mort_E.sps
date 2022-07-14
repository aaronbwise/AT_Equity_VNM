* Direct estimation of mortality.  Trevor Croft, Sept 1, 2006.
* Calculation of exposure -- see mort.sps.

get file='bh.sav'.

* following line is a macro defining the subgroup to use -- see mort.sps.
subgroup

* Set width of each period for analysis. Minimum = 12 months.
compute period = 60.

* Set number of periods for analysis.
compute maxper = 6.

* Define lower limits of age categories for calculating probabilities.
compute AgeGr$01 = 0.
compute AgeGr$02 = 1.
compute AgeGr$03 = 3.
compute AgeGr$04 = 6.
compute AgeGr$05 =12.
compute AgeGr$06 =24.
compute AgeGr$07 =36.
compute AgeGr$08 =48.
compute AgeGr$09 =60.

* Set upper and lower limits for date of analysis period.
compute upplim = cmcdoiw - 1.
compute lowlim = cmcdoiw - (maxper * period) - 1.

* Select children born in the analysis period.
compute xproc = 0.
if (lowlim <= ccdob & ccdob <= upplim) xproc = 1.
select if (lowlim <= ccdob & ccdob <= upplim).

compute ageatdth = 0.
if (BH9U = 1) ageatdth = trunc(BH9N*12/365).
if (BH9U = 2) ageatdth = BH9N.
if (BH9U = 3) ageatdth = BH9N*12.
if (BH9U = 9) ageatdth = 0.
if (BH9U = 1 and BH9N = 99) ageatdth = 0.
if (BH9U = 2 and BH9N = 99) ageatdth = 1.
if (BH9U = 3 and BH9N = 99) ageatdth = 24.

* Set months = number of months child lived.
compute months = 0.
if (BH5 = 2) months = ageatdth.
if (BH5 = 1) months = (cmcdoiw - ccdob).

* Calculate period of birth.
compute perborn = trunc((cmcdoiw-1 - ccdob)/period).

* Define macro for tabulating exposure.
define tabexp (!positional !tokens(1) /!positional !tokens(2))
* Select children exposed for at least part of the age group, ie children who enter the age group.
select if (agei <= ccdob + months).

* Calculate lower bound for the date of the period in which the child was born.
compute limlow = cmcdoiw - ((perborn+1) * period).

* Calculate upper bound for the date of the period in which the child was born.
compute limupp = limlow + period.

* Determine number of periods in which exposure occurred in the age group (iter).
compute iter = 0.
do if (limupp <= agei).
+ compute perborn = perborn - 1.
+ compute iter = 1.
+ compute n = 1.
+ compute limlow = limlow + period.
+ compute limupp = limlow + period.
end if.

* All exposure occurs in period of birth.
do if (nxtage < limupp).
+ compute iter = 1.
+ compute n = 1.
end if.

* Exposure occurs in period of birth and in the next period.
do if (agei < limupp & limupp <= nxtage).
+ compute iter = 2.
+ compute n = 0.5.
+ if (perborn = 0) iter = 1.
end if.

* Colper defines columns for tabulation = time periods.
compute colper = perborn.
format colper (f1.0).

* Weight data.
* Multiplied by 1000 used to allow more decimal places in the tabulation.
* Exposure that occurs over two time periods is assigned 1/2 to each period (n).
compute rweight = n * wmweight.
weight by rweight.

* Select 5 periods for tabulation.
temporary.
select if (0 <= colper & colper < 5).
aggregate outfile = !1
  /break = ageexp colper
  /exposure = n(ageexp).

compute colper = colper - 1.
temporary.
select if (0 <= colper & colper < 5 & iter = 2).
aggregate outfile = !2
  /break = ageexp colper
  /exposure = n(ageexp).

!enddefine.

* Tabulate exposure in the first age group (0 months) by period.
compute ageexp = 0.
format ageexp (f1.0).
* Set agei to CMC for start of age group and next age to CMC for start of next age group.
compute agei   = ccdob.
compute nxtage = ccdob + agegr$02.
tabexp 'exposd11.sav' 'exposd12.sav'.

* Tabulate exposure in the second age group (1-2 months) by period.
compute ageexp = 1.
* Set agi to CMC for start of age group and next age to CMC for start of next age group.
compute agei = nxtage.
compute nxtage = ccdob + agegr$03.
tabexp 'exposd21.sav' 'exposd22.sav'.

* Tabulate exposure in the third age group (3-5 months) by period.
compute ageexp = 2.
* Set agi to CMC for start of age group and next age to CMC for start of next age group.
compute agei = nxtage.
compute nxtage = ccdob + agegr$04.
tabexp 'exposd31.sav' 'exposd32.sav'.

* Tabulate exposure in the fourth age group (6-11 months) by period.
Compute ageexp = 3.
* Set agi to CMC for start of age group and next age to CMC for start of next age group.
compute agei = nxtage.
compute nxtage = ccdob + agegr$05.
tabexp 'exposd41.sav' 'exposd42.sav'.

* Tabulate exposure in the fifth age group (12-23 months) by period.
compute ageexp = 4.
* Set agi to CMC for start of age group and next age to CMC for start of next age group.
compute agei = nxtage.
compute nxtage = ccdob + agegr$06.
tabexp 'exposd51.sav' 'exposd52.sav'.

* Tabulate exposure in the sixth age group (24-35 months) by period.
compute ageexp = 5.
* Set agi to CMC for start of age group and next age to CMC for start of next age group.
compute agei = nxtage.
compute nxtage = ccdob + agegr$07.
tabexp 'exposd61.sav' 'exposd62.sav'.

* Tabulate exposure in the seventh age group (36-47 months) by period.
compute ageexp = 6.
* Set agi to CMC for start of age group and next age to CMC for start of next age group.
compute agei = nxtage.
compute nxtage = ccdob + agegr$08.
tabexp 'exposd71.sav' 'exposd72.sav'.

* Tabulate exposure in the eigth age group (48-59 months) by period.
compute ageexp = 7.
* Set agi to CMC for start of age group and next age to CMC for start of next age group.
compute agei = nxtage.
compute nxtage = ccdob + agegr$09.
tabexp 'exposd81.sav' 'exposd82.sav'.

* Combine all the exposure files and save as a single file.
add files
  /file='exposd11.sav'
  /file='exposd21.sav'
  /file='exposd31.sav'
  /file='exposd41.sav'.
add files
  /file=*
  /file='exposd51.sav'
  /file='exposd61.sav'
  /file='exposd71.sav'
  /file='exposd81.sav'.
add files
  /file=*
  /file='exposd12.sav'
  /file='exposd22.sav'
  /file='exposd32.sav'
  /file='exposd42.sav'.
add files
  /file=*
  /file='exposd52.sav'
  /file='exposd62.sav'
  /file='exposd72.sav'
  /file='exposd82.sav'.

* Tabulate exposure.
aggregate outfile = 'exposure.sav'
  /break = ageexp colper
  /exposure = sum(exposure).

new file.

erase file='exposd11.sav'.
erase file='exposd21.sav'.
erase file='exposd31.sav'.
erase file='exposd41.sav'.
erase file='exposd51.sav'.
erase file='exposd61.sav'.
erase file='exposd71.sav'.
erase file='exposd81.sav'.
erase file='exposd12.sav'.
erase file='exposd22.sav'.
erase file='exposd32.sav'.
erase file='exposd42.sav'.
erase file='exposd52.sav'.
erase file='exposd62.sav'.
erase file='exposd72.sav'.
erase file='exposd82.sav'.