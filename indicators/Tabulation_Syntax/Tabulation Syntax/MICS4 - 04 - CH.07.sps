* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

compute total = 1.
variable labels  total "".
value labels total 1 "Number of children age 0-59 months".

* Suspected pneumonia in the last 2 weeks.
compute ari  = 0.
if (CA7 = 1 and CA8 = 1 and (CA9 =1 or CA9 = 3)) ari = 100.
variable labels  ari "Had suspected pneumonia in the last two weeks".

do if (ari = 100).
+ recode CA11A ("A" = 100) (else = 0) into gh.
+ recode CA11B ("B" = 100) (else = 0) into gc.
+ recode CA11C ("C" = 100) (else = 0) into gp.
+ recode CA11D ("D" = 100) (else = 0) into wh.
+ recode CA11E ("E" = 100) (else = 0) into mo.
+ recode CA11H ("H" = 100) (else = 0) into opu.
+ recode CA11I ("I" = 100) (else = 0) into ph.
+ recode CA11J ("J" = 100) (else = 0) into pf.
+ recode CA11K ("K" = 100) (else = 0) into pp.
+ recode CA11L ("L" = 100) (else = 0) into mc.
+ recode CA11O ("O" = 100) (else = 0) into opm.
+ recode CA11P ("P" = 100) (else = 0) into rf.
+ recode CA11Q ("Q" = 100) (else = 0) into sh.
+ recode CA11R ("R" = 100) (else = 0) into tr.
+ recode CA11X ("X" = 100) (else = 0) into ot.
+ compute any = 0.

* excludes Pharmacy.
+ if (gh = 100 or gc = 100 or gp = 100 or wh = 100 or mo = 100 or opu = 100 or 
       ph =100 or pf = 100 or mc = 100 or opm = 100) any = 100.

+ compute anti = 0.
+ if (CA13A = "A" or CA13B = "B") anti = 100.

+ compute atotal = 1.

end if.

variable labels  gh " Public sector: Government hospital".
variable labels  gc "Public sector: Government health center".
variable labels  gp "Public sector: Government health post".
variable labels  wh "Public sector: Village health worker".
variable labels  mo "Public sector: Mobile / Outreach clinic".
variable labels  opu "Other public".
variable labels  ph "Private hospital / clinic".
variable labels  pf "Private physician".
variable labels  pp "Private pharmacy".
variable labels  mc "Mobile clinic".
variable labels  opm "Other private medical".
variable labels  rf "Relative / Friend".
variable labels  sh "Shop".
variable labels  tr "Traditional practitioner".
variable labels  ot "Other".

variable labels  any "Any appropriate provider [1]".
variable labels  anti "Percentage of children with suspected pneumonia who received antibiotics in the last two weeks [2]".
variable labels  atotal "".
value labels atotal 1 "Number of children age 0-59 months with suspected pneumonia in the last two weeks".

compute layer = 0.
variable labels  layer "".
value labels layer 0 "Children with suspected pneumonia who were taken to:".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

* For labels in French uncomment commands bellow.

* value labels total 1 "Nombre d enfants âgés de 0-59 mois".

* variable labels  ari "A eu une pneumonie présumée au cours des deux dernières semaines".

* variable labels  gh "Sources publiques: Hôpital de l'Etat ".
* variable labels  gc "Sources publiques: Centre de santé du gouvernement".
* variable labels  gp "Sources publiques: Poste de santé du gouvernement".
* variable labels  wh "Sources publiques: Agent de santé villageois".
* variable labels  mo "Sources publiques: Clinique mobile/ locale ".
* variable labels  opu "Autre structure".
* variable labels  ph "Sources privées: Hôpital/ clinique".
* variable labels  pf "Sources privées: Médecin privé".
* variable labels  pp "Sources privées: Pharmacie privée".
* variable labels  mc "Sources privées: Clinique mobile".
* variable labels  opm "Autre structure médicale privéel".
* variable labels  rf "Parent ou ami".
* variable labels  sh "Boutique".
* variable labels  tr "Tradipraticien ".
* variable labels  ot "Autre source".

* variable labels  any "n'mporte quel soignant [1]".
* variable labels  anti "Pourcentage d'enfants ayant eu une pneumonie présumée et reçu des antibiotiques au cours des deux dernières semaines [2]".
* value labels atotal 1 "Nombre d'enfants âgés de 0-59 mois ayant eu une pneumonie présumée au cours des deux dernières semaines".

* value labels layer 0 "Enfants ayant eu une pneumonie présumée et emmenés à/dans/chez:".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = tot layer atotal total
         display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + cage_11 [c] + melevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
  	ari [s] [mean,'',f5.1] + total [c] [count,'',f5.0] + 
                  layer [c] > (gh [s] [mean,'',f5.1] + gc [s] [mean,'',f5.1] + gp [s] [mean,'',f5.1] + wh [s] [mean,'',f5.1] + mo[s] [mean,'',f5.1] + opu [s] [mean,'',f5.1] +
  		ph [s] [mean,'',f5.1] + pf [s] [mean,'',f5.1] + pp [s] [mean,'',f5.1] + mc [s] [mean,'',f5.1] + opm [s] [mean,'',f5.1] + 
                                    rf [s] [mean,'',f5.1] + sh [s] [mean,'',f5.1] + tr [s] [mean,'',f5.1] + ot [s] [mean,'',f5.1]) +
                   any [s] [mean,'',f5.1] + anti [s] [mean,'',f5.1] + atotal[c][count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table CH.7: Care seeking for suspected pneumonia and antibiotic use during suspected pneumonia"
 	 "Percentage of children age 0-59 months with suspected pneumonia in the last two weeks "+
                   "who were taken to a health provider and percentage of children who were given antibiotics, " + surveyname
  caption =
  	"[1] MICS indicator 3.9"
                  "[2] MICS indicator 3.10".

* Ctables command in French.
*
ctables
  /vlabels variables = tot layer atotal total
         display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + cage_11 [c] + melevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
  	ari [s] [mean,'',f5.1] + total [c] [count,'',f5.0] + 
                  layer [c] > (gh [s] [mean,'',f5.1] + gc [s] [mean,'',f5.1] + gp [s] [mean,'',f5.1] + wh [s] [mean,'',f5.1] + mo[s] [mean,'',f5.1] + opu [s] [mean,'',f5.1] +
  		ph [s] [mean,'',f5.1] + pf [s] [mean,'',f5.1] + pp [s] [mean,'',f5.1] + mc [s] [mean,'',f5.1] + opm [s] [mean,'',f5.1] + 
                                    rf [s] [mean,'',f5.1] + sh [s] [mean,'',f5.1] + tr [s] [mean,'',f5.1] + ot [s] [mean,'',f5.1]) +
                   any [s] [mean,'',f5.1] + anti [s] [mean,'',f5.1] + atotal[c][count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Tableau CH.7: Recours au traitement  d'une pneumonie présumée et usage d'antibiotiques au cours de la pneumonie présumée"
 	 "Pourcentage d'enfants âgés de 0-59 mois avec une pneumonie présumée au cours des deux dernières semaines, "+
                   "emmenés chez un soignant et  Pourcentage d'enfants ayant reçu des antibiotiques, " + surveyname
  caption =
  	"[1] Indicateur MICS 3.9"
                  "[2] Indicateur MICS 3.10".																					

new file.
