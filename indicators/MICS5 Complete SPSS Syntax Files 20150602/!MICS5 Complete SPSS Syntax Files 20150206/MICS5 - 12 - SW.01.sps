* MICS5 SW-01.

* v01 - 2013-06-22.

* REMARK : calculating job satisfaction out of those that do have a job,
           similar to income and school.

* Percentage of women age 15-24 who are very or somewhat satisfied in specified domains are
  those with responses 1 or 2 to questions on
       (LS3) family life,
       (LS4) friendships,
       (LS8) health,
       (LS9) living environment,
       (LS10)treatment by others,
       (LS11)the way they look,
       (LS6) school,
       (LS7) current job, and
       (LS13)current income.

* Women who are attending school, who do have a job, and who do have any income are:
       LS5<>2, LS7<>0 and LS13<>0, respectively.

* Many surveys will not have sample sizes that will support all of the breakdowns shown in this table.

* In addition to the narrow age range of women for whom the table is produced, many women in this
  age group (age 15-24 years) may not be attending school, or may not have a job or current income.
* For these domains, the denominators may be small, and therefore the right panel of the table may not be produced.

***.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open women dataset.
get file = 'wm.sav'.

* Select completed interviews.
select if (WM7 = 1).

* Select men aged 15-24.
select if (wage = 1 or wage = 2).

* Weight the data by the women weight.
weight by wmweight.

* Create marital status with separate groups for ever married married.
recode mstatus (1, 2 = 1) (3 = 2) (else = 9).
variable labels mstatus "Marital status".
value labels mstatus
    1 "Ever married/in union"
    2 "Never married/in union"
    9 "Missing".

* Generate total variable.
compute numWomen = 1.
variable labels numWomen "Number of women age 15-24 years".

* Generate indicator variables .
recode LS3 (1, 2 = 100) (else = 0) into famlife.
variable labels famlife "Family life".

recode LS4 (1, 2 = 100) (else = 0) into friends.
variable labels friends "Friendships".

do if (LS5 = 1).
+ recode LS6 (1, 2 = 100) (else = 0) into school.
+ variable labels school "Percentage of women age 15-24 years who are very or somewhat satisfied with school".
end if.

do if (LS7 <> 0 and LS7 < 6).
+ recode LS7 (1, 2 = 100) (else = 0) into job.
+ variable labels job "Percentage of women age 15-24 years who are very or somewhat satisfied with their job".
end if.

recode LS8 (1, 2 = 100) (else = 0) into health.
variable labels health "Health".

recode LS9 (1, 2 = 100) (else = 0) into livenv.
variable labels livenv "Living environment".

recode LS10 (1, 2 = 100) (else = 0) into treat.
variable labels treat "Treatment by others".

recode LS11 (1, 2 = 100) (else = 0) into look.
variable labels look "The way they look".

do if (LS13 <> 0 and LS13 < 6).
+ recode LS13 (1, 2 = 100) (else = 0) into income.
+ variable labels income "Percentage of women age 15-24 years who are very or somewhat satisfied with their income".
end if.

recode LS5 (1 = 100) (else = 0) into goSchool.
variable labels goSchool "Are attending school".

recode LS7 (1 thru 5  = 100) (else = 0) into haveJob.
variable labels haveJob "Have a job".

recode LS13 (1 thru 5 = 100) (else = 0) into haveIncome.
variable labels haveIncome "Have an income".

compute layer0 = 0.
variable labels layer0 "".
value labels layer0 0 "Percentage of women age 15-24 who are very or somewhat satisfied with selected domains:".

compute layer1 = 0.
variable labels layer1 "".
value labels layer1 0 "Percentage of women age 15-24 years who:".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

compute numGoSchool = goSchool > 0 .
variable labels numGoSchool "Number of women age 15-24 years attending school".

compute numHaveJob = haveJob > 0 .
variable labels numHaveJob "Number of women age 15-24 years who have a job".

compute numHaveIncome = haveIncome > 0 .
variable labels numHaveIncome "Number of women age 15-24 years who have an income".


ctables
  /vlabels variables =  total layer0 layer1
         display = none
  /table   total [c]
         + wage [c]
         + hh7 [c]
         + hh6 [c]
         + mstatus [c]
         + welevel [c]
         + windex5 [c]
         + ethnicity [c]
     by
           layer0 [c] > (
             famlife [s] [mean,'',f5.1]
           + friends [s] [mean,'',f5.1]
           + health [s] [mean,'',f5.1]
           + livenv [s] [mean,'',f5.1]
           + treat [s] [mean,'',f5.1]
           + look  [s] [mean,'',f5.1] )
         + layer1 [c] > (  
             goSchool [s] [mean,'',f5.1]
           + haveJob [s] [mean,'',f5.1]
           + haveIncome[s] [mean,'',f5.1] )
         + numWomen [s] [sum,'',f5.0]
         + school   [s] [mean,'',f5.1] + numGoSchool   [s] [sum, '', f5.0]
         + job      [s] [mean,'',f5.1] + numHaveJob    [s] [sum, '', f5.0]
         + income   [s] [mean,'',f5.1] + numHaveIncome [s] [sum, '', f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
     "Table SW.1: Domains of life satisfaction (women)"
     "Percentage of women age 15-24 years who are very or somewhat satisfied in selected domains of satisfaction, " + surveyname
  .

new file.
