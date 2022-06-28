* Encoding: UTF-8.

***.
* v02 - 2020-04-14. Labels in French and Spanish have been removed.
***.


include "surveyname.sps".

get file = 'mn.sav'.

include "CommonVarsMN.sps".

select if (MWM17 = 1).

weight by mnweight.

compute numMen15_49 = 1.
compute before15 = 0.
if (MWAGEM < 15) before15 = 100.

do if (MWB4 >= 20).
+ compute numMen20_49 = 1.
+ compute before152049 = 0.
+ if (MWAGEM < 15) before152049 = 100.
+ compute before18 = 0.
+ if (MWAGEM < 18) before18 = 100.
end if.

do if (MWB4 >= 20 and MWB4 <= 24).
+ compute numMen20_24 = 1.
+ compute before15_1 = 0.
+ if (MWAGEM < 15) before15_1 = 100.
+ compute before18_1 = 0.
+ if (MWAGEM < 18) before18_1 = 100.
end if.

do if (MWB4 < 20).
+ compute numMen15_19 = 1.
+ compute currentlyMarried = 0.
+ if any(MMA1, 1, 2) currentlyMarried = 100 .
end if.

do if (any(MMA1, 1, 2)) .
+ compute numMarried = 1 .
+ compute inPolygynous = 0.
+ if (MMA3=1) inPolygynous = 100 .
end if.

compute layer15_49 = 1 .
compute layer20_49 = 1 . 
compute layer20_24 = 1 .
compute layer15_19 = 1 .
value labels 
   layer15_49 1 "Men age 15-49 years"
  /layer20_49 1 "Men age 20-49 years" 
  /layer20_24 1 "Men age 20-24 years"  
  /layer15_19 1 "Men age 15-19 years"
  /numMen15_49 1 "Number of men age 15-49 years" 
  /numMen20_49 1 "Number of men age 20-49 years"
  /numMen20_24 1 "Number of men age 20-24 years"   
  /numMen15_19 1 "Men age 15-19 years" 
  /numMarried 1 "Number of men age 15-49 years currently married/in union".
  
variable labels 
    before15    "Percentage married before age 15"
   /before152049    "Percentage married before age 15"    
   /before15_1  "Percentage married before age 15 [1]" 
   /before18    "Percentage married before age 18"
   /before18_1    "Percentage married before age 18 [2]"
   /currentlyMarried "Percentage currently  married/in union [3]"
   /inPolygynous "Percentage in polygynous marriage/ union [4]" .

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* Ctables command in English.
ctables
  /format missing = "na" 
  /vlabels variables = layer15_19 layer15_49 layer20_49 layer20_24 numMarried numMen15_19 numMen20_24 numMen15_49 numMen20_49 
           display = none
  /table  total [c]
        + hh6 [c]
        + hh7 [c]
        + $mwage [c]
        + mwelevel [c]
        + mdisability [c]
        + ethnicity [c]
        + windex5 [c]
   by
          layer15_49 [c] > (
            before15 [s][mean '' f5.1]
          + numMen15_49 [c][count '' f5.0] )
        + layer20_49 [c] > (
            before152049 [s][mean '' f5.1]
          + before18 [s][mean '' f5.1]
          + numMen20_49 [c][count '' f5.0] )
        + layer20_24 [c] > (
            before15_1 [s][mean '' f5.1]
          + before18_1 [s][mean '' f5.1]
          + numMen20_24 [c][count '' f5.0] )          
        + layer15_19 [c] > (
            currentlyMarried [s][mean '' f5.1]
          + numMen15_19 [c][count '' f5.0] )
        + layer15_49 [c] > (
            inPolygynous [s][mean '' f5.1]
          + numMarried [c][count '' f5.0] )
  /slabels position=column visible = no
  /categories variables=all empty=exclude missing=exclude
  /titles title=
    "Table PR.4.1M: Child marriage and polygyny (men)"
    "Percentage of men age 15-49 years who first married or entered a marital union before their 15th birthday, " 
    "percentages of men age 20-49 and 20-24 years who first married or entered a marital union before their 15th and 18th birthdays, "
    "percentage of men age 15-19 years currently married or in union, and the percentage of men who are in a polygynous marriage or union,  " + surveyname
  caption = 
    "[1] MICS indicator PR.4a - Child marriage (before age 15); SDG 5.3.1"														
    "[2] MICS indicator PR.4b - Child marriage (before age 18); SDG 5.3.1"												
    "[3] MICS indicator PR.5 - Young men age 15-19 years currently married or in union"															
    "[4] MICS indicator PR.6 - Polygyny"															
     "na: not applicable"
  .

new file.
