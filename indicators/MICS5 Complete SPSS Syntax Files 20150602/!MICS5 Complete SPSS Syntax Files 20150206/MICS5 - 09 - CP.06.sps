* MICS5 CP-06.

* v01 - 2014-03-13.
* v02 - 2014-04-21.
* The background characteristic of “Respondent's parenting status” and categories has been deleted and replaced with “Respondent's relationship to selected child”.
* The table note has been deleted as a result.
* added "Missing\DK" to variable ageGroup.
* v03 - 2014-08-19.
*footnote deleted as per the latest version of standard tab plan.
* changes made in guidelines on how to recode respondent education level.



* The denominator of the table is respondents to the household questionnaire living in households where a child age 1-14 was randomly selected for the child discipline module. 

* The respondent's relationship to any child age 1-14 is established using information from the List of Household Members. 

* Respondent believes that a child needs to be physically punished: CD4=1.

***.


include "surveyname.sps".

get file = 'hl.sav'.
sort cases by HH1 HH2 HL1 .
save outfile = 'tmp.sav'
  /keep HH1 HH2 HL1 HL12 HL14 HL15 .

save outfile = 'tmpHL.sav'
  /keep HH1 HH2 HL1 ED4A HL4 HL6.

get file = 'hh.sav' .

select if (not sysmis(CD2)) .

* add tmpHL file in order to determine respondents education and age.
sort cases by HH1 HH2 HH10.
match files
  /file = *
  /table = "tmpHL.sav"
  /rename = (HL1 = HH10)
  /by HH1 HH2 HH10  .

sort cases by hh1 hh2 cd2.

* add tmp file in order to determine relashionship of respondent.
match files
  /file = *
  /table = "tmp.sav"
  /rename= (hl1=cd2)
  /by HH1 HH2 cd2
  .

* weight by HH weight.
weight by hhweight.

* Customize the respondent education level categories.
* See example below and make sure to customize further as defined in make.sps file.
recode ED4A (1 = 2) (2 = 3) (3 = 4) (8,9 = 9) (else = 1) into respondentEducation.
variable labels respondentEducation "Respondent's education" .
value labels respondentEducation
  1 "None"
  2 "Primary"
  3 "Secondary"
  4 "Higher"
  9 "Missing/DK".
formats respondentEducation (f1.0).

* Respondent's relationship to selected child: Mother, Father, Other.
compute  parentingStatus = 3 .
if (HL14 = HH10) parentingStatus = 2 .
if (HL12 = HH10) parentingStatus = 1 .

variable labels parentingStatus "Respondent's relationship to selected child".
value labels parentingStatus
  1 "Mother"
  2 "Father"
  3 "Other" .

recode HL6
  (lo thru 24 = 1)
  (25 thru 39 = 2)
  (40 thru 59 = 3)
  (60 thru 96 = 4)
  (97 thru hi = 9) into ageGroup .
variable labels ageGroup "Age" .
value labels ageGroup
  1 "<25"
  2 "25-39"
  3 "40-59"
  4 "60+" 
  9 "Missing\DK".

* Respondent believes that a child needs to be physically punished: CD4=1.
compute belivePunishment = 0 .
if (CD4 = 1) belivePunishment = 100 .
variable labels belivePunishment "Respondent believes that a child needs to be physically punished" .

compute numRespondents = 1.
value labels numRespondents 1 "Number of respondents to the child discipline module".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* Ctables command in English (currently active, comment it out if using different language).
ctables
   /vlabels variables = numRespondents
            display = none
   /table  total [c]
         + hl4 [c]
         + hh7 [c]
         + hh6 [c]
         + ageGroup [c]
         + parentingStatus [c]
         + respondentEducation [c]
         + windex5 [c]
         + ethnicity [c]
    by
           belivePunishment [s][mean,'',f5.1]
         + numRespondents [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
    "Table CP.6: Attitudes toward physical punishment"
    "Percentage of respondents to the child discipline module who believe that physical punishment is needed to bring up, raise, or educate a child properly, " + surveyname
  .

new file.

erase file = "tmp.sav" .
erase file = "tmpHL.sav" .
