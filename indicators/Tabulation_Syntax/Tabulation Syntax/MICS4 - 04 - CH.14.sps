include "surveyname.sps".

get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

compute total = 1.
variable labels  total "".
value labels total 1 "Number of children age 0-59 months".

* fever in the last 2 weeks.
recode ML1 (1 = 100) (else = 0) into fever.
variable labels  fever "Had a fever in last two weeks".

do if (fever = 100).

+ compute layer1 = 1.

+ compute sp = 0.
+ if (ML6A = "A" or ML9A = "A") sp = 100.
+ compute ch = 0.
+ if (ML6B = "B" or ML9B = "B") ch = 100.
+ compute am = 0.
+ if (ML6C = "C" or ML9C = "C") am = 100.
+ compute qu = 0.
+ if (ML6D = "D" or ML9D = "D") qu = 100.
+ compute ar = 0.
+ if (ML6E = "E" or ML9E = "E") ar = 100.
+ compute oa = 0.
+ if (ML6H = "H" or ML9H = "H") oa = 100.

+ compute approp = 0.
+ if (sp = 100 or ch = 100 or am = 100 or qu = 100 or ar = 100 or oa = 100) approp = 100.

+ compute ps = 0.
+ if (ML6I = "I" or ML9P = "I") ps = 100.
+ compute ai = 0.
+ if (ML6J = "J" or ML9J = "J") ai = 100.

+ compute pa = 0.
+ if (ML6P = "P" or ML9P = "P") pa = 100.
+ compute as = 0.
+ if (ML6Q = "Q" or ML9Q = "Q") as = 100.
+ compute ib = 0.
+ if (ML6R = "R" or ML9R = "R") ib = 100.
+ compute ot = 0.
+ if (ML6X = "X" or ML9X = "X") ot = 100.
+ compute dk = 0.
+ if (ML6Z = "Z" or ML9Z = "Z") dk = 100.

+ compute okdrug = 0.
+ if (approp = 100 and ML11 >= 0 and ML11 <= 1) okdrug = 100.

+ compute ftotal = 1.

end if.

value labels layer1 1 "Children with a fever in the last two weeks who were treated with:".
variable labels  layer1 "".
variable labels  sp "Anti-malarials: SP / Fansidar".
variable labels  ch "Anti-malarials: Chloroquine".
variable labels  am "Anti-malarials: Armodiaquine".
variable labels  qu "Anti-malarials: Quinine".
variable labels  ar "Anti-malarials: Artemisinin based combinations".
variable labels  oa "Anti-malarials: Other Anti-malarial".
variable labels  approp "Anti-malarials: Any anti-malarial drug [1]".
variable labels  ps "Other medications: Antibiotic pill or syrup".
variable labels  ai "Other medications: Antibiotic injection".
variable labels  pa "Other medications: Paracetamol/Panadol/Acetaminophan".
variable labels  as "Other medications: Aspirin".
variable labels  ib "Other medications: Ibuprofen".
variable labels  ot "Other medications: Other".
variable labels  dk "Don't know".
variable labels  okdrug "Percentage who took an anti-malarial drug same or next day [2]".
value labels ftotal 1 "Number of children with fever in last two weeks".
variable labels  ftotal "".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

* For labels in French uncomment commands bellow.

* value labels total 1 " Nombre  des enfants âgés de 0-59 mois".
* variable labels  fever " Ont eu de la fièvre au cours des deux dernières semaines".
* value labels layer1 1 "Children with a fever in the last two weeks who were treated with:".
* variable labels  layer1 "".
* variable labels  sp " Antipaludéens: SP / Fansidar".
* variable labels  ch " Antipaludéens: Chloroquine".
* variable labels  am " Antipaludéens: Armodiaquine".
* variable labels  qu " Antipaludéens: Quinine".
* variable labels  ar " Antipaludéens: Combinaison avec Artémisinine".
* variable labels  oa " Antipaludéens: Autre anti-palu".
* variable labels  approp " Antipaludéens: N importe quel anti-palu [1]".
* variable labels  ps " Autres médicaments: Comprimés ou sirop antibiotique".
* variable labels  ai " Autres médicaments: Injection d'antibiotique".
* variable labels  pa " Autres médicaments: Paracétamol/ Panadol/ Acétaminophène".
* variable labels  as " Autres médicaments: Aspirine".
* variable labels  ib " Autres médicaments: Ibuprofen ".
* variable labels  ot " Autres médicaments: Autre".
* variable labels  dk " Manquant/NSP".
* variable labels  okdrug " Pourcentage de ceux ayant pris un antipaludéen le même jour ou le jour suivant [2]".
* value labels ftotal 1 " Nombre d'enfants ayant eu la fièvre au cours des 2 dernières semaines".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables =  total tot ftotal layer1
         display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + cage_11 [c] + melevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                fever [s] [mean,'',f5.1] + total [c] [count,'',f5.0] +
                layer1[c] > (sp[s][mean,'',f5.1]+ ch[s][mean,'',f5.1] + am[s][mean,'',f5.1]+ qu[s][mean,'',f5.1] + ar[s][mean,'',f5.1] +
                oa[s][mean,'',f5.1]+approp[s][mean,'',f5.1]+ ps[s][mean,'',f5.1]+ai[s][mean,'',f5.1]+pa[s][mean,'',f5.1]+as[s][mean,'',f5.1]+ ib[s][mean,'',f5.1]+ot[s][mean,'',f5.1]+
                dk[s][mean,'',f5.1]+okdrug[s][mean,'',f5.1])+
                ftotal[c][count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table CH.14: Anti-malarial treatment of children with anti-malarial drugs"
  	"Percentage of children age 0-59 months who had fever in the last two weeks who received anti-malarial drugs, " + surveyname
  caption=
    "[1] MICS indicator 3.18; MDG indicator 6.8"
    "[2] MICS indicator 3.17".

* Ctables command in French.
*
ctables
  /vlabels variables =  total tot ftotal layer1
         display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + cage_11 [c] + melevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                fever [s] [mean,'',f5.1] + total [c] [count,'',f5.0] +
                layer1[c] > (sp[s][mean,'',f5.1]+ ch[s][mean,'',f5.1] + am[s][mean,'',f5.1]+ qu[s][mean,'',f5.1] + ar[s][mean,'',f5.1] +
                oa[s][mean,'',f5.1]+approp[s][mean,'',f5.1]+ ps[s][mean,'',f5.1]+ ai[s][mean,'',f5.1]+ pa[s][mean,'',f5.1]+as[s][mean,'',f5.1]+ ib[s][mean,'',f5.1]+ot[s][mean,'',f5.1]+
                dk[s][mean,'',f5.1]+okdrug[s][mean,'',f5.1])+
                ftotal[c][count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Tableau CH.14: Traitement antipaludique des enfants avec des antipaludéens"
  	"Pourcentage d'enfants âgés de 0-59 mois ayant eu de la fièvre au cours des deux dernières semaines et reçu des antipaludéens, " + surveyname
  caption=
    "[1] Indicateur MICS 3.18; Indicateur OMD 6.8"
    "[2] Indicateur MICS 3.17	".
																													
new file.
