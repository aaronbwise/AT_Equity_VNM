* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open household members data file.
get files="hl.sav".

* Select female household members age 10 - 54.
select if (hl6 >= 10 and hl6 <= 54 and hl4 = 2).

* Recode single age groups to 5 year age groups.
recode hl6 (10 thru 14 = 0)  (15 thru 19 = 1) (20 thru 24 = 2) (25 thru 29 = 3) (30 thru 34 = 4) 
	(35 thru 39 = 5) (40 thru 44 = 6) (45 thru 49 = 7) (50 thru 54 = 8) into hlage.
variable label hlage "Age".
value label hlage
  0 "10-14"
  1 "15-19"
  2 "20-24"
  3 "25-29"
  4 "30-34"
  5 "35-39"
  6 "40-44"
  7 "45-49"
  8 "50-54".

* Weight the data by the household weight.
weight by hhweight.

* Give value 1 to each women to calculate total number of women age 10-54.
compute t1054 = 1.

* Give value 1 to each women 15-49 to calculate total number of eligible women for WM questioannire.
if (hl6 >= 15 and hl6 <= 49) t1549 = 1.

* Give value 1 to each women 15-49 to calculate total number of eligible women for WM questioannire, for presenting the row in the table.
if (hl6 >= 15 and hl6 <= 49) total = 1.
variable labels total "Total (15-49)".
value labels total 1 " ".

* Give value 1 to each women 50-54 to calculate total number of women in this age froup, for calculation of ratio of 50-54 to 45-49.
if (hl6 >= 50 and hl6 <= 54) t5054 = 1.
variable labels t5054 "Total (50-54)".

* Give value 1 to each women 45-49 to calculate total number of women in this age froup, for calculation of ratio of 50-54 to 45-49.
if (hl6 >= 45 and hl6 <=49) t4549 = 1.
variable labels t4549 "Total (45-49)".

* For each 5 years age group separately.
* Aggregate the hl data file to calculate the sum of women age 10-54 and age 15-49.
aggregate outfile ="tmp1.sav"
  /break   = hlage
  /tt1054  = sum(t1054)
  /tt1549  = sum(t1549).

* For overall country.
* Aggregate the hl data file to calculate the sum of women age 10-54 and age 15-49, and age 50-54 and 45-49 for calculation of ratio of 50-54 to 45-49.
aggregate outfile = "tmp2.sav"
  /break   = total
  /tt1054  = sum(t1054)
  /tt1549  = sum(t1549)
  /tt5054  = sum(t5054)
  /tt4549  = sum(t4549).

* Add this summary information together in one data file.
get file = 'tmp1.sav'.
add files
  /file = *
  /file = 'tmp2.sav'.

sort cases by hlage total.
save outfile ="tmp1.sav".

* Open household members data file, and keep only the information needed for merging with the women data: cluster and household number, line number, age and weight.
get file="hl.sav"
 /keep HH1 HH2 HL1 HL6 hhweight
 /rename (HL1=LN).
sort cases hh1 hh2 ln.
save outfile ="tmp1c.sav".

* Open women data file.
get file="wm.sav".

* Sort cases by cluster number, household number and women line number.
sort cases by HH1 HH2 LN.

* Add the household member data: age (HL6) and household weight (hhweight) to a women data.
match files 
 /file=*
 /table='tmp1c.sav'
 /by HH1 HH2 LN.

* Select completed interviews.
select if (WM7 = 1).

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

* Give value 1 to each interviewed women 15-49.
compute t1549i = 0.
if (WM7 = 1) t1549i = 1.

* For each 5 years age group separately.
* Aggregate the wm data file to calculate the sum of eligible women interviewed.
aggregate outfile ="tmp3.sav"
  /break   = hlage
  /tt1549i = sum(t1549i).

* For overall country.
* Aggregate the wm data file to calculate the sum of eligible women interviewed.
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

* Add information from WM data file onto information from HL data file.
get file="tmp1.sav".
match files 
 /file=*
 /table='tmp3.sav'
 /by  hlage total.

variable labels tt1054 'Household population of women age 10-54 years'.
variable labels tt1549i 'Interviewed women age 15-49 years'.

* Compute response rates for Women. 
compute pelig = (tt1549i/tt1549)*100.
variable labels pelig "".

* Compute ratio of 50-54 to 45-49.
compute temp5054 = lag (tt5054).
do if total =1.
+ compute ratio = temp5054/tt4549.
+ variable labels ratio "Ratio of 50-54 to 45-49".
end if.

ctables
  /vlabels variables = pelig display = none
  /table hlage [c] + total [c] by 
           tt1054 [s] [sum,'Number',f5.0] + 
           tt1549i [s] [sum,'Number',f5.0,tablepct.sum,'Percent',f5.1] + 
           pelig [s] [mean,'Percentage of eligible women interviewed (Completion rate)',f5.1] 
  /titles title=
  "Table DQ.2: Age distribution of eligible and interviewed women"
  "Household population of women age 10-54 years, interviewed women age 15-49 years, " +
  "and percentage of eligible women who were interviewed, by five-year age groups, " + surveyname.

ctables
  /table ratio [s] [mean, '',f7.2].

COMMENT -- End CTABLES command.
new file.
erase file 'tmp1.sav'.
erase file 'tmp1c.sav'.
erase file 'tmp2.sav'.
erase file 'tmp3.sav'.
erase file 'tmp4.sav'.
