* Encoding: UTF-8.
/*****************************************************************************/
/*  MICS6: Standard.
/*  Chapter 8. Learn.
/*  LN.1. Early childhood education.
/*  LN.1.1: Early childhood education.
/*.
/*  Reflects Tab Plan of 3 March 2021.
/*.
/*  Updates:.
/*    [20210319] - Tab Plan of 3 March 2021 implemented.
/*      - The subtitle and description have been edited to include "currently".
/*      - Note [A] added.
/*    [20200414].
/*      - Labels in French and Spanish have been removed.
/*.
/*****************************************************************************/

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open children data file.
get file = 'ch.sav'.

include "CommonVarsCH.sps".

* Select completed households.
select if (UF17 = 1).

* Select only children 36 to 59 months old.
select if (cage >= 36 and cage <= 59).

* Weight the data by the children weight.
weight by chweight.

/*****************************************************************************/

* Generating age groups.
recode  cage
  (36 thru 47 = 1)
  (48 thru 59 = 2) into ageGr.
variable labels ageGr 'Age (in months)'.
value labels ageGr
  1 '36-47'
  2 '48-59'.

*Children attending early childhood education: (UB8A/B=1).
compute ecedu = 0.
if (UB8 = 1) ecedu = 100.
variable labels ecedu "Percentage of children age 36-59 months attending early childhood education [1],[A]".

* Generate total.
compute total = 1.
compute numChildren = 1.
variable labels total "Total".
value labels
  /total 1 " "
  /numChildren 1 "Number of children age 36-59 months".

variable labels cdisability "Child's functional difficulties".

/*****************************************************************************/

* Ctables command in English.
ctables
  /vlabels variables =  numChildren
           display = none
  /table   total[c]
         + hl4 [c]
         + hh6 [c]
         + hh7 [c]
         + ageGr [c]
         + melevel [c]
         + cdisability [c]
         + ethnicity [c]
         + windex5 [c]
   by
           ecedu [s] [mean ''  f5.1]
         + numChildren [c] [count f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels visible=no
  /titles title=
    "Table LN.1.1: Early childhood education"
    "Percentage of children age 36-59 months who are currently attending early childhood education, " + surveyname
    caption=
     "[1] MICS indicator LN.1 - Attendance to early childhood education"
     "[A] Note that this indicator is a measure of current attendance, i.e. attending at the time of interview. It is therefore " +
     "not directly comparable to the adjusted net attendance rates at higher levels of education presented elsewhere in this chapter."
.

/*****************************************************************************/

new file.
