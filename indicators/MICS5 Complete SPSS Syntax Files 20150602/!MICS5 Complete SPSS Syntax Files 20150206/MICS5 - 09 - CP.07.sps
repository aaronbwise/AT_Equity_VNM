* MICS5 CP-07.

* v02 - 2014-03-14.
* v03 - 2014-04-22.
* included:
*  /categories var=all empty=exclude missing=exclude
* in the tables command.
* duplicated welevel variable in ctables command corrected to wage.

* Women who were first married/in union 
    (MA1=1 or 2 or MA5=1 or 2) 
  by exact ages 15 or 18 are calculated by using information on the date at first marriage/entry into marital union 
    (MA8) 
  or age at first marriage/entry into marital union 
    (MA9) and date of birth (WB1).

* Percentage of women in polygynous marriage/union 
    (MA3=1) are calculated for women currently married or in union (MA1=1 or 2) .

***.


include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

compute numWomen15_49 = 1.
compute before15_1 = 0.
if (WAGEM < 15) before15_1 = 100.

do if (WB2 >= 20).
+ compute numWomen20_49 = 1.
+ compute before15 = 0.
+ if (WAGEM < 15) before15 = 100.
+ compute before18 = 0.
+ if (WAGEM < 18) before18 = 100.
end if.

do if (WB2 < 20).
+ compute numWomen15_19 = 1.
+ compute currentlyMarried = 0.
+ if (any(MA1, 1, 2) or any(MA5, 1, 2)) currentlyMarried = 100 .
end if.

do if (any(MA1, 1, 2)) .
+ compute numMarried = 1 .
+ compute inPolygynous = 0.
+ if (MA3=1) inPolygynous = 100 .
end if.

compute layer15_49 = 1 .
compute layer20_49 = 1 . 
compute layer15_19 = 1 .
value labels 
   layer15_49 1 "Women age 15-49 years"
  /layer20_49 1 "Women age 20-49 years" 
  /layer15_19 1 "Women age 15-19 years"
  /numWomen15_49 1 "Number of women age 15-49 years" 
  /numWomen20_49 1 "Number of women age 20-49 years"
  /numWomen15_19 1 "Women age 15-19 years" 
  /numMarried 1 "Number of women age 15-49 years currently married/in union".
  
  
variable labels 
    before15    "Percentage married before age 15"
   /before15_1  "Percentage married before age 15 [1]" 
   /before18    "Percentage married before age 18 [2]"
   /currentlyMarried "Percentage currently  married/in union [3]"
   /inPolygynous "Percentage in polygynous marriage/ union [4]" .

compute total = 1.
variable label total "Total".
value label total 1 " ".



* Ctables command in English (currently active, comment it out if using different language).
ctables
  /format missing = "na" 
  /vlabels variables = layer15_19 layer15_49 layer20_49 numMarried numWomen15_19 numWomen15_49 numWomen20_49
           display = none
  /table  total [c]
        + hh7 [c]
        + hh6 [c]
        + wage [c]
        + welevel [c]
        + windex5 [c]
        + ethnicity [c]
   by
          layer15_49 [c] > (
            before15_1 [s][mean,'',f5.1]
          + numWomen15_49 [c][count,'',f5.0] )
        + layer20_49 [c] > (
            before15 [s][mean,'',f5.1]
          + before18 [s][mean,'',f5.1]
          + numWomen20_49 [c][count,'',f5.0] )
        + layer15_19 [c] > (
            currentlyMarried [s][mean,'',f5.1]
          + numWomen15_19 [c][count,'',f5.0] )
        + layer15_49 [c] > (
            inPolygynous [s][mean,'',f5.1]
          + numMarried [c][count,'',f5.0] )
  /slabels position=column visible = no
  /categories var=all empty=exclude missing=exclude
  /title title=
    "Table CP.7: Early marriage and polygyny (women)"
    "Percentage of women age 15-49 years who first married or entered a marital union before their 15th birthday, percentages of women age " +
    "20-49 years who first married or entered a marital union before their 15th and 18th birthdays, percentage of women age 15-19 years " +
    "currently married or in union, and the percentage of women who are in a polygynous marriage or union, " + surveyname
  caption = 
    "[1] MICS indicator 8.4 - Marriage before age 15"
    "[2] MICS indicator 8.5 - Marriage before age 18" 
    "[3] MICS indicator 8.6 - Young women age 15-19 years currently married or in union"
    "[4] MICS indicator 8.7 - Polygyny"
     "na: not applicable"
  .

new file.
