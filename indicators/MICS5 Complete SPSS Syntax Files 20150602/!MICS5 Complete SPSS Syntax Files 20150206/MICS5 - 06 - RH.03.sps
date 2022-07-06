* MICS5 RH-03.

* v03 - 2014-04-02.
* In the sub-title, “years” has been added after “age 20-24”.

* v04 - 2015-04-21.
* In the column layer over the first four columns and in the last three columns “years” has been added behind the stated age-groups.

* Women who have had a live birth are those women with
    CM10 > 0 .
* Women currently pregnant
    CP1=1 .
* Women who have begun childbearing includes women who have either had a live birth or are pregnant at the time of survey.

* Ages at first birth are calculated by using information on the woman's own date of birth and the date of birth of her first child.
* If the Fertility/Birth History module is used, this information is calculated by using information on the date of birth of the woman (WB1)
  and the date of birth of her first child (BH4) in the birth history.
* If only the Fertility module is included (the full birth history is not administered), the latter is based on the responses to CM2.
* Dates of birth for women and first births are first converted into century month codes (CMC) (see below).
* The CMC of the woman's birth date is then subtracted from the CMC of the birth date of the first child, and divided by 12 to obtain the
  woman's age in years at the time of first birth.

* Note that if full information (month and year) on the birth dates of the woman or the first birth is not available, robust imputation
  procedures are used to estimate dates for both types of information.
* Additional information such as the age stated by the woman (WB2), the number of years since first birth (CM3), or the age of the first child
  (BH6) may be used for this purpose.

* The century month code of an event is calculated by multiplying by 12 the difference between the year of the event and 1900, and adding the
  calendar month of the event.
* For example, the century month code corresponding to May 2013 is calculated as follows:
    ((2013-1900)*12) + 5 = 1361 .

***.


include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

recode CM10 (sysmis = 0) .

do if (WB2 >=15 and WB2<=19).
+ compute numWoman15 = 1.
+ compute hadBirth = 0.
+ if (CM10 > 0) hadBirth = 100.
+ compute firstChild = 0.
+ if (hadBirth = 0 and CP1 = 1) firstChild = 100.
+ compute begunChildbearing = 0.
+ if (hadBirth = 100 or CP1 = 1) begunChildbearing  = 100.
+ compute birthBefore15 = 0.
+ if ((wdobfc - wdob)/12 < 15) birthBefore15 = 100.
end if.

variable labels
   numWoman15 "Number of women age 15-19 years"
  /hadBirth "Have had a live birth"
  /firstChild "Are pregnant with first child"
  /begunChildbearing "Have begun childbearing"
  /birthBefore15 "Have had a live birth before age 15"
  .

do if (WB2 >=20 and WB2 <=24).
+ compute numWoman20 = 1.
+ compute birthBefore18 = 0.
+ if ((wdobfc - wdob)/12 < 18) birthBefore18 = 100.
end if.

variable labels
   numWoman20 "Number of women age 20-24 years"
  /birthBefore18 "Percentage of women age 20-24 years who have had a live birth before age 18 [1]"
  .

compute layer = 0.
value labels layer 0 "Percentage of women age 15-19 years who:".
variable labels layer " ".

compute total = 1.
variable labels total "Total".
value labels total 1" ".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = layer
           display = none
  /table   total [c]
         + hh7 [c]
         + hh6 [c]
         + welevel [c]
         + windex5 [c]
         + ethnicity [c]        
   by
           layer [c] > (
             hadBirth [s] [mean,'',f5.1]
           + firstChild [s] [mean,'',f5.1]
           + begunChildbearing [s] [mean,'',f5.1]
           + birthBefore15 [s] [mean,'',f5.1] )
         + numWoman15 [s] [sum,'',f5.0]
         + birthBefore18 [s] [mean,'',f5.1]
         + numWoman20 [s] [sum,'',f5.0]
  /slabels position=column visible =no
  /categories var=all empty=exclude missing=exclude
  /title title=
     "Table RH.3: Early childbearing"
     "Percentage of women age 15-19 years who have had a live birth, are pregnant with the first child, have begun childbearing, " 
     "and who have had a live birth before age 15, and percentage of women age 20-24 years who have had a live birth before age 18, " + surveyname
   caption =
     "[1] MICS indicator 5.2 - Early childbearing"
  .


new file.
