* This syntax produces output required for Figure NU.3: Infant feeding patterns by age, [Country], [Year].

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

weight by chweight.

select if (UF9 = 1 and cage < 24).

compute bf = 0.
if (BF2=1 & (BF3 <> 1 & BF4 <> 1 & BF6 <> 1 & BF8 <> 1 & BF9 <> 1 &  BF12<> 1 & BF13 <> 1 & BF15 <> 1 & BF16 <> 1)) bf = 1.
if (BF2 = 1 & BF3 = 1 & (BF4 <> 1 & BF6 <> 1 & BF8 <> 1 & BF9 <> 1 &  BF12<> 1 & BF13 <> 1 & BF15 <> 1 & BF16 <> 1))  bf = 2.
if (BF2=1 & (BF8 = 1 or BF9 = 1 or BF12 = 1 or BF15 = 1) & BF4 <> 1 & BF6 <> 1 & BF13 <> 1 & BF16 <> 1) bf = 3.
if (BF2=1 & (BF4 = 1 or BF6 = 1 or BF13 = 1) & BF16  <>  1) bf = 4.
if (BF2 = 1 & (BF16 = 1)) bf = 5.
if (BF1 <> 1 or BF2 <> 1) bf = 6.

variable labels bf "Infant feeding pattern".
value labels bf 
  6 "Weaned (not breastfed)"
  5 "Breastfed and complementary foods"
  4 "Breastfed and other milk / formula"
  3 "Breastfed and non-milk liquids"
  2 "Breastfed and plain water only"
  1 "Exclusively breastfed".

compute cage2 = trunc(cage/2).
variable labels cage2 "Age".
value labels cage2 
  0 "0-1"
  1 "2-3"
  2 "4-5"
  3 "6-7"
  4 "8-9"
  5 "10-11"
  6 "12-13"
  7 "14-15"
  8 "16-17"
  9 "18-19"
  10 "20-21"
  11 "22-23".

compute total = 1.
value labels total 1 "Number of children".

compute tot2 = 100.
variable labels tot2 "Total".
value labels tot2 100 "".

* For labels in French uncomment commands below.

* variable labels bf "Type d'alimentation".
* value labels bf 
  6 "Non allaités"
  5 "Allaités au sein et aliments complémentaires"
  4 "Allaitement maternel et autre lait / préparation pour nourrissons"
  3 "Allaitement maternel et liquides non lactés"
  2 "Allaitement maternel et eau simple uniquement "
  1 "Allaitement maternel exclusif".
* value labels total 1 "Nombre d'enfants".
						
* ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = total display = none
  /table cage2 [c] by 
                 bf[c][rowpct.validn,'',f5.1] + tot2[s][mean,'',f5.1] + total[c][count,'',f5.0] 
  /slabels position = column visable = no
  /categories var = all empty = exclude missing = exclude
  /titles title=
	  "Table NU.A1. Infant feeding patterns by age" 
	  "Percent distribution of children age 0-23 months by feeding pattern, " + surveyname.

* ctables command in French.
* ctables
  /vlabels variables = total display = none
  /table cage2 [c] by 
                bf[c][rowpct.validn,'',f5.1] + tot2[s][mean,'',f5.1] + total[c][count,'',f5.0] 
  /slabels position = column visable = no
  /categories var = all empty = exclude missing = exclude
  /titles title=
  	"Tableau NU.A1. Types d'alimentation infantile par âge" 
	  "Répartition en pourcentage des enfants âgés de 0-23 mois selon le type d'alimentation, " + surveyname.

new file.
