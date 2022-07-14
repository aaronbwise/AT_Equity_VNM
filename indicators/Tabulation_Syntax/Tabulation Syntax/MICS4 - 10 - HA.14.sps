include "surveyname.sps".

get file = 'mm.sav'.

select if (MWM7 = 1).

weight by mmweight.

recode MMC1 (1 = 100) (else = 0) into circumcised.
variable labels circumcised "Percent circumcised [1]".

compute total = 1.
variable labels total "".
value labels total 1 "Number of men age 15-49 years".

do if (MMC1 = 1). 
+ compute agec = 8.
+ if (MMC2 < 1) agec = 1.
+ if (MMC2 >= 1 and MMC2 < 5) agec = 2.
+ if (MMC2 >= 5 and MMC2 < 12) agec = 3.
+ if (MMC2 >= 12 and MMC2 < 18) agec = 4.
+ if (MMC2 >= 18 and MMC2 < 97) agec = 5.
+ compute totalc = 1.
end if.

variable labels agec "Age at circumcision:".
value labels agec 1 "During infancy" 2 "1-4 years" 3 "5-11 years" 4 "12-17 years" 5 "18+ years" 8 "Don't know/Missing".
value labels totalc 1 "Number of men circumcised".

recode mage (1,2 = 1) (else = sysmis) into mage1.
recode mage (1,2 = copy) (else = sysmis) into mage2.
recode mage (3 = 3) (4,5 = 4) (6,7 = 5) (else = sysmis) into mage3.
variable labels mage1 "Age".
variable labels mage2 " ".
variable labels mage3 " ".
value labels mage1 1 "15-24".
value labels mage2 1 "  15-19" 2 "  20-24".
value labels mage3 3 "25-29" 4 "30-39" 5 "40-49".

compute tot = 1.
variable labels tot "".
value labels tot 1 "Total".

* For labels in French uncomment commands below.

* variable labels circumcised "Pourcentage circoncis".
* value labels total 1 "Nombre de hommes âgées de 15-49 ans".
* variable labels agec "Âge à la circoncision:".
* value labels agec 1 "Durant l'enfance" 2 "1-4 ans" 3 "5-11 ans" 4 "12-17 ans" 5 "18+ ans" 8 "Manquant/NSP".
* value labels totalc 1 "Nombre de hommes circoncis".
* variable labels mmstatus "Etat matrimonial".
* value labels mmstatus
  1 "Déjà été mariée/vécu avec une femme"
  2 "N'a jamais été mariée/vécu avec une femme".

* ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = total totalc tot display = none
  /table hh7 [c] + hh6 [c] + mage1 [c] + mage2 [c] + mage3 [c] + mmelevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   circumcised [s] [mean,'',f5.1] + total [c] [count,'',f5.0] + agec [c] [rowpct.validn,'',f5.1] +  
                   totalc[c][count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /categories var = agec total = yes position = after label = "Total"
  /slabels position = column visible = no
  /title title=
   "Table HA.14: Male Circumcision"
	  "Percentage of men age 15-49 years who report having been circumcised, and percent distribution of men by age of circumcision, " +
	  "by background characteristics, " + surveyname
  caption = 
   "[1] MICS indicator 9.21".

* ctables command in French.
* ctables
  /vlabels variables = total totalc tot display = none
  /table hh7 [c] + hh6 [c] + mage1 [c] + mage2 [c] + mage3 [c] + mmelevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   circumcised [s] [mean,'',f5.1] + total [c] [count,'',f5.0] + agec [c] [rowpct.validn,'',f5.1] +  
                   totalc[c][count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /categories var = agec total = yes position = after label = "Total"
  /slabels position = column visible = no
  /title title=
   "Tableau HA.14: Circoncision masculine"
	  "Répartition en pourcentage des hommes âgés de 15-49 ans qui déclarent avoir été circoncis, et pourcentage des hommes par âge à la circoncision " +
   "par les caractéristiques caractéristiques sociodémographiques, " + surveyname
  caption = 
   "[1] Indicateur MICS 9.21".

new file.
