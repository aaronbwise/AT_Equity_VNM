* Encoding: UTF-8.
***.
* v02 - 2020-04-14. Labels in French and Spanish have been removed.
* v03 - 2021-04-09. -	+ mnelevel [c] 
Into 
+ mwelevel [c]
-	variable labels any "ANY WEAPON."
into 
variable labels any "ANY WEAPON".
***.
* v04 - 2021-10-26
Line 86 changed to:         + mdisability [c].

include "surveyname.sps".

get file = "mn.sav".

include "CommonVarsMN.sps".

select if (mvt9 = 1).

weight by mnweight.

compute layer2=0.
value labels layer2 0 "Use of weapon during last assault:".

variable labels mvt12 "Location of last incident of assault".
recode mvt12 (32=31).
add value labels mvt12 31 "AT SCHOOL/ WORKPLACE".

compute noweapon=0.
compute knife=0.
compute gun=0.
compute other=0.
compute any=0.
do if mvt17=1.
+compute any=100.
else.
+compute noweapon=100.
end if.
if mvt18A="A" knife=100.
if mvt18B="B" gun=100.
if mvt18X="X" other=100.

recode mvt10 mvt13 mvt14(9=8).
variable labels mvt10 "Last incident occurred".
recode mvt10(2=1)(1=2). /* to follow the tabulation plan order */.
value labels mvt10
 1 "More than 1 year ago"
 2 "Less than 1 year ago"
 8 "Don't remember".

variable labels noweapon "NO WEAPON".
variable labels knife "KNIFE".
variable labels gun "GUN".
variable labels other "OTHER".
variable labels any "ANY WEAPON".

variable labels mvt13 "Number of offenders".
recode mvt13(3=2).
value labels mvt13
 1 "One"
 2 "2 or more"
 8 "DK/Not sure".

variable labels mvt14 'Recognition of offender(s)'.

compute numMen = 1 .
value labels numMen 1 "Number of men experiencing assault in the last 3 years" .

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* Ctables command in English.
ctables
  /vlabels variables = numMen layer2 display = none
  /table  total [c]
        + hh6 [c]
        + hh7 [c]
        + $mwage [c]
        + mwelevel [c]
        + mvt10[c]
        + mvt13[c]
        + mvt14[c]
        + mdisability [c]
        + ethnicity [c]
        + windex5 [c]
   by   
       mvt12[c][rowpct '' F4.1]+
      layer2>(
       noweapon [s] [mean  f5.1]+
       knife [s] [mean  f5.1]+
       gun [s] [mean  f5.1]+
       other[s] [mean f5.1]+
       any[s] [mean f5.1])+
       numMen[count]
  /categories variables=all empty=exclude missing=exclude
 /cat var=mvt12 total=yes label="TOTAL"
  /slabels position=column visible = no
  /titles title=
    "Table PR.6.3M: Location and circumstances of latest incident of assault (men)"
    "Percentage of men age 15-49 years by classification of the location and circumstances of the latest assault, "+surveyname.

new file.


