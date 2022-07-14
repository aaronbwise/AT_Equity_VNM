get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

select if (WM9 >= 15 and WM9 <= 24).

do if (WM9 >= 15 and WM9 <= 19).
+ compute sex15 = 0.
+ if (SB1 <> 0 and SB1 < 15) sex15 = 100.
+ if (SB1 = 95 and agem >= 4 and agem < 15) sex15 = 100.
+ compute tot1519 = 1.
end if.
variable label sex15 "Percentage of women aged 15-19 who had sex before age 15 *".
variable label tot1519 "Number of women aged 15-19 years".
value label tot1519 1 "".

do if (WM9 >= 20 and WM9 <= 24).
+ compute sex18 = 0.
+ if (SB1 <> 0 and SB1 < 18) sex18 = 100.
+ if (SB1 = 95 and agem >= 4 and agem < 18) sex18 = 100.
+ compute tot2024 = 1.
end if.
variable label sex18 "Percentage of women aged 20-24 who had sex before age 18".
variable label tot2024 "Number of women aged 20-24 years".
value label tot2024 1 "".

do if (SB1 <> 0 and (SB2U >= 1 and SB2U <= 3)).
+ compute difage10 = 0.
+ if ((SB4 = 1 or SB8 = 1) and MA2 <= 90 and MA2-WM9 >= 10) difage10 = 100.
+ if (SB4 <> 1 and SB5 <= 90 and SB5-WM9 >= 10) difage10 = 100.
+ if (SB6 = 1 and SB8 <> 1 and SB9 <= 90 and SB9-WM9 >= 10) difage10 = 100.
+ compute tot12 = 1.
end if.
variable label difage10 "Percentage who had sex in the 12 months preceding the survey with a man 10 or more years older **".
value label tot12 1 "". 
variable label tot12 "Number of women who had sex in the 12 months preceding the survey".

tables
  /format = zero
  /observation = sex15 sex18 difage10
  /ftotal = tot1 "Total"
  /table = HH7 + HH6 + wage + melevel + wlthind5 + HC1B + tot1 by 
	  sex15 + tot1519 + sex18 + tot2024 + difage10 + tot12
  /statistics
    mean(sex15 (f5.1) '')
    count(tot1519 (f5.0) '')
    mean(sex18 (f5.1) '')
    count(tot2024 (f5.0) '')
    mean(difage10 (f5.1) '')
    count(tot12 (f5.0) '')
  /title
    "Table HA.8: Sexual behaviour that increases risk of HIV infection"
		"Percentage of young women aged 15-19 years who had sex before age 15, "
		"percentage of young women aged 20-24 who had sex before age 18 "
        "and percentage of young women aged 15-24 "+
		"who had sex with a man 10 or more years older, Country, Year"
  /caption
    "* MICS Indicator 84"
    "** MICS Indicator 92".

new file.
