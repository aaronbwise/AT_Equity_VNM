* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open children data file.
get file = 'ch.sav'.

* Select interviewed children.
select if (UF9 = 1).

* Weight the data by the under-5 weight.
weight by chweight.

compute tot1 = 1.
variable labels tot1 "Total".
value labels tot1 1" ".

compute wp = 0.
variable labels wp " ".
compute nch = 0.
variable labels nch "Number of children".

* For labels in French uncomment commands bellow.
* variable labels nch "Nombre des enfants de moins de 5 ans".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variable = wp display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + cage_6 [c] + melevel [c] + windex5[c] + ethnicity[c] + tot1[c] by
           wp [s] [colpct.count,'Weighted percent' f5.1] + nch [s] [count, 'Weighted', f5.0, ucount, 'Unweighted', f5.0]
  /categories var=all empty=exclude missing = exclude
  /title title=
	"Table HH.5: Under-5's background characteristics"
	 "Percent and frequency distribution of children under five years of age by selected characteristics, " + surveyname.

* Ctables command in French.
*ctables
  /vlabels variable = wp display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + cage_6 [c] + melevel [c] + windex5[c] + ethnicity[c] + tot1[c] by
           wp [s] [colpct.count,'Weighted percent' f5.1] + nch [s] [count, 'Weighted', f5.0, ucount, 'Unweighted', f5.0]
  /categories var=all empty=exclude missing = exclude
  /title title=
	"Tableau HH.5: Caractéristiques des enfants de moins de 5 ans"
	 "Pourcentage et fréquence de répartition des enfants de moins de cinq ans selon les caractéristiques sélectionnées, " + surveyname.

new file.
