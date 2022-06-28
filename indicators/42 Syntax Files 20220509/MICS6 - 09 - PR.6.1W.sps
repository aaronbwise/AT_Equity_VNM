* Encoding: windows-1252.
***.
* v02 - 2020-04-14. Labels in French and Spanish have been removed.
***.
include "surveyname.sps".

get file = "wm.sav".

include "CommonVarsWM.sps".

select if (WM17 = 1).

weight by wmweight.

compute layer1=0.
value label layer1 0 "Percentage of women age 15-49 years who were victims of:".

recode vt1 (1=100)(else=0) into robbery3.
recode vt2 (1=100)(else=0) into robbery1.
recode vt3 (2,3=100)(else=0) into robberym.
var labels robbery3 "In the last 3 years".
var labels robbery1 "In the last 1 year".
var labels robberym "Multiple times in the last 1 years" .
compute layer2=0.
value label layer2 0 "Robbery [a]".

recode vt9 (1=100)(else=0) into assault3.
recode vt10 (1=100)(else=0) into assault1.
recode vt11 (2,3=100)(else=0) into assaultm.
var labels assault3 "In the last 3 years".
var labels assault1 "In the last 1 year".
var labels assaultm "Multiple times in the last 1 years" .
compute layer3=0.
value label layer3 0 "Assault [b]".

compute any3=0.
if robbery3>0 or assault3>0 any3=100.
compute any1=0.
if robbery1>0 or assault1>0 any1=100.
compute anym=0.
if robberym>0 or assaultm>0 or robbery1>0 and assault1>0 anym=100.
var labels any3 "In the last 3 years".
var labels any1 "In the last 1 year [1]".
var labels anym "Multiple times in the last 1 years" .

compute layer4=0.
value label layer4 0 "Percentage of women age 15-49 years who experienced physical violence of robbery or assault:".

compute numWomen = 1 .
value labels numWomen 1 "Number of women" .

compute total = 1.
variable labels total "Total".
value labels total 1 " ".
  
* Ctables command in English.
ctables
  /vlabels variables = numWomen layer1 layer2 layer3 layer4 display = none
  /table  total [c]
        + hh6 [c]
        + hh7 [c]
        + $wage [c]
        + welevel [c]
        + disability [c]
        + ethnicity [c]
        + windex5 [c]
   by   
      layer1>(
      layer2>(
       robbery3[s] [mean  f5.1]+
       robbery1[s] [mean  f5.1]+
       robberym[s] [mean f5.1])+
      layer3>(
       assault3[s] [mean  f5.1]+
       assault1[s] [mean  f5.1]+
       assaultm[s] [mean f5.1]))+
      layer4>(
       any3[s] [mean  f5.1]+
       any1[s] [mean  f5.1]+
       anym[s] [mean f5.1])+
       numWomen[count]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table PR.6.1W: Victims of robbery and assault (women)"											
    "Percentage of women age 15-49 years who were victims of robbery, assault and either robbery or assault in the last 3 years, last 1 year and multiple times in the last year, "+surveyname
   caption =
    "[1] MICS indicator PR.12 - Experience of robbery and assault"											
    "[A] A robbery is here defined as <<taking or trying to take something, by using force or threatening to use force>>"								
    "[B] An assault is here defined as a physical attack".										

new file.

