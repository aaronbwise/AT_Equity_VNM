get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

compute total = 1.
variable label total "Number of children aged 0-59 months".
value label total 1 "".

* ARI in the last 2 weeks.
compute ari  = 0.
if ((CA7 =1 or CA7 = 3) and CA5 = 1 and CA6 = 1) ari = 100.
variable label ari "Had acute respiratory infection".

do if (ari = 100).

+ recode CA9A ("A" = 100) (else = 0) into ho.
+ recode CA9B ("B" = 100) (else = 0) into hc.
+ recode CA9C ("C" = 100) (else = 0) into hp.
+ recode CA9D ("D" = 100) (else = 0) into vi.
+ recode CA9E ("E" = 100) (else = 0) into oc.
+ recode CA9H ("H" = 100) (else = 0) into pu.
+ recode CA9I ("I" = 100) (else = 0) into ph.
+ recode CA9J ("J" = 100) (else = 0) into pp.
+ recode CA9K ("K" = 100) (else = 0) into pr.
+ recode CA9L ("L" = 100) (else = 0) into mo.
+ recode CA9O ("O" = 100) (else = 0) into op.
+ recode CA9P ("P" = 100) (else = 0) into rf.
+ recode CA9Q ("Q" = 100) (else = 0) into sh.
+ recode CA9R ("R" = 100) (else = 0) into tr.
+ recode CA9X ("X" = 100) (else = 0) into ot.
+ compute any = 0.
* excludes Pharmacy.
+ if (ho = 100 or hc = 100 or hp = 100 or vi = 100 or oc = 100 or pu =100 or
    ph = 100 or pp = 100 or mo = 100 or op = 100) any = 100.
+ compute atotal = 1.
end if.

variable label ho "Govt. hospital".
variable label hc "Govt. health centre".
variable label hp "Govt. health post".
variable label vi "Village health worker".
variable label oc "Mobile/outreach clinic".
variable label pu "Other public".
variable label ph "Private hospital clinic".
variable label pp "Private physician".
variable label pr "Pharmacy".
variable label mo "Mobile clinic".
variable label op "Other private medical".
variable label rf "Relative or friend".
variable label sh "Shop".
variable label tr "Traditional practitioner".
variable label ot "Other".
variable label any "Any appropriate provider *".
variable label atotal "Number of children aged 0-59 months with suspected pneumonia".
value label atotal 1 "".


tables
  /format = zero
  /observation = ari ho hc hp vi oc pu ph pp pr mo op rf sh tr ot any
  /ftotal = tot1 "Total"
  /table = HL4 + HH7 + HH6 + cage_11 + melevel + wlthind5 + HC1B + tot1 by
    ari + total + ho + hc + hp + vi + oc + pu + ph + pp + pr + mo + 
		op + rf + sh + tr + ot + any + atotal
  /statistics
    mean(ari (f5.1) '')
    count(total (f5.0) '')
    mean(ho (f5.1) '')
    mean(hc (f5.1) '')
    mean(hp (f5.1) '')
    mean(vi (f5.1) '')
    mean(oc (f5.1) '')
    mean(pu (f5.1) '')
    mean(ph (f5.1) '')
    mean(pp (f5.1) '')
    mean(pr (f5.1) '')
    mean(mo (f5.1) '')
    mean(op (f5.1) '')
    mean(rf (f5.1) '')
    mean(sh (f5.1) '')
    mean(tr (f5.1) '')
    mean(ot (f5.1) '')
    mean(any (f5.1) '')
    count(atotal (f5.0) '')
  /title
    "Table CH.6: Care seeking for suspected pneumonia"
		"Percentage of children aged 0-59 months in the last two weeks taken to "+
		"a health provider, Country, Year"
  /caption
    "* MICS indicator 23".

new file.
