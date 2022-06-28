* Encoding: UTF-8.

***.
* v02 - 2020-04-14. Subtitled has been changed. Labels in French and Spanish have been removed.
* v03 - 2020-09-09. Corrected line 211: to compute ratio3s = tt517s/temp14s.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open household members data file.
get files="hl.sav".

weight by hhweight.

* Select household population of age 3-20 years.
select if (hl6 >= 3 and hl6 <= 20).
compute age3 = 0.
if (HL6 = 3) age3 = 1.
compute age4 = 0.
if (HL6 = 4) age4 = 1.
compute age5 = 0.
if (HL6 = 5) age5 = 1.
compute age6 = 0.
if (HL6 = 6) age6 = 1.
compute age7 = 0.
if (HL6 = 7) age7 = 1.
compute age8 = 0.
if (HL6 = 8) age8 = 1.
compute age9 = 0.
if (HL6 = 9) age9 = 1.
compute age10 = 0.
if (HL6 = 10) age10 = 1.
compute age11 = 0.
if (HL6 = 11) age11 = 1.
compute age12 = 0.
if (HL6 = 12) age12 = 1.
compute age13 = 0.
if (HL6 = 13) age13 = 1.
compute age14 = 0.
if (HL6 = 14) age14 = 1.
compute age15 = 0.
if (HL6 = 15) age15 = 1.
compute age16 = 0.
if (HL6 = 16) age16 = 1.
compute age17 = 0.
if (HL6 = 17) age17 = 1.
compute age18 = 0.
if (HL6 = 18) age18 = 1.
compute age19 = 0.
if (HL6 = 19) age19 = 1.
compute age20 = 0.
if (HL6 = 20) age20 = 1.
compute age517 = 0.
if (HL6 >= 5 and HL6 <=17) age517 = 1.

* agreggating number of households with at least one child age 3, age 4, age 5 etc.
aggregate
  /outfile="tmphh.sav"
  /break=HH1 HH2 HL6
  /age3_h=max(age3) 
  /age4_h=max(age4) 
  /age5_h=max(age5) 
  /age6_h=max(age6) 
  /age7_h=max(age7) 
  /age8_h=max(age8) 
  /age9_h=max(age9) 
  /age10_h=max(age10) 
  /age11_h=max(age11) 
  /age12_h=max(age12) 
  /age13_h=max(age13) 
  /age14_h=max(age14) 
  /age15_h=max(age15) 
  /age16_h=max(age16) 
  /age17_h=max(age17) 
  /age18_h=max(age18) 
  /age19_h=max(age19) 
  /age20_h=max(age20)
  /age517_h=max(age517).

get file = "tmphh.sav".

* Give value 1 to each child to calculate total number of children age 5-17.
compute total = 1.
variable labels total "Total (5-17)".
value labels total 1 " ".

aggregate outfile ="tmp1.sav"
  /break   = total
  /tt517  = sum(age517_h)
  /age3_t=sum(age3_h) 
  /age4_t=sum(age4_h) 
  /age5_t=sum(age5_h) 
  /age6_t=sum(age6_h) 
  /age7_t=sum(age7_h) 
  /age8_t=sum(age8_h) 
  /age9_t=sum(age9_h) 
  /age10_t=sum(age10_h) 
  /age11_t=sum(age11_h) 
  /age12_t=sum(age12_h) 
  /age13_t=sum(age13_h) 
  /age14_t=sum(age14_h) 
  /age15_t=sum(age15_h) 
  /age16_t=sum(age16_h) 
  /age17_t=sum(age17_h) 
  /age18_t=sum(age18_h) 
  /age19_t=sum(age19_h) 
  /age20_t=sum(age20_h).

get file = "tmp1.sav".

varstocases /make ageHL from tt517 to age20_t.

save outfile = "tmp2.sav".

* Open household members data file, and keep only the information needed for merging with the children data: cluster and household number, line number, age and weight.
get file="hl.sav"
 /keep HH1 HH2 HL1 HL6 hhweight
 /rename (HL1=LN).
sort cases hh1 hh2 ln.
save outfile ="tmp1c.sav".

* Open fs data file.
get file="fs.sav".

* Sort cases by cluster number, household number and child line number.
sort cases by HH1 HH2 LN.

* Add the household member data: age (HL6) and household weight (hhweight) to a child data.
match files 
 /file=*
 /table='tmp1c.sav'
 /by HH1 HH2 LN.

* Weight the data by the household weight.
weight by hhweight.

* Total variable.
compute total  = 1.
variable labels total "Total".
value labels total 1 "".

* labels ages 3-20 from the added hl file.
compute hlage = hl6.
variable labels hlage "Age".

compute t517s = 1.
* Give value 1 to each interviewed mother/caretaker of a child 5-17.
compute t517i = 0.
if (FS17 = 1) t517i = 1.

* For each age separately.
* Aggregate the fs data file to calculate the sum of eligible children interviewed.
aggregate outfile ="tmp3.sav"
  /break   = hlage
  /tt517s = sum(t517s)
  /tt517i = sum(t517i).

* For overall country.
* Aggregate the fs data file to calculate the sum of eligible children interviewed.
aggregate outfile = "tmp4.sav"
  /break   = total
  /tt517s = sum(t517s)
  /tt517i = sum(t517i).

* Add this summary information together in one data file.
get file = 'tmp3.sav'.
add files
  /file = *
  /file = 'tmp4.sav'.

sort cases by hlage total.
if sysmis(hlage) hlage = 2.
save outfile="tmp3.sav".

* Add information from FS data file onto information from HL data file.
get file="tmp2.sav".
compute hlage = $casenum+1.
if hlage <> 2 total = $sysmis.

match files 
 /file=*
 /table='tmp3.sav'
 /by  hlage total.

variable labels ageHL 'Number of households with at least one household member age 3-20 years [A]'.
variable labels tt517i '5-17s with completed interviews'.
variable labels tt517s 'Percent distribution of children selected for interview'.

* Compute response rates for children. 
compute pelig = (tt517i/tt517s)*100.
variable labels pelig " ".

* Compute ratio of 4 to 5, 6 to 7, 15 to 14, 18 to 17.
if hlage = 5 temp4 = lag (ageHL).
if hlage = 7 temp6 =  lag (ageHL).
if hlage = 15 temp14 =  lag (ageHL).
if hlage = 18 temp17 = lag (ageHL).
if hlage = 7 temp6s =  lag (tt517s).
if hlage = 15 temp14s =  lag (tt517s).
compute ratio1 = temp4/ageHL.
variable labels ratio1 "Ratio of 4 to 5".
compute ratio2 = temp6/ageHL.
variable labels ratio2 "Ratio of 6 to 7".
compute ratio3 = ageHL/temp14.
variable labels ratio3 "Ratio of 15 to 14".
compute ratio4 = ageHL/temp17.
variable labels ratio4 "Ratio of 18 to 17".

compute ratio2s = temp6s/tt517s.
variable labels ratio2s "Ratio of 6 to 7".
compute ratio3s = tt517s/temp14s.
variable labels ratio3s "Ratio of 15 to 14".

recode hlage (2 = sysmis)(else = copy).
formats hlage (f2.0).	

* Ctables command in English.
ctables
  /format missing = "na" 
  /vlabels variables = pelig display = none
  /table hlage [c] + total [c] by 
           agehl [s] [sum,'',f5.0] + 
           tt517s [s] [tablepct.sum,'',f5.1] + 
           tt517i [s] [sum,'Number',f5.0,tablepct.sum,'Percent',f5.1] + 
           pelig [s] [mean,'Percentage of eligible 5-17s with completed interviews (Completion rate)',f5.1] 
  /titles title=
  "Table DQ.1.4: Age distribution of children age 3-20 in households and 5-17 questionnaires" 
  "Number of households with at least one member age 3-20 years, percent distribution of children selected for interview " +
  "and number and percent of children age 5-17 years whose mothers/caretakers were interviewed, " + surveyname
  caption = "na = not applicable"
  "[A] Number of cases are used to calculate the ‘Ratio of 6 to 7’ and ‘Ratio of 15 to14’".

ctables
  /table ratio1 [s] [mean, '',f7.2]
  /slabels position = row.  

ctables
  /table by ratio2 [s] [mean, '',f7.2] + ratio2s [s] [mean, '',f7.2]
  /slabels position = row.

ctables
  /table by ratio3 [s] [mean, '',f7.2] + ratio3s [s] [mean, '',f7.2]
  /slabels position = row.

ctables
  /table ratio4 [s] [mean, '',f7.2]
  /slabels position = row.  

new file.

erase file 'tmphh.sav'.
erase file 'tmp1.sav'.
erase file 'tmp1c.sav'.
erase file 'tmp2.sav'.
erase file 'tmp3.sav'.
erase file 'tmp4.sav'.
