get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

compute total = 1.
variable label total "Number of women".
value label total 1 "".

recode HA1 (1 = 100) (else = 0) into knowaids.
variable label knowaids "Heard of AIDS".

recode HA2 (1 = 100) (else = 0) into onepart.
variable label onepart "Having only one faithful uninfected sex partner".

recode HA4 (1 = 100) (else = 0) into condom.
variable label condom "Using a condom every time".

recode HA6 (1 = 100) (else = 0) into abstain .
variable label abstain "Abstaining from sex".

count ways = onepart condom abstain (100).

recode ways (3 = 100) (else = 0) into three.
variable label three "Knows all three ways".

recode ways (1 thru 3 = 100) (else = 0) into oneplus.
variable label oneplus "Knows at least one way".

recode ways (0 = 100) (else = 0) into none.
variable label none "Doesn't know any way".

compute layer = 0.
variable label layer "".
value label layer 0 "Percentage who know transmission can be prevented by:".

tables
  /format = zero
  /observation knowaids onepart condom abstain three oneplus none
  /ftotal = tot1 "Total"
  /table = HH7 + HH6 + wage + melevel + wlthind5 + HC1B + tot1 by
    knowaids + layer > (onepart + condom + abstain) + three + oneplus + none + total
  /statistics
    mean(knowaids (f5.1) '')
    mean(onepart (f5.1) '')
    mean(condom (f5.1) '')
    mean(abstain (f5.1) '')
    mean(three (f5.1) '')
    mean(oneplus (f5.1) '')
    mean(none (f5.1) '')
    count(total (f5.0) '')
  /title
    "Table HA.1: Knowledge of preventing HIV transmission"
		"Percentage of women aged 15-49 years who know the main ways of "+
		"preventing HIV transmission, Country, Year".
                                                                                                                                
new file.
