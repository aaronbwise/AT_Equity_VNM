get file = 'ch.sav'.

weight by chweight.

compute total = 1.
variable label total "Number of children under 5".

do if (fever = 100).

+ compute pa = 0.
+ if (ML4A = 1 or ML7A = 1) pa = 100.
+ variable label pa "Paracetamol".

+ compute ch = 0.
+ if (ML4B = 2 or ML7B = 2) ch = 100.
+ variable label ch "Chloroquine".

+ compute fa = 0.
+ if (ML4C = 3 or ML7C = 3) fa = 100.
+ variable label fa "Fansidar".

+ compute ot = 0.
+ if (ML4D = 4 or ML7D = 4) ot = 100.
+ variable label ot "Other".

+ compute dk = 0.
+ if (ML4Z = 9 or ML7Z = 9) dk = 100.
+ variable label dk "Don't know".

+ compute okdrug = 0.
+ if (ch = 100 or fa = 100) okdrug = 100.
+ variable label okdrug "Any appropriate anti-malarial drug".

+ compute ftotal = 1.
+ variable label ftotal "Number of childern with fever".

end if.

tables
  /observation = fever pa ch fa ot dk okdrug
  /ftotal = tot1 "Total"
  /table = HL3 + HI7 + HI6 + cage_6 + melevel + tot1 by
           fever + total + pa + ch + fa + ot + dk + okdrug + ftotal
  /statistics
    mean(fever (f5.1) '')
    count(total (f5.0) '')
    mean(pa (f5.1) '')
    mean(ch (f5.1) '')
    mean(fa (f5.1) '')
    mean(ot (f5.1) '')
    mean(dk (f5.1) '')
    mean(okdrug (f5.1) '')
    count(ftotal (f5.0) '')
  /title
    "Table 29: Percentage of children 0-59 months of age who were ill with fever in the last two weeks"
    "who received anti-malarial drugs, Country, Year"
  /caption
    "Monitoring IMCI and Malaria Indicator".
