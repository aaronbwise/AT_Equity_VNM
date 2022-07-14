get file = 'hl.sav'.

weight by hhweight.

select if (HL5 >= 5 and HL5 <= 14).

recode HL5 (5 thru 11 = 1) (12 thru 14 = 2) into agegrp.
variable label agegrp "Age".
value label agegrp
  1 "5-11 years"
  2 "12-14 years".

recode ED4 (1 = 1) (else = 2) into part.
variable label part "School participation".
value label part 1 "Yes" 2 "No".

compute apaid = 0.
if (CL3 = 1) apaid = 100.
variable label apaid "Any paid  child work outside the household".

compute paid = 0.
if (CL3 = 1 and (agegrp = 1 or (agegrp = 2 and CL4 >= 14 and CL4 <= 95)))
  paid = 100.
variable label paid "Paid labour (to be eliminated) outside the household".

compute aunpaid = 0.
if (CL3 = 2) aunpaid = 100.
variable label aunpaid "Any unpaid child work outside the household".

compute unpaid = 0.
if (CL3 = 2 and (agegrp = 1 or (agegrp = 2 and CL4 >= 14 and CL4 <= 95)))
  unpaid = 100.
variable label unpaid "Unpaid labour (to be eliminated) outside the household".

compute achores = 0.
if (CL6 = 1) achores = 100.
variable label achores "Any Household chores".

compute more4 = 0.
if (CL6 = 1 and CL7 >= 28 and CL7 <= 95) more4 = 100.
variable label more4 "Household chores for 28+ hours/week".

compute afamily = 0.
if (CL8 = 1) afamily = 100.
variable label afamily "Any  child work for family business".

compute family = 0.
if (CL8 = 1 and (agegrp = 1 or (agegrp = 2 and CL9 >= 14 and CL9 <= 95)))
  family = 100.
variable label family "Any child labour (to be eliminated) for family business".

compute aworking = 0.
if (CL3 = 1 or CL3 = 2 or (CL6 = 1 and CL7 >= 28 and CL7 <= 95) or CL8 = 1) 
  aworking = 100.
variable label aworking "Any child work".

recode CL4 CL9 (98,99,sysmis = 0) .
compute hours1 = CL4 + CL9.
variable label hours1 "EA number of hours".

recode hours1 (14 thru 190 = 1) (else = 0) into hours14.
variable label hours14 "EA number of hours: 14 or more".

compute working = 0.
if (agegrp = 1 and (CL3 = 1 or CL3 = 2 or CL8 = 1 or (CL7 >= 28 and CL7 <= 95))) working
	= 100.
if (agegrp = 2 and ((CL7 >= 28 and CL7 <= 95) or (hours14 = 1))) working = 100.
variable label working "Total child labour *".

tables
  /format = zero
  /observation = apaid paid aunpaid unpaid achores more4 afamily family 
	  aworking working
  /ftotal = tot1 "Total" tot2 "Number of children 5-14 years of age"
  /tables = HL4 + HH7 + HH6 + agegrp + part + melevel + wlthind5 + HC1B + tot1 
	  by apaid + paid + aunpaid + unpaid + achores + more4 + afamily + family 
		+ aworking + working + tot2
  /statistics
    mean(apaid (f5.1) '')
    mean(paid (f5.1) '')
    mean(aunpaid (f5.1) '')
    mean(unpaid (f5.1) '')
    mean(achores (f5.1) '')
    mean(more4 (f5.1) '')
    mean(afamily (f5.1) '')
    mean(family (f5.1) '')
    mean(aworking (f5.1) '')
    mean(working (f5.1) '')
    count(tot2 (f5.0) '')
  /title
    "Table CP.2w: Child labour (working table)"
		"Percentage of children aged 5-14 years who are currently working and "+
		"the percentage who are involved in child labour activites (to be "+
		"eliminated), by type of work, Country, Year"
  /caption                                                                                                                                                                          
    "* MICS Indicator 71".

new file.
