* Encoding: UTF-8.
***.
* v02 - 2020-04-14. Labels in French and Spanish have been removed.
* v03 - 2021-10-26. Reversed categories of answers for variable mtv2, lines 39-42:
recode mvt2 (1=1)(2=0)
value labels mvt2
 0 "More than 1 year ago"
 1 "Less than 1 year ago"
 8 "Don't remember".
***.

include "surveyname.sps".

get file = "mn.sav".

include "CommonVarsMN.sps".

select if (mvt1 = 1).

weight by mnweight.

compute layer1=0.
value labels layer1 0 "Circumstances of the last robbery:".
compute layer2=0.
value labels layer2 0 "Armed robbery with:".

compute noweapon=0.
compute knife=0.
compute gun=0.
compute other=0.
compute any=0.
do if mvt6=1.
+compute any=100.
else.
+compute noweapon=100.
end if.
if mvt7A="A" knife=100.
if mvt7B="B" gun=100.
if mvt7X="X" other=100.

recode mvt2 mvt5(9=8).
variable labels noweapon "Robbery with no weapon".
variable labels mvt2 "Last incident occurred".
recode mvt2 (1=1)(2=0).
value labels mvt2
 0 "More than 1 year ago"
 1 "Less than 1 year ago"
 8 "Don't remember".

variable labels mvt5 "Robbery outcome".
variable labels knife "Knife".
variable labels gun "Gun".
variable labels other "Other".
variable labels any "Any weapon".

value labels mvt5
 1 "Robbery"
 2 "Attempted robbery"
 8 "DK/Not sure".

compute numMen= 1 .
value labels numMen 1 "Number of men experiencing robbery in the last 3 years" .

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* Ctables command in English.
ctables
  /vlabels variables = layer1 layer2 numMen display = none
  /table  total [c]
        + hh6 [c]
        + hh7 [c]
        + $mwage [c]
        + mwelevel [c]
        + mvt2[c]
        + mvt5[c]
        + mdisability [c]
        + ethnicity [c]
        + windex5 [c]
   by   
      layer1>(
       noweapon[s] [mean  f5.1]+
      layer2>(
       knife [s] [mean  f5.1]+
       gun [s] [mean  f5.1]+
       other[s] [mean f5.1]+
       any[s] [mean f5.1]))+
       numMen[count]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table PR.6.2M: Circumstances of latest incident of robbery (men)"
    "Percentage of men age 15-49 years by classification of the circumstances of the latest robbery, "+surveyname.

new file.


