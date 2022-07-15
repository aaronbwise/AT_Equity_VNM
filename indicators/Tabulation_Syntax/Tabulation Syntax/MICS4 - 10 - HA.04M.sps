include "surveyname.sps".

get file = 'mm.sav'.

select if (MWM7 = 1 and MHA1 = 1).

weight by mmweight.

compute total = 1.
variable labels total "".
value labels total 1 "Number of men who have heard of AIDS".

recode MHA12 (1 = 100) (else = 0) into care.
variable labels care "Are willing to care for a family member with the AIDS virus in own home".

recode MHA10 (1 = 100) (else = 0) into food.
variable labels food "Would buy fresh vegetables from a shopkeeper or vendor who has the AIDS virus".

recode MHA9 (1 = 100) (else = 0) into teacher.
variable labels teacher "Believe that a female teacher with the AIDS virus and is not sick should be allowed to continue teaching".

recode MHA11 (2 = 100) (else = 0) into secret.
variable labels secret "Would not want to keep secret that a family member got infected with the AIDS virus".

count ways = secret care teacher food (100).

recode ways (1,2,3,4 = 100) (else = 0) into oneplus.
variable labels oneplus "Agree with at least one accepting attitude".

recode ways (4 = 100) (else = 0) into all4.
variable labels all4 "Express accepting attitudes on all four indicators [1]".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percent of men who:".

recode mmstatus (1,2 = 1) (3 = 2).
variable labels mmstatus "Marital status".
value labels mmstatus
  1 "Ever married/in union"
  2 "Never married/in union".

recode mage (1,2 = 1) (else = sysmis) into mage1.
recode mage (1,2 = copy) (else = sysmis) into mage2.
recode mage (3 = 3) (4,5 = 4) (6,7 = 5) (else = sysmis) into mage3.
variable labels mage1 "Age".
variable labels mage2 " ".
variable labels mage3 " ".
value labels mage1 1 "15-24".
value labels mage2 1 "  15-19" 2 "  20-24".
value labels mage3 3 "25-29" 4 "30-39" 5 "40-49".

compute tot = 1.
variable labels tot "".
value labels tot 1 "Total".

* For labels in French uncomment commands below.

 * value labels total 1 "Nombre de hommes ayant entendu parler du SIDA".
 * variable labels care "sont dispos�es � prendre soin d'un membre de la famille porteur du virus du SIDA dans leurs propres m�nages".
 * variable labels food "ach�teraient des l�gumes frais � un marchand ou � un vendeur qui a le virus du SIDA".
 * variable labels teacher "pensent qu'une enseignante qui a le SIDA mais n'est pas malade devrait �tre autoris�e � continuer d'enseigner".
 * variable labels secret "ne souhaiteraient pas que l'on garde secret l'�tat d'un membre de la famille infect� par le virus du SIDA".
 * variable labels oneplus "Sont d'accord avec au moins une attitude benveillante".
 * variable labels all4 "Expriment des attitudes bienveillantes sur tous les quatre indicateurs [1]".
 * value labels layer 0 "Pourcentage de hommes qui:".
 * variable labels mmstatus "Etat matrimonial".
 * value labels mmstatus
  1 "D�j� �t� mari�e/v�cu avec une femme"
  2 "N'a jamais �t� mari�e/v�cu avec une femme".

* ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables =  total layer tot display = none
  /table hh7 [c] + hh6 [c] + mage1 [c] + mage2 [c] + mage3 [c] + mmstatus [c] + mmelevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   layer [c] > (care [s] [mean,'',f5.1] + food [s] [mean,'',f5.1] + teacher [s] [mean,'',f5.1] + secret [s] [mean,'',f5.1] + oneplus [s] [mean,'',f5.1] + all4 [s] [mean,'',f5.1]) + 
                   total [c] [count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
   "Table HA.4M: Accepting attitudes toward people living with HIV/AIDS"
		 "Percentage of men age 15-49 years who have heard of AIDS who express an accepting attitude towards people living with HIV/AIDS, " + surveyname
  caption = 
   "[1] MICS indicator 9.4".

* ctables command in French.
* ctables
  /vlabels variables =  total layer tot display = none
  /table hh7 [c] + hh6 [c] + mage1 [c] + mage2 [c] + mstatus [c] + mmelevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   layer [c] > (care [s] [mean,'',f5.1] + food [s] [mean,'',f5.1] + teacher [s] [mean,'',f5.1] + secret [s] [mean,'',f5.1] + oneplus [s] [mean,'',f5.1] + all4 [s] [mean,'',f5.1]) + 
                   total [c] [count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
   "Tableau HA.4M: Attitudes bienveillantes � l'�gard des gens vivant avec le VIH/SIDA"
	  "Pourcentage de hommes �g�es de 15-49 ans qui ont entendu parler du SIDA et expriment une attitude bienveillante � l'�gard des gens vivant avec le VIH/SIDA, " + surveyname
  caption = 
   "[1] Indicateur MICS 9.4".

new file.