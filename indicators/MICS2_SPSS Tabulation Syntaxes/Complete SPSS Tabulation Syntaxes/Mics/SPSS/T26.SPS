get file = 'ch.sav'.

weight by chweight.

compute sick = 0.
if (CI1 = 1 or CI2 = 1) sick = 100.
variable label sick "Reported illness in last two weeks".

compute total = 1.
variable label total "Number of children under 5".

do if (sick = 100).

+ recode CI4 (3 = 100) (else = 0) into drnkmore.
+ variable label drnkmore "Drank more".

+ recode CI4 (1,2 = 100) (else = 0) into drnkless.
+ variable label drnkless "Drank the same or less".

+ recode CI5 (3,4,5 = 100) (else = 0) into ateokay.
+ variable label ateokay "Ate somewhat less, same or more".

+ recode CI5 (1,2 = 100) (else = 0) into atebadly.
+ variable label atebadly "Ate much less or none".

+ compute drnkate = 0.
+ if (drnkmore = 100 and ateokay = 100) drnkate = 100.
+ variable label drnkate "Received increased fluids and continued eating".

+ compute dtotal = 1.
+ variable label dtotal "Number of sick children".

end if.

tables
  /observation sick drnkmore drnkless ateokay atebadly drnkate
  /ftotal tot1 "Total"
  /table = HL3 + HI7 + HI6 + cage_6 + melevel + tot1 by
           sick + total + drnkmore + drnkless + ateokay + atebadly + drnkate + dtotal
  /statistics
    mean(sick (f5.1) '')
    count(total (f5.0) '')
    mean(drnkmore (f5.1) '')
    mean(drnkless (f5.1) '')
    mean(ateokay (f5.1) '')
    mean(atebadly (f5.1) '')
    mean(drnkate (f5.1) '')
    count(dtotal (f5.0) '')
  /title
    "Table 26: Percentage of children 0-59 months of age reported ill during the last two weeks who received increased fluids"
    "and continued feeding, Country, Year"
  /caption
    "Monitoring IMCI and Malaria Indicator".
