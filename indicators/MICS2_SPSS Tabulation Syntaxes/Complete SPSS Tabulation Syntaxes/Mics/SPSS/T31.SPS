get file = 'wm.sav'.

weight by wmweight.

compute total = 1.
variable label total "Number of women".

recode HA4 (2 = 100) (else = 0) into super.
variable label super "AIDS can't be transmitted by supernatural means".

recode HA6 (2 = 100) (else = 0) into mosquito.
variable label mosquito "AIDS can't be transmitted by mosquito bites".

recode HA8 (1 = 100) (else = 0) into healthy.
variable label healthy "A healthy looking person can be infected".

count ways = super mosquito healthy (100).

recode ways (3 = 100) (else = 0) into three.
variable label three "Knows all three misconceptions".

recode ways (1 thru 3 = 100) (else = 0) into oneplus.
variable label oneplus "Knows at least one misconception".

recode ways (0 = 100) (else = 0) into none.
variable label none "Doesn't correctly identify any misconception".

tables
  /observation aids super mosquito healthy three oneplus none
  /ftotal = tot1 "Total"
  /table = HI7 + HI6 + wage + melevel + tot1 by
           aids + super + mosquito + healthy + three + oneplus + none + total
  /statistics
    mean(aids (f5.1) '')
    mean(super (f5.1) '')
    mean(mosquito (f5.1) '')
    mean(healthy (f5.1) '')
    mean(three (f5.1) '')
    mean(oneplus (f5.1) '')
    mean(none (f5.1) '')
    count(total (f5.0) '')
  /title
    "Table 31: Percentage of women aged 15-49 who correctly identify misconceptions about HIV/AIDS, Country, Year"
  /caption
    "Monitoring HIV/AIDS Indicator".
