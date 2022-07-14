* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

select if (CM13 = "Y" or CM13 = "O").

compute total = 1.
value labels total 1 "".
variable labels total "Number of women with a live birth in the last 2 years".

* Received at least two tetanus toxoid injections during the most recent pregnancy (MN7>=2).
compute twocr = 0.
if (MN7 >= 2 and MN7 <= 7) twocr = 100.
variable labels twocr "Percentage of women who received at least 2 doses during last pregnancy".

* Received one tetanus toxoid injection during the last pregnancy and at least one dose prior to the pregnancy (MN7=1 and MN10>=1) OR
* received at least two tetanus toxoid injections, the last of which was less than 3 years ago (MN10>=2 and MN11<3).
compute two3y = 0.
do if (twocr = 0).
+ if (MN7 = 1 and MN10 >= 1 and MN10 <= 7) two3y = 100.
+ if (MN10 >= 2 and MN10 <= 7 and MN11 < 3) two3y = 100.
end if.
variable labels two3y "2 doses, the last within prior 3 years".

* Received at least 3 tetanus toxoid injections over lifetime, the last of which was in the last 5 years (MN10>=3 and MN11< 5).
compute three5y = 0.
do if (twocr = 0 and two3y = 0).
+ if (MN10 >= 3 and MN10 <= 7 and MN11 < 5 ) three5y = 100.
end if.
variable labels three5y "3 doses, the last within prior 5 years".

* Received at least 4 tetanus toxoid injections over lifetime, the last of which was in the last 10 years (MN10>=4 and MN11< 10).
compute four10y = 0.
do if (twocr = 0 and two3y = 0 and three5y = 0).
+ if (MN10 >= 4 and MN10 <= 7 and MN11 < 10) four10y = 100.
end if.
variable labels four10y "4 doses, the last within prior 10 years".

* Received five or more tetanus toxoid injections (MN10>=5) at any point.
compute five = 0.
do if (twocr = 0 and two3y = 0 and three5y = 0 and four10y = 0).
+ if (MN10 >= 5 and MN10 <= 7) five = 100.
end if.
variable labels five "5 or more doses during lifetime".

compute protect = 0.
if (twocr = 100 or two3y = 100 or three5y = 100 or four10y = 100 or
	five = 100) protect = 100.
variable labels protect "Protected against tetanus [1]".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of women who did not receive two or more doses during last pregnancy but received:".

compute tot = 1.
variable labels tot "".
value labels tot 1 "Total".

* For labels in French uncomment commands bellow.

* variable labels labels total " Nombre de femmes ayant eu une naissance vivante au cours des 2 dernieres annees".
* variable labels twocr " Pourcentage de femmes ayant recu au moins 2 doses lors de la derniere grossesse".
* variable labels two3y "2 doses, la derniere il y a moins de 3 ans".
* variable labels three5y "3 doses, la derniere il y a moins de 5 ans ".
* variable labels four10y "4 doses, la derniere il y a moins de 10 ans".
* variable labels five "5 ou plusieurs doses dans la vie ".
* variable labels protect " Protegee contre le tetanos".
* value labels layer 0 " Pourcentage de femmes qui n'ont pas recu deux ou plusieurs doses lors de la derniere grossesse mais ont recu:".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = layer tot
         display = none
  /table hh7 [c] + hh6 [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
    twocr [s] [mean,'',f5.1] + 
    layer [c] > (two3y [s] [mean,'',f5.1] + three5y [s] [mean,'',f5.1] + four10y [s] [mean,'',f5.1] + five [s] [mean,'',f5.1]) + 
    protect [s] [mean,'',f5.1] +
    total [s] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table CH.3: Neonatal tetanus protection"
 	 "Percentage of women age 15-49 years with a live birth in the last 2 years protected against neonatal tetanus, " + surveyname
  caption=
	 "[1] MICS indicator 3.7".

* Ctables command in French.
*
ctables
  /vlabels variables = layer tot
         display = none
  /table hh7 [c] + hh6 [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
    twocr [s] [mean,'',f5.1] + 
    layer [c] > (two3y [s] [mean,'',f5.1] + three5y [s] [mean,'',f5.1] + four10y [s] [mean,'',f5.1] + five [s] [mean,'',f5.1]) + 
    protect [s] [mean,'',f5.1] +
    total [s] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Tableau CH.3: Protection néo-natale contre le tétanos"
 	 "Pourcentage de femmes âgées de 15-49 ans avec une naissance vivante au cours des 2 dernières années protégées contre le tétanos néo-natal, " + surveyname
  caption=
	 "[1] Indicateur MICS 3.7".									

COMMENT -- End CTABLES command.
new file.
