include "surveyname.sps".

* Open the women's data file.
get file = 'wm.sav'.

* Select only complete interviews.
select if (WM7 = 1).

* Weight the data by the women's weight.
weight by wmweight.

* Select only married or in union women.
select if (mstatus = 1).

* Get the most effective method from the list (will be the first given).
compute method = 99.
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

* If pregnant or state they are not using, set method to 0.
if (CP1 = 1 or CP2 = 2 or CP2 = 9) method = 0.

variable label method "Current method".
value label method 
                   0 "No method"
                   1 "Female sterilization"
                   2 "Male sterilization"
                   3 "Pill"
                   4 "IUD"
                   5 "Injections"
                   6 "Implants"
                   7 "Condom"
                   8 "Female condom"
                   9 "Diaphragm/foam/jelly"
                   11 "LAM"
                   12 "Periodic abstinence"
                   13 "Withdrawal"
                   14 "Other"
                   99 "Missing".

* Current users of contraception.
compute usemeth = 0.
if (method <> 0) usemeth = 100.
variable label usemeth "Current use of contraception".

* Amenorrheic women.
compute amenor = 0.
if ((CM13 = "Y" or CM13 = "O") and CP1 <> 1 and MN23 = 2) amenor = 1.
variable label amenor "Postpartum amenorrheic women".

* Pregnant women.
compute preg = 0.
if (CP1 = 1) preg = 1.
variable label preg "Pregnant women".

* Continuously married for the past 5 years.
compute m5yrs = 0.
if (mstatus = 1 and MA7 = 1 and (wdoi - wdom) >= 60) m5yrs = 1.
variable label m5yrs "Continuously married for the past 5 years".

* No birth in the past 5 years.
compute nob5yrs = 0.
if (CM10 = 0 or (wdoi - wdoblc) >= 60) nob5yrs = 1.
variable label nob5yrs "No birth in past 5 years".

* Check for other fecund women.
do if (preg = 0 and amenor = 0).
+ compute fecund = 1.
+ if (UN13U = 4 or (UN13U = 3 and UN13N > 6) or (UN13U = 9 and UN13N>= 94 and UN13N<=96)) fecund = 0.
+ if (UN11B = "B" or UN11C = "C" or UN11D = "D" or UN11E="E") fecund = 0.
+ if (UN6 = 3 or (UN7U = 9 and UN7N = 94)) fecund = 0.
+ if (usemeth = 0 and nob5yrs = 1 and m5yrs = 1) fecund = 0.
end if.
variable label fecund "Fecund women".
value label fecund 0 "No" 1 "Yes".

* Met and unment need for spacing and limiting.
compute metspc = 0.
compute metlmt = 0.
compute met = 0.

compute space  = 0.
compute limit  = 0.
compute unmet = 0.

* Current users - calculate met need for spacing and limiting.
do if (usemeth = 100).
+ if (UN6 = 2) metlmt = 100.
+ if (method = 1 or method = 2) metlmt = 100.
+ if (UN6 = 3) metlmt = 100.
+ if (UN6 = 1 and UN7U = 9 and UN7N = 94) metlmt = 100.
+ if (UN6 = 1 and metlmt = 0) metspc = 100.
+ if (UN6 = 8 or UN6 = 9) metspc = 100.

* Total met need.
if (metspc = 100 or metlmt = 100) met = 100.

* Calculate unment need for spacing and limiting.

* Pregnant women.
else if (preg = 1).
+ if (UN3 = 1) space = 100.
+ if (UN3 = 2 and UN4 = 1) space = 100.  /* Added to allow for women changing their minds about the future.
+ if (UN3 = 2 and UN4 <> 1) limit = 100. 
+ if (UN3 = 9) space = 100.                     /* Assume missing is treated as a spacer.

* Amenorrheic women.
else if (amenor = 1).
+ if (DB2 = 1) space = 100.
+ if (DB2 = 2 and UN6 = 1) space = 100.  /* Added to allow for women changing their minds about the future.
+ if (DB2 = 2 and UN6 <> 1) limit = 100. 
+ if (DB2 = 9) space = 100.                     /* Assume missing is treated as a spacer.

* Other fecund women.
else if (fecund = 1).
+ if (UN7U = 1 and UN7N >= 24 and UN7N < 90)  space = 100.
+ if (UN7U = 2 and UN7N >= 2 and UN7N < 90)  space = 100.
+ if (UN7U = 9 and UN7N = 95) space = 100.
+ if (UN6 = 8) space = 100.
+ if (UN6 = 2) limit = 100.

end if.

* Total unmet need.
if (space = 100 or limit = 100) unmet = 100.

variable label metspc "Met need for contraception - For spacing".
variable label metlmt "Met need for contraception - For limiting".
variable label met "Met need for contraception - Total".

variable label space "Unmet need for contraception - For spacing".
variable label limit "Unmet need for contraception - For limiting".
variable label unmet "Unmet need for contraception - Total [1]".

compute total = 1.
variable label total "Number of women currently married or in union".
value label total 1 " ".

* Percentage of demand satisfied.
do if (unmet = 100 or usemeth = 100).
+ compute satisf  = 0.
+ if (usemeth = 100) satisf = 100.
+ compute totneed = 1.
end if.

compute tot1 = 1.
variable label tot1 "Total".
value labels tot1 1 " ".

variable label satisf "Percentage of demand for contraception satisfied".
variable label totneed "Number of women currently married or in union with need for contraception".
value label totneed 1 " ".

* For labels in French uncomment commands bellow.

* variable label metspc " Besoin satisfait en matière de contraception - Pour l'espacement".
* variable label metlmt " Besoin satisfait en matière de contraception - Pour la limitation".
* variable label met " Besoin satisfait en matière de contraception - Total".

* variable label space " Besoin non satisfait en matière de contraception - Pour l'espacement ".
* variable label limit "Unmet need for contraception - Pour la limitation".
* variable label unmet "Unmet need for contraception - Total [1]".

* variable label total " Nombre de femmes actuellement mariées ou vivant avec un homme".

* variable label satisf " Pourcentage de demandes de contraception satisfaites".
* variable label totneed " Nombre de femmes actuellement mariées ou vivant avec un homme et ayant un besoin de contraception".

* Tabulate unmet need data.

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /table hh7 [c] + hh6 [c] + wage [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
  	metspc [s] [mean,'',f5.1] + metlmt [s] [mean,'',f5.1] + met [s] [mean,'',f5.1] + 
                  space [s] [mean,'',f5.1] + limit [s] [mean,'',f5.1] + unmet [s] [mean,'',f5.1] + 
                  total [c] [count,'',f5.0] + satisf [s] [mean,'',f5.1] + totneed [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /title title=
    "Table RH.5: Unmet need for contraception"
		"Percentage of women aged 15-49 years currently married or in union with an unmet need for family planning and percentage of demand for contraception satisfied, " + surveyname
  caption=
     "[1] MICS indicator 5.4; MDG indicator 5.6".


* Ctables command in French.
*
ctables
  /table hh7 [c] + hh6 [c] + wage [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
  	metspc [s] [mean,'',f5.1] + metlmt [s] [mean,'',f5.1] + met [s] [mean,'',f5.1] + 
                  space [s] [mean,'',f5.1] + limit [s] [mean,'',f5.1] + unmet [s] [mean,'',f5.1] + 
                  total [c] [count,'',f5.0] + satisf [s] [mean,'',f5.1] + totneed [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /title title=
    "Tableau RH.5: Besoins non satisfaits en matière de contraception"
		"Pourcentage de femmes âgées de 15-49 ans actuellement mariées ou vivant avec un homme et ayant " 
		"un besoin non satisfait en matière de planification familiale et pourcentage de demandes de contraception satisfaites, " + surveyname
   caption=
     "[1] Indicateur MICS 5.4; Indicateur OMD 5.6".

new file.
