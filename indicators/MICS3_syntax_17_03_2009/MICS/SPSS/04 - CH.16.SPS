get file = 'ch.sav'.

weight by chweight.

select if (UF9  = 1 and CA11A = "A") .

compute tari = 1.
value label tari  1 "".
variable label tari "Number children with suspected pneumonia in prior 2 "+
  "weeks who received antibiotics". 

recode  CA11B (11 thru 16 = 1) (21 thru 26 = 2) (else  = 3) into anti.
variable label anti "Antibiotic".
value label anti 1 "Public*" 2 "Private" 3 "Others".

do if (anti = 1).
+ compute anpufree = 0.
+ if (CA11C = 9996 | CA11C = 0000) anpufree = 100.
+ if (CA11C > 0 & CA11C < 9996) anpucost = CA11C.
else if (anti = 2).
+ compute anprfree = 0.
+ if (CA11C = 9996 | CA11C = 0000) anprfree = 100.
+ if (CA11C > 0 & CA11C < 9996) anprcost = CA11C.
end if.
variable label anpufree "Public".
variable label anprfree "Private".
variable label anpucost "Public**".
variable label anprcost "Private**".

compute layer1 = 1.
value label layer1 1 " ".
variable label layer1 "Percentage Free".

compute layer2 = 1.
value label layer2 1 " ".
variable label layer2 "Median cost for those not free".

tables
  /format = zero
	/observation = anpufree anprfree anpucost anprcost
  /ftotal = tot1 "Total"
  /table = HL4 + HH7 + HH6 + melevel + wlthind5 + HC1B + tot1 by anti + tot1 +
	  tari + layer1 > (anpufree + anprfree) + layer2 > (anpucost + anprcost)
  /statistics
    cpct(anti (f5.1) '': HL4 HH7 HH6 melevel wlthind5 HC1B)
    count(tari (f5.0) '')
    mean(anpufree (f5.1) '')
    mean(anprfree (f5.1) '')
    median(anpucost (f5.1) '')
    median(anprcost (f5.1) '')
  /title
	  "Table CH.16: Source and cost of supplies for antibiotics"
		"Percent distribution of children aged 0-59 months with suspected "+
		"pneumonia during the two weeks preceding the survey by source of "+
		"antibotics for treatment of pneumonia, percentage of children aged 0-59 "
		"with suspected pneumonia during the two weeks preceding the survey for "+
		"whom antibiotics were obtained for free, and median cost of antibiotics "+
		"for those paying for the antibiotics, by type of source of antibiotics, "+
		"Country, Year"
  /caption
    "* MICS indicator 96"
    "** MICS indicator 97".

new file.
