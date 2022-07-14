include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

select if (wage = 1 or wage = 2).

do if ((wage = 1 or wage = 2) and mstatus = 3).
+ compute sexnm15 = 0.
+ if (SB1 = 0) sexnm15 = 100.
+ compute totnm1524 = 1.
end if.

variable labels sexnm15 "Percentage of never-married women age 15-24 years who have never had sex [1]".
variable labels totnm1524 "".
value labels totnm1524 1 "Number of never-married women age 15-24 years".

* Women age 15-24 who had sex before age 15 is calculated based on responses to SB1 (SB1<>0 AND SB1<15).
* If the response is that the first time she had sex was when she started living with her first husband or partner (SB1=95).
* then her age at first sex is calculated from the date of first marriage/union or age at first marriage/union.
do if (wage = 1 or wage = 2).
+ compute sex15 = 0.
+ if (SB1 <> 0 and SB1 < 15) sex15 = 100.
+ if (SB1 = 95 and wagem >= 4 and wagem < 15) sex15 = 100.
+ compute tot1524 = 1.
end if.

variable labels sex15 "Percentage of women age 15-24 years who had sex before age 15 [2]".
variable labels tot1524 "".
value labels tot1524 1 "Number of women age 15-24 years".

* Only for women who had sex in the 12 months preceding the survey. 
* The age difference between the respondent and her partner is calculated by using information on the age(s) of partner(s) during the last 12 months (SB7and SB12).
* If the last sexual partner during this period is a husband or cohabiting partner, then the partner's age information is obtained from MA2 if the respondent is currently.
* married or living with a man or SB7 if not.
do if (SB1 <> 0 and (SB3U >= 1 and SB3U <= 3)).
+ compute difage10 = 0.
+ if ((SB5 = 1 or SB5 = 2 or SB10 = 1 or SB10 = 2) and MA2 <= 96 and MA2-WB2 >= 10) difage10 = 100.
+ if (SB5 <> 1 and SB5 <> 2 and SB7 <= 90 and SB7-WB2 >= 10) difage10 = 100.
+ if (SB8 = 1 and (SB10 <> 1 and SB10 <> 2) and SB12 <= 96 and SB12-WB2>= 10) difage10 = 100.
+ compute tot12 = 1.
end if.

variable labels difage10 "Percentage of women age 15-24 years who had sex in the last 12 months with a man 10 or more years older [3]".
value labels tot12 1 "Number of women age 15-24 years who had sex in the 12 months preceding the survey".
variable labels tot12 "".

recode mstatus (1,2 = 1) (3 = 2).
variable labels mstatus "Marital status".
value labels mstatus
  1 "Ever married/in union"
  2 "Never married/in union".

compute tot = 1.
variable labels tot "".
value labels tot 1 "Total".

* For labels in French uncomment commands below.

* variable labels sexnm15 "Pourcentage de jeunes femmes jamais mariées âgées de 15-24 ans qui n'ont jamais eu de rapports sexuels [1]".
* value labels totnm1524 1 "Nombre de femmes jamais mariées âgées de 15-24 ans".
* variable labels sex15 "Pourcentage de femmes âgées de 15-24 ans qui ont eu des rapports sexuels avant l'âge de 15 ans [2]".
* value labels tot1524 1 "Nombre de femmes âgées de 15-24 ans".
* variable labels difage10 "Pourcentage de femmes âgées de 15-24 ans qui ont eu des rapports sexuels au cours des 12 derniers mois avec un homme âgé de 10 ans ou plus [3]".
* value labels tot12 1 "Nombre de femmes âgées de 15-24 ans qui ont eu des rapports sexuels au cours des 12 mois précédant l'enquête".
* variable labels tot12 "".
* variable labels mstatus "Etat matrimonial".
* value labels mstatus
  1 "Déjà été mariée/vécu avec un homme"
  2 "N'a jamais été mariée/vécu avec un homme".

* ctables command in English (currently active, comment it out if using different language).
ctables
  /format empty = "na" missing = "na"
  /vlabels variables = tot totnm1524 tot1524 tot12 display = none
  /table hh7 [c] + hh6 [c] + wage [c] + mstatus [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   sexnm15 [s] [mean,'',f5.1] + totnm1524 [c] [count,'',f5.0] + sex15 [s] [mean,'',f5.1] + tot1524 [c] [count,'',f5.0] + 
	                  difage10 [s] [mean,'',f5.1] + tot12 [c] [count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
   "Table HA.8: Sexual behaviour that increases the risk of HIV infection"
		 "Percentage of never-married young women age 15-24 years who have never had sex, " +
   "percentage of young women age 15-24 years who have had sex before age 15, and percentage " +
   "of young women age 15-24 years who had sex with a man 10 or more years older during the last 12 months, " + surveyname
  caption=
	  "[1] MICS indicator 9.10"						
	  "[2] MICS indicator 9.11"						
	  "[3] MICS indicator 9.12"
   "na: Not applicable".

* ctables command in French.
* ctables
  /format empty = "na" missing = "na"
  /vlabels variables = tot totnm1524 tot1524 tot12 display = none
  /table hh7 [c] + hh6 [c] + wage [c] + mstatus [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   sexnm15 [s] [mean,'',f5.1] + totnm1524 [c] [count,'',f5.0] + sex15 [s] [mean,'',f5.1] + tot1524 [c] [count,'',f5.0] + 
	                  difage10 [s] [mean,'',f5.1] + tot12 [c] [count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
   "Tableau HA.8: Comportements sexuels augmentant le risque d'infection au VIH"
	  "Pourcentage de jeunes femmes jamais mariées âgées de 15-24 ans qui n'ont jamais eu de rapports sexuels, " + 
	  "pourcentage de jeunes femmes âgées de 15-24 ans qui ont eu des rapports sexuels avant l'âge de 15 ans, " + 
	  "et pourcentage de jeunes femmes âgées de 15-24 ans qui ont eu des rapports sexuels avec un homme plus âgé de " + 
	  "10 ans ou plus au cours des 12 derniers mois, " + surveyname
  caption=
	  "[1] Indicateur MICS 9.10"						
	  "[2] Indicateur MICS 9.11"						
	  "[3] Indicateur MICS 9.12"
   "na: Non applicable".

new file.
