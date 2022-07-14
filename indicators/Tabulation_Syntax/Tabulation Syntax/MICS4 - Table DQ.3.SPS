* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open household members data file.
get files="hl.sav".

* Select household population of age 0-7 years.
select if (hl6 <= 7).

* Label ages 0-7 from the hl file.
compute hlage = hl6.
variable labels hlage "Age".
value labels hlage
  0 "0"
  1 "1"
  2 "2"
  3 "3"
  4 "4"
  5 "5"
  6 "6"
  7 "7".

* Weight the data by the household weight.
weight by hhweight.

* Give value 1 to each child to calculate total number of children age 0-7.
compute t07 = 1.

* Give value 1 to each child to calculate total number of children age 0-5.
if (hl6 <= 4) t04 = 1.

* Give value 1 to each child under 5 to calculate total number of eligible children.
if (hl6 <= 4) total = 1.
variable labels total "Total (0-4)".
value labels total 1 " ".

* Give value 1 to each child age 5 for calculation of ratio of 5 to 4.
if (hl6 = 5) t5age = 1.
variable labels t5age "Total (5)".

* Give value 1 to each child age 4 for calculation of ratio of 5 to 4.
if (hl6 = 4) t4age = 1.
variable labels t4age "Total (4)".

* For each 5 years age group separately.
* Aggregate the hl data file to calculate the sum of children age 0-7 and age 0-5.
aggregate outfile ="tmp1.sav"
  /break   = hlage
  /tt07  = sum(t07)
  /tt04  = sum(t04).

* For overall country.
* Aggregate the hl data file to calculate the sum of children age 0-7 and age 0-5.
aggregate outfile = "tmp2.sav"
  /break   = total
  /tt07  = sum(t07)
  /tt04  = sum(t04)
  /tt5age  = sum(t5age)
  /tt4age  = sum(t4age).

* Add this summary information together in one data file.
get file = 'tmp1.sav'.
add files
  /file = *
  /file = 'tmp2.sav'.

sort cases by hlage total.
save outfile ="tmp1.sav".

* Open household members data file, and keep only the information needed for merging with the children data: cluster and household number, line number, age and weight.
get file="hl.sav"
 /keep HH1 HH2 HL1 HL6 hhweight
 /rename (HL1=LN).
sort cases hh1 hh2 ln.
save outfile ="tmp1c.sav".

* Open children data file.
get file="ch.sav".

* Sort cases by cluster number, household number and child line number.
sort cases by HH1 HH2 LN.

* Add the household member data: age (HL6) and household weight (hhweight) to a child data.
match files 
 /file=*
 /table='tmp1c.sav'
 /by HH1 HH2 LN.

* Select completed interviews.
select if (UF9 = 1).

* Weight the data by the household weight.
weight by hhweight.

* Total variable.
compute total  = 1.
variable labels total "Total".
value labels total 1 "".

* Label ages 0-7 from the added hl file.
compute hlage = hl6.
variable labels hlage "Age".
value labels hlage
  0 "0"
  1 "1"
  2 "2"
  3 "3"
  4 "4"
  5 "5"
  6 "6"
  7 "7"
  8 "8".

* Give value 1 to each interviewed mother/caretaker of a child 0-4.
compute t04i = 0.
if (UF9 = 1) t04i = 1.

* For each age separately.
* Aggregate the ch data file to calculate the sum of eligible children interviewed.
aggregate outfile ="tmp3.sav"
  /break   = hlage
  /tt04i = sum(t04i).

* For overall country.
* Aggregate the ch data file to calculate the sum of eligible children interviewed.
aggregate outfile = "tmp4.sav"
  /break   = total
  /tt04i = sum(t04i).

* Add this summary information together in one data file.
get file = 'tmp3.sav'.
add files
  /file = *
  /file = 'tmp4.sav'.

sort cases by hlage total.
save outfile="tmp3.sav".

* Add information from CH data file onto information from HL data file.
get file="tmp1.sav".
match files 
 /file=*
 /table='tmp3.sav'
 /by  hlage total.

variable labels tt07 'Household population of children 0-7 years'.
variable labels tt04i 'Interviewed under-5 children'.

* Compute response rates for children. 
compute pelig = (tt04i/tt04)*100.
variable labels pelig "Percentage of eligible under-5s interviewed (Completion rate)".

* Compute ratio of 5 to 4.
compute temp5054 = lag (tt5age).
do if total =1.
+ compute ratio = temp5054/tt4age.
+ variable labels ratio "Ratio of 5 to 4".
end if.

* old version for use with old tables command in older versions of SPSS.
 *tables
 /format = zero
 /observation= tt07 tt04i pelig
 /table= hlage + total + ratio by tt07 + tt04i + pelig 
 /statistics
 sum(tt07 (f5.0) 'Number')
 sum(tt04i (f5.0) 'Number')
 spct(tt04i (f5.1) 'Percent')
 means(pelig (f5.1) ' ')
 /title
  "Table DQ.3: Age distribution of under-5s in household and under-5 questionnaires" 
  "Household population of children age 0-7, children age 0-4 whose mothers/caretakers were interviewed, " +
  "and percentage of under-5 children whose mothers/caretakers were interviewed, by single ages, "
  "" + surveyname.
   *tables
 /format = zero
 /observation= ratio
 /table= ratio
 /statistics
 means(ratio (f5.2) ' ').

* Ctables command for the tabulation in newer versions of SPSS.
ctables
  /table hlage [c] + total [c] by 
           tt07 [s] [sum,'Number',f5.0] + 
           tt04i [s] [sum,'Number',f5.0,tablepct.sum,'Percent',f5.1] + 
           pelig [s] [mean,'',f5.1] 
  /titles title=
  "Table DQ.3: Age distribution of under-5s in household and under-5 questionnaires" 
  "Household population of children age 0-7, children age 0-4 whose mothers/caretakers were interviewed, " +
  "and percentage of under-5 children whose mothers/caretakers were interviewed, by single ages, " + surveyname.

ctables
  /table ratio [s] [mean, '',f7.2].

COMMENT -- End CTABLES command.
new file.
erase file 'tmp1.sav'.
erase file 'tmp1c.sav'.
erase file 'tmp2.sav'.
erase file 'tmp3.sav'.
erase file 'tmp4.sav'.