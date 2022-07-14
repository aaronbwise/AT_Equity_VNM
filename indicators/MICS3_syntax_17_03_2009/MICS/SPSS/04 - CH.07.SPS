get file = 'ch.sav'.

* ARI in the last 2 weeks.
compute ari  = 0.
if ((CA7 =1 or CA7 = 3) and CA5 = 1 and CA6 = 1) ari = 100.
variable label ari "Had acute respiratory infection".

select if (UF9 = 1 and ari = 100).

weight by chweight.

recode CA11A ("A" = 100) (else = 0) into anti.
variable label anti "Percentage of children aged 0-59 months with suspected "+
  "pneumonia who received antibiotics in the last two weeks *".

compute atotal = 1.
value label atotal 1 "".
variable label atotal "Number of children aged 0-59 months with suspected "+
  "pneumonia in the two weeks prior to the survey".

tables
  /format = zero
  /observation = ari anti
  /ftotal = tot1 "Total"
  /table = HL4 + HH7 + HH6 + cage_11 + melevel + wlthind5 + HC1B + tot1 by
    anti + atotal
  /statistics
    mean(anti (f5.1) '')
    count(atotal (f5.0) '')
  /title
    "Table CH.7: Antibiotic treatment of pneumonia"
		"Percentage of children aged 0-59 months with suspected pneumonia who "+
		"received antibiotic treatment, Country, Year"
  /caption
    "* MICS indicator 22".

new file.
