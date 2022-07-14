include "surveyname.sps".

get file = "wm.sav".

select if (WM7 = 1).

weight by wmweight.

select if (MA1 = 1 or MA1 = 2 and (wage = 1 or wage = 2)).

compute age = rnd((wdoi-wdob)/12,1).

if (MA2 < 96) difage = MA2 - age.
variable label difage "Age difference with partner".

do if (wage = 1).
+ compute t1519 = 1.
+ recode difage (lo thru -1 = 1) (0 thru 4 = 2) (5 thru 9 = 3) (10 thru hi = 4) (sysmis = 9) into difage1.
end if.

variable label t1519 "".
value label t1519 1 "Number of women age 15-19 years currently married/in union".

variable label difage1 "Percentage of currently married/in union women age 15-19 years whose husband or partner is:".
value label difage1 
  1 "Younger"
  2 "0-4 years older"
  3 "5-9 years older"
  4 "10+ years older [1]"
  9 "Husband/partner's age unknown".

do if (wage = 2).
+ compute t2024 = 1.
+ recode difage (lo thru -1 = 1) (0 thru 4 = 2) (5 thru 9 = 3) (10 thru hi = 4) (sysmis = 9) into difage2.
end if.

variable label t2024 "".
value label t2024 1 "Number of women age 20-24 years currently married/in union".

variable label difage2 "Percentage of currently married/in union women age 20-24 years whose husband or partner is:".
value label difage2 
  1 "Younger"
  2 "0-4 years older"
  3 "5-9 years older"
  4 "10+ years older [2]"
  9 "Husband/partner's age unknown".

compute tot = 1.
variable label tot "Total".
value labels tot 1 " ".

* For labels in French uncomment commands bellow.

* variable label difage "Age difference with partner".
* value label t1519 1 " Nombre de femmes âgées de 15-19 ans actuellement mariées/vivant avec un homme".
* variable label difage1 "Pourcentage de femmes actuellement mariées/vivant avec un homme âgées de 15-19 ans dont le mari ou partenaire est:".
* value label difage1 
  1 "plus jeune"
  2 "de 0-4 ans plus jeune"
  3 "de 5-9 ans plus âgé"
  4 "de 10+ ans plus âgé [1]"
  9 "Age du mari/partenaire inconnu".
* value label t2024 1 "Nombre de femmes âgées de 20-24 ans actuellement mariées/ vivant avec un homme".
* variable label difage2 "Pourcentage de femmes actuellement mariées/vivant avec un homme âgées de 20-24 ans dont le mari ou le partenaire est:".
* value label difage2 
  1 "plus jeune"
  2 "de 0-4 ans plus jeune"
  3 "de 5-9 ans plus âgé"
  4 " de 10+ ans plus âgé  [2]"
  9 "Age du mari/partenaire inconnu".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = t1519 t2024
         display = none
  /table hh7 [c] + hh6 [c] + wage [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
  difage1 [c] [rowpct.validn,'',f5.1] + t1519 [c] [count,'',f5.0] +
  difage2 [c] [rowpct.validn,'',f5.1] + t2024 [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /categories var = difage1 difage2 total = yes position = after label = "Total"
  /slabels position=column visible = no
  /title title=
  "Table CP.7: Spousal age difference"
  	"Percent distribution of women currently married/in union age 15-19 and 20-24 years according to the age difference with their husband or partner, " + surveyname
  caption=
	"[1] MICS indicator 8.10a"															
                  "[2] MICS indicator 8.10b".	

* Ctables command in French.
*
ctables
  /vlabels variables = t1519 t2024
         display = none
  /table hh7 [c] + hh6 [c] + wage [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
  difage1 [c] [rowpct.validn,'',f5.1] + t1519 [c] [count,'',f5.0] +
  difage2 [c] [rowpct.validn,'',f5.1] + t2024 [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /categories var = difage1 difage2 total = yes position = after label = "Total"
  /slabels position=column visible = no
  /title title=
  "Tableau CP.7: Différence d'âge entre conjoints"
  	"Répartition en pourcentage des femmes actuellement mariées /vivant avec un homme " +
	"âgées de 15-19 ans et de 20-24 ans selon la différence d'âge avec leurs maris ou partenaires, " + surveyname
  caption=
	"[1]  Indicateur MICS 8.10a"															
                  "[2]  Indicateur MICS 8.10b".										

new file.
