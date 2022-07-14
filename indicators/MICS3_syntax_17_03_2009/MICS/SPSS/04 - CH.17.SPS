get file = 'ch.sav'.

weight by chweight.

select if (UF9  = 1 and CA2A = 1).

compute tdiar = 1.
value label tdiar  1 "".
variable label tdiar "Number of children with diarrhoea in prior 2 weeks "+
  "who received oral rehydration salts".

recode  CA4B (11 thru 16 = 1) (21 thru 26 = 2) (else  = 3) into ors.
variable label ors "Oral rehydration salts".
value label ors 1 "Public*" 2 "Private" 3"Others".

do if (ors = 1).
+ compute orpufree = 0.
+ if (CA4C = 9996 | CA4C = 0000) orpufree = 100.
+ if (CA4C > 0 & CA4C < 9996) orpucost = CA4C.
else if (ors = 2).
+ compute orprfree = 0.
+ if (CA4C = 9996 | CA4C = 0000) orprfree = 100.
+ if (CA4C > 0 & CA4C < 9996) orprcost = CA4C.
end if.
variable label orpufree "Public".
variable label orprfree "Private".
variable label orpucost "Public**".
variable label orprcost "Private**".

compute layer1 = 1.
value label layer1 1 " ".
variable label layer1 "Percentage Free".

compute layer2 = 1.
value label layer2 1 " ".
variable label layer2 "Median cost for those not free".

tables
  /format = zero
	/observation = orpufree orprfree orpucost orprcost
  /ftotal = tot1 "Total"
  /table = HL4 + HH7 + HH6 + melevel + wlthind5 + HC1B + tot1 by ors + tot1 +
	  tdiar + layer1 > (orpufree + orprfree) + layer2 > (orpucost + orprcost)
  /statistics
    cpct(ors (f5.1) '': HL4 HH7 HH6 melevel wlthind5 HC1B)
    count(tdiar (f5.0) '')
    mean(orpufree (f5.1) '')
    mean(orprfree (f5.1) '')
    median(orpucost (f5.1) '')
    median(orprcost (f5.1) '')
  /title
	  "Table CH.17: Source and cost of supplies for oral rehydration salts"
		"Percent distribution of children aged 0-59 months with diarrhoea during "+
		"the two weeks preceding the survey by source of oral rehydration salts "+
		"for treatment of diarrhoea, percentage of children aged 0-59 months "
		"with diarrhoea during the two weeks preceding the survey for whom oral "+
		"rehydration salts were obtained for free, and median cost of oral "+
		"rehydration salts for those paying for the oral rehydration salts, by "
		"type of source of oral rehydration salts, Country, Year"
  /caption
    "* MICS indicator 96"
    "** MICS indicator 97".

new file.
