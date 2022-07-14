get file = 'hl.sav'.

weight by hhweight.

select if (schage >= 5 and schage <= 24).

select if (HL4 < 9).

compute attend = 0.
if (ed5 = 1) attend = 100.
variable label attend "Percentage attending".

compute total = 1.
value label total 1 "Number of household members".

format schage (f5.0).

* For labels in French uncomment commands bellow.
 * variable label attend " Pourcentage fréquentation".
 * value label total 1 " Nombre de membres des ménages".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = HH6 HL4 total display = none
  /table schage [c] by 
                     HH6[c] > HL4 [c] > (attend[s][mean,'',f5.1] + total [c][count,'',f5.0])
  /categories var=all empty=exclude 
  /titles title=  "Table ED.A2: School attendance" 
    "Percentage of household members age 5-24 years attending school, by residence and sex, " + surveyname.

* Ctables command in French.
*
ctables
  /vlabels variables = HH6 HL4 total display = none
  /table schage [c] by 
                     HH6[c] > HL4 [c] > (attend[s][mean,'',f5.1] + total [c][count,'',f5.0])
  /categories var=all empty=exclude 
  /titles title=  "Tableau ED.A2: Fréquentation scolaire" 
    "Pourcentage des membres du ménage âgés de 5-24 ans fréquentant une école, par résidence et sexe, " + surveyname.

new file.
