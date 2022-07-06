* MICS5 SW-01M.

* v01 - 2013-06-22.

* REMARK : calculating job satisfaction out of those that do have a job,
           similar to income and school.

* Percentage of men age 15-24 who are very or somewhat satisfied in specified domains are
  those with responses 1 or 2 to questions on
       (MLS3) family life,
       (MLS4) friendships,
       (MLS8) health,
       (MLS9) living environment,
       (MLS10)treatment by others,
       (MLS11)the way they look,
       (MLS6) school,
       (MLS7) current job, and
       (MLS13)current income.

* Women who are attending school, who do have a job, and who do have any income are:
       MLS5<>2, MLS7<>0 and MLS13<>0, respectively.

* Many surveys will not have sample sizes that will support all of the breakdowns shown in this table.

* In addition to the narrow age range of men for whom the table is produced, many men in this
  age group (age 15-24 years) may not be attending school, or may not have a job or current income.
* For these domains, the denominators may be small, and therefore the right panel of the table may not be produced.

***.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open men dataset.
get file = 'mn.sav'.

* Select completed interviews.
select if (MWM7 = 1).

* Select men aged 15-24.
select if (mwage  = 1 or mwage  = 2).

* Weight the data by the men weight.
weight by mnweight.

* Create marital status with separate groups for ever married married.
recode mmstatus  (1, 2 = 1) (3 = 2) (else = 9).
variable labels mmstatus  "Marital status".
value labels mmstatus 
   1 "Ever married/in union"
   2 "Never married/in union"
   9 "Missing".

* Generate total variable.
compute numMen = 1.
variable labels numMen "Number of men age 15-24 years".

* Generate indicator variables .
recode MLS3 (1, 2 = 100) (else = 0) into famlife.
variable labels famlife "Family life".

recode MLS4 (1, 2 = 100) (else = 0) into friends.
variable labels friends "Friendships".

do if (MLS5 = 1).
+ recode MLS6 (1, 2 = 100) (else = 0) into school.
+ variable labels school "Percentage of men age 15-24 years who are very or somewhat satisfied with school".
end if.

do if (MLS7 <> 0 and MLS7 < 6).
+ recode MLS7 (1, 2 = 100) (else = 0) into job.
+ variable labels job "Percentage of men age 15-24 years who are very or somewhat satisfied with their job".
end if.

recode MLS8 (1, 2 = 100) (else = 0) into health.
variable labels health "Health".

recode MLS9 (1, 2 = 100) (else = 0) into livenv.
variable labels livenv "Living environment".

recode MLS10 (1, 2 = 100) (else = 0) into treat.
variable labels treat "Treatment by others".

recode MLS11 (1, 2 = 100) (else = 0) into look.
variable labels look "The way they look".

do if (MLS13 <> 0 and MLS13 < 6).
+ recode MLS13 (1, 2 = 100) (else = 0) into income.
+ variable labels income "Percentage of men age 15-24 years who are very or somewhat satisfied with their income".
end if.

recode MLS5 (1 = 100) (else = 0) into goSchool.
variable labels goSchool "Are attending school".

recode MLS7 (1 thru 5  = 100) (else = 0) into haveJob.
variable labels haveJob "Have a job".

recode MLS13 (1 thru 5 = 100) (else = 0) into haveIncome.
variable labels haveIncome "Have an income".

compute layer0 = 0.
variable labels layer0 "".
value labels layer0 0 "Percentage of men age 15-24 who are very or somewhat satisfied with selected domains:".

compute layer1 = 0.
variable labels layer1 "".
value labels layer1 0 "Percentage of men age 15-24 years who:".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

compute numGoSchool = goSchool > 0 .
variable labels numGoSchool "Number of men age 15-24 years attending school".

compute numHaveJob = haveJob > 0 .
variable labels numHaveJob "Number of men age 15-24 years who have a job".

compute numHaveIncome = haveIncome > 0 .
variable labels numHaveIncome "Number of men age 15-24 years who have an income".


ctables
  /vlabels variables =  total layer0 layer1
         display = none
  /table   total [c]
         + mwage  [c]
         + hh7 [c]
         + hh6 [c]
         + mmstatus  [c]
         + mwelevel [c]
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
         + numMen [s] [sum,'',f5.0]
         + school   [s] [mean,'',f5.1] + numGoSchool   [s] [sum, '', f5.0]
         + job      [s] [mean,'',f5.1] + numHaveJob    [s] [sum, '', f5.0]
         + income   [s] [mean,'',f5.1] + numHaveIncome [s] [sum, '', f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
     "Table SW.1M: Domains of life satisfaction (men)"
     "Percentage of men age 15-24 years who are very or somewhat satisfied in selected domains of satisfaction, " + surveyname
  .

new file.
