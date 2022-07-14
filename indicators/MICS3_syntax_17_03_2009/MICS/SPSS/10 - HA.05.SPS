get file = 'wm.sav'.

select if (WM7 = 1 and HA1 = 1).

weight by wmweight.

compute total = 1.
variable label total "Number of women who have heard of AIDS".
value label total 1 "".

recode HA13 (2 = 100) (else = 0) into care.
variable label care "Would not care for a family member who was sick with AIDS".

recode HA12 (1 = 100) (else = 0) into secret.
variable label secret "If a family member had HIV would want to keep it a secret".

recode HA10 (2 = 100) (else = 0) into teacher.
variable label teacher "Believe that a female teacher with HIV should not be allowed to work".

recode HA11 (2 = 100) (else = 0) into food.
variable label food "Would not buy fresh vegetables from a person with HIV/AIDS".

count ways = secret care teacher food (100).

recode ways (1 thru 4 = 100) (else = 0) into oneplus.
variable label oneplus "Agree with at least one discriminatory statement".

recode ways (0 = 100) (else = 0) into none.
variable label none "Agree with none of the discriminatory statements*".

compute layer = 0.
variable label layer "".
value label layer 0 "Percent of women who:".

tables
  /format = zero
  /observation care secret  teacher food oneplus none
  /ftotal = tot1 "Total"
  /table = HH7 + HH6 + wage + melevel + wlthind5 + HC1B + tot1 by
    layer > (care + secret + teacher + food + oneplus + none) + total
  /statistics
    mean(care (f5.1) '')
    mean(secret (f5.1) '')
    mean(teacher (f5.1) '')
    mean(food (f5.1) '')
    mean(oneplus (f5.1) '')
    mean(none (f5.1) '')
    count(total (f5.0) '')
  /title
    "Table HA.5: Attitudes toward people living with HIV/AIDS"
		"Percentage of women aged 15-49 years who have heard of AIDS who express "+
		"a discriminatory attitude towards people living with HIV/AIDS, Country, Year"
  /caption
    "* MICS Indicator 86".

new file.
