* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = "tn.sav".

sort cases by HH1 HH2.

compute longtreat = 0.
if (TN5 >=11 and TN5 <= 18) longtreat = 100.
variable labels  longtreat "Percentage of households with at least one long-lasting treated net".

compute itn = 0.
if (TN5 >=11 and TN5 <= 18) itn = 100.
if (TN5 >=21 and TN5 <= 28 and TN6 <12) itn = 100.
if ((TN5 >= 31 or TN5 = 98) and TN6 <12 and TN8 = 1) itn = 100.
if (TN5 >= 21 and TN5 <=98 and TN9 = 1 and TN10 < 12) itn = 100.
variable labels  itn "Percentage of households with at least one ITN [1]".

aggregate outfile = "tmp.sav"
  /break=HH1 HH2
  /longtreat=max(longtreat)
  /itn=max(itn).

get file = 'hh.sav'.

sort cases by HH1 HH2.

match files 
  /file=*
  /table='tmp.sav'
  /by hh1 hh2.

select if (HH9 = 1).

weight by hhweight.

compute total = 1.
value labels total  1 "Number of households".
variable labels  total "".

recode longtreat (sysmis = 0) (else = copy).

recode itn (sysmis = 0) (else = copy).

compute netpresent = 0.
if (TN1 = 1) netpresent = 100.
variable labels  netpresent "Percentage of households with at least one mosquito net".

compute itnirs = 0.
if (itn = 100 or IR1 = 1) itnirs = 100.
variable labels  itnirs "Percentage of households with at least one ITN or received IRS during the last 12 months [2]".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

* For labels in French uncomment commands bellow.
* variable labels  longtreat " Pourcentage des ménages ayant au moins une moustiquaire imprégnée de longue durée".
* variable labels  itn "Pourcentage des ménages ayant au moins une MI [1]".
* value labels total  1 "Nombre des ménages".
* variable labels  netpresent " Pourcentage des ménages ayant au moins une moustiquaire".
* variable labels  itnirs " Pourcentage des ménages ayant au moins une MI ou reçu une PRI au cours des 12 derniers mois [2]".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables =  total tot
         display = none
  /table hh7 [c] + hh6 [c] + helevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
   	netpresent [s] [mean,'',f5.1] + longtreat [s] [mean,'',f5.1] +  itn [s] [mean,'',f5.1] +  itnirs [s] [mean,'',f5.1] + total [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
   "Table CH.11: Household availability of insecticide treated nets and protection by a vector control methods"
		"Percentage of households with at least one mosquito net, percentage of households " +
                                    "with at least one long-lasting treated net, percentage of households with at least one " +
                                     "insecticide treated net (ITN) and percentage of households which either have at least one " +
                                     "ITN or have received spraying through an indoor residual spraying (IRS) campaign in the last 12 months, "
                                    + surveyname
  caption =
   "[1] MICS indicator 3.12, [2] MICS indicator 3.13".

* Ctables command in French.
*
ctables
  /vlabels variables =  total tot
         display = none
  /table hh7 [c] + hh6 [c] + helevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
   	netpresent [s] [mean,'',f5.1] + longtreat [s] [mean,'',f5.1] +  itn [s] [mean,'',f5.1] +  itnirs [s] [mean,'',f5.1] + total [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
   "Tableau CH.11: Disponibilité  de moustiquaires imprégnées au niveau des ménages et protection par une méthode de lutte contre le vecteur"
		"Pourcentage de ménages ayant au moins une moustiquaire, pourcentage de ménages ayant au moins une moustiquaire " +
                                    " imprégnée de longue durée, pourcentage de ménages ayant au moins une moustiquaire imprégnée (MI) " +
                                     "et pourcentage de ménages qui ont soit eu au moins une MI soit bénéficié d'une pulvérisation lors d'une campagne " +
                                     "de pulvérisation résiduelle intra-domiciliaire (PRI) au cours des 12 derniers mois, "
                                    + surveyname
  caption =
   "[1] Indicateur MICS 3.12, [2] Indicateur MICS 3.13".

new file.

* erase working file.
erase file = "tmp.sav".