get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

compute gotam = 0.
if (not(sysmis(ML9))) gotam = 1.
variable label gotam "Children who received an anti-malarial".

select if (gotam = 1).

compute ctotal = 1.
value label ctotal 1 "".
variable label ctotal "Number of children with fever in prior 2 weeks who "+
  "were treated with antimalarials".

recode ML9A (11 through 16 = 1) (21 through 26 = 2) (else = 3) into amsource.
variable label amsource "Source of antimalarials".
value label amsource
	1 "Public*"
	2 "Private"
	3 "Other".

do if (amsource = 1).
+ compute ampufree = 0.
+ if (ML9B = 9996 | ML9B = 0000) ampufree = 100.
+ if (ML9B > 0 & ML9B < 9996) ampucost = ML9B.
else if (amsource = 2).
+ compute amprfree = 0.
+ if (ML9B = 9996 | ML9B = 0000) amprfree = 100.
+ if (ML9B > 0 & ML9B < 9996) amprcost = ML9B.
end if.
variable label ampufree "Public".
variable label amprfree "Private".
variable label ampucost "Public**".
variable label amprcost "Private**".

compute layer1 = 1.
value label layer1 1 " ".
variable label layer1 "Percentage Free".

compute layer2 = 1.
value label layer2 1 " ".
variable label layer2 "Median cost for those not free".

tables
  /format = zero
	/observation = ampufree amprfree ampucost amprcost
  /ftotal = tot1 "Total"
  /table = HL4 + HH7 + HH6 + melevel + wlthind5 + HC1B + tot1 by 
		amsource + tot1 + ctotal + layer1 > (ampufree + amprfree) + 
		layer2 > (ampucost + amprcost)  
  /statistics
    cpct(amsource (f5.1) '': HL4 HH7 HH6 melevel wlthind5 HC1B)
    count(ctotal (f5.0) '')
    mean(ampufree (f5.1) '')
    mean(amprfree (f5.1) '')
    median(ampucost (f5.1) '')
    median(amprcost (f5.1) '')
  /title
	  "Table CH.15: Source and cost of supplies for antimalarials"
    "Percent distribution of children aged 0-59 months with fever who took antimalarials in "+
		"the two weeks preceding the survey by source of antimalarials, "+
		"percentage of children for whom antimalarials were obtained for free, "
		"and median cost of antimalarials for those paying for antimalarials, "+
		"Country, Year"
  /caption
    "* MICS indicator 96"
    "** MICS indicator 97".

new file.
