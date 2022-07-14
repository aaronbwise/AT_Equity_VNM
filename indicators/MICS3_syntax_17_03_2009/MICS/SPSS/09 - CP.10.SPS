get files="hl.sav".

weight by hhweight.

select if (HL5 >= 2 and HL5 <= 9).

recode HL5 (2 thru 4 = 1) (5 thru 6 = 2) (7 thru 9 = 3) into agegrp.
variable label agegrp "Age of child".
value label agegrp 
	1 "2-4" 
	2 "5-6"
	3 "7-9".

compute delay = 0.
if (DA3 = 1) delay = 100.
variable label delay "Delay in sitting standing or walking".

compute seeing = 0.
if (DA4 = 1) seeing = 100.
variable label seeing "Difficulty seeing, either in the daytime or at night".

compute hearing = 0.
if (DA5 = 1) hearing = 100.
variable label hearing "Appears to have difficulty hearing".

compute nounders = 0.
if (DA6 = 2) nounders = 100.
variable label nounders "No understanding of instructions".

compute dwalk = 0.
if (DA7 = 1) dwalk = 100.
variable label dwalk "Difficulty in walking moving, moving arms, weakness or "+
  "stiffness".

compute hfits = 0.
if (DA8 = 1) hfits = 100.
variable label hfits "Have fits, become rigid, lose conciousness".

compute nlearn = 0.
if (DA9 = 2) nlearn = 100.
variable label nlearn "Not learning to do things like other children his/her "+
  "age".

compute nospeak = 0.
if (DA10 = 2) nospeak = 100.
variable label nospeak "No speaking cannot be understood in words".

compute mentally = 0.
if (DA13 = 1) mentally = 100.
variable label mentally "Appears mentally backward, dull, or slow".

compute disabil = 0.
if (delay = 100 or seeing = 100 or hearing  = 100 or nounders = 100 or 
  dwalk = 100 or hfits = 100 or nlearn = 100 or nospeak = 100 or 
	mentally = 100) disabil = 100. 
variable label disabil "Percentage of children 2-9 years of age with at "+
  "least one reported disability*".

do if (HL5 >=3 and HL5 <= 9).
+ compute speech = 0.
+ if (DA11 = 1) speech = 100.
+ compute total39 = 1.
end if.
variable label speech "Speech is not normal".
variable label total39 "Number of children aged 3-9 years".
value label total39 1 "".

do if (HL5 = 2).
+ compute cname = 0.
+ if (DA12 = 2) cname = 100.
+ compute total2 = 1.
end if.
variable label cname "Cannot name at least one object".
variable label total2 "Number of children aged 2 years".
value label total2 1 "".

compute total = 1.
variable label total "Number of children aged 2-9 years".

compute layer = 0.
variable label layer "".
value label layer 0 "Percentage of children aged 2-9 years with reported disability by type of disability".

tables
  /format = zero
  /observation = delay seeing hearing nounders dwalk hfits nlearn nospeak 
	  mentally disabil speech cname 
  /ftotal = tot1 "Total"
  /table = HH7 + HH6 + agegrp + melevel + wlthind5 + HC1B + tot1 by 
	  layer > (delay + seeing + hearing + nounders + dwalk + hfits + nlearn + nospeak 
		+ mentally + disabil) + total + speech + total39 + cname + total2
  /statistics
    mean(delay (f5.1) '')
    mean(seeing (f5.1) '')
    mean(hearing (f5.1) '')
    mean(nounders (f5.1) '')
    mean(dwalk (f5.1) '')
    mean(hfits (f5.1) '')
    mean(nlearn (f5.1) '')
    mean(nospeak (f5.1) '')
    mean(mentally (f5.1) '')
    mean(disabil (f5.1) '')
    count(total (f5.0) '')
    mean(speech (f5.1) '')
    count(total39 (f5.0) '')
    mean(cname (f5.1) '')
    count(total2 (f5.0) '')
 /title
    "Table CP.10: Child disability"
		"Percentage of children 2-9 years of age with disability reported by "+
		"their mother or caretaker according to the type of disability, "+
		"Country, year"
  /caption                                                                                                                                                                          
    "* MICS Indicator 101".

new file.






















