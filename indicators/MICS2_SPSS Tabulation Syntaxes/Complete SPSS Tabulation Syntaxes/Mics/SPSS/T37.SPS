get file = 'wm.sav'.

weight by wmweight.

select if (CM11X = "Y").

compute total = 1.
variable label total "Number of mothers".

set seed = 1003.

do if (TT6AY < 9996 and TT6AM < 96).
+ compute dolt = (TT6AY - 1900)*12 + TT6AM.
+ compute yslt = trunc((cmcdoi - dolt)/12).
else if (TT6AY < 9996).
+ compute dolt = (TT6AY - 1900)*12 + trunc(rv.uniform(1,12.99)).
+ compute yslt = trunc((cmcdoi - dolt)/12).
else if (TT6B <= 19).
+ compute yslt = TT6B.
else.
+ compute yslt = 99.
end if.
missing values yslt (99).

compute two = 0.
if (TT3 >= 2 and TT3 <= 19) two = 100.
if (TT3 = 1 and TT7 >= 2 and TT7 <= 19) two = 100.
if (TT7 >= 2 and TT7 <= 19 and yslt < 3) two = 100.
variable label two "Received at least 2 doses, last within 3 years".

compute three = 0.
do if (two = 0)
+ if (TT7 >= 3 and TT7 <= 19 and yslt < 10) three = 100.
+ variable label three "Received at least 3 doses, last within 10 years".
end if.

compute five = 0.
do if (two = 0 and three = 0)
+ if (TT7 >= 5 and TT7 <= 19) five = 100.
+ variable label five "Received at least 5 doses during lifetime".
end if.

compute protect = 0.
if (two = 100 or three = 100 or five = 100) protect = 100.
variable label protect "Protected against tetanus".

tables
  /observation = two three five protect
  /ftotal tot1 "Total"
  /table = HI7 + HI6 + melevel + tot1 by two + three + five + protect + total
  /statistics
    mean(two (f5.1) '')
    mean(three (f5.1) '')
    mean(five (f5.1) '')
    mean(protect (f5.1) '')
    count(total (f5.0) '')
  /title
    "Table 37: Percentage of mothers with a birth in the last 12 months protected against neonatal tetanus, Country, Year"
  /caption
    "World Summit for Children Goal => Number 22".
