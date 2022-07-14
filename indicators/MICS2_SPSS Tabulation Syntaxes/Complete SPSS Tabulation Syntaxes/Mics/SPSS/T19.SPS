get file = 'wm.sav'.

weight by wmweight.

select if (CM11X = "Y").

recode MN1 (1 = 100) (else = 0) into vitayes.
variable label vitayes "Received Vitamin A supplement".

recode MN1 (7,9 = 100) (else = 0) into vitadk.
variable label vitadk "Not sure if received".

compute total = 1.
variable label total "".
value label total 1 "Number of women".

tables
  /observation = vitayes vitadk
  /ftotal = tot1 "Total"
  /table = HI7 + HI6 + melevel + tot1 by vitayes + vitadk + total
  /statistics
    mean(vitayes (f5.1) '')
    mean(vitadk (f5.1) '')
    count(total (f5.0) '')
  /title
    "Table 19: Percentage of women with a birth in the last 12 months by whether they received a high dose of Vitamin A"
    "supplement before the infant was 8 weeks old, Country, Year"
  /caption
    "World Summit for Children Goal => Number 15".
