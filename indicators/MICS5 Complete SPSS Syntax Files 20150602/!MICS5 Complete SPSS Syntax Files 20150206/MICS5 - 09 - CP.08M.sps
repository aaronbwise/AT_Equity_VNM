* MICS5 CP-08M.

* v01 - 2014-03-14.
* v02 - 2014-04-22.
* added " empty=exclude missing=exclude" under ctables command.
* variable labels before15 and before18 updated.

* Figures in the total row are based on men age 15-49 and 20-49 for marriage before age 15 and age 18, respectively .

***.


include "surveyname.sps".

get file = 'mn.sav'.

select if (MWM7 = 1).

weight by mnweight.

compute before15 = 0.
if (MWAGEM < 15) before15 = 100.
compute numMen15_49 = 1.

do if (MWB2 >= 20).
+ compute numMen20_49 = 1.
+ compute before18 = 0.
+ if (MWAGEM < 18) before18 = 100.
end if.


value labels 
   numMen15_49 1 "Number of men age 15-49 years" 
  /numMen20_49 1 "Number of men age 20-49 years" .
  
variable labels 
    before15    "Percentage of men married before age 15"
   /before18    "Percentage of men married before age 18" .

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /format missing = "na" 
  /vlabels variables = numMen15_49 numMen20_49 HH6
           display = none
  /table  total [c]
        + mwage [c]
   by
          HH6 [c] > (
            before15 [s][mean,'',f5.1]
          + numMen15_49 [c][count,'',f5.0] 
          + before18 [s][mean,'',f5.1]
          + numMen20_49 [c][count,'',f5.0] )
  /slabels position=column visible = no
  /categories variables=HH6 total=yes label="All" position=after empty=exclude missing=exclude
  /titles title=
    "Table CP.8M: Trends in early marriage (men)"
    "Percentage of men who were first married or entered into a marital union before age 15 and 18, by area and age groups, " + surveyname
   caption =     
    "na: not applicable"
  .

new file.
