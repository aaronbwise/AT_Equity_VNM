get file = 'wm.sav'.

weight by wmweight.

compute total = 1.
variable label total "Number of women".

recode HA13 (1 = 100) (else = 0) into teacher.
variable label teacher "Believe that a teacher with HIV should not be allowed to work".

recode HA14 (1 = 100) (else = 0) into food.
variable label food "Would not buy food from a person with HIV/AIDS".

count ways = teacher food (100).

recode ways (1 thru 2 = 100) (else = 0) into oneplus.
variable label oneplus "Agree with at least one discriminatory statement".

recode ways (0 = 100) (else = 0) into none.
variable label none "Agree with neither discriminatory statement".

tables
  /observation teacher food oneplus none
  /ftotal = tot1 "Total"
  /table = HI7 + HI6 + wage + melevel + tot1 by
           teacher + food + oneplus + none + total
  /statistics
    mean(teacher (f5.1) '')
    mean(food (f5.1) '')
    mean(oneplus (f5.1) '')
    mean(none (f5.1) '')
    count(total (f5.0) '')
  /title
    "Table 33: Percentage of women aged 15-49 who express a discriminatory attitude towards people with HIV/AIDS, Country, Year"
  /caption
    "Monitoring HIV/AIDS Indicator".
