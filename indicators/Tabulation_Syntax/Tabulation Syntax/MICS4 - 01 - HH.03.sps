* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open household members data file.
get file = 'hl.sav'.

* Count the total number of children under age 18 in each household.
compute kid18 = 0.
if (HL6 < 18) kid18 = 1.

* Save this information (by cluster and hh number) in a temporary working file.
aggregate outfile = 'tmp.sav'
  /break =  HH1 HH2
  /totkid18 = sum(kid18).

* Open the aggregated file.
get file = 'tmp.sav'.

*Sort the cases by cluster number and household number.
sort cases by HH1 HH2.

* Save the sorted cases in a working file.
save outfile = 'tmp.sav'.

* Open the household data file.
get file = 'hh.sav'.

* Select completed households.
select if (HH9  = 1).

* Sort the cases by cluster number and household number.
sort cases by HH1 HH2.

* Merge the aggregate data onto the hh data file (add total no of children <18 info to hh).
match files
  /file = *
  /table = 'tmp.sav'
  /by  HH1 HH2.

* Weight the data by the household weight.
weight by hhweight.

* Recode total number of household members.
recode HH11 (lo thru 9=copy) (10 thru hi = 10) into hhmember.
variable labels hhmember "Number of household members".
value labels hhmember 10 "10+".
format hhmember (f2.0).

variable labels HH11 "Mean household size".

* Prepare the variables for tables.
recode totkid18 (0 = 0) (1 thru hi = 100) into kid18.
variable labels kid18 "Households with at least: one child age 0-17 years".
recode HH14 (0 = 0) (1 thru hi = 100) into kid5.
variable labels kid5 "Households with at least: one child age 0-4 years".
recode HH12 (0 = 0) (1 thru hi = 100) into woman.
variable labels woman "Households with at least: one woman age 15-49 years".
recode HH13A (0 = 0) (1 thru hi = 100) into man.
variable labels man "Households with at least: one man age 15-59 years".

compute tot1 = 1.
variable labels tot1 "Total".
value labels tot1 1" ".

compute wp = 0.
variable labels wp " ".
compute nhh = 0.
variable labels nhh "Number of households".
value labels nhh 0 "Number of households".

* For labels in French uncomment commands bellow.
* variable labels
  nhh "Nombre de ménages"
  /hhmember "Ménages ayant au moins"
  /HH11 "Taille moyenne du ménage"
  /kid18 "Un enfant de 0-17 ans"
  /kid5 "Un enfant de 0-4 ans"
  /woman "Une femme de 15-49 ans"
  /woman "Un homme de 15-59 ans".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variable = wp display = none
  /table hhsex [c] + hh7 [c] + hh6 [c] + hhmember [c] + helevel [c] + ethnicity [c] + tot1 [c] by
           wp [s] [colpct.count,'Weighted percent' f5.1] + nhh [s] [count, 'Weighted', f5.0, ucount, 'Unweighted', f5.0]
  /categories var=all empty=exclude missing=exclude
  /title title=
	"Table HH.3: Household composition"
  	"Percent distribution of households by selected characteristics, " + surveyname.

* If using French replace above title with this one.
*  	"Tableau HH.3: Composition du ménage"			
	"Pourcentage et fréquence de répartition des ménages selon des caractéristiques sélectionnées, " + surveyname.	

* If using French replace above ctable command with this one.

ctables
  /vlabels variable = nhh display = none
  /table
            kid5 [s] [mean,'Weighted percent',f5.1,validn,'Weighted',f5.0, uvalidn,'Unweighted',f5.0] +
            kid18 [s] [mean,'Weighted percent',f5.1, validn,'Weighted',f5.0, uvalidn,'Unweighted',f5.0]+
            woman [s] [mean,'Weighted percent',f5.1,validn,'Weighted',f5.0,uvalidn,'Unweighted',f5.0] +
            man [s] [mean,'Weighted percent',f5.1,validn,'Weighted',f5.0,uvalidn,'Unweighted',f5.0] +
            hh11 [s] [mean,'Weighted percent',f5.1,validn,'Weighted',f5.0,uvalidn,'Unweighted',f5.0]
            by nhh [c]
  /categories var=all empty=exclude missing=exclude
  /title title=
	"Table HH.3: Household composition"
	"Percent distribution of households by selected characteristics, " + surveyname.

* Ctables command in French.
*
ctables
  /vlabels variable = wp display = none
  /table hhsex [c] + hh7 [c] + hh6 [c] + hhmember [c] + helevel [c] + ethnicity [c] + tot1 [c] by
           wp [s] [colpct.count,'Weighted percent' f5.1] + nhh [s] [count, 'Weighted', f5.0, ucount, 'Unweighted', f5.0]
  /categories var=all empty=exclude missing=exclude
  /title title=
	"Tableau HH.3: Composition du ménage"			
	"Pourcentage et fréquence de répartition des ménages selon des caractéristiques sélectionnées, " + surveyname.
*
ctables
  /vlabels variable = nhh display = none
  /table
            kid5 [s] [mean,'Weighted percent',f5.1,validn,'Weighted',f5.0, uvalidn,'Unweighted',f5.0] +
            kid18 [s] [mean,'Weighted percent',f5.1, validn,'Weighted',f5.0, uvalidn,'Unweighted',f5.0]+
            woman [s] [mean,'Weighted percent',f5.1,validn,'Weighted',f5.0,uvalidn,'Unweighted',f5.0] +
            man [s] [mean,'Weighted percent',f5.1,validn,'Weighted',f5.0,uvalidn,'Unweighted',f5.0] +
            hh11 [s] [mean,'Weighted percent',f5.1,validn,'Weighted',f5.0,uvalidn,'Unweighted',f5.0]
            by nhh [c]
  /categories var=all empty=exclude missing=exclude
  /title title=
	"Tableau HH.3: Composition du ménage"			
	"Pourcentage et fréquence de répartition des ménages selon des caractéristiques sélectionnées, " + surveyname.

new file.

* Delete temporary working file.
erase file = 'tmp.sav'.


