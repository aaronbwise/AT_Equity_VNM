* Encoding: windows-1252.
***.
* v02 - 2020-04-14. Labels in French and Spanish have been removed.
***.

include "surveyname.sps".

get file = "wm.sav".

include "CommonVarsWM.sps".

select if (VT9 = 1).

weight by wmweight.

compute layer2=0.
value labels layer2 0 "Use of weapon during last assault:".

variable labels VT12 "Location of last incident of assault".
recode VT12 (32=31).
add value labels VT12 31 "AT SCHOOL/ WORKPLACE".

compute noweapon=0.
compute knife=0.
compute gun=0.
compute other=0.
compute any=0.
do if VT17=1.
+compute any=100.
else.
+compute noweapon=100.
end if.
if VT18A="A" knife=100.
if VT18B="B" gun=100.
if VT18X="X" other=100.

recode vt10 vt13 vt14(9=8).
variable labels vt10 "Last incident occurred".
recode VT10(2=1)(1=2). /* to follow the tabulation plan order */.
value labels vt10
 1 "More than 1 year ago"
 2 "Less than 1 year ago"
 8 "Don't remember".

variable labels noweapon "NO WEAPON".
variable labels knife "KNIFE".
variable labels gun "GUN".
variable labels other "OTHER".
variable labels any "ANY WEAPON".

variable labels vt13 "Number of offenders".
recode vt13(3=2).
value labels VT13
 1 "One"
 2 "2 or more"
 8 "DK/Not sure".

variable labels vt14 'Recognition of offender(s)'.

compute numWomen = 1 .
value labels numWomen 1 "Number of women experiencing assault in the last 3 years" .

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* Ctables command in English.
ctables
  /vlabels variables = numWomen layer2 display = none
  /table  total [c]
        + hh6 [c]
        + hh7 [c]
        + $wage [c]
        + welevel [c]
        + vt10[c]
        + vt13[c]
        + vt14[c]
        + disability [c]
        + ethnicity [c]
        + windex5 [c]
   by   
       VT12[c][rowpct '' F4.1]+
      layer2>(
       noweapon [s] [mean  f5.1]+
       knife [s] [mean  f5.1]+
       gun [s] [mean  f5.1]+
       other[s] [mean f5.1]+
       any[s] [mean f5.1])+
       numWomen[count]
  /categories variables=all empty=exclude missing=exclude
 /cat var=vt12 total=yes label="TOTAL"
  /slabels position=column visible = no
  /titles title=
    "Table PR.6.3W: Location and circumstances of latest incident of assault (women)"
    "Percentage of women age 15-49 years by classification of the location and circumstances of the latest assault, "+surveyname.

new file.


