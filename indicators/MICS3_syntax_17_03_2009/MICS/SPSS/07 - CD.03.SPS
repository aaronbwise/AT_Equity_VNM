get file = 'ch.sav'.

select if (UF9 = 1).
weight by chweight.

compute total = 1.
variable label total "Number of children aged 0-59 months".
value label total 1 "".

recode cage (0 thru 23 = 1) (else = 2) into agegrp .
variable label agegrp "Age".
value label agegrp 1 "0-23" 2 "24-59".

recode CE4 (0 = 0) (else = 100) into care.
variable label  care "Left in the care children under the age of 10 years in past week".

recode CE5 (0 = 0) (else = 100) into alone.
variable label  alone "Left alone in the past week".

compute inadeq = 0.
if (care = 100 or alone  = 100) inadeq  = 100.
variable label inadeq "Left with inadequate care in past week *".

tables
  /format = zero  
  /observation care alone inadeq
  /ftotal tot1 "Total"
  /table = HL4 + HH7 + HH6 + agegrp + melevel + wlthind5 + HC1B + tot1 by 
	  care + alone + inadeq + total
  /statistics
    mean(care (f5.1) '')
    mean(alone (f5.1) '')
    mean(inadeq (f5.1) '')
    count(total (f5.0) '')
  /title
    "Table CD.3: Children left alone or with other children" 
    "Percentage of children age 0-59 months left in the care of other "+
		"children under the age of 10 years or left alone in the past week, "+
		"Country, Year"
  /caption
    "* MICS indicator 51".

new file.
