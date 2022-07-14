include "surveyname.sps".

* the following code assumes that primary school comprises 6 grades. 
* in countries where primary school has more or fewer grades, 
* variables zXYt in the code should be customized accordingly.

get file 'hl.sav'.

weight by hhweight.

compute total = 1.
variable label total " ".
value label total 1 "Total".

compute z10t = 0.
compute z12t = 0.
if (ED8A = 1 and ED8B = 1 and ED5 <> 1) z10t = 1.
if (ED8A = 1 and ED8B = 1 and ED6A = 1 and ED6B = 2) z12t = 1.
variable label z10t "Number in 1st grade last year who are not in school this year".
variable label z12t "Number in 1st grade last year who are in 2nd grade this year".

compute z20t = 0.
compute z23t = 0.
if (ED8A = 1 and ED8B = 2 and ED5 <> 1) z20t = 1.
if (ED8A = 1 and ED8B = 2 and ED6A = 1 and ED6B = 3) z23t = 1.
variable label z20t "Number in 2nd grade last year who are not in school this year".
variable label z23t "Number in 2nd grade last year who are in 3rd grade this year".

compute z30t = 0.
compute z34t = 0.
if (ED8A = 1 and ED8B = 3 and ED5 <> 1) z30t = 1.
if (ED8A = 1 and ED8B = 3 and ED6A = 1 and ED6B = 4) z34t = 1.
variable label z30t "Number in 3rd grade last year who are not in school this year".
variable label z34t "Number in 3rd grade last year who are in 4th grade this year".

compute z40t = 0.
compute z45t = 0.
if (ED8A = 1 and ED8B = 4 and ED5 <> 1) z40t = 1.
if (ED8A = 1 and ED8B = 4 and ED6A = 1 and ED6B = 5) z45t = 1.
variable label z40t "Number in 4th grade last year who are not in school this year".
variable label z45t "Number in 4th grade last year who are in 5th grade this year".

compute z50t = 0.
compute z56t = 0.
if (ED8A = 1 and ED8B = 5 and ED5 <> 1) z50t = 1.
if (ED8A = 1 and ED8B = 5 and ED6A = 1 and ED6B = 6) z56t = 1.
variable label z50t "Number in 5th grade last year who are not in school this year".
variable label z56t "Number in 5th grade last year who are in 6th grade this year".

aggregate outfile = 'tmp1.sav'
  /break = HL4
  /z10   = sum(z10t)
  /z12   = sum(z12t)
  /z20   = sum(z20t)
  /z23   = sum(z23t)
  /z30   = sum(z30t)
  /z34   = sum(z34t)
  /z40   = sum(z40t)
  /z45   = sum(z45t)
  /z50   = sum(z50t)
  /z56   = sum(z56t).

aggregate outfile = 'tmp2.sav'
  /break = HH7
  /z10   = sum(z10t)
  /z12   = sum(z12t)
  /z20   = sum(z20t)
  /z23   = sum(z23t)
  /z30   = sum(z30t)
  /z34   = sum(z34t)
  /z40   = sum(z40t)
  /z45   = sum(z45t)
  /z50   = sum(z50t)
  /z56   = sum(z56t).

aggregate outfile = 'tmp3.sav'
  /break = HH6
  /z10   = sum(z10t)
  /z12   = sum(z12t)
  /z20   = sum(z20t)
  /z23   = sum(z23t)
  /z30   = sum(z30t)
  /z34   = sum(z34t)
  /z40   = sum(z40t)
  /z45   = sum(z45t)
  /z50   = sum(z50t)
  /z56   = sum(z56t).

aggregate outfile = 'tmp4.sav'
  /break = melevel
  /z10   = sum(z10t)
  /z12   = sum(z12t)
  /z20   = sum(z20t)
  /z23   = sum(z23t)
  /z30   = sum(z30t)
  /z34   = sum(z34t)
  /z40   = sum(z40t)
  /z45   = sum(z45t)
  /z50   = sum(z50t)
  /z56   = sum(z56t).

aggregate outfile = 'tmp5.sav'
  /break = windex5
  /z10   = sum(z10t)
  /z12   = sum(z12t)
  /z20   = sum(z20t)
  /z23   = sum(z23t)
  /z30   = sum(z30t)
  /z34   = sum(z34t)
  /z40   = sum(z40t)
  /z45   = sum(z45t)
  /z50   = sum(z50t)
  /z56   = sum(z56t).

aggregate outfile = 'tmp6.sav'
  /break = ethnicity
  /z10   = sum(z10t)
  /z12   = sum(z12t)
  /z20   = sum(z20t)
  /z23   = sum(z23t)
  /z30   = sum(z30t)
  /z34   = sum(z34t)
  /z40   = sum(z40t)
  /z45   = sum(z45t)
  /z50   = sum(z50t)
  /z56   = sum(z56t).

aggregate outfile = 'tmp7.sav'
  /break = total
  /z10   = sum(z10t)
  /z12   = sum(z12t)
  /z20   = sum(z20t)
  /z23   = sum(z23t)
  /z30   = sum(z30t)
  /z34   = sum(z34t)
  /z40   = sum(z40t)
  /z45   = sum(z45t)
  /z50   = sum(z50t)
  /z56   = sum(z56t).

get file = 'tmp1.sav'.
add files
  /file = *
  /file = 'tmp2.sav'
  /file = 'tmp3.sav'
  /file = 'tmp4.sav'
  /file = 'tmp5.sav'
  /file = 'tmp6.sav'
  /file = 'tmp7.sav'.

if (z12+z10 > 0) y1 = (z12/(z12+z10))*100.
if (z23+z20 > 0) y2 = (z23/(z23+z20))*100.
if (z34+z30 > 0) y3 = (z34/(z34+z30))*100.
if (z45+z40 > 0) y4 = (z45/(z45+z40))*100.
if (z56+z50 > 0) y5 = (z56/(z56+z50))*100.

compute y6 = (y1*y2*y3*y4*y5)/100000000.

variable label y1 "Percent attending grade 1 last year who are in grade 2 this year".
variable label y2 "Percent attending grade 2 last year who are attending grade 3 this year".
variable label y3 "Percent attending grade 3 last year who are attending grade 4 this year".
variable label y4 "Percent attending grade 4 last year who are attending grade 5 this year".
variable label y5 "Percent attending grade 5 last year who are attending grade 6 this year".
variable label y6 "Percent who reach grade 6 of those who enter grade 1 [1]".

* For labels in French uncomment commands bellow.

* variable label y1 "Pourcentage de ceux ayant fait la classe 1 l'an dernier et qui sont en classe 2 cette année".
* variable label y2 "Pourcentage de ceux ayant fait la classe 2 l'an dernier et qui sont en classe 3 cette année".
* variable label y3 "Pourcentage de ceux ayant fait la classe 3 l'an dernier et qui font la classe 4 cette année".
* variable label y4 " Pourcentage de ceux ayant fait la classe 4 l'an dernier et qui sont en classe 5 cette année".
* variable label y5 " Pourcentage de ceux ayant fait la classe 5 l'an dernier et qui sont en classe 6 cette année".
* variable label y6 " Pourcentage de ceux qui atteignent la classe 6 sur ceux qui entrent en classe 1 [1]".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /table hl4 [c] + hh7[c] + hh6[c] + melevel [c] + windex5 [c] + ethnicity [c] + total [c] by 
              y1 [s] [mean,'',f5.1] +  y2 [s] [mean,'',f5.1] + y3 [s] [mean,'',f5.1] + y4 [s] [mean,'',f5.1] +  y5 [s] [mean,'',f5.1] + y6 [s] [mean,'',f5.1] 
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /title title=
  "Table ED.6: Children reaching last grade of primary school"
  	"Percentage of children entering first grade of primary school who eventually reach " +
                  "the last grade of primary school (Survival rate to last grade of primary school), " + surveyname
  caption ="[1] MICS indicator 7.6; MDG indicator 2.2".

* Ctables command in French.
*
ctables
  /table hl4 [c] + hh7[c] + hh6[c] + melevel [c] + windex5 [c] + ethnicity [c] + total [c] by 
              y1 [s] [mean,'',f5.1] +  y2 [s] [mean,'',f5.1] + y3 [s] [mean,'',f5.1] + y4 [s] [mean,'',f5.1] +  y5 [s] [mean,'',f5.1] + y6 [s] [mean,'',f5.1] 
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /title title=
  "Tableau ED.6: Enfants ayant fait la dernière classe d'école primaire"
  	"Pourcentage d'enfants entrant en première classe d'école primaire et qui finissent par atteindre " +
                  "la dernière classe d'école primaire (Taux de survie à la dernière classe d'école primaire), " + surveyname
  caption ="[1] Indicateur MICS 7.6; Indicateur OMD 2.2".

new file.

erase file = 'tmp1.sav'.
erase file = 'tmp2.sav'.
erase file = 'tmp3.sav'.
erase file = 'tmp4.sav'.
erase file = 'tmp5.sav'.
erase file = 'tmp6.sav'.

