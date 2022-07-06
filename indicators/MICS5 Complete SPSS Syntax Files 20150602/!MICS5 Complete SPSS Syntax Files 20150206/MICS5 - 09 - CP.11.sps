* MICS5 CP-11 .

* v01 - 2013-10-24.
* v02 - 2014-04-22.
* added "1" to value labels numWomen "Number of daughters age 0-14 years" .
* v03 - 2015-04-23. 
* several corrections made in calculations for daughters - previous version referred to mother.

* Information on the FGM/C status of daughters is obtained by asking the questions on FGM/C to women age 15-49 years who have been interviewed,
  on their daughters below the age of 15.
* Therefore, the prevalence figures in the Table do not represent all girls age 0-14 years in the population:
  Girls whose mothers are (a) deceased, (b) above age 49, and (c) living in another country are not captured by these questions.
* However, figures in the table very closely approximate the FGM/C status among girls age 0-14.

* Daughters age 0-14 reported to have had any type of FGM/C are
    FG15=1 .
* Individual forms of FGM/C include the removal of flesh from the genital area
    (FG17=1),
  the nicking of the flesh of the genital area
    (FG18=1),
  and sewing closed the genital area
    (FG19=1)

*  In countries where FGM/C is practiced predominantly during certain age groups, these should be broken down and presented with smaller age
  intervals, such as 0-1, 2-4 or 10-12, 13-14, etc.

***.


get file = "fg.sav".

* select  daughters age 0-14 years .
select if (FG13 >= 0 and FG13 <= 14).

weight by wmweight.

compute anyFgm = 0 .
if (FG15 = 1) anyFgm = 100 .
variable labels anyFgm "Percentage of daughters who had any form of FGM/C [1]" .

do if (FG15 = 1) .
+ compute fgmType = 4 .
+ if (FG17 = 1) fgmType = 1 .
+ if (FG18 = 1) fgmType = 2 .
+ if (FG19 = 1) fgmType = 3 .
end if .
variable labels fgmType "Percent distribution of daughters age 0-14 years who had FGM/C:".
value labels fgmType
  1 "Had flesh removed"
  2 "Were nicked"
  3 "Were sewn closed"
  4 "Form of FGM/C not determined" .

if (FG15 = 1) numFgm = 1 .
value labels numFgm 1 "Number of daughters age 0-14 years who had FGM/C" .

compute numWomen = 1 .
value labels numWomen 1 "Number of daughters age 0-14 years" .

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

compute motherFgm = 1.
if (FG3 = 1) motherFgm = 2.
variable labels motherFgm "Mother's FGM/C experience".
value labels motherFgm
  1 "No FGM/C"
  2 "Had FGM/C".

recode FG13
  (0 thru 4 = 1)
  (5 thru 9 = 2)
  (10 thru 14 = 3)
  (else = 9) into ageDaughter .
variable labels ageDaughter "Age".
value labels ageDaughter
  1 "0-4"
  2 "5-9"
  3 "10-14"
  9 "Missing/DK".

variable labels welevel "Mother's Education" .

* Ctables command in English (currently active, comment it out if using different language).

ctables
  /vlabels variables = numWomen numFgm
           display = none
  /table  total [c]
        + hh7 [c]
        + hh6 [c]
        + ageDaughter [c]
        + welevel [c]
        + motherFgm [c]
        + windex5 [c]
        + ethnicity [c]
   by
 	       anyFgm [s] [mean,'',f5.1]
         + numWomen [c] [count,'',f5.0]
         + fgmType [c] [rowpct.validn,'',f5.1]
         + numFgm [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /categories var=fgmType total=yes
  /slabels position=column visible = no
  /title title=
     "Table CP.11: Female genital mutilation/cutting (FGM/C) among girls"
	 "Percentage of daughters age 0-14 years by FGM/C status and percent distribution of daughters who had FGM/C by type of FGM/C" + surveyname
   caption =
     "[1] MICS indicator 8.11 - Prevalence of FGM/C among girls"
  .

new file.
