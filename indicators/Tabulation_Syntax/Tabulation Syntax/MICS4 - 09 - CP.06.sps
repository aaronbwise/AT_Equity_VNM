include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

compute t15 = 0.
if (wagem < 15) t15 = 100.
value label t15 100 "Percentage of women married before age 15".
variable labels t15 " ".

compute total = 1.
variable labels total "".
value labels total 1 "Number of women".

do if (WB2 >= 20).
+ compute t2049 = 1.
+ compute t18 = 0.
+ if (wagem >= 15 and wagem <= 17 or t15 = 100) t18 = 100.
end if.
variable labels t2049 "".
value labels t2049 1 "Number of women".
value labels t18 100 "Percentage of women married before age 18".

do if (HH6 = 1).
+ compute t15ur = 0.
+ if (wagem < 15) t15ur = 100.
+ compute tot15ur = 1.
end if.
variable labels t15ur " ".
value labels t15ur 100 "Percentage of women married before age 15".
value labels tot15ur 1 "Number of women".

do if (HH6 = 1 and WB2 >= 20).
+compute t2049ur = 1.
+ compute t18ur = 0.
+ if (wagem < 18) t18ur = 100.
end if.
variable labels t18ur " ".
value labels t18ur 100 "Percentage of women married before age 18".
variable labels t2049ur "".
value labels t2049ur 1 "Number of women".

do if (HH6 = 2).
+ compute t15rur = 0.
+ if (wagem < 15) t15rur = 100.
+ compute tot15rur = 1.
end if.
variable labels t15rur " ".
value labels t15rur 100 "Percentage of women married before age 15".
value labels tot15rur 1 "Number of women".

do if (HH6 = 2 and WB2 >= 20).
+ compute t2049rur = 1.
+ compute t18rur = 0.
+ if (wagem < 18) t18rur = 100.
+ variable labels t2049rur "".
end if.
variable labels t18rur " ".
value labels t18rur 100 "Percentage of women married before age 18".
value labels t2049rur 1 "Number of women".

compute layer1 = 0.
value labels layer1 0 "Urban".
variable labels layer1 " ".

compute layer2 = 0.
value labels layer2 0 "Rural".
variable labels layer2 " ".

compute layer3 = 0.
value labels layer3 0 "All".
variable labels layer3 " ".

compute tot1 = 1.
variable labels tot1 "Total".
value labels tot1 1" ".

* For labels in French uncomment commands bellow.

* value labels t15 100 "Pourcentage de femmes mariées avant l'âge de 15 ans".
* value labels total 1 "Nombre de femmes".
* value labels t2049 1 "Nombre de femmes".
* value labels t18 100 "Pourcentage de femmes mariées avant l'âge de 18 ans".
* value labels t15ur 100 "Pourcentage de femmes mariées avant l'âge de 15 ans".
* value labels tot15ur 1 "Nombre de femmes".
* value labels t18ur 100 "Pourcentage de femmes mariées avant l'âge de 18 ans".
* value labels t2049ur 1 "Nombre de femmes".
* value labels t15rur 100 "Pourcentage de femmes mariées avant l'âge de 15 ans".
* value labels tot15rur 1 "Nombre de femmes".
* value labels t18rur 100 "Pourcentage de femmes mariées avant l'âge de 18 ans".
* value labels t2049rur 1 "Nombre de femmes".
* value labels layer1 0 "Urbain".
* value labels layer2 0 "Rural".
* value labels layer3 0 "Total".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = layer1 layer2 layer3 t15ur t18ur t15rur t18rur t15 t18 tot15ur t2049ur tot15rur t2049rur total t2049
         display = none
  /table wage [c] + tot1 [c] by 
       layer1 [c] > (t15ur [s] [mean, "Percentage of women married before age 15", f5.1] + tot15ur [s] [validn,"Number of women age 15-49" ,f5.0] + 
                         t18ur [s] [mean, "Percentage of women married before age 18", f5.1] + t2049ur [s] [validn,"Number of women age 20-49" ,f5.0])+ 
       layer2 [c] > (t15rur [s] [mean, "Percentage of women married before age 15", f5.1] + tot15rur [s] [validn,"Number of women age 15-49" ,f5.0] + 
                         t18rur [s] [mean,"Percentage of women married before age 18", f5.1] + t2049rur [s] [validn,"Number of women age 20-49" ,f5.0]) +
       layer3 [c] > (t15 [s] [mean, "Percentage of women married before age 15", f5.1] + total [s] [validn,"Number of women age 15-49" ,f5.0] +  
                         t18 [s]  [mean, "Percentage of women married before age 18", f5.1] + t2049 [s] [validn,"Number of women age 20-49" ,f5.0])
  /title title=
   "Table CP.6: Trends in early marriage"
		"Percentage of women who were first married or entered into a marital union before age 15 and 18, by residence and age groups, " + surveyname.

* Ctables command in French.
*
ctables
  /vlabels variables = layer1 layer2 layer3 t15ur t18ur t15rur t18rur t15 t18 tot15ur t2049ur tot15rur t2049rur total t2049
         display = none
  /table wage [c] + tot1 [c] by 
       layer1 [c] > (t15ur [s] [mean, "Pourcentage de femmes mariées avant l'âge de 15 ans", f5.1] + tot15ur [s] [validn,"Nombre de femmes" ,f5.0] + 
                         t18ur [s] [mean, "Pourcentage de femmes mariées avant l'âge de 18 ans", f5.1] + t2049ur [s] [validn,"Nombre de femmes" ,f5.0])+ 
       layer2 [c] > (t15rur [s] [mean, "Pourcentage de femmes mariées avant l'âge de 15 ans", f5.1] + tot15rur [s] [validn,"Nombre de femmes" ,f5.0] + 
                         t18rur [s] [mean,"Pourcentage de femmes mariées avant l'âge de 18 ans", f5.1] + t2049rur [s] [validn,"Nombre de femmes" ,f5.0]) +
       layer3 [c] > (t15 [s] [mean, "Pourcentage de femmes mariées avant l'âge de 15 ans", f5.1] + total [s] [validn,"Nombre de femmes" ,f5.0] +  
                         t18 [s]  [mean, "Pourcentage de femmes mariées avant l'âge de 18 ans", f5.1] + t2049 [s] [validn,"Nombre de femmes" ,f5.0])
  /title title=
   "Tableau CP.6: Tendances du mariage précoce"
		"Pourcentage de femmes qui se sont d'abord mariées ou ont vécu avec un homme avant l'âge de 15 et 18 ans, par résidence et tranches d'âge, " + surveyname.
 
new file.
