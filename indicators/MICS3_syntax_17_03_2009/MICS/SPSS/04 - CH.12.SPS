get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

compute total = 1.
variable label total "Number of children aged 0-59 months".

* fever in the last 2 weeks.
recode ML1 (1 = 100) (else = 0) into fever.
variable label fever "Had a fever in last two weeks".

do if (fever = 100).
+ compute layer1 = 1.
+ compute sp = 0.
+ if (ML4A = "A" or ML7A = "A") sp = 100.
+ compute ch = 0.
+ if (ML4B = "B" or ML7B = "B") ch = 100.
+ compute am = 0.
+ if (ML4C = "C" or ML7C = "C") am = 100.
+ compute qu = 0.
+ if (ML4D = "D" or ML7D = "D") qu = 100.
+ compute ar = 0.
+ if (ML4E = "E" or ML7E = "E") ar = 100.
+ compute oa = 0.
+ if (ML4H = "H" or ML7H = "H") oa = 100.
+ compute approp = 0.
+ if (sp = 100 or ch = 100 or am = 100 or qu = 100 or ar = 100 or oa = 100) approp = 100.
+ compute pa = 0.
+ if (ML4P = "P" or ML7P = "P") pa = 100.
+ compute as = 0.
+ if (ML4Q = "Q" or ML7Q = "Q") as = 100.
+ compute ib = 0.
+ if (ML4R = "R" or ML7R = "R") ib = 100.
+ compute ot = 0.
+ if (ML4X = "X" or ML7X = "X") ot = 100.
+ compute dk = 0.
+ if (ML4Z = "Z" or ML7Z = "Z") dk = 100.
+ compute okdrug = 0.
+ if (approp = 100 and ML9 >= 0 and ML9 <= 1) okdrug = 100.
+ compute ftotal = 1.
end if.

value label layer1 1 " ".
variable label layer1 "Children with a fever in the last two weeks who were treated with:"
variable label sp "Anti-malarials: SP/Fansidar".
variable label ch "Anti-malarials: Chloroquine".
variable label am "Anti-malarials: Armodiaquine".
variable label qu "Anti-malarials: Quinine".
variable label ar "Anti-malarials: Artemisnin based combinations".
variable label oa "Anti-malarials: Other Anti-malarial".
variable label approp "Any appropriate anti-malarial drug".
variable label pa "Other medications: Paracetamol/Panadol/Acetaminophan".
variable label as "Other medications: Aspirin".
variable label ib "Other medications: Ibuprofen".
variable label ot "Other medications : Other".
variable label dk "Don't know".
variable label okdrug "Any appropriate anti-malarial drug within 24 hours of onset of symptoms *".
value label ftotal 1 "".
variable label ftotal "Number of children with fever in last two weeks".

tables
  /format = zero
  /observation = fever sp ch am qu ar oa approp pa as ib ot dk okdrug 
  /ftotal = tot1 "Total"
  /table = HL4 + HH7 + HH6 + cage_11 + melevel + wlthind5 + HC1B + tot1 by
	  fever + total + layer1 > (sp + ch + am + qu + ar + oa + approp + 
		pa + as + ib + ot + dk + okdrug) + ftotal
  /statistics
    mean(fever (f5.1) '')
    count(total (f5.0) '')
    mean(sp (f5.1) '')
    mean(ch (f5.1) '')
    mean(am (f5.1) '')
    mean(qu (f5.1) '')
    mean(ar (f5.1) '')
    mean(oa (f5.1) '')
    mean(approp (f5.1) '')
    mean(pa (f5.1) '')
    mean(as (f5.1) '')
    mean(ib (f5.1) '')
    mean(ot (f5.1) '')
    mean(dk (f5.1) '')
    mean(okdrug (f5.1) '')
    count(ftotal (f5.0) '')
  /title
    "Table CH.12: Treatment of children with anti-malarial drugs"
		"Percentage of children 0-59 months of age who were ill with fever in "+
		"the last two weeks who received anti-malarial drugs, Country, Year"
  /caption
    "MICS indicator 39; MDG indicator 22".

new file.
