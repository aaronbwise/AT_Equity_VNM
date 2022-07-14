get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

select if (WM9 >= 15 and WM9 <= 24).

compute total = 1.
variable label total "Number of women aged 15-24".
value label total 1 "".

compute everhad = 0.
if (SB1 <> 0) everhad = 100.
variable label everhad "Ever had sex".

compute hadsex = 0.
if (SB1 <> 0 and SB2U >= 1 and SB2U <= 3) hadsex = 100.
variable label hadsex "Had sex in the last 12 months".

compute more = 0.
if (SB6 = 1) more = 100.
variable label more "Had sex with more than one partner in the last 12 months". 

do if (hadsex = 100).
+ compute nonmari = 0.
+ if ((SB4 >= 2 and SB4 <= 6) or (SB8 >= 2 and SB8 <= 6)) nonmari = 100.
+ compute t1524hs = 1.
end if.
variable label nonmari "Percent who had sex with non-marital, non-cohabiting partner *".
variables labels t1524hs "Number of women aged 15-24 years who had sex in last 12 months".
value labels t1524hs 1 "".

do if (nonmari = 100).
+ compute condom = 0.
+ if ((SB4 >= 2 and SB4 <= 6 and SB3 = 1) or 
  (SB4 = 1 and SB8 >= 2 and SB8 <= 6 and SB7 = 1)) condom = 100.
+ compute t1524nm = 1.
end if.
variable label condom "Percent who used a condom at last sex with a non-marital, non-cohabiting partner **".
variables labels t1524nm "Number of women aged 15-24 years who had sex in last 12 months with a non-marital, non-cohabiting partner".
value labels t1524nm 1 "".

tables
  /format = zero
  /observation = everhad hadsex more nonmari condom  
  /ftotal = tot1 "Total"
  /table = HH7 + HH6 + wage + melevel + wlthind5 + HC1B + tot1 by 
	  everhad + hadsex + more + total + nonmari + t1524hs+ condom + t1524nm
  /statistics
    mean(everhad (f5.1) '')
    mean(hadsex (f5.1) '')
    mean(more (f5.1) '')
    count(total (f5.0) '')
    mean(nonmari (f5.1) '')
    count(t1524hs (f5.0) '')
    mean(condom (f5.1) '')
    count(t1524nm (f5.0) '')
  /title
    "Table HA.9: Condom use at last high-risk sex"
		"Percentage of young women aged 15-24 who had high risk sex in the "+
		"previous year and who used a condom at last high risk sex, Country, Year"
  /caption
    "* MICS Indicator 85"
    "** MICS Indicator 83; MDG Indicator 19a".

new file.
