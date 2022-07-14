include "surveyname.sps".

get file= "mm.sav".

select if (MWM7 = 1).

weight by mmweight.

compute t15 = 0.
if (magem < 15) t15 = 100.
variable label t15 "Percentage married before age 15 [1]".

compute total = 1.
variable label total "".
value label total 1 "Number of men age 15-49 years".

do if (MWB2 >= 20).
+ compute t15a = 0.
+ if (magem < 15) t15a = 100.
+ compute t18 = 0.
+ if (magem < 18) t18 = 100.
end if.

variable label t15a "Percentage married before age 15".
variable label t18 "Percentage married before age 18 [2]".

if (MWB2 >= 20) t2049 = 1.
variable label t2049 "".
value label t2049 1 "Number of men age 20-49 years".

do if (mage = 1).
+ compute t1519m = 0.
+ if (MMA1 =1 or MMA1 = 2) t1519m  = 100.
+ compute t1519 = 1.
end if.

variable label t1519m "Percentage of men 15-19 years currently  married/in union [3]".
variable label t1519 "".
value label t1519 1 "Number of men age 15-19 years".

* this code is only for countries with polygyny.
if (MMA1 = 1 or MMA1 = 2) totalm  = 1.
variable label totalm "".
value label totalm 1 "Number of men age 15-49 years currently married/in union".
do if (totalm = 1).
+ compute polyg  = 0.
+ if (MMA3 = 1) polyg  = 100.
end if.

variable label polyg "Percentage of men age 15-49 years in polygynous marriage/ union [4]".

compute tot = 1.
variable label tot "Total".
value label tot 1" ".

* For labels in French uncomment commands bellow.

* variable label t15 "Pourcentage de hommes mariées avant l'âge de 15 [1]".
* value label total 1 "Nombre de hommes âgées de 15-49 ans".
* variable label t15a "Pourcentage de hommes mariées avant l'âge de 15 ans".
* variable label t18 "Pourcentage de hommes mariées avant l'âge de 18 [2]".
* value label t2049 1 "Nombre de hommes âgées de 20-49 ans".
* variable label t1519m "Pourcentage de hommes de 15-19 ans actuellement mariées/vivant avec un femme [3]".
* value label t1519 1 "Nombre de hommes de 15-19 ans".
* value label totalm 1 " Nombre de hommes de 15-49 ans actuellement mariées/vivant avec un femme".
* variable label polyg " Pourcentage de hommes de 15-49 ans en mariage/union polygame [4]".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = total t2049 t1519 totalm
              display = none
  /table hh7 [c] + hh6 [c] + mage [c] + mmelevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
	t15 [s] [mean,'',f5.1] + total [c] [count,'',f5.0] + t15a [s] [mean,'',f5.1] + t18 [s] [mean,'',f5.1] + t2049 [c] [count,'',f5.0] +
                  t1519m [s] [mean,'',f5.1] + t1519 [c] [count,'',f5.0] + polyg [s] [mean,'',f5.1] + totalm [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /title title=
  "Table CP.5M: Early marriage and polygyny"
	"Percentage of men age 15-49 years who first married or entered a marital union before their 15th birthday, "+
                  "percentages of men age 20-49 years who first married or entered a marital union before their 15th and 18th birthdays, " +
                  "percentage of men age 15-19 years currently married or in union, " +
                  "and the percentage of men currently married or in union who are in a polygynous marriage or union, " + surveyname
  caption= 	"[1] MICS indicator 8.6"									
	"[2] MICS indicator 8.7"									
	"[3] MICS indicator 8.8"									
	"[4] MICS indicator 8.9".	

* Ctables command in French.
*
ctables
  /vlabels variables = total t2049 t1519 totalm
              display = none
  /table hh7 [c] + hh6 [c] + mage [c] + mmelevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
	t15 [s] [mean,'',f5.1] + total [c] [count,'',f5.0] + t15a [s] [mean,'',f5.1] + t18 [s] [mean,'',f5.1] + t2049 [c] [count,'',f5.0] +
                  t1519m [s] [mean,'',f5.1] + t1519 [c] [count,'',f5.0] + polyg [s] [mean,'',f5.1] + totalm [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /title title=
  "Tableau CP.5M: Mariage précoce et polygamie"
	"Pourcentage de hommes âgées de 15-49 ans qui se sont mariées ou ont vécu avec un homme avant leur  "+
                  "15 ème anniversaire, pourcentage de hommes âgées de 20-49 ans qui se sont mariées ou ont vécu avec un homme avant leur 15 ème " +
                  "et 18 ème anniversaire, pourcentage de hommes âgées de 15-19 ans actuellement mariées ou vivant avec un homme, et pourcentage de hommes " +
                  "actuellement mariées ou en union polygame, " + surveyname
  caption= 	"[1] Indicateur MICS 8.6"									
	"[2] Indicateur MICS 8.7"									
	"[3] Indicateur MICS 8.8"									
	"[4] Indicateur MICS 8.9".

new file.
