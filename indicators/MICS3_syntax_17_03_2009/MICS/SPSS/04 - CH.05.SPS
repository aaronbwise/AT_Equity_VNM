get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

compute total = 1.
value label total 1 "".
variable label total "Number of children aged 0-59 months".

* diarrhoea in last 2 weeks.
recode CA1 (1 = 100) (else = 0) into diarrhea.
variable label diarrhea "Had diarrhoea in last two weeks".

do if (CA1 = 1).
+ recode CA3 (3 = 100) (else = 0) into drnkmore.
+ recode CA3 (1,2 = 100) (else = 0) into drnkless.
+ recode CA4 (3,4,5 = 100) (else = 0) into ateokay.
+ recode CA4 (1,2 = 100) (else = 0) into atebadly.
+ compute homemgmt = 0.
+ if (drnkmore = 100 and ateokay = 100) homemgmt = 100.
+ compute orifcf = 0.
+ if ((CA2A = 1 or CA2B = 1 or CA2C = 1 or drnkmore = 100) and ateokay = 100) orifcf = 100.
+ compute dtotal = 1.
end if.

variable label drnkmore "Children with diarrhoea who drank more".
variable label drnkless "Children with diarrhoea who drank the same or less".
variable label ateokay "Children with diarrhoea who ate somewhat less, same or more".
variable label atebadly "Children with diarrhoea who ate much less or none".
variable label homemgmt "Home management of diarrhoea *".
variable label orifcf "Received ORT or increased fluids AND continued feeding **".
value label dtotal 1 "".
variable label dtotal "Number of children aged 0-59 months with diarrhoea".

tables
  /format = zero
  /observation diarrhea drnkmore drnkless ateokay atebadly homemgmt orifcf
  /ftotal tot1 "Total"
  /table = HL4 + HH7 + HH6 + cage_11 + melevel + wlthind5 + HC1B + tot1 by
     diarrhea + total + drnkmore + drnkless + ateokay + atebadly + homemgmt + 
		 orifcf + dtotal
  /statistics
    mean(diarrhea (f5.1) '')
    count(total (f5.0) '')
    mean(drnkmore (f5.1) '')
    mean(drnkless (f5.1) '')
    mean(ateokay (f5.1) '')
    mean(atebadly (f5.1) '')
    mean(homemgmt (f5.1) '')
    mean(orifcf (f5.1) '')
    count(dtotal (f5.0) '')
  /title
    "Table CH.5: Home management of diarrhoea"
		"Percentage of children aged 0-59 months with diarrhoea in the last two "+
		"weeks who took increased fluids and continued to feed during the "+
		"episode, Country, Year"
  /caption
    "* MICS indicator 34"
		"** MICS indicator 35".

new file.
