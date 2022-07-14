get file = 'wm.sav'.

select if (WM7 = 1).
weight by wmweight.

select if (CM12 = "Y" or CM12 = "O" or CM12 = "S").

* set random number seed.
set seed = 1003.

* calculate months since last birth IF last birth in last two years.
do if (CM11Y < 9996 and CM11M < 96).
+ compute wdolb = (CM11Y - 1900)*12 + CM11M.
+ if (cmcdoiw - wdolb = 24) wdolb = wdolb + 1 .
else if (CM11Y < 9996).
+ compute udolb = (CM11Y - 1900)*12 + 12.
+ compute ldolb = (CM11Y - 1900)*12 + 1.
+ if (cmcdoiw - ldolb >= 24) ldolb = cmcdoiw - 23.
+ compute wdolb = trunc(rv.uniform(ldolb,udolb)).
end if.
compute mslbrth = cmcdoiw - wdolb.
variable label mslbrth "Months since last birth".
variable label wdolb "Date of last birth (CMC)".

*create a recoded months variable since last birth.
recode mslbrth (0 thru 5 = 1) (6 thru 11 = 2) (12 thru 23 = 3) into mslbrthr.
variable label mslbrthr "Months since last birth".
value label mslbrthr
  1 "< 6 months"
  2 "6-11 months"
  3 "12-23 months".

compute w1hour = 0.
if ((MN13U = 1 and MN13N = 0) or MN13U  = 0) w1hour = 100.
variable label w1hour "Percentage who started breastfeeding within one hour "+
  "of birth*".

compute w1day = 0.
if (MN13U = 0 or  MN13U = 1) w1day = 100.
variable label w1day "Percentage who started breastfeeding within one day of birth".

compute total = 1.
value label total 1 "".
variable label total "Number of women with live birth in the two years "+
  "preceding the survey".

tables
  /format = zero
  /observation = w1hour w1day 
  /ftotal = tot1 "Total"
  /table = HH7 + HH6 + mslbrthr + melevel + wlthind5 + HC1B + tot1 
		by w1hour + w1day + total
  /statistics
    mean(w1hour (f5.1) '')
    mean(w1day (f5.1) '')
    count(total (f5.0) '')
  /title
    "Table NU.2: Intitial breastfeeding" 
		"Percentage of women aged 15-49 years with a birth in the 2 years preceding the survey "+
		"who breastfed their baby within one hour of birth and within one day of birth, Country, Year"
  /caption
  	"* MICS indicator 45".

new file.
