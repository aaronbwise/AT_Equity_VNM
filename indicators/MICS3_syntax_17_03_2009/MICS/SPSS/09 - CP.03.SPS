get file = 'hl.sav'.

weight by hhweight.

select if (HL5 >= 5 and HL5 <= 14).

recode HL5 (5 thru 11 = 1) (12 thru 14 = 2) into agegrp.
variable label agegrp "Age".
value label agegrp
  1 "5-11 years"
  2 "12-14 years".

recode CL4 CL9 (98,99,sysmis = 0) .
compute hours1 = CL4 + CL9.
variable label hours1 "EA number of hours".

recode hours1 (14 thru 190 = 1) (else = 0) into hours14.
variable label hours14 "EA number of hours: 14 or more".

compute working = 0.
if (agegrp = 1 and (CL3 = 1 or CL3 = 2 or CL8 = 1 or (CL7 >= 28 and CL7 <= 95))) working
	= 100.
if (agegrp = 2 and ((CL7 >= 28 and CL7 <= 95) or (hours14 = 1))) working = 100.
variable label working "Percentage of children in child labour *".

do if (working = 100).
+ compute lbschool = 0.
+ if (ED4 = 1) lbschool  = 100.
+ compute lbtotal = 1.
end if.

variable label  lbschool "Percentage of child labourers who are also attending school **".
variable label lbtotal "Number of child labourers aged 5-14 ".
value label lbtotal 1 "".

compute school  = 0.
if (ED4 = 1) school  = 100.
variable label  school "Percentage of children attending school ***".

do if (school = 100).
+ compute schlabor  = 0.
+ if (working = 100) schlabor  = 100.
+ compute schtotal = 1.
end if.

variable label schlabor "Percentage of students who are also involved in child labour ****".
variable label schtotal "Number of students aged 5-14".
value label schtotal 1 "".

compute total = 1.
variable label total "Number of children aged 5-14".
value label total 1 "".

tables
  /format = zero
  /observation = working  school lbschool  schlabor 
  /ftotal = tot1 "Total"
  /table = HL4 + HH7 + HH6 + agegrp + melevel + wlthind5 + HC1B + tot1 by 
	  working + school +total+lbschool+lbtotal + schlabor + schtotal
  /statistics
    mean(working (f5.1) '')
    mean(school (f5.1) '')
    mean(lbschool (f5.1) '')
    count(lbtotal (f5.0) '')
    mean(schlabor (f5.1) '')
    count(schtotal (f5.0) '')
    count(total (f5.0) '')
  /title
    "Table CP.3: Labourer students and student labourers"
		"Percentage of children aged 5-14 years who are labourer students and "+
		"student labourers, Country, Year"
  /caption                                                                                                                                                                          
    "** MICS Indicator 72"
    "**** MICS Indicator 73".

new file.
