get file = 'wm.sav'.

weight by wmweight.

compute total = 1.
variable label total "Number of women".

recode HA9 (1 = 100) (else = 0) into momtokid.
variable label momtokid "Know AIDS can be transmitted from mother to child".

recode HA10 (1 = 100) (else = 0) into preg.
variable label preg "Transmission during pregnancy possible".

recode HA11 (1 = 100) (else = 0) into delivery.
variable label delivery "Transmission at delivery possible".

recode HA12 (1 = 100) (else = 0) into bmilk.
variable label bmilk "Transmission through breastmilk possible".

count ways = preg delivery bmilk (100).

recode ways (3 = 100) (else = 0) into three.
variable label three "Knows all three".

recode ways (0 = 100) (else = 0) into none.
variable label none "Did not know any specific way".

tables
  /observation momtokid preg delivery bmilk three none
  /ftotal = tot1 "Total"
  /table = HI7 + HI6 + wage + melevel + tot1 by
           momtokid + preg + delivery + bmilk + three + none + total
  /statistics
    mean(momtokid (f5.1) '')
    mean(preg (f5.1) '')
    mean(delivery (f5.1) '')
    mean(bmilk (f5.1) '')
    mean(three (f5.1) '')
    mean(none (f5.1) '')
    count(total (f5.0) '')
  /title
    "Table 32: Percentage of women aged 15-49 who correctly identify means of HIV transmission from mother to child, Country, Year"
  /caption
    "Monitoring HIV/AIDS Indicator".
