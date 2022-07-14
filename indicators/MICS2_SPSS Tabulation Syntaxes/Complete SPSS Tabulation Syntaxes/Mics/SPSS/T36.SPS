get file = 'wm.sav'.

weight by wmweight.

select if mstatus = 1.

compute total = 1.
variable label total "Number of currently married women".

recode CU4A (1 = 100) (else = 0) into cm1.
variable label cm1 "Female sterilization".

recode CU4B (2 = 100) (else = 0) into cm2.
variable label cm2 "Male sterilization".

recode CU4C (3 = 100) (else = 0) into cm3.
variable label cm3 "Pill".

recode CU4D (4 = 100) (else = 0) into cm4.
variable label cm4 "IUD".

recode CU4E (5 = 100) (else = 0) into cm5.
variable label cm5 "Injections".

recode CU4F (6 = 100) (else = 0) into cm6.
variable label cm6 "Implants".

recode CU4G (7 = 100) (else = 0) into cm7.
variable label cm7 "Condom".

recode CU4H (8 = 100) (else = 0) into cm8.
variable label cm8 "Female condom".

compute cm9 = 0.
if (CU4I = 9 or CU4J = 10) cm9 = 100.
variable label cm9 "Diaphragm/foam/jelly".

recode CU4K (11 = 100) (else = 0) into cm11.
variable label cm11 "LAM".

recode CU4L (12 = 100) (else = 0) into cm12.
variable label cm12 "Periodic abstinence".

recode CU4M (13 = 100) (else = 0) into cm13.
variable label cm13 "Withdrawal".

recode CU4N (14 = 100) (else = 0) into cm14.
variable label cm14 "Other".

compute anymod = 0.
if (cm1 = 100 or cm2 = 100 or cm3 = 100 or cm4 = 100 or cm5 = 100 or cm6 = 100 or cm7 = 100 or cm8 = 100 or cm9 = 100) anymod = 100.
variable label anymod "Any modern method".

compute anytrad = 0.
if (cm11 = 100 or cm12 = 100 or cm13 = 100 or cm14 = 100) anytrad = 100.
variable label anytrad "Any traditional method".

compute any = 0.
if (anymod = 100 or anytrad = 100) any = 100.
variable label any "Any method".

tables
  /observation cm1 cm2 cm3 cm4 cm5 cm6 cm7 cm8 cm9 cm11 cm12 cm13 cm14 anymod anytrad any
  /ftotal tot1 "Total"
  /tables = HI7 + HI6 + melevel + tot1 by
            cm1 + cm2 + cm3 + cm4 + cm5 + cm6 + cm7 + cm8 + cm9 + cm11 + cm12 + cm13 + cm14 + anymod + anytrad + any + total
  /statistics
    mean(cm1 (f5.1) '')
    mean(cm2 (f5.1) '')
    mean(cm3 (f5.1) '')
    mean(cm4 (f5.1) '')
    mean(cm5 (f5.1) '')
    mean(cm6 (f5.1) '')
    mean(cm7 (f5.1) '')
    mean(cm8 (f5.1) '')
    mean(cm9 (f5.1) '')
    mean(cm11 (f5.1) '')
    mean(cm12 (f5.1) '')
    mean(cm13 (f5.1) '')
    mean(cm14 (f5.1) '')
    mean(anymod (f5.1) '')
    mean(anytrad (f5.1) '')
    mean(any (f5.1) '')
    count(total (f5.0) '')
  /title
    "Table 36: Percentage of married or in union women aged 15-49 who are using (or whose partner is using) a contraceptive"
    "method, Country, Year"
  /caption
    "World Summit for Children Goal => Number 10".
