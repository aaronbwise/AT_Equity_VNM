get file = "ch.sav" 
 /keep HH1 HH2 LN UF9 BR6 cage chweight.

select if (UF9 = 1).

select if (cage >= 36 and cage <= 59).

recode BR6 (1 = 100) (else = 0) into ecep.
variable label ecep "".

sort  cases by HH1 HH2 LN. 

*save the sorted cases in a working file.
save outfile = 'tmp.sav'
 /keep HH1 HH2 LN ecep cage chweight
 /rename (LN = HL1) .

get file = 'hl.sav'.

sort cases by HH1 HH2 HL1. 

*merge children  data onto the household listing data file.
match files
  /file = *
  /table = 'tmp.sav'
  /by HH1 HH2 HL1.

weight by hhweight.

* modify selection to include only one specific age on HL5 that matches the age at which children start primary school
* in addition to the age range of 36-59 months for the early childhood education columns.
select if ((cage >= 36 and cage <= 59) or HL5 = 6).

do if (ED6A = 1 and ED6B = 1).
+ compute first = 0.
+ if (ED8A = 0) first =  100.
+ variable label first "".
end if.

if (cage >= 36 and cage <= 47) agerange = 1.
if (cage >= 48 and cage <= 59) agerange = 2.
if (hl5 = 5) agerange = 3.
if (hl5 = 6) agerange = 4.
if (hl5 = 7) agerange = 5.
variable label agerange "Age of child".
value label agerange
  1 "36-47 months"
  2 "48-59 months"
  3 "5 years" 
  4 "6 years"
  5 "7 years".

if (cage >= 36 and cage <= 59) hhweight = chweight.

tables
  /format = zero
  /observation = ecep first
  /ftotal = tot1 "Total" 
  /tables = HL4 + HH7 + HH6 + agerange + melevel + wlthind5 + HC1B + tot1 
	  by ecep + first
  /statistics
    mean(ecep (f5.1) 'Percentage of children  aged 36-59 months currently '+
		  'attending early childhood education*')
    validn(ecep (f5.0) 'Number of children aged 36-59 months')
    mean(first (f5.1) ' Percentage of children attending first grade who '+
		  'attended preschool program in previous year**')
    validn(first (f5.0) 'Number of children attending first grade')
  /title
    "Table ED.1: Early childhood education"
		"Percentage of children aged 36-59 months who are attending some form of "+
		"organized early childhood education programme and percentage of first "+
		"graders who attended pre-school, Country, Year"
  /caption
    "* MICS Indicator 52"
		"** MICS Indicator 53".

new file.

*delete working files.
erase file = 'tmp.sav'.
