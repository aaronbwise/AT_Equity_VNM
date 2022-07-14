get file = 'ch.sav'.

weight by chweight.

compute total = 1.
variable label total "Number of children under 5".

do if (diarrhea = 100).

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
+ variable label dtotal "Number of children with diarrhea".

end if.

tables
  /observation diarrhea drnkmore drnkless ateokay atebadly drnkate
  /ftotal tot1 "Total"
  /table = HL3 + HI7 + HI6 + cage_6 + melevel + tot1 by
           diarrhea + total + drnkmore + drnkless + ateokay + atebadly + drnkate + dtotal
  /statistics
    mean(diarrhea (f5.1) '')
    count(total (f5.0) '')
    mean(drnkmore (f5.1) '')
    mean(drnkless (f5.1) '')
    mean(ateokay (f5.1) '')
    mean(atebadly (f5.1) '')
    mean(drnkate (f5.1) '')
    count(dtotal (f5.0) '')
  /title
    "Table 24: Percentage of under-five children with diarrhea in the last two weeks who took increased fluids and continued to"
    "feed during the episode, Country, Year"
  /caption
    "World Summit for Children Goal => Number 23".
