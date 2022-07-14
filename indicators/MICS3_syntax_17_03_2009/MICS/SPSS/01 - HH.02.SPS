get file = 'hl.sav'.

weight by hhweight.

recode HL5 (0 thru 4 = 1) (5 thru  9 = 2) (10 thru  14 = 3) (15 thru  19 = 4) 
  (20 thru 24 = 5) (25  thru 29 = 6) (30 thru  34 = 7) (35 thru 39 = 8) 
  (40 thru 44 = 9) (45 thru 49 = 10) (50 thru 54 = 11) (55 thru  59 = 12) 
  (60 thru 64 = 13) (65 thru  69 = 14)  (70 thru 97 = 15) (98,99 = 99) 
  into memage.
variable label memage "Age".
value label memage
	1 	"0-4"
	2 	"5-9"
 	3 	"10-14"
 	4 	"15-19"
 	5 	"20-24"
 	6 	"25-29"
 	7 	"30-34"
 	8 	"35-39"
 	9 	"40-44"
 	10 	"45-49"
 	11 	"50-54"
 	12 	"55-59"
 	13 	"60-64"
 	14 	"65-69"
 	15  "70+"
  99  "Missing/DK".

recode HL5 (0 thru 14 = 1) (15 thru 64 =2 ) (65 thru  97 = 3) (98,99 = 99) 
  into depend.
variable label depend "Dependency age groups".
value label depend
  1  "<15"
  2  "15-64"
  3  "65+"
  99 "Missing/DK".

recode hl5 (0 thru 17 = 1) (else = 2) into  age017.
variable label age017 "Age". 
value label age017 1 "Children aged 0-17" 2 "Adults 18+/Missing/DK".

tables
  /format = zero
  /ftotal = tot1 "Total"
  /table = memage + depend + age017 + tot1 by hl4 + tot1
  /statistics
    count(hl4 (f5.0) 'Number')
    cpct(hl4 (f5.1) 'Percent': hl4)
  /title
    "Table HH.2: Household age distribution by sex" 
		"Percent distribution of the household population by five-year age "+
		"groups and dependency age groups, and number of children aged 0-17 "+
		"years, by sex, Country, Year".

new file.
