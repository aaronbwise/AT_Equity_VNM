include "surveyname.sps".

get file = 'mm.sav'.

select if (MWM7 = 1).

weight by mmweight.

select if (mage = 1 or mage = 2).

do if ((mage = 1 or mage = 2) and mmstatus = 3).
+ compute sexnm15 = 0.
+ if (MSB1 = 0) sexnm15 = 100.
+ compute totnm1524 = 1.
end if.

variable labels sexnm15 "Percentage of never-married men age 15-24 years who have never had sex [1]".
variable labels totnm1524 "".
value labels totnm1524 1 "Number of never-married men age 15-24 years".

* Men age 15-24 who had sex before age 15 is calculated based on responses to MSB1 (MSB1<>0 AND MSB1<15).
* If the response is that the first time he had sex was when he started living with his first wife or partner (MSB1=95).
* then his age at first sex is calculated from the date of first marriage/union or age at first marriage/union.
do if (mage = 1 or mage = 2).
+ compute sex15 = 0.
+ if (MSB1 <> 0 and MSB1 < 15) sex15 = 100.
+ if (MSB1 = 95 and magem >= 4 and magem < 15) sex15 = 100.
+ compute tot1524 = 1.
end if.

variable labels sex15 "Percentage of men age 15-24 years who had sex before age 15 [2]".
variable labels tot1524 "".
value labels tot1524 1 "Number of men age 15-24 years".

* Only for men who had sex in the 12 months preceding the survey. 
* The age difference between the respondent and his partner is calculated by using information on the age(s) of partner(s) during the last 12 months (SB7and SB12).
* If the last sexual partner during this period is a wife or cohabiting partner, then the partner's age information is obtained from MA2 if the respondent is currently.
* married or living with a woman or SB7 if not.
do if (MSB1 <> 0 and (MSB3U >= 1 and MSB3U <= 3)).
+ compute difage10 = 0.
+ if ((MSB5 = 1 or MSB5 = 2 or MSB10 = 1 or MSB10 = 2) and MMA2 <= 96 and MMA2 - MWB2 >= 10) difage10 = 100.
+ if (MSB5 <> 1 and MSB5 <> 2 and MSB7 <= 90 and MSB7 - MWB2 >= 10) difage10 = 100.
+ if (MSB8 = 1 and (MSB10 <> 1 and MSB10 <> 2) and MSB12 <= 96 and MSB12 - MWB2>= 10) difage10 = 100.
+ compute tot12 = 1.
end if.

variable labels difage10 "Percentage of men age 15-24 years who had sex in the last 12 months with a woman 10 or more years older [3]".
value labels tot12 1 "Number of men age 15-24 years who had sex in the 12 months preceding the survey".
variable labels tot12 "".

recode mmstatus (1,2 = 1) (3 = 2).
variable labels mmstatus "Marital status".
value labels mmstatus
  1 "Ever married/in union"
  2 "Never married/in union".

compute tot = 1.
variable labels tot "".
value labels tot 1 "Total".

* For labels in French uncomment commands below.

* variable labels sexnm15 "Pourcentage de jeunes hommes jamais mariées âgées de 15-24 ans qui n'ont jamais eu de rapports sexuels [1]".
* value labels totnm1524 1 "Nombre de hommes jamais mariées âgées de 15-24 ans".
* variable labels sex15 "Pourcentage de hommes âgées de 15-24 ans qui ont eu des rapports sexuels avant l'âge de 15 ans [2]".
* value labels tot1524 1 "Nombre de hommes âgées de 15-24 ans".
* variable labels difage10 "Pourcentage de hommes âgées de 15-24 ans qui ont eu des rapports sexuels au cours des 12 derniers mois avec une femme âgé de 10 ans ou plus [3]".
* value labels tot12 1 "Nombre de hommes âgées de 15-24 ans qui ont eu des rapports sexuels au cours des 12 mois précédant l'enquête".
* variable labels tot12 "".
* variable labels mmstatus "Etat matrimonial".
* value labels mmstatus
  1 "Déjà été mariée/vécu avec une femme"
  2 "N'a jamais été mariée/vécu avec une femme".

* ctables command in English (currently active, comment it out if using different language).
ctables
  /format empty = "na" missing = "na"
  /vlabels variables =  tot totnm1524 tot1524 tot12 display = none
  /table hh7 [c] + hh6 [c] + mage [c] + mmstatus [c] + mmelevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   sexnm15 [s] [mean,'',f5.1] + totnm1524 [c] [count,'',f5.0] + sex15 [s] [mean,'',f5.1] + tot1524 [c] [count,'',f5.0] + 
	                  difage10 [s] [mean,'',f5.1] + tot12 [c] [count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
   "Table HA.8M: Sexual behaviour that increases the risk of HIV infection"
		 "Percentage of never-married young men age 15-24 years who have never had sex, " +
   "percentage of young men age 15-24 years who have had sex before age 15, and percentage " +
   "of young men age 15-24 years who had sex with a woman 10 or more years older during the last 12 months, " + surveyname
  caption=
	  "[1] MICS indicator 9.10"						
	  "[2] MICS indicator 9.11"						
	  "[3] MICS indicator 9.12"
   "na: Not applicable".

* ctables command in French.
* ctables
  /format empty = "na" missing = "na"
  /vlabels variables =  tot totnm1524 tot1524 tot12 display = none
  /table hh7 [c] + hh6 [c] + mage [c] + mmstatus [c] + mmelevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   sexnm15 [s] [mean,'',f5.1] + totnm1524 [c] [count,'',f5.0] + sex15 [s] [mean,'',f5.1] + tot1524 [c] [count,'',f5.0] + 
	                  difage10 [s] [mean,'',f5.1] + tot12 [c] [count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
   "Tableau HA.8M: Comportements sexuels augmentant le risque d'infection au VIH"
	  "Pourcentage de jeunes hommes jamais mariées âgées de 15-24 ans qui n'ont jamais eu de rapports sexuels, " + 
	  "pourcentage de jeunes hommes âgées de 15-24 ans qui ont eu des rapports sexuels avant l'âge de 15 ans, " + 
	  "et pourcentage de jeunes hommes âgées de 15-24 ans qui ont eu des rapports sexuels avec une femme plus âgé de " + 
	  "10 ans ou plus au cours des 12 derniers mois, " + surveyname
  caption=
	  "[1] Indicateur MICS 9.10"						
	  "[2] Indicateur MICS 9.11"						
	  "[3] Indicateur MICS 9.12"
   "na: Non applicable".

new file.
