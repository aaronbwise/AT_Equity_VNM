include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

select if (wage = 1 or wage = 2).

weight by wmweight.

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of women 15-24 who:".

compute total = 1.
variable labels total "".
value labels total 1 "Number of women age 15-24 years".

compute sexever = 0.
if (SB1 <> 0) sexever = 100.
variable labels sexever "Ever had sex".

compute sex12 = 0.
if (SB1 <> 0 and SB3U >= 1 and SB3U <= 3) sex12 = 100.
variable labels sex12 "Had sex in the last 12 months".

do if (sex12 = 100).
+ compute tsex12 = 1.
+ compute nhpart = 0.
+ if (sex12 = 100 and ((SB5 >= 3 and SB5 <=6) or (SB10 >= 3 and SB10 <=6))) nhpart = 100.
end if.
value labels tsex12 1 "Number of women age 15-24 years who had sex in the last 12 months".
variable labels nhpart "Percentage who had sex with a non-marital, non-cohabiting partner in the last 12 months [1]".

do if (nhpart = 100).
+ compute condom = 0.
+ if ((SB5 = 3 or SB5 = 4 or SB5 = 6) and SB4 = 1) condom = 100.
+ if ((SB10 = 3 or SB10 = 4 or SB10 = 6) and SB9 = 1) condom = 100.
+ compute tcondom = 1.
end if.

variable labels condom "Percentage of women age 15-24 years who had sex with a non-marital, " +
		"non-cohabiting partner in the last 12 months, who also reported that a condom " +
		"was used the last time they had sex with such a partner [2]".
variable labels tcondom "".
value labels tcondom 1 "Number of women age 15-24 years who had more than one sexual partner in the last 12 months".

recode mstatus (1,2 = 1) (3 = 2).
variable labels mstatus "Marital status".
value labels mstatus
  1 "Ever married/in union"
  2 "Never married/in union".

compute tot = 1.
variable labels tot "".
value labels tot 1 "Total".

* For labels in French uncomment commands below.

* value labels layer 0 "Pourcentage de femmes âgées de 15-24 ans qui :".
* value labels total 1 "Nombre de femmes âgées de 15-24 ans".
* variable labels sexever "ont déjà eu des rapports sexuels".
* variable labels sex12 "ont eu des rapports sexuels au cours des 12 derniers mois".
* value labels tsex12 1 "Nombre de femmes âgées de 15-24 ans qui ont eu des rapports sexuels au cours des 12 derniers mois".
* variable labels nhpart "Pourcentage de celles qui ont eu des rapports sexuels avec un partenaire hors mariage, non cohabitant au cours des 12 derniers mois [1]".
* variable labels condom "Pourcentage de femmes âgées de 15-24 ans qui on eu des rapports sexuels avec un partenaire hors mariage, " + 
	 "non cohabitant au cours des 12 derniers mois, et qui ont déclaré avoir utilisé un préservatif la dernière fois " + 
	 "qu'elles ont eu des rapports sexuels avec ce partenaire [2]".
* value labels tcondom 1 "Nombre de femmes âgées de 15-24 ans qui ont eu des rapports sexuels au cours des 12 derniers mois avec un partenaire hors mariage, non cohabitant".
* variable labels mstatus "Etat matrimonial".
* value labels mstatus
  1 "Déjà été mariée/vécu avec un homme"
  2 "N'a jamais été mariée/vécu avec un homme".

* ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = tot total layer tcondom tsex12 display = none
  /table hh7 [c] + hh6 [c] + wage [c] + mstatus [c] + welevel[c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   layer [c] > (sexever [s] [mean,'',f5.1] + sex12 [s] [mean,'',f5.1]) + total [c] [count,'',f5.0] +
	                  nhpart [s] [mean,'',f5.1] + tsex12 [c] [count,'',f5.0] +
 	                 condom [s] [mean,'',f5.1] + tcondom [c] [count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
   "Table HA.11: Sex with non-regular partners"
		 "Percentage of women age 15-24 years who ever had sex, " +
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
  /table hh7 [c] + hh6 [c] + wage [c] + mstatus [c] + welevel[c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   layer [c] > (sexever [s] [mean,'',f5.1] + sex12 [s] [mean,'',f5.1]) + total [c] [count,'',f5.0] +
	                  nhpart [s] [mean,'',f5.1] + tsex12 [c] [count,'',f5.0] +
 	                 condom [s] [mean,'',f5.1] + tcondom [c] [count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
   "Tableau HA.11: Rapports sexuels avec des partenaires occasionnels"
	  "Pourcentage de femmes âgées de 15-24 ans qui ont déjà eu des raports sexuels, pourcentage de celles ayant eu des rapports sexuels " + 
	  "au cours des 12 derniers mois, pourcentage de celles qui ont eu des rapports sexuels avec un partenaire hors mariage, non cohabitant " + 
	  "au cours des 12 derniers mois et parmi celles-ci, pourcentage de celles ayant utilisé un préservatif la dernière fois qu'elles ont eu des " + 
	  "rapports sexuels avec ce partenaire hors mariage, non cohabitant , " + surveyname
  caption=
 	 "[1] Indicateur MICS 9.15"							
	  "[2] Indicateur MICS 9.16; Indicateur OMD 6.2".	

new file.
