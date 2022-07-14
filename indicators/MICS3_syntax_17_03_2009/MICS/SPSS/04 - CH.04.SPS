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
+ recode CA2A (1 = 100) (else = 0) into orspack.
+ recode CA2B (1 = 100) (else = 0) into recom.
+ recode CA2C (1 = 100) (else = 0) into prepack.
+ compute notreat = 0.
+ if (orspack = 0 and recom = 0 and prepack = 0) notreat = 100.
+ compute ortuse = 0.
+ if (orspack = 100 or recom = 100 or prepack = 100) ortuse = 100.
+ compute dtotal = 1.
end if.

variable label orspack "Fluid from ORS packet".
variable label recom "Recommended homemade fluid".
variable label prepack "Pre-packaged ORS fluid".
variable label notreat "No treatment".
variable label ortuse "ORT use rate *".
value label dtotal 1 "".
variable label dtotal "Number of children aged 0-59 months with diarrhoea".

tables
  /format = zero
  /observation diarrhea orspack recom prepack notreat ortuse 
  /ftotal tot1 "Total"
  /table = HL4 + HH7 + HH6 + cage_6 + melevel + wlthind5 + HC1B + tot1 by
    diarrhea + total + orspack + recom + prepack + notreat + ortuse + dtotal
  /statistics
    mean(diarrhea (f5.1) '')
    count(total (f5.0) '')
    mean(orspack (f5.1) '')
    mean(recom (f5.1) '')
    mean(prepack (f5.1) '')
    mean(notreat (f5.1) '')
    mean(ortuse (f5.1) '')
    count(dtotal (f5.0) '')
  /title
    "Table CH.4: Oral rehydration treatment"
		"Percentage of children aged 0-59 months with diarrhoea in the last two weeks "+
		"and treatment with oral rehydration solution (ORS) or other oral rehydration treatment (ORT), Country, Year"
  /caption
    "* MICS Indicator 33".

new file.
