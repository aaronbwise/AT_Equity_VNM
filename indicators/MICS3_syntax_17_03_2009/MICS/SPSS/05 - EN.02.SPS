get file = 'hh.sav'.
select if (HH9 = 1).
compute hhweight = hhweight*HH11.
weight by hhweight.

* create variable that will provide title in final table.
compute treat = 1.
value label treat 1  "Water treatment method used in the household".
variable label treat "".

compute none = 0.
if (WS5 <> 1) none = 100.
variable label none "None".

compute boil = 0.
if (WS6A = "A") boil = 100.
variable label boil "Boil".

compute bleach = 0.
if (WS6B = "B") bleach = 100.
variable label bleach "Add bleach/chlorine".

compute cloth = 0.
if (WS6C = "C") cloth = 100.
variable label cloth "Strain through a cloth".

compute wfilter = 0.
if (WS6D = "D") wfilter = 100.
variable label wfilter "Use water filter".

compute solar = 0.
if (WS6E = "E") solar = 100.
variable label solar "Solar disinfection".

compute stand = 0.
if (WS6F = "F") stand = 100.
variable label stand "Let it stand and settle".

compute other = 0.
if (WS6X = "X") other = 100.
variable label other "Other".

compute dk = 0.
if (WS6Z = "Z") dk = 100.
variable label dk "Don't know".

compute allh = 0.
if (boil = 100 or bleach = 100 or wfilter = 100 or solar = 100) allh = 100.
variable label allh "All drinking water sources: Appropriate water treatment method *".

compute total = 1.
value label total 1 "".
variable label total "Number of household members".

recode WS1 (11,12,13,21,31,41,51 = 1) (else = 2) into type.
do if (WS1 = 91).
recode WS2 (11,12,13,21,31,41,51 = 1) (else = 2) into type.
end if.
variable label type "".
value label type 1 "Improved sources" 2 "Unimproved sources".

do if (type  = 1).
+ compute improved = 0.
+ if (boil = 100 or bleach = 100 or wfilter = 100 or solar = 100) improved = 100.
+ compute itotal = 1.
end if.
variable label improved "Improved drinking water sources: Appropriate water treatment method".
value label itotal  1 "".
variable label itotal "Number of household members".

do if (type  = 2).
+ compute unimp = 0.
+ if (boil = 100 or bleach = 100 or wfilter = 100 or solar = 100) unimp = 100.
+ compute utotal = 1.
end if.
variable label unimp "Unimproved drinking water sources: Approprate water treatment method".
value label utotal  1 "".
variable label utotal "Number of household members".

tables
  /format = zero
  /observation = none boil bleach cloth wfilter solar stand other dk allh 
	  improved unimp
  /ftotal = tot1 "Total" 
  /table = HH7 + HH6 + helevel + wlthind5 + HC1B + tot1 by treat > 
	  (none + boil + bleach + cloth + wfilter + solar + stand + other + dk) + 
		allh + total + improved + itotal + unimp + utotal
  /statistics
    mean(none (f5.1) '')
    mean(boil (f5.1) '')
    mean(bleach (f5.1) '')
    mean(cloth (f5.1) '')
    mean(wfilter (f5.1) '')
    mean(solar (f5.1) '')
    mean(stand (f5.1) '')
    mean(other (f5.1) '')
    mean(dk (f5.1) '')
    mean(allh (f5.1) '')
    count(total (f5.0) '')
    mean(improved (f5.1) '')
    count(itotal (f5.0) '')
    mean(unimp (f5.1) '')
    count(utotal (f5.0) '')
  /title
    "Table EN.2: Household water treatment"
		"Percentage distribution of household population according to drinking water "+
		"treatment method used in the household and percentage of household "+
		"members that applied an appropriate water treatment method, Country, Year"
  /caption
    "* MICS indicator 13".

new file.
