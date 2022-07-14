include "surveyname.sps".

get file = 'hh.sav'.

select if (HH9 = 1).

compute hhweight1 = HH11*hhweight.

weight by hhweight1.

recode WS8 (11,12,13,15,21,22,31 = 1) (95 = 3) (else = 2) into type.
variable labels  type "Type of toilet facility used by household".
value labels type 
  1 "Users of improved sanitation facilities" 
  2 "Users of unimproved sanitation facilities"
  3 "Open defecation (no facility, bush field)".

do if (type = 1).
+ recode WS11 (1 thru 5 = 2) (98,99 = 9) (sysmis = 0) (else = 3) into shared1.
+ if (WS10 = 2) shared1 = 1.
end if.
variable labels shared1 "Users of improved sanitation facilities".
value labels shared1
  0 "Not shared [1]"
  1 "Public facility"
  2 "Shared by: 5 households or less"
  3 "Shared by: More than 5 households"
  9 "Missing/DK".

do if (type = 2).
+ recode WS11 (1 thru 5 = 2) (98,99 = 9) (sysmis = 0) (else = 3) into shared2.
+ if (WS10 = 2) shared2 = 1.
end if.
variable labels shared2 "Users of unimproved sanitation facilities".
value labels shared2
  0 "Not shared"
  1 "Public facility"
  2 "Shared by: 5 households or less"
  3 "Shared by: More than 5 households"
  9 "Missing/DK".

do if (type = 3).
+ compute shared3 = 1.
end if.
variable labels  shared3 "".
value labels shared3 1 "Open defecation (no facility, bush field)".

compute total = 1.
variable labels  total "Number of household members".
value labels total 1 " ".

compute tot1 = 1.
variable labels  tot1 "Total".
value labels tot1 1 " ".

compute tot2 = 100.
variable labels  tot2 "Total".
value labels tot2 100 " ".

* For labels in French uncomment commands bellow.

* variable labels  type "Type of toilet facility used by household".
* value labels type 
  1 "Users of improved sanitation facilities" 
  2 "Users of unimproved sanitation facilities"
  3 "Open defecation (no facility, bush field)".
* variables labels shared1 " Utilisateurs de toilettes améliorées".
* value lables shared1
  0 " Non partagées [1]"
  1 " Toilette publique"
  2 " Partagées par: 5 ménages au moins"
  3 " Partagées par: Plus de 5 ménages"
  9 " Manquant/NSP".
* variables labels shared2 " Utilisation de toilettes non améliorées".
* value lables shared2
  0 " Non partagées"
  1 " Toilette publique"
  2 " Partagées par: 5 ménages au moins"
  3 " Partagées par: Plus de 5 ménages"
  9 " Manquant/NSP".
* value labels shared3 1 " Défécation ouverte (pas de toilettes, brousse, champ)".
* variable labels  total " Nombre des membres de ménages".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = shared3
             display = none
  /table hh7 [c] + hh6[c] + helevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
                  shared1 [c] [rowpct.totaln,'',f5.1] + shared2 [c] [rowpct.totaln,'',f5.1] + 
                      shared3 [c] [rowpct.totaln,'',f5.1] + tot2 [s] [mean,'',f5.1] + total[s][sum,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table WS.6: Use and sharing of sanitation facilities"
		"Percent distribution of household population by use of private and public sanitation facilities "+
                                    "and use of shared facilities, by users of improved and unimproved sanitation facilities, " + surveyname
  caption = 
     "[1] MICS indicator 4.3; MDG indicator 7.9".

* Ctables command in French.
*
ctables
  /vlabels variables = shared3
             display = none
  /table hh7 [c] + hh6[c] + helevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
                  shared1 [c] [rowpct.totaln,'',f5.1] + shared2 [c] [rowpct.totaln,'',f5.1] + 
                      shared3 [c] [rowpct.totaln,'',f5.1] + tot2 [s] [mean,'',f5.1] + total[s][sum,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Tableau WS.6: Utilisation partagée de toilettes"
		"Répartition en pourcentage des populations de ménages selon l'utilisation de toilettes publiques et privées et l'utilisation de toilettes partagées, "+
                                    "par des utilisateurs de toilettes améliorées ou non améliorées, " + surveyname
  caption = 
     "[1] Indicateur MICS 4.3; Indicateur OMD 7.9".
								
new file.

