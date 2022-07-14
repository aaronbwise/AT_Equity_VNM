include "surveyname.sps".

get file = 'mm.sav'.

select if (MWM7 = 1).

select if (mage = 1 or mage = 2).

weight by mmweight.

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of men 15-24 who:".

compute total = 1.
variable labels total "".
value labels total 1 "Number of men age 15-24 years".

compute sexever = 0.
if (MSB1 <> 0) sexever = 100.
variable labels sexever "Ever had sex".

compute sex12 = 0.
if (MSB1 <> 0 and MSB3U >= 1 and MSB3U <= 3) sex12 = 100.
variable labels sex12 "Had sex in the last 12 months".

do if (sex12 = 100).
+ compute tsex12 = 1.
+ compute nhpart = 0.
+ if (sex12 = 100 and ((MSB5 >= 3 and MSB5 <=6) or (MSB10 >= 3 and MSB10 <=6))) nhpart = 100.
end if.
value labels tsex12 1 "Number of men age 15-24 years who had sex in the last 12 months".
variable labels nhpart "Percentage who had sex with a non-marital, non-cohabiting partner in the last 12 months [1]".

do if (nhpart = 100).
+ compute condom = 0.
+ if ((MSB5 = 3 or MSB5 = 4 or MSB5 = 6) and MSB4 = 1) condom = 100.
+ if ((MSB10 = 3 or MSB10 = 4 or MSB10 = 6) and MSB9 = 1) condom = 100.
+ compute tcondom = 1.
end if.

variable labels condom "Percentage of men age 15-24 years who had sex with a non-marital, " +
		"non-cohabiting partner in the last 12 months, who also reported that a condom " +
		"was used the last time they had sex with such a partner [2]".
variable labels tcondom "".
value labels tcondom 1 "Number of men age 15-24 years who had more than one sexual partner in the last 12 months".

recode mmstatus (1,2 = 1) (3 = 2).
variable labels mmstatus "Marital status".
value labels mmstatus
  1 "Ever married/in union"
  2 "Never married/in union".

compute tot = 1.
variable labels tot "".
value labels tot 1 "Total".

* For labels in French uncomment commands below.

* value labels layer 0 "Pourcentage de hommes âgées de 15-24 ans qui :".
* value labels total 1 "Nombre de hommes âgées de 15-24 ans".
* variable labels sexever "ont déjà eu des rapports sexuels".
* variable labels sex12 "ont eu des rapports sexuels au cours des 12 derniers mois".
* value labels tsex12 1 "Nombre de hommes âgées de 15-24 ans qui ont eu des rapports sexuels au cours des 12 derniers mois".
* variable labels nhpart "Pourcentage de celles qui ont eu des rapports sexuels avec un partenaire hors mariage, non cohabitant au cours des 12 derniers mois [1]".
* variable labels condom "Pourcentage de hommes âgées de 15-24 ans qui on eu des rapports sexuels avec un partenaire hors mariage, " + 
	 "non cohabitant au cours des 12 derniers mois, et qui ont déclaré avoir utilisé un préservatif la dernière fois " + 
	 "qu'elles ont eu des rapports sexuels avec ce partenaire [2]".
* value labels tcondom 1 "Nombre de hommes âgées de 15-24 ans qui ont eu des rapports sexuels au cours des 12 derniers mois avec un partenaire hors mariage, non cohabitant".
* variable labels mstatus "Etat matrimonial".
* value labels mstatus
  1 "Déjà été mariée/vécu avec une femme"
  2 "N'a jamais été mariée/vécu avec une femme".

* ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = tot total layer tcondom tsex12 display = none
  /table hh7 [c] + hh6 [c] + mage [c] + mmstatus [c] + mmelevel[c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   layer [c] > (sexever [s] [mean,'',f5.1] + sex12 [s] [mean,'',f5.1]) + total [c] [count,'',f5.0] +
	                  nhpart [s] [mean,'',f5.1] + tsex12 [c] [count,'',f5.0] +
 	                 condom [s] [mean,'',f5.1] + tcondom [c] [count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
   "Table HA.11M: Sex with non-regular partners"
		 "Percentage of men age 15-24 years who ever had sex, " +
   "percentage who had sex in the last 12 months, percentage who " +
   "have had sex with a non-marital, non-cohabiting partner in the last 12 " +
   "months and among those who had sex with a non-marital, non-cohabiting partner, " +
   "the percentage who used a condom the last time they had sex with such a partner, " + surveyname
  caption=
 	 "[1] MICS indicator 9.15"							
	  "[2] MICS indicator 9.16; MDG indicator 6.2".	

* ctables command in French.
*	ctables
  /vlabels variables = tot total layer tcondom tsex12 display = none
  /table hh7 [c] + hh6 [c] + mage [c] + mmstatus [c] + mmelevel[c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   layer [c] > (sexever [s] [mean,'',f5.1] + sex12 [s] [mean,'',f5.1]) + total [c] [count,'',f5.0] +
	                  nhpart [s] [mean,'',f5.1] + tsex12 [c] [count,'',f5.0] +
 	                 condom [s] [mean,'',f5.1] + tcondom [c] [count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
   "Tableau HA.11M: Rapports sexuels avec des partenaires occasionnels"
	  "Pourcentage de hommes âgées de 15-24 ans qui ont déjà eu des raports sexuels, pourcentage de celles ayant eu des rapports sexuels " + 
	  "au cours des 12 derniers mois, pourcentage de celles qui ont eu des rapports sexuels avec un partenaire hors mariage, non cohabitant " + 
	  "au cours des 12 derniers mois et parmi celles-ci, pourcentage de celles ayant utilisé un préservatif la dernière fois qu'elles ont eu des " + 
	  "rapports sexuels avec ce partenaire hors mariage, non cohabitant , " + surveyname
  caption=
 	 "[1] Indicateur MICS 9.15"							
	  "[2] Indicateur MICS 9.16; Indicateur OMD 6.2".	

new file.
