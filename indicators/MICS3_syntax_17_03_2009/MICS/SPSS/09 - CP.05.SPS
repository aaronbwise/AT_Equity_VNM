get file= "wm.sav".

select if (WM7 = 1).

weight by wmweight.

compute t15 = 0.
if (agem < 15) t15 = 100.
variable label t15 "Percentage married before age 15 *".

compute total = 1.
variable label total "Number of women aged 15-49 years".
value label total 1 "".

do if (WM9 >= 20).
+ compute t18 = 0.
+ if (agem >= 15 and agem <= 17 or t15 = 100) t18 = 100.
end if.
variable label t18 "Percentage married before age 18 *".

if (WM9 >= 20) t2049 = 1.
variable label t2049 "Number of women aged 20-49 years".
value label t2049 1 "".

do if (wage = 1).
+ compute t1519m = 0.
+ if (MA1 =1 or MA1 = 2) t1519m  = 100.
+ compute t1519 = 1.
end if.
variable label t1519m "Percentage of women 15-19 years married/in union **".
variable label t1519 "Number of  women aged 15-19 years".
value label t1519 1 "".

* this code is only for countries with polygyny.
if (MA1 = 1 or MA1 = 2) totalm  = 1.
variable label totalm "Number of women aged 15-49 currently married/in union".
value label totalm 1 "".

do if (totalm = 1).
+ compute polyg  = 0.
+ if (MA2A = 1) polyg  = 100.
end if.
variable label polyg "Percentage of women aged 15-49 years in polygynous marriage/union ***".

tables
  /format = zero
  /observation = t15 t18 t1519m polyg   
  /ftotal = tot1 "Total"
  /table = HH7 + HH6 + wage + melevel + wlthind5 + HC1B + tot1 by 
	  t15 + total + t18 + t2049 + t1519m + t1519 + polyg + totalm
  /statistics
    mean(t15 (f5.1) '')
    count(total (f5.0) '')
    mean(t18 (f5.1) '')
    count(t2049 (f5.0) '')
    mean(t1519m (f5.1) '')
    count(t1519 (f5.0)'')
    mean(polyg (f5.1) '')
    count(totalm (f5.0) '')
 /title
    "Table CP.5: Early marriage and polygyny"
		"Percentage of women aged 15-49 in marriage or union before their 15th birthday, "+
                        "percentage of women aged 20-49 in marriage or union before their 18th birthday, "
                        "percentage of women aged 15-19 currently married or in union, "+
                        "and the percentage of married or in union women in a polygynous marriage or union,  Country, Year"
  /caption                                                                                                                                                                          
    "* MICS Indicator 67"
		"** MICS Indicator 68"
		"*** MICS Indicator 70".

new file.
