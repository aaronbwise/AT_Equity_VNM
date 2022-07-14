* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

select if (CM13 = "Y" or CM13 = "O").

compute weighed = 0.
do if (MN22 < 9.996).
+ compute weighed = 1.
+ compute less2500 = 0.
+ if (MN22 < 2.500) less2500 = 1.
+ compute w2500 = 0.
+ if (MN22 = 2.500) w2500 = 1.
end if.

variable labels weighed "Percent of live births weighed at birth".
variable labels less2500 "Number of births weighing < 2500 grams".
variable labels w2500 "Number of births weighing exactly 2500 grams".

compute births = 1.
variable labels births "Total number of live births".

recode MN20 (8=9).
value labels MN20
 1 "Very large"
 2 "Larger than average"
 3 "Average"
 4 "Smaller than average"
 5 "Very small"
 9 "DK/Missing".

aggregate outfile = 'tmp.sav'
  /break MN20
  /tweighed = sum(weighed)
  /t2500 = sum(less2500)
  /we2500 = sum(w2500)
  /tbirths = sum(births).

get file = 'tmp.sav'.
variable labels tweighed "Number of weighed births".
variable labels t2500 "Number of births weighing < 2500 g".
variable labels we2500 "Number of births weighing exactly 2500 g".
variable labels tbirths "Total number of births".

compute tot2500 = t2500+(we2500*0.25).
variable labels tot2500 "Adjusted number of births < 2500 g".

if (tweighed > 0) prop2500 = tot2500/tweighed.
variable labels prop2500 "Proportion of births weighing < 2500 g".

compute est2500 = prop2500*tbirths.
variable labels est2500 "Estimated number < 2500 g".
if (sysmis(t2500)) t2500 = 0.
if (sysmis(prop2500)) prop2500 = 0.
if (sysmis(est2500)) est2500 = 0.
if (sysmis(we2500)) we2500 = 0.
if (sysmis(tot2500)) tot2500 = 0.

sort cases by MN20.

save outfile = 'tmp2.sav'.

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

select if (CM13 = "Y" or CM13 = "O").

recode MN20 (8=9).
value labels MN20
 1 "Very large"
 2 "Larger than average"
 3 "Average"
 4 "Smaller than average"
 5 "Very small"
 9 "DK/Missing".

sort cases by MN20.

match files
  /file = *
  /table = 'tmp2.sav'
  /by MN20.

compute lowb = prop2500 * 100.
variable labels lowb "Below 2500 grams [1]".

compute weighed = 0.
if ( MN22 < 9.996) weighed = 100.
variable labels weighed "Weighed at birth [2]".

compute births = 1.
value label births 1 "".
variable label births "Number of last-born children in the two years preceding the survey".
recode MN22 (9.996 thru 9.999 = sysmis).

compute layer = 1.
variable labels layer "".
value labels layer 1 "Percent of live births:".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* For labels in French uncomment commands bellow.

* variable labels lowb "avec poids inférieur à 2500 grammes [1]".
* variable labels weighed "pesés à la naissance [2]".
* variable labels births "Nombre d'enfants derniers-nés au cours des deux années précédant l'enquête".
* value labels layer 1 "Pourcentage des naissances d'enfants vivants:".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = layer 
	display = none
  /table hh7 [c] + hh6 [c] + welevel [c] + windex5 [c] + ethnicity [c] + total [c] by 
                 layer [c] > (lowb [s] [mean,'',f7.1] + weighed [s] [mean,'',f7.1] ) + births [s] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table NU.11: Low birth weight infants"
  "Percentage of last-born children in the 2 years preceding the survey " +
   "that are estimated to have weighed below 2500 grams at birth and " +
   "percentage of live births weighed at birth, " + surveyname
  caption =
     " [1] MICS indicator 2.18"
     " [2] MICS indicator 2.19".

* Ctables command in French.
*
ctables
  /vlabels variables = layer 
	display = none
  /table hh7 [c] + hh6 [c] + welevel [c] + windex5 [c] + ethnicity [c] + total [c] by 
                 layer [c] > (lowb [s] [mean,'',f7.1] + weighed [s] [mean,'',f7.1] ) + births [s] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Tableau NU.11: Bébés ayant une insuffisance pondérale à la naissance"
  "Pourcentage d'enfants derniers-nés au cours des 2 années précédant l'enquête " +
   "qu'on estime avoir pesé moins de 2500 grammes à la naissance et pourcentage " +
   "de naissances d'enfants vivants et pesés à la naissance, " + surveyname
  caption =
     " [1] Indicateur  MICS2.18 "
     " [2] Indicateur MICS 2.19".

new file.

*delete working files.
erase file = 'tmp.sav'.
erase file = 'tmp2.sav'.
