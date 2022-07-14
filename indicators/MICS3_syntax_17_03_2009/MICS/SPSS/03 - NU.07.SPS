get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

select if (CM12 = "Y" or CM12 = "O" or CM12 = "S").

recode MN1 (1 = 100) (else = 0) into vitayes.
variable label vitayes "Received Vitamin A supplement*".

recode MN1 (8,9 = 100) (else = 0) into vitadk.
variable label vitadk "Not sure if received Vitamin A".

compute total = 1.
variable label total "".
value label total 1 "Number of women aged 15-49 years".

tables
  /format = zero
  /observation = vitayes vitadk
  /ftotal = tot1 "Total"
  /table = HH7 + HH6 + melevel + wlthind5 + HC1B + tot1 by 
		vitayes + vitadk + total
  /statistics
    mean(vitayes (f5.1) '')
    mean(vitadk (f5.1) '')
    count(total (f5.0) '')
  /title
    "Table NU.7: Post-partum mother's Vitamin A supplementation" 
		"Percentage of women aged 15-49 years with a birth in the 2 last years preceding the "+
		"survey whether they received a high dose  Vitamin A supplement before "+
		"the infant was 8 weeks old, Country, Year"
  /caption
    "* MICS indicator 43".

new file.
