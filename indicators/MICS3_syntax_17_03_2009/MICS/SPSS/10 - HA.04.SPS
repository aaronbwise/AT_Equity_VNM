get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

compute total = 1.
value label total 1 "".
variable label total "Number of women".

compute know = 0.
if (HA9A = 1 or HA9B = 1 or HA9C = 1) know = 100.
variable label know "Know HIV can be transmitted from mother to child".

recode HA9A (1 = 100) (else = 0) into preg.
variable label preg "During pregnancy ".

recode HA9B (1 = 100) (else = 0) into delivery.
variable label delivery "At delivery ".

recode HA9C (1 = 100) (else = 0) into bmilk.
variable label bmilk "Through breastmilk".

compute three = 0.
if (HA9A = 1 and HA9B = 1 and HA9C = 1) three = 100.
variable label three "All three ways *".

compute none = 0.
if (HA9A <> 1 and HA9B <> 1 and HA9C <> 1) none = 100.
variable label none "Did not know any specific way".

compute layer = 0.
variable label layer "".
value label layer 0 "Percent who know HIV can be transmitted:".

tables
  /format = zero
  /observation know  preg delivery bmilk three none
  /ftotal = tot1 "Total"
  /table = HH7 + HH6 + wage + melevel + wlthind5 + HC1B + tot1 by
    know + layer > (preg + delivery + bmilk + three) + none + total
  /statistics
    means(know (f5.1) '')
    mean(preg (f5.1) '')
    mean(delivery (f5.1) '')
    mean(bmilk (f5.1) '')
    mean(three (f5.1) '')
    mean(none (f5.1) '')
    count(total (f5.0) '')
  /title
    "Table HA.4: Knowledge of mother-to-child HIV transmission"
		"Percentage of women aged 15-49 who correctly identify means of HIV "+
		"transmission from mother to child, Country, Year"
  /caption
    "* MICS Indicator 89".

new file.
