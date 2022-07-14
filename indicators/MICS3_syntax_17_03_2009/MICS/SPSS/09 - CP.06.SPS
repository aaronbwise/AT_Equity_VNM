get file = "wm.sav".

select if (WM7 = 1).

weight by wmweight.

select if (MA1 = 1 or MA1 = 2 and WM9 >= 15 and WM9 <= 24).

if (MA2 < 96) difage = MA2 - WM9.
variable label difage "Age difference with partner".

do if (wage = 1).
+ compute t1519 = 1.
+ recode difage (lo thru -1 = 1) (0 thru 4 = 2) (5 thru 9 = 3) (10 thru hi = 4) (sysmis = 9) into difage1.
end if.
variable label t1519 "Number of women aged 15-19 years currently married/in union".
value label t1519 1 "".
variable label difage1 "Percentage of currently married/in union women aged 15-19 whose husband or partner is:".
value label difage1 
  1 "Younger"
  2 "0-4 years older"
  3 "5-9 years older"
  4 "10+ years older *"
  9 "Husband/partner's age unknown".  

do if (wage = 2).
+ compute t2024 = 1.
+ recode difage (lo thru -1 = 1) (0 thru 4 = 2) (5 thru 9 = 3) (10 thru hi = 4) (sysmis = 9) into difage2.
end if.
variable label t2024 "Number of women aged 20-24 years currently married/in union".
value label t2024 1 "".
variable label difage2 "Percentage of currently married/in union women aged 20-24 whose husband or partner is:".
value label difage2 
  1 "Younger"
  2 "0-4 years older"
  3 "5-9 years older"
  4 "10+ years older *"
  9 "Husband/partner's age unknown".  

tables
  /format = zero
  /ftotal = tot1 "Total"
  /table = HH7 + HH6 + melevel + wlthind5 + HC1B + tot1 by 
	  difage1 + tot1 + t1519 + difage2 + tot1 + t2024
  /statistics
    cpct(difage1 (f5.1) '':HH7 HH6  melevel wlthind5 HC1B)
    count(t1519 (f5.0) '')
    cpct(difage2 (f5.1) '':HH7 HH6 melevel wlthind5 HC1B)
    count(t2024 (f5.0) '')
 /title
    "Table CP.6: Spousal age difference"
		"Percent distribution of currently married/in union women aged 15-19 and "+
		"20-24 according to the age difference with their husband or partner, "+
		"Country, Year"
  /caption                                                                                                                                                                          
    "* MICS Indicator 69".

new file.
