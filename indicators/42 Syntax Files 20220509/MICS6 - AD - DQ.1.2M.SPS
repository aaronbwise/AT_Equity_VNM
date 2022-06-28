* Encoding: windows-1252.

***.
* v02 - 2020-04-14. Subtitle has been changed. Labels in French and Spanish have been removed.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open household members data file.
get files="hl.sav".

* Household population of men in all households.
* Select male household members age 10 - 54.
select if (hl6 >= 10 and hl6 <= 54 and hl4 = 1). 

* Weight data by household weight.
weight by hhweight.

* Recode single age groups to 5 year age groups.
recode hl6 (10 thru 14 = 0)  (15 thru 19 = 1) (20 thru 24 = 2) (25 thru 29 = 3) (30 thru 34 = 4) 
	(35 thru 39 = 5) (40 thru 44 = 6) (45 thru 49 = 7) (50 thru 54 = 8) into hlage.
variable labels hlage "Age".
value labels hlage
  0 "10-14"
  1 "15-19"
  2 "20-24"
  3 "25-29"
  4 "30-34"
  5 "35-39"
  6 "40-44"
  7 "45-49"
  8 "50-54".

* Give value 1 to each men to calculate total number of men age 10-54.
compute t1054all = 1.

* Give value 1 to each men in selected household to calculate total number of men age 10-54 in selected households.
if (sysmis(HL9) = 0) t1054sel = 1.

* Give value 1 to each men 15-49 to calculate total number of eligible men for MN questionnaire.
if ((hl6 >= 15 and hl6 <= 49) and sysmis(HL9) = 0) t1549 = 1.

* Give value 1 to each men 10-14 to calculate total number of men in this age froup, for calculation of ratio of 15-19 to 10-14.
if (hl6 >= 10 and hl6 <= 14) t1014all = 1.
variable labels t1014all "Total (10-14)".

* Give value 1 to each men 15-19 to calculate total number of men in this age froup, for calculation of ratio of 15-19 to 10-14.
if (hl6 >= 15 and hl6 <= 19) t1519all = 1.
variable labels t1519all "Total (15-19)".

* Give value 1 to each men 15-49 to calculate total number of eligible men for MN questionnaire, for presenting the row in the table.
if (hl6 >= 15 and hl6 <= 49) total = 1.
variable labels total "Total (15-49)".
value labels total 1 " ".

* Give value 1 to each men 50-54 to calculate total number of men in this age froup, for calculation of ratio of 50-54 to 55-59.
if (hl6 >= 50 and hl6 <= 54) t5054all = 1.
variable labels t5054all "Total (50-54)".

* Give value 1 to each men 45-49 to calculate total number of men in this age froup, for calculation of ratio of 50-54 to 45-49.
if (hl6 >= 45 and hl6 <=49) t4549all = 1.
variable labels t4549all "Total (45-49)".

* Give value 1 to each men 50-54 in selected households to calculate total number of men in this age froup, for calculation of ratio of 50-54 to 55-59.
if ((hl6 >= 50 and hl6 <= 54) and (sysmis(HL9) = 0)) t5054sel = 1.
variable labels t5054sel "Total (50-54) in selected households".

* Give value 1 to each men 45-49 in selected households to calculate total number of men in this age froup, for calculation of ratio of 50-54 to 45-49.
if ( (hl6 >= 45 and hl6 <=49) and (sysmis(HL9) = 0) ) t4549sel = 1.
variable labels t4549sel "Total (45-49) in selected households".

* Give value 1 to each men 10-14 in selected households to calculate total number of men in this age froup, for calculation of ratio of 10-14 to 15-19.
if ((hl6 >= 10 and hl6 <= 14) and (sysmis(HL9) = 0)) t1014sel = 1.
variable labels t1014sel "Total (10-14) in selected households".

* Give value 1 to each men 15-19 in selected households to calculate total number of men in this age froup, for calculation of ratio of 10-14 to 15-19.
if ( (hl6 >= 15 and hl6 <= 19) and (sysmis(HL9) = 0) ) t1519sel = 1.
variable labels t1519sel "Total (15-19) in selected households".

* For each 5 years age group separately.
* Aggregate the hl data file to calculate the sum of men age 10-64 and age 15-59.
aggregate outfile ="tmp1.sav"
  /break   = hlage
  /tt1054all  = sum(t1054all)
  /tt1054sel = sum(t1054sel)
  /tt1549  = sum(t1549).

* For overall country.
* Aggregate the hl data file to calculate the sum of men age 10-54 and age 15-49, and age 50-54 and 45-49 for calculation of ratio of 50-54 to 45-49.
aggregate outfile = "tmp2.sav"
  /break   = total
  /tt1014all  = sum(t1014all)
  /tt1014sel  = sum(t1014sel)
  /tt1519all  = sum(t1519all)
  /tt1519sel  = sum(t1519sel)
  /tt1054all  = sum(t1054all)
  /tt1054sel  = sum(t1054sel)
  /tt1549  = sum(t1549)
  /tt5054all  = sum(t5054all)
  /tt4549all  = sum(t4549all)
  /tt5054sel  = sum(t5054sel)
  /tt4549sel  = sum(t4549sel).

* Add this summary information together in one data file.
get file = 'tmp1.sav'.
add files
  /file = *
  /file = 'tmp2.sav'.

sort cases by hlage total.
save outfile ="tmp1.sav".

* Open household members data file, and keep only the information needed for merging with the men data: cluster and household number, line number, age and weight.
get file="hl.sav"
 /keep HH1 HH2 HL1 HL6 hhweight
 /rename (HL1=LN).
sort cases hh1 hh2 ln.
save outfile ="tmp1c.sav".

* Open men data file.
get file="mn.sav".

* Sort cases by cluster number, household number and men line number.
sort cases by HH1 HH2 LN.

* Add the household member data: age (HL6) and household weight (hhweight) to a men data.
match files 
 /file=*
 /table='tmp1c.sav'
 /by HH1 HH2 LN.

* Select completed interviews.
select if (MWM17 = 1).

* Weight the data by the household weight.
weight by hhweight.

* Total variable.
compute total  = 1.
variable labels total "Total".
value labels total 1 "".

* Recode single age groups to 5 year age groups.
recode hl6 (10 thru 14 = 0)  (15 thru 19 = 1) (20 thru 24 = 2) (25 thru 29 = 3) (30 thru 34 = 4) 
	(35 thru 39 = 5) (40 thru 44 = 6) (45 thru 49 = 7) (50 thru 54 = 8) into hlage.
variable labels hlage "Age".
value labels hlage
  0 "10-14"
  1 "15-19"
  2 "20-24"
  3 "25-29"
  4 "30-34"
  5 "35-39"
  6 "40-44"
  7 "45-49"
  8 "50-54".                                   

* Give value 1 to each interviewed men 15-49.
compute t1549i = 0.
if (MWM17 = 1) t1549i = 1.

* For each 5 years age group separately.
* Aggregate the wm data file to calculate the sum of eligible men interviewed.
aggregate outfile ="tmp3.sav"
  /break   = hlage
  /tt1549i = sum(t1549i).

* For overall country.
* Aggregate the wm data file to calculate the sum of eligible men interviewed.
aggregate outfile = "tmp4.sav"
  /break   = total
  /tt1549i = sum(t1549i).

* Add this summary information together in one data file.
get file = 'tmp3.sav'.
add files
  /file = *
  /file = 'tmp4.sav'.

* Sort cases in the temporary file by age groups and total.
sort cases by hlage total.
save outfile="tmp3.sav".

* Add information from MN data file onto information from HL data file.
get file="tmp1.sav".
match files 
 /file=*
 /table='tmp3.sav'
 /by  hlage total.

variable labels tt1054all 'In all households'.
variable labels tt1054sel 'In selected households'.
variable labels tt1549i 'Interviewed men age 15-49 years'.

compute layertt = 1.
variable labels layertt " ".
value labels layertt 1 'Household population of men age 10-54 years'.

* Compute response rates for men. 
compute pelig = (tt1549i/tt1054sel)*100.
variable labels pelig " ".

* Compute ratio of 50-54 to 45-49.
* For all households.
compute temp5054all = lag (tt5054all).
compute temp1014all = lag (tt1014all).
do if total =1.
+ compute ratio1ALL = temp1014all/tt1519all.
+ variable labels ratio1ALL "Ratio of 10-14 to 15-19: In all households".
+ compute ratio2ALL = temp5054all/tt4549all.
+ variable labels ratio2ALL "Ratio of 50-54 to 45-49: In all households".
end if.

* For selected households.
compute temp1014sel = lag (tt1014sel).
compute temp5054sel = lag (tt5054sel).
do if total =1.
+ compute ratio1SEL = temp1014sel/tt1519sel.
+ variable labels ratio1SEL "Ratio of 10-14 to 15-19: In selected households".
+ compute ratio2SEL = temp5054sel/tt4549sel.
+ variable labels ratio2SEL "Ratio of 50-54 to 45-49: In selected households".
end if.

* Ctables command in English.
ctables
  /format missing = "na" 
  /vlabels variables = layertt pelig display = none
  /table hlage [c] + total [c] by 
           layertt [c] > ( tt1054all [s] [sum,'Number',f5.0] + tt1054sel [s] [sum,'Number',f5.0]) + 
           tt1549i [s] [sum,'Number',f5.0,tablepct.sum,'Percent',f5.1] + 
           pelig [s] [mean,'Percentage of eligible men interviewed (Completion rate)',f5.1] 
  /titles title=
  "Table DQ.1.2M: Age distribution of eligible and interviewed men"
  "Household population of men age 10-54 years, in all households and in households selected for men's interviews, interviewed men age 15-49 years, and percentage of eligible men who were interviewed, " + surveyname
   caption=
    "na: not applicable".		

* Ctables command in English.
ctables
  /table by ratio1ALL [s] [mean, '',f7.2] + ratio1SEL [s] [mean, '',f7.2] 
  /slabels position = row.

* Ctables command in English.
ctables
  /table by ratio2ALL [s] [mean, '',f7.2] + ratio2SEL [s] [mean, '',f7.2]
  /slabels position = row.

new file.
erase file 'tmp1.sav'.
erase file 'tmp1c.sav'.
erase file 'tmp2.sav'.
erase file 'tmp3.sav'.
erase file 'tmp4.sav'.


