get file = 'WM.sav'.

select if (WM7 = 1).

weight by wmweight.

select if (CM12 = "Y" or CM12 = "O" or CM12 = "S").

compute total = 1.
value label total 1 "".
variable label total "Number of mothers".

do if (TT7Y < 9996 and TT7M < 96).
+ compute dolt = (TT7Y - 1900)*12 + TT7M.
+ compute yslt = trunc((cmcdoiw - dolt)/12).
else if (TT7Y < 9996).
+ compute dolt = (TT7Y - 1900)*12 + 6.
+ compute yslt = trunc((cmcdoiw - dolt)/12).
else if (TT8 <= 19).
+ compute yslt = TT8.
else.
+ compute yslt = 99.
end if.
missing values yslt (99).

compute twocr = 0.
if (TT3 >= 2 and TT3 <= 19) twocr = 100.
variable label twocr "Received at least 2 doses during last pregnancy".

compute two3y = 0.
do if (twocr = 0).
+ if (TT3 = 1 and TT6 >= 1) two3y = 100.
+ if (TT6 >= 2 and TT6 <= 19 and yslt < 3) two3y = 100.
end if.
variable label two3y "Received at least 2 doses, the last within prior 3 years".

compute three5y = 0.
do if (twocr = 0 and two3y = 0).
+ if (TT6 >= 3 and TT6 <= 19 and yslt < 5 ) three5y = 100.
end if.
variable label three5y "Received at least 3 doses, the last within 5 years".

compute four10y = 0.
do if (twocr = 0 and two3y = 0 and three5y = 0).
+ if (TT6 >= 4 and TT6 <= 19 and yslt < 10) four10y = 100.
end if.
variable label four10y "Received at least 4 doses, the last within 10 years".

compute five = 0.
do if (twocr = 0 and two3y = 0 and three5y = 0 and four10y = 0).
+ if (TT6 >= 5 and TT6 <= 19) five = 100.
end if.
variable label five "Received at least 5 doses during lifetime".

compute protect = 0.
if (twocr = 100 or two3y = 100 or three5y = 100 or four10y = 100 or
	five = 100) protect = 100.
variable label protect "Protected against tetanus *".

tables
  /format = zero
  /observation = twocr two3y three5y four10y five protect
  /ftotal tot1 "Total"
  /table = HH7 + HH6 + wage + melevel + wlthind5 + HC1B + tot1
		by twocr + two3y + three5y + four10y + five + protect + total
  /statistics
    mean(twocr (f5.1) '')
    mean(two3y (f5.1) '')
    mean(three5y (f5.1) '')
    mean(four10y (f5.1) '')
    mean(five (f5.1) '')
    mean(protect (f5.1) '')
    count(total (f5.0) '')
  /title
    "Table CH.3: Neonatal tetanus protection"
		"Percentage of mothers with a birth in the last 24 months protected "+
		"against neonatal tetanus, Country, year"
  /caption
    "* MICS Indicator 32".

new file.
