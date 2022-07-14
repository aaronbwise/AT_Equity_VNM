* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open the household data file.
get file = 'hh.sav'.

* Give value 1 to each HH to calculate total number of hhs sampled.
compute sampled = 1.

* Give value 1 to each HH occupied to calculate total number of hhs occupied.
recode HH9 (1,2,4,7 = 1) (else = 0) into occupied.

* Give value 1 to each hh interviewed to calculate total no of interviewed HHs.
recode HH9 (1 = 1) (else = 0) into complete.

compute total = 1.
variable label total "".
value label total 1 "Total".

* For urban and rural separately.
* Aggregate the hh data file to calculate the sum of sampled, occupied, complete HHs.
* and sum of eligible and interviewed women age 15-49 and children under age 5.
aggregate outfile = 'tmp1.sav'
  /break   = HH6
  /hhsamp  = sum(sampled)
  /hhoccup = sum(occupied)
  /hhcomp  = sum(complete)
  /women   = sum(HH12)
  /cwomen  = sum(HH13)
  /men   = sum(HH13A)
  /cmen  = sum(HH13B)
  /kids    = sum(HH14)
  /ckids   = sum(HH15).

* For each region separately.
* Aggregate the hh data file to calculate the sum of sampled, occupied, complete HHs.
* and sum of eligible and interviewed women age 15-49 and children under age 5.
aggregate outfile = 'tmp2.sav'
  /break   = HH7
  /hhsamp  = sum(sampled)
  /hhoccup = sum(occupied)
  /hhcomp  = sum(complete)
  /women   = sum(HH12)
  /cwomen  = sum(HH13)
  /men   = sum(HH13A)
  /cmen  = sum(HH13B)
  /kids    = sum(HH14)
  /ckids   = sum(HH15).

* For overall country.
* Aggregate the hh data file to calculate the sum of sampled, occupied, complete HHs.
* and sum of eligible and interviewed women age 15-49 and children under age 5.
aggregate outfile = 'tmp3.sav'
  /break   = total
  /hhsamp  = sum(sampled)
  /hhoccup = sum(occupied)
  /hhcomp  = sum(complete)
  /women   = sum(HH12)
  /cwomen  = sum(HH13)
  /men   = sum(HH13A)
  /cmen  = sum(HH13B)
  /kids    = sum(HH14)
  /ckids   = sum(HH15).

* Add this summary information together in one data file.
get file = 'tmp1.sav'.
add files
  /file = *
  /file = 'tmp2.sav'
  /file = 'tmp3.sav'.

* Compute response rates for HH, Women and Under5. 
compute hhrr = (hhcomp/hhoccup)*100.
compute wmrr = (cwomen/women)*100.
compute orw = (hhrr*wmrr)/100.
compute mrr = (cmen/men)*100.
compute orm = (hhrr*mrr)/100.
compute chrr = (ckids/kids)*100.
compute orc = (hhrr*chrr)/100.

* Labels in English.
variable label
  hhsamp   "Households Sampled"
  /hhoccup "Households Occupied"
  /hhcomp  "Households Interviewed"
  /women   "Women Eligible"
  /cwomen  "Women Interviewed"
  /men   "Men Eligible"
  /cmen  "Men Interviewed"
  /kids    "Children under 5 Eligible"
  /ckids   "Children under 5 Mother/Caretaker Interviewed "
  /hhrr "Household response rate"
  /wmrr "Women's response rate"
  /orm "Men's overall response rate"
  /mrr "Men's response rate"
  /orw "Women's overall response rate"
  /chrr "Under-5's response rate"
  /orc "Under-5's overall response rate".
  
* Labels in French.
* Please uncomment this part if presenting labels in French.
*variable label
  hhsamp   "Ménages Echantillonnés"
  /hhoccup "Ménages Occupés"
  /hhcomp  "Ménages Interviewés"
  /women   "Femmes Eligibles"
  /cwomen  "Femmes Interviewées"
  /men   "Men Eligible"
  /cmen  "Men Interviewed"
  /kids    "Enfants de moins de 5 ans Eligibles"
  /ckids   "Enfants de moins de 5 ans Mères/gardiennes interviewées"
  /hhrr "Taux de réponse des ménages"
  /wmrr "Taux de réponse des femmes"
  /orw "Taux de réponse global des femmes"
  /orm "Men's overall response rate"
  /mrr "Men's response rate"
  /chrr "Taux de réponse des enfants <5 ans"
  /orc "Taux de réponse global des enfants <5 ans".

* Ctables command in English (currently active, comment it out if using different language).
ctables
 /vlabels variables=total display=none
 /table hhsamp[s][mean,'',f5.0] + 
          hhoccup [s] [mean,'',f5.0] + 
          hhcomp [s] [mean,'',f5.0] + 
          hhrr [s] [mean,'',f5.1] +
          women [s] [mean,'',f5.0] + 
          cwomen [s] [mean,'',f5.0] +
          wmrr [s] [mean,'',f5.1] +
          orw [s] [mean,'',f5.1] +
          men [s] [mean,'',f5.0] + 
          cmen [s] [mean,'',f5.0] +
          mrr [s] [mean,'',f5.1] +
          orm [s] [mean,'',f5.1] +
          kids [s] [mean,'',f5.0] + 
          ckids [s] [mean,'',f5.0] +
          chrr [s] [mean,'',f5.1] +
          orc [s] [mean,'',f5.1] 
          by hh6 [c] + hh7 [c] + total [c] 
 /slabels visible = no
 /categories var=all empty=exclude missing=exclude
 /title title=  
    	"Table HH.1: Results of household, women's, men's and under-5 interviews" 
		"Number of households, women, men, and children under 5 by results of the household, "+
		"women's, men's and under-5's interviews, and household, women's, men's "+
		" and under-5's response rates, " + surveyname.

* Ctables command in French.
*
ctables
 /vlabels variables=total display=none
 /table hhsamp[s][mean,'',f5.0] + 
          hhoccup [s] [mean,'',f5.0] + 
          hhcomp [s] [mean,'',f5.0] + 
          hhrr [s] [mean,'',f5.1] +
          women [s] [mean,'',f5.0] + 
          cwomen [s] [mean,'',f5.0] +
          wmrr [s] [mean,'',f5.1] +
          orw [s] [mean,'',f5.1] +
          men [s] [mean,'',f5.0] + 
          cmen [s] [mean,'',f5.0] +
          mrr [s] [mean,'',f5.1] +
          orm [s] [mean,'',f5.1] +
          kids [s] [mean,'',f5.0] + 
          ckids [s] [mean,'',f5.0] +
          chrr [s] [mean,'',f5.1] +
          orc [s] [mean,'',f5.1] 
          by hh6 [c] + hh7 [c] + total [c] 
 /slabels visible = no
 /categories var=all empty=exclude missing=exclude
 /title title=  
 	"Tableau HH.1: Résultats des interviews des ménages, femmes, hommes et enfants de moins de 5 ans"									
		"Nombre de ménages, femmes, hommes, enfants de moins de 5 ans selon les résultats des interviews ménages, " +
		"femmes, hommes et enfants de moins de 5 ans, des taux de réponse des ménages, femmes, hommes " +
		"et enfants de moins de 5 ans, " + surveyname.								

new file.

* Delete temporary working files.
erase file = 'tmp1.sav'.
erase file = 'tmp2.sav'.
erase file = 'tmp3.sav'.
