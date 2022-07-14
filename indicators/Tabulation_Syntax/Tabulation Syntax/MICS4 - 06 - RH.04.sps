include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

select if  (mstatus = 1).

compute method = 0.
if (CP3A = "?") method = 99.
if (CP3X = "X") method = 14.
if (CP3M = "M") method = 13.
if (CP3L = "L") method = 12.
if (CP3K = "K") method = 11.
if (CP3I = "I" or CP3J = "J") method = 9.
if (CP3H = "H") method = 8.
if (CP3G = "G") method = 7.
if (CP3F = "F") method = 6.
if (CP3E = "E") method = 5.
if (CP3D = "D") method = 4.
if (CP3C = "C") method = 3.
if (CP3B = "B") method = 2.
if (CP3A = "A") method = 1.
variable label method "Percent of women (currently married or in union) who are using:".
value label method 0 "Not using any method"
                   1 "Female sterilization"
                   2 "Male sterilization"
                   3 "IUD"
                   4 "Injectables"
                   5 "Implants"
                   6 "Pill"
                   7 "Male condom"
                   8 "Female condom"
                   9 "Diaphragm/foam/jelly"
                   11 "Lactational amenorrhoea method (LAM)"
                   12 "Periodic abstinence/Rhythm"
                   13 "Withdrawal"
                   14 "Other"
				   99 "Missing".

compute anymod = 0.
if (method >= 1 and method <= 9) anymod = 100.
variable label anymod "Any modern method".

compute anytrad = 0.
if (method >= 11 and method <= 99) anytrad = 100.
variable label anytrad "Any traditional method".

compute any = 0.
if (anymod = 100 or anytrad = 100) any = 100.
variable label any "Any method [1]".

compute living = 0.
if (CM1 = 1 and CM8 <> 1) living = CM10.
if (CM1 = 1 and CM8 = 1) living = CM10 - (CM9A + CM9B).
recode living (0 thru 3 = copy) (4 thru hi = 4).
variable label living "Number of living children".
value label living 4 "4+".
format living (f5.0).

compute total = 1.
variable label total "Number of women currently married or in union".
value label total 1 "".

compute tot1 = 1.
variable label tot1 "Total".
value label tot1 1" ".

* For labels in French uncomment commands bellow.

* variable label method " Pourcentage de femmes (actuellement mariées ou vivant avec un homme) utilisant:".
* value label method 0 "N'utilise pas de méthode"
                   1 " Stérilisation féminine"
                   2 " Stérilisation masculine"
                   3 " DIU"
                   4 " Solutions injectables"
                   5 " Implants"
                   6 " Pilule"
                   7 " Préservatif pour hommes"
                   8 " Préservatif pour femmes"
                   9 " Diaphragme/Mousse/ Gelée"
                   11 " MAMA"
                   12 " Abstinence périodique"
                   13 " Retrait"
                   14 " Autre".

* variable label anymod " N'importe quelle méthode moderne".
* variable label anytrad " N'importe quelle méthode tradition-nelle".
* variable label any " N'importe quelle method [1]".
* variable label living " Nombre d'enfants vivants".
* variable label total " Nombre de femmes actuellement mariées ou vivant avec un homme".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /table hh7 [c] + hh6 [c] + wage[c]+ living [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
  	method [c] [rowpct.validn,'',f5.1] +
	anymod [s] [mean,'',f5.1] +
	anytrad [s] [mean,'',f5.1] + 
	any [s] [mean,'',f5.1] + 
	total [s] [sum,'',f5.0]
  /slabels position=column visible = no
  /title title=
	"Table RH.4: Use of contraception"
 	"Percentage of women age 15-49 years currently married or in union who are using (or whose partner is using) a contraceptive method, " + surveyname
  caption=
     "[1] MICS indicator 5.3; MDG indicator 5.3".

* Ctables command in French.
*
ctables
  /table hh7 [c] + hh6 [c] + wage[c]+ living [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
  	method [c] [rowpct.validn,'',f5.1] +
	anymod [s] [mean,'',f5.1] +
	anytrad [s] [mean,'',f5.1] + 
	any [s] [mean,'',f5.1] + 
	total [s] [sum,'',f5.0]
  /slabels position=column visible = no
  /title title=
	"Tableau RH.4: Utilisation de contraception"
 	"Pourcentage de femmes âgées de 15-49 ans actuellement mariées ou vivant avec un homme qui utilisent actuellement  (ou dont le partenaire utilise ) "
	"une méthode contraceptive, " + surveyname
  caption=
     "[1] Indicateur MICS 5.3; Indicateur OMD 5.3".															

new file.
