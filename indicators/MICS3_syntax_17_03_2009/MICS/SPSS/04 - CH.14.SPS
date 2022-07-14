get file = 'hh.sav'.

select if (HH9 = 1).

weight by hhweight.

compute treated  = 0.
if (TN3L1 = 1 or TN3L2 = 1) treated = 100.
if (TN7 = 1 and TN8 < 12) treated  =100.
if ((TN3P1 = 1 or TN3P2  = 1) and  TN6 < 12) treated = 100.
if ((TN3O1 = 1 or TN3O2 = 1 or TN3O3 = 1 or TN3O4 = 1) and 
  TN5 = 1 and  TN6 < 12) treated = 100.
variable label treated "Households with at least one ITN".

select if (treated = 100).

compute htotal = 1.
variable label htotal "Number of households with an least one".
value label htotal 1 "".

recode TN3A (11 through 16 = 1) (21 through 26 = 2) (else = 3) into tnsource.
variable label tnsource "Source of insecticide treated nets".
value label tnsource
	1 "Public*"
	2 "Private"
	3 "Other".

do if (tnsource = 1).
+ compute tnpufree = 0.
+ if (TN3B = 9996 | TN3B = 0000) tnpufree = 100.
+ if (TN3B > 0 & TN3B < 9996) tnpucost = TN3B.
else if (tnsource = 2).
+ compute tnprfree = 0.
+ if (TN3B = 9996 | TN3B = 0000) tnprfree = 100.
+ if (TN3B > 0 & TN3B < 9996) tnprcost = TN3B.
end if.
variable label tnpufree "Public".
variable label tnprfree "Private".
variable label tnpucost "Public**".
variable label tnprcost "Private**".

compute layer1 = 1.
value label layer1 1 " ".
variable label layer1 "Percentage Free".

compute layer2 = 1.
value label layer2 1 " ".
variable label layer2 "Median cost for those not free".

tables
  /format = zero
	/observation tnpufree tnprfree tnpucost tnprcost
  /ftotal = tot1 "Total"
  /table = HH7 + HH6 + helevel + wlthind5 + HC1B + tot1 by 
	  tnsource + tot1 + htotal + layer1 > (tnpufree + tnprfree) +  
		layer2 > (tnpucost + tnprcost) 
  /statistics
    cpct(tnsource (f5.1) '': HH7 HH6 helevel wlthind5 HC1B)
    count(htotal (f5.0) '')
		mean(tnpufree (f5.1) '')
		mean(tnprfree (f5.1) '')
		median(tnpucost (f5.1) '')
		median(tnprcost (f5.1) '')
  /title
	  "Table CH.14: Source of supplies for insecticide treated nets"
    		"Percent distribution of households by source of "+
		"insecticide treated nets for prevention of malaria, "
		"percentage of households obtaining insecticide treated nets for free, "+
		"and median cost of insecticide treated nets for those paying for nets by type of source of net, "+
		"Country, Year"
  /caption
    "* MICS indicator 96"
    "** MICS indicator 97".

new file.
