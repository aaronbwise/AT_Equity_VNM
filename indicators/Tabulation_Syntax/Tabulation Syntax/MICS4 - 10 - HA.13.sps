include "surveyname.sps".

get file = 'hl.sav'.

weight by hhweight.

select if (HL6 >= 10 and HL6 <= 14).

compute total  = 1.
variable labels total "".
value labels total 1 "Total".

compute mfdead = 0.
if (HL11 = 2 and HL13 = 2) mfdead = 100.
variable labels mfdead "Percentage of children whose mother and father have died (orphans)".

do if (mfdead = 100).
+ compute tmfdead = 1.
end if.

compute school = 0.
if (ED5 = 1) school = 100.
variable labels school "Attending school".

do if (mfdead = 100).
+ compute school1 = 0.
+ if (school = 100) school1 = 100.
+ compute tschool1 = 0.
+ if (school = 100) tschool1 = 1.
end if.
variable labels school1 "Percentage of children who are orphans and are attending school [1]".

compute liveone = 0.
if (HL11 = 1 and HL13 = 1 and (HL12 <> 0 or HL14 <> 0)) liveone = 100.
variable labels liveone "Percentage of children of whom both parents are alive and child is living with at least one parent (non-orphans)".

do if (liveone = 100).
+ compute tliveone = 1.
end if.

do if (liveone = 100).
+ compute school2 = 0.
+ if (school = 100) school2 = 100.
+ compute tschool2 = 0.
+ if (school2 = 100) tschool2 = 1.
end if.
variable labels school2 "Percentage of children who are non-orphans and are attending school [2]".

* For labels in French uncomment commands below.

*variable labels mfdead "Pourcentage d'enfants dont la mère et le père sont décédés (orphelin)".
*variable labels school "Fréquentent l'école".
*variable labels school1 "Pourcentage d'enfants qui sont orphelins et fréquentent l'école [1]".
*variable labels liveone "Pourcentage d'enfants dont les deux parents sont en vie et l'enfant vit avec au moins un parent (non-orphelin)".
*variable labels school2 "Pourcentage d'enfants qui sont non orphelins et fréquentent l'école [2]".

aggregate outfile = 'tmp1.sav'
  /break HL4
  /tot2  = mean(mfdead)
  /tot2a = sum(tmfdead)
  /tot3  = mean(school1)
  /tot3a = sum(tschool1)
  /tot4  = mean(liveone)
  /tot4a  = sum(tliveone)
  /tot5  = mean(school2)
  /tot5a = sum(tschool2)
  /tot6 = sum(total).

aggregate outfile = 'tmp2.sav'
  /break HH6
  /tot2  = mean(mfdead)
  /tot2a = sum(tmfdead)
  /tot3  = mean(school1)
  /tot3a = sum(tschool1)
  /tot4  = mean(liveone)
  /tot4a  = sum(tliveone)
  /tot5  = mean(school2)
  /tot5a = sum(tschool2)
  /tot6 = sum(total).

aggregate outfile = 'tmp3.sav'
  /break total
  /tot2  = mean(mfdead)
  /tot2a = sum(tmfdead)
  /tot3  = mean(school1)
  /tot3a = sum(tschool1)
  /tot4  = mean(liveone)
  /tot4a  = sum(tliveone)
  /tot5  = mean(school2)
  /tot5a = sum(tschool2)
  /tot6 = sum(total).

get file = 'tmp1.sav'.
add files
  /file = *
  /file = 'tmp2.sav'
  /file = 'tmp3.sav'.

variable labels tot2 "Percentage of children whose mother and father have died (orphans)".
variable labels tot2a "Total number of orphan children age 10-14 years".
variable labels tot3 "Percentage of children who are orphans and are attending school [1]".
variable labels tot3a "Total number of orphan children age 10-14 years".
variable labels tot4 "Percentage of children of whom both parents are alive and child is living with at least one parent (non-orphans)".
variable labels tot4a "Total number of non-orphan children age 10-14 years".
variable labels tot5 "Percentage of children who are non-orphans and are attending school [2]".
variable labels tot6 "Number of children age 10-14 years".

compute ratio1 = tot3/tot5.
variable labels ratio1 "Orphans to non-orphans school attendance ratio".

* For labels in French uncomment commands below.

* variable labels tot2 "Pourcentage d'enfants dont la mère et le père sont décédés (orphelin)".
* variable labels tot2a "Nombre total d'enfants orphelins âgés de 10-14 ans".
* variable labels tot3 "Pourcentage d'enfants qui sont orphelins et fréquentent l'école [1]".
* variable labels tot3a "Nombre total d'enfants orphelins âgés de 10-14 ans".
* variable labels tot4 "Pourcentage d'enfants dont les deux parents sont en vie et l'enfant vit avec au moins un parent (non-orphelin)".
* variable labels tot4a "Nombre total d'enfants non orphelins âgés de 10-14 ans".
* variable labels tot5 "Pourcentage d'enfants qui sont non orphelins et fréquentent l'école [2]".
* variable labels tot6 "Nombre d'enfants âgés de 10-14 ans".
* variable labels ratio1 "Ratio de fréquentation scolaire orphelins-non orphelins".

* ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = total display = none
  /table hl4 [c] + hh6 [c] + total [c] by 
              tot2 [s] [mean,'',f5.1] + tot4 [s] [mean,'',f5.1] + tot6 [s] [sum,'',f5.0] + 
              tot3 [s] [mean,'',f5.1] + tot2a [s] [sum,'',f5.0] + 
              tot5 [s] [mean,'',f5.1] + tot4a [s] [sum,'',f5.0] + 
              ratio1 [s] [mean,'',f5.2] 
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
   "Table HA.13: School attendance of orphans and non-orphans"
		 "School attendance of children age 10-14 years by orphanhood, " + surveyname
  caption=
   "[1] MICS indicator 9.19; MDG indicator 6.4"
   "[2] MICS indicator 9.20; MDG indicator 6.4".

* ctables command in French.
* ctables
  /vlabels variables = total display = none
  /table hl4 [c] + hh6 [c] + total [c] by 
              tot2 [s] [mean,'',f5.1] + tot4 [s] [mean,'',f5.1] + tot6 [s] [sum,'',f5.0] + 
              tot3 [s] [mean,'',f5.1] + tot2a [s] [sum,'',f5.0] + 
              tot5 [s] [mean,'',f5.1] + tot4a [s] [sum,'',f5.0] + 
              ratio1 [s] [mean,'',f5.2] 
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
   "Tableau HA.13: Fréquentation scolaire des orphelin (e)s et des non orphelin (e)s"
	  "Fréquentation scolaire des enfants âgés de 10-14 ans par état d'orphelin (e), " + surveyname
  caption=
   "[1] Indicateur MICS 9.19; Indicateur OMD 6.4"
   "[2] Indicateur MICS 9.20; Indicateur OMD 6.4".

new file.

*delete working files.
erase file = 'tmp1.sav'.
erase file = 'tmp2.sav'.
erase file = 'tmp3.sav'.
