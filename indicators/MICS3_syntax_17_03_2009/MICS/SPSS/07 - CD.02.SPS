get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

compute total = 1.
value labels total  1 "".
variable label total "Number of children aged 0-59 months".

* remove don't know and missing from future calculations (e.g., medians).
recode CE1 (98,99 = sysmis).
recode CE2 (98,99 = sysmis).

recode CE1 (3 thru 10 = 100) (else = 0) into  nbooks3.
variable label  nbooks3 "3 or more non-children's books *".

recode CE2 (3 thru 10 = 100) (else = 0) into  cbooks3.
variable label  cbooks3 "3 or more children's books **".

recode CE3A ("A" = 100)  (else = 0) into hobjects.
variable label hobjects "Household objects".

recode CE3B  ("B" = 100)  (else = 0) into outside.
variable label outside "Objects and materials found outside the home".

recode CE3C  ("C" = 100)  (else = 0) into homem.
variable label homem "Homemade toys".

recode CE3D ("D" = 100)  (else = 0) into store.
variable label store "Toys that came from a store".

recode CE3Y ("Y" = 100)  (else = 0) into noplay.
variable label noplay "No playthings mentioned".

count typeplay = hobjects outside homem store (100).
recode typeplay (3 thru hi = 100) (else = 0) into type3.
variable label type3 "3 or more types of playthings ***".

variable label CE1 "Median number of non-children's books".
variable label CE2 "Median number of children's books".

recode cage (0 thru 23 = 1) (else = 2) into age2.
variable label age2 "Age".
value label age2 1 "0-23 months" 2 "24-59 months".

compute layer3 = 0.
variable lable layer3 "".
value label layer3 0 "Child plays with:".

tables
  /format = zero  
  /observation nbooks3 ce1 cbooks3 ce2 hobjects outside homem store noplay 
	  type3
  /ftotal tot1 "Total"
  /table = HL4 + HH7 + HH6 + age2 + melevel + wlthind5 + HC1B + tot1 by 
	  nbooks3 + CE1 + 
              cbooks3 + CE2 + 
              layer3 > (hobjects + outside + homem + store + noplay) + type3 + total
  /statistics
    mean(nbooks3 (f5.1) '')
    median(CE1 (f5.0) '')
    mean(cbooks3 (f5.1) '')
    median(CE2 (f5.0) '')
    mean(hobjects (f5.1) '')
    mean(outside (f5.1) '')
    mean(homem (f5.1) '')
    mean(store (f5.1) '')
    mean(noplay (f5.1) '')
    mean(type3 (f5.1) '')
    count(total (f5.0) '')
  /title
   "Table CD.2: Learning materials" 
   "Percentage of children aged 0-59 months living in households containing learning materials, Country, Year"
  /caption
    "* MICS indicator 49"
		"** MICS indicator 48"
		"*** MICS indicator 50".

new file.
