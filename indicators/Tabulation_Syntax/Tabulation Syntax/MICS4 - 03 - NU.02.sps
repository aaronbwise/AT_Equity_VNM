* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

select if (CM13 = "Y" or CM13 = "O" or CM13 = "S").

* Calculate months since last birth IF last birth in last two years.
compute mslbrth = wdoi - wdoblc.
if (cm10 = 1) mslbrth = wdoi - wdobfc.
variable labels mslbrth "Months since last birth".

*Create a recoded months variable since last birth.
recode mslbrth (0 thru 11 = 1) (12 thru 23 = 2) into mslbrthr.
variable labels mslbrthr "Months since last birth".
value labels mslbrthr 1 "0-11 months" 2 "12-23 months".

compute ebrf = 0.
if (MN24 = 1) ebrf = 100.
variable labels ebrf "Percentage ever breastfed [1]".

compute w1hour = 0.
if ((MN25U = 1 and MN25N = 0) or MN25U  = 0) w1hour = 100.
variable labels w1hour "Percentage who were first breastfed: Within one hour of birth [2]".

compute w1day = 0.
if (MN25U = 0 or MN25U = 1) w1day = 100.
variable labels w1day "Percentage who were first breastfed:  Within one day of birth".

compute prelac = 0.
if (MN26 = 1) prelac = 100.
variable labels prelac "Percentage who received a prelacteal feed".

compute tot2 = 1.
value labels tot2 1 "Number of last-born children in the two years preceding the survey".

compute anc = 0.
if (MN17A = "A") anc = 11.
if (anc = 0 and MN17B = "B") anc = 12.
if (anc = 0 and MN17C = "C") anc = 13.
if (anc = 0 and MN17F = "F") anc = 21.
if (anc = 0 and MN17G = "G") anc = 22.
if (anc = 0 and MN17H = "H") anc = 23.
if (anc = 0 and MN17X = "X") anc = 96.
if (anc = 0 and MN17A = "?") anc = 97.
variable labels anc "Person assisting delivery".
value labels anc
  11 "Doctor"
  12 "Nurse / Midwife"
  13 "Auxiliary midwife"
  21 "Traditional birth attendant"
  22 "Community health worker"
  23 "Relative / Friend"
  96 "Other"
  97 "Missing".

compute skilled = 9.
if (anc = 11 or anc = 12 or anc = 13) skilled = 1.
if (anc = 21) skilled = 2.
if (anc = 22 or anc = 23 or anc = 96) skilled = 3.
variable labels skilled "Assistance at delivery".
value labels skilled
  1 "Skilled attendant"
  2 "Traditional birth attendant"
  3 "Other"
  9 "No one/Missing".

compute hfacility = 9.
if (MN18 >= 21 and MN18 <=26) hfacility = 1.
if (MN18 >= 31 and MN18 <= 39) hfacility = 2.
if (MN18 >= 11 and MN18 <= 12) hfacility = 3.
variable labels hfacility "Place of delivery".
value labels hfacility
  1 "Public sector health facility"
  2 "Private sector health facility"
  3 "Home"
  9 "Other/Missing".

compute tot1 = 1.
value labels tot1 1 " ".
variable labels tot1 "Total".

variable labels welevel "Mother’s education".

* For labels in French uncomment commands bellow.

* variable labels mslbrth "Mois depuis la naissance".
* value labels mslbrthr 1 "0-11 mois" 2 "12-23 mois".
* variable labels ebrf "Pourcentage de ceux ayant déjà été allaités au sein [1]".
* variable labels w1hour "Pourcentage de ceux ayant d'abord été allaités au sein: Dans l'heure qui a suivi la naissance [2]".
* variable labels w1day "Pourcentage de ceux ayant d'abord été allaités au sein: Dans la journée qui a suivi la naissance".
* variable labels prelac "Pourcentage de ceux ayant reçu une nourriture prélactée".
* value labels tot2 1 "Nombre d'enfants derniers-nés au cours des deux années précédant l'enquête".

* variable labels skilled "Assistance à l'accouchement".
* value labels skilled
  1 "Agent qualifié"
  2 "Accoucheuse traditionnelle"
  9 "Manquant".

* variable labels hfacility "Lieu d'accouchement".
* value labels hfacility
  1 "Structure sanitaire du secteur public"
  2 "Structure sanitaire du secteur privé"
  3 "A domicile"
  9 "Manquant".

* variable labels welevel "Instruction de la mère".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = tot2
     display = none
  /table hh7 [c] + hh6 [c] + mslbrthr [c] + skilled [c] + hfacility [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot1[c] by 
  		ebrf[s][mean,'',f5.1] +
                                    w1hour[s][mean,'',f5.1] +
  		w1day[s][mean,'',f5.1] +
	                  prelac[s][mean,'',f5.1] +
 		tot2[c][count,'',f5.0]
  /slabels position = column visable = no
  /categories var=all empty=exclude missing=exclude
  /titles title=
	"Table NU.2: Initial breastfeeding" 
	"Percentage of last-born children in the 2 years preceding the survey who were ever breastfed, " +
                  "percentage who were breastfed within one hour of birth and within one day of birth, " +
                  "and percentage who received a prelacteal feed, " + surveyname
  caption=
	"[1] MICS indicator 2.4"
                  "[2] MICS indicator 2.5".

* Ctables command in French.
*ctables
  /vlabels variables = tot2
     display = none
  /table hh7 [c] + hh6 [c] + mslbrthr [c] + skilled [c] + hfacility [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot1[c] by 
  		ebrf[s][mean,'',f5.1] +
                                    w1hour[s][mean,'',f5.1] +
  		w1day[s][mean,'',f5.1] +
	                  prelac[s][mean,'',f5.1] +
 		tot2[c][count,'',f5.0]
  /slabels position = column visable = no
  /categories var=all empty=exclude missing=exclude
  /titles title=
	"Tableau NU.2: Allaitement au sein initial" 
	"Pourcentage des derniers-nés au cours des 2 années précédant l'enquête et ayant été allaités au sein, " +
                  "pourcentage de ceux ayant été allaités dans heure qui a suivi la naissance et dans la journée qui a suivi la naissance,  " +
                  "et pourcentage de ceux ayant reçu une nourriture prélactée, " + surveyname
  caption=
	"[1] Indicateur MICS 2.4"
                  "[2] Indicateur MICS 2.5".				

new file.
