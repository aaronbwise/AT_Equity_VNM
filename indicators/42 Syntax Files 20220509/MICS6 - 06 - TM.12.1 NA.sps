* Encoding: windows-1252.

***.
* v02 - 2020-04-14. Labels in French and Spanish have been removed.
***.

include "surveyname.sps".

get file = 'mn.sav'.

include "CommonVarsMN.sps".

select if (MWM17 = 1).

weight by mnweight.

include 'define\MICS6 - 06 - TM.M.sps' .

compute circum=0.
if MMC1=1 circum=100.
variable labels circum "Percent circumcised[1]".

compute nummen = 1.
variable labels nummen "".
value labels nummen 1 "Number of men".

do if circum=100.
+compute nummencircum=1.
+compute infancy=0.
+if MMC2=0 infancy=100.
+compute circum14=0.
+if (MMC2>=1 and MMC2<=4) circum14=100.
+compute circum59=0.
+if (MMC2>=5 and MMC2<=9) circum59=100.
+compute circum1014=0.
+if (MMC2>=10 and MMC2<=14) circum1014=100.
+compute circum1519=0.
+if (MMC2>=15 and MMC2<=19) circum1519=100.
+compute circum2024=0.
+if (MMC2>=20 and MMC2<=24) circum2024=100.
+compute circum25=0.
+if (MMC2>=25 and MMC2<=97) circum25=100.
+compute circum98=0.
+if (MMC2=98) circum98=100.
+compute circum99=0.
+if (MMC2=99) circum99=100.
+compute total100=100.
end if.

variable labels nummencircum "".
value labels nummencircum 1 "Number of men who have have been circumcised".

variable labels infancy "During infancy".
variable labels circum14 "1-4 years".
variable labels circum59 "5-9 years".
variable labels circum1014 "10-14 years".
variable labels circum1519 "15-19 years".
variable labels circum2024 "20-24 years".
variable labels circum25 "25+ years".
variable labels circum98 "DK".
variable labels circum99 "Missing".

variable labels total100 "Total".

compute layerCan = 0.
variable labels layerCan "".
value labels layerCan 0 "Age at circumcision:".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

* ctables command in English.
ctables
  /vlabels variables = nummen nummencircum layerCan  total
           display = none
  /format missing = "na" 
  /table   total [c]
         + HH6 [c]
         + HH7 [c]
         + $mwagez [c]
         + mwelevel [c]
         + mdisability [c]
         + ethnicity [c]
         + windex5 [c]
   by
         circum [s] [mean '' f5.1] 
         + nummen[c][count '' f5.0] 
         + layerCan [c] > 
         (infancy [s] [mean '' f5.1] + circum14 [s] [mean '' f5.1] + circum59 [s] [mean '' f5.1] + circum1014 [s] [mean '' f5.1] + circum1519 [s] [mean '' f5.1]  + 
          circum2024 [s] [mean '' f5.1] + circum25 [s] [mean '' f5.1]  + circum98 [s] [mean '' f5.1]  + circum99 [s] [mean '' f5.1]) + total100 [s] [mean '' f5.1]
         + nummencircum[c][count '' f5.0]
  /categories variables = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /titles title=
    "Table TM.12.1: Male circumcision"
    "Percentage of men age 15-49 years who report having been circumcised, and percent distribution of men by age of circumcision,  " + surveyname
   caption =
      "[1] MICS indicator TM.37 - Male circumcision"
      "na: not applicable".
  
new file.
