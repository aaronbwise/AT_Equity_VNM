get file = 'wm.sav'.

weight by wmweight.

compute total = 1.
variable label total "Number of women".

recode HA3 (1 = 100) (else = 0) into onepart.
variable label onepart "Have only one faithful uninfected sex partner".

recode HA5 (1 = 100) (else = 0) into condom.
variable label condom "Using a condom every time".

recode HA7 (1 = 100) (else = 0) into abstain.
variable label abstain "Abstaining from sex".

count ways = onepart condom abstain (100).

recode ways (3 = 100) (else = 0) into three.
variable label three "Knows all three ways".

recode ways (1 thru 3 = 100) (else = 0) into oneplus.
variable label oneplus "Knows at least one way".

recode ways (0 = 100) (else = 0) into none.
variable label none "Doesn't know any way".

tables
  /observation aids onepart condom abstain three oneplus none
  /ftotal = tot1 "Total"
  /table = HI7 + HI6 + wage + melevel + tot1 by
           aids + onepart + condom + abstain + three + oneplus + none + total
  /statistics
    mean(aids (f5.1) '')
    mean(onepart (f5.1) '')
    mean(condom (f5.1) '')
    mean(abstain (f5.1) '')
    mean(three (f5.1) '')
    mean(oneplus (f5.1) '')
    mean(none (f5.1) '')
    count(total (f5.0) '')
  /title
    "Table 30: Percentage of women aged 15-49 who know the main ways of preventing HIV transmission, Country, Year"
  /caption
    "Monitoring HIV/AIDS Indicator".
