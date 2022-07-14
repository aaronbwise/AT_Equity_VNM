get file = 'ch.sav'.

weight by chweight.

recode CI11A (1 = 100) (else = 0) into br.
variable label br "Not able to drink/breastfeed".

recode CI11B (2 = 100) (else = 0) into si.
variable label si "Becomes sicker".

recode CI11C (3 = 100) (else = 0) into fe.
variable label fe "Develops a fever".

recode CI11D (4 = 100) (else = 0) into fa.
variable label fa "Has fast breathing".

recode CI11E (5 = 100) (else = 0) into di.
variable label di "Has difficult breathing".

recode CI11F (6 = 100) (else = 0) into bl.
variable label bl "Has blood in stool".

recode CI11G (7 = 100) (else = 0) into dr.
variable label dr "Is drinking poorly".

count signs = br si fe fa di bl dr (100).

compute twosigns = 0.
if (signs >= 2) twosigns = 100.
variable label twosigns "Knows at least two signs".

tables
  /observation = br si fe fa di bl dr twosigns
  /ftotal = tot1 "Total" tot2 "Number of caretakers"
  /table = HI7 + HI6 + melevel + tot1 by br + si + fe + fa + di + bl + dr + twosigns + tot2
  /statistics
    mean(br (f5.1) '')
    mean(si (f5.1) '')
    mean(fe (f5.1) '')
    mean(fa (f5.1) '')
    mean(di (f5.1) '')
    mean(bl (f5.1) '')
    mean(dr (f5.1) '')
    mean(twosigns (f5.1) '')
    count(tot2 (f5.0) '')
  /title
    "Table 27: Percentage of caretakers of children 0-59 months who know at least 2 signs for seeking care"
    "immediately, Country, Year"
  /caption
    "Monitoring IMCI and Malaria Indicator".
