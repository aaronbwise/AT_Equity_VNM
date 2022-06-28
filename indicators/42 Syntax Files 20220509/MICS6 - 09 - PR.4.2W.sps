* Encoding: windows-1252.

* v01 - 2014-03-14.
* v02 - 2014-04-22.
* added " empty=exclude missing=exclude" under ctables command.
* variable labels before15 and before18 updated.
* v03 - 2020-04-14. Subtitle has been edited. Labels in French and Spanish have been removed.

* Figures in the total row are based on women age 15-49 and 20-49 for marriage before age 15 and age 18, respectively .

***.

include "surveyname.sps".

get file = 'wm.sav'.

include "CommonVarsWM.sps".

select if (WM17 = 1).

weight by wmweight.

compute before15 = 0.
if (WAGEM < 15) before15 = 100.
compute numWomen15_49 = 1.

do if (WB4 >= 20).
+ compute numWomen20_49 = 1.
+ compute before18 = 0.
+ if (WAGEM < 18) before18 = 100.
end if.

value labels 
   numWomen15_49 1 "Number of women age 15-49 years" 
  /numWomen20_49 1 "Number of women age 20-49 years" .
  
variable labels 
    before15    "Percentage of women married before age 15"
   /before18    "Percentage of women married before age 18" .

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* Ctables command in English.
ctables
  /format missing = "na" 
  /vlabels variables = numWomen15_49 numWomen20_49 HH6
           display = none
  /table  total [c]
        + $wage [c]
   by
          HH6 [c] > (
            before15 [s][mean '' f5.1]
          + numWomen15_49 [c][count '' f5.0] 
          + before18 [s][mean '' f5.1]
          + numWomen20_49 [c][count '' f5.0] )
  /slabels position=column visible = no
  /categories variables=HH6 total=yes label="All" position=after empty=exclude missing=exclude
  /titles title=
    "Table PR.4.2W: Trends in child marriage (women)"
    "Percentage of women who were first married or entered into a marital union before their 15th and 18th birthday, by area of residence, " + surveyname
   caption =     
    "na: not applicable"
  .

new file.
