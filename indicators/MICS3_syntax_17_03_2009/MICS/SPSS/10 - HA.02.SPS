get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

recode HA3 (2 = 100) (else = 0) into super.
variable label super "HIV cannot be transmitted by supernatural means".

recode HA5 (2 = 100) (else = 0) into mosquito.
variable label mosquito "HIV cannot be transmitted by mosquito bites".

recode HA8 (1 = 100) (else = 0) into healthy.
variable label healthy "A healthy looking person can be infected".

recode HA7 (2 = 100) (else = 0) into food.
variable label food "HIV cannot be transmitted by sharing food".

recode HA7A (1 = 100) (else = 0) into needles.
variable label needles "HIV can be transmitted by sharing needles".

* The count of ways should be modified to include the two most common misconceptions together
* with the healthy looking person variable.
count ways = super mosquito healthy (100).

recode ways (3 = 100) (else = 0) into three.
variable label three "Reject two most common misconceptions and "+
  "know a healthy-looking person can be infected".

compute total = 1.
variable label total "Number of women".
value label total 1 "".

compute layer = 0.
value label layer 0 "Percent who know that:".

* The order of the columns should be so that the two most common misconceptions together
* with the healthy looking person variable are before the three ways variable
* and those ways with fewer misconceptions are placed after the three ways variable.
tables
  /format = zero
  /observation super mosquito healthy three food needles
  /ftotal = tot1 "Total"
  /table = HH7 + HH6 + wage + melevel + wlthind5 + HC1B + tot1 by
    layer > (super + mosquito + healthy) + three + food + needles + total
  /statistics
    mean(super (f5.1) '')
    mean(mosquito (f5.1) '')
    mean(healthy (f5.1) '')
    mean(three (f5.1) '')
    mean(food (f5.1) '')
    mean(needles (f5.1) '')
    count(total (f5.0) '')
  /title
    "Table HA.2: Identifying misconceptions about HIV/AIDS"
		"Percentage of women aged 15-49 years who correctly identify "+
		"misconceptions about HIV/AIDS, Country, Year".

new file.
