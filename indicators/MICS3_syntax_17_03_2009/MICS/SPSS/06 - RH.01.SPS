get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

select if  (mstatus = 1).

compute method = 0.
if (CP3X = "X") method = 14.
if (CP3M = "M") method = 13.
if (CP3L = "L") method = 12.
if (CP3K = "K") method = 11.
if (CP3I = "I" or CP3J = "J") method = 9.
if (CP3H = "H") method = 8.
if (CP3G = "G") method = 7.
if (CP3F = "F") method = 6.
if (CP3E = "E") method = 5.
if (CP3D = "D") method = 4.
if (CP3C = "C") method = 3.
if (CP3B = "B") method = 2.
if (CP3A = "A") method = 1.

variable label method "Percent of women (currently married or inunion) who are using:".
value label method 0 "Not using any method"
                   1 "Female sterilization"
                   2 "Male sterilization"
                   3 "Pill"
                   4 "IUD"
                   5 "Injections"
                   6 "Implants"
                   7 "Condom"
                   8 "Female condom"
                   9 "Diaphragm/foam/jelly"
                   11 "LAM"
                   12 "Periodic abstinence"
                   13 "Withdrawal"
                   14 "Other".

compute anymod = 0.
if (method >= 1 and method <= 9) anymod = 100.
variable label anymod "Any modern method".

compute anytrad = 0.
if (method >= 11 and method <= 14) anytrad = 100.
variable label anytrad "Any traditional method".

compute any = 0.
if (anymod = 100 or anytrad = 100) any = 100.
variable label any "Any method *".

compute living = 0.
if (CM1 = 1 and CM7 <> 1) living = CM9.
if (CM1 = 1 and CM7 = 1) living = CM9 - (CM8A + CM8B).
recode living (0 thru 3 = copy) (4 thru hi = 4).
variable label living "Number of living children".
value label living 4 "4+".
format living (f5.0).

compute total = 1.
variable label total "Number of women currently married or in union".
value label total 1 "".

tables
  /format = zero
  /observation anymod anytrad any
  /ftotal tot1 "Total"
  /tables = HH7 + HH6 + wage + living + melevel + wlthind5 + HC1B + tot1 
	  by method + tot1 + anymod + anytrad + any + total
  /statistics
    cpct(method (f5.1) '':HH7 HH6 wage melevel living wlthind5 HC1B)
    mean(anymod (f5.1) '')
    mean(anytrad (f5.1) '')
    mean(any (f5.1) '')
    count(total (f5.0) '')
  /title
    "Table RH.1: Use of contraception" 
		"Percentage of women aged 15-49 years married or in union who are using (or "+
		"whose partner is using) a contraceptive method, Country, Year"
  /caption
    "* MICS indicator 21; MDG indicator 19C".

new file.
