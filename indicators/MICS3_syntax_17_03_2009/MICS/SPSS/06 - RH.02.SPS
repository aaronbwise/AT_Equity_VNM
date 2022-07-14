get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

select if (mstatus = 1).

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

variable label method "Current method".
value label method 0 "No method"
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

compute usemeth = 0.
if (method >= 1 and method <= 14) usemeth = 100.
variable label usemeth "Current use of contraception*".

compute fecund = 0.
if (CP1 = 1) fecund = 1.
if (not(sysmis(CP4E)) & CP4E <> 2) fecund = 1.
variable label fecund "Is woman fecund".
value label fecund
  0 "No"
  1 "Yes".
	
compute space  = 0.
compute limit  = 0.
compute unmet = 0.

do if (usemeth = 0 and fecund = 1).
+ if (CP1 = 1 and CP1A = 2) space = 100.
+ if (CP1 <> 1 and CP4A = 1 and CP4CU = 1 and CP4CN >= 24 and CP4CN < 90)  space = 100.
+ if (CP1 <> 1 and CP4A = 1 and CP4CU = 2 and CP4CN >= 2 and CP4CN < 90) space = 100.
+ if (CP1 <> 1 and CP4A = 1 and CP4CU = 9 and CP4CN = 95) space = 100.
+ if ((CP1 = 1 and CP1A = 3) or (CP1 <> 1 and CP4A = 2)) limit = 100.
+ if (space = 100 or limit = 100) unmet = 100.
end if.

variable label space "Unmet need for contraception - For spacing**". 
variable label limit "Unmet need for contraception - For limiting***".  
variable label unmet "Unmet need for contraception - Total ****".

compute total = 1.
variable label total "Number of women currently married or in union".
value label total 1 "".

do if (unmet = 100 or usemeth = 100).
+ compute satisf  = 0.
+ if (usemeth = 100) satisf = 100.
+ compute totneed = 1.
end if.

variable label satisf "Percentage of demand for contraception satisfied *****".
variable label totneed "Number of women currently married or in union with need for contraception".
value label totneed 1 "".

tables
  /format = zero
  /observation usemeth space limit unmet satisf
  /ftotal tot1 "Total"
  /tables = HH7 + HH6 + wage + melevel + wlthind5 + HC1B + tot1 
	  by usemeth+ space+ limit + unmet + total + satisf + totneed
  /statistics
    mean(usemeth (f5.1) '')
    mean(space (f5.1) '')
    mean(limit (f5.1) '')
    mean(unmet (f5.1) '')
    count(total (f5.0) '')
    mean(satisf (f5.1) '')
    count(totneed (f5.0) '')
  /title
    "Table RH.2: Unmet need for contraception"
		"Percentage of women aged 15-49 years currently married or in union with an "+
		"unmet need for family planning and percentage of demand for contraception "+
		"satisfied, Country, Year"
  /caption
    "* MICS indicator 21; MDG indicator 19C"
    "**** MICS indicator 98" 
    "***** MICS indicator 99".

new file.
