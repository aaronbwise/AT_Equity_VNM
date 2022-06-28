* Encoding: windows-1252.

***.
* v02 - 2020-04-14. Labels in French and Spanish have been removed.
***.

include "surveyname.sps".

get file = 'mn.sav'.

include "CommonVarsMN.sps".

select if (MWM17 = 1).
select if (MMC1 = 1).

weight by mnweight.

include 'define\MICS6 - 06 - TM.M.sps' .

compute nummen = 1.
variable labels nummen "".
value labels nummen 1 "Number of men who have have been circumcised".

recode MMC3 (9=8) (else=copy).
add value labels MMC3 8 "DK/Missing".

recode MMC4 (9=8) (else=copy).
add value labels MMC4 8 "DK/Missing".
compute total100=100.

variable labels total100 "Total".

variable labels MMC3 "Person performing circumcision:".

variable labels MMC4 "Place of circumcision:".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

* ctables command in English.
ctables
  /vlabels variables = nummen total
           display = none
  /table   total [c]
         + HH6 [c]
         + HH7 [c]
         + $mwagez [c]
         + mwelevel [c]
         + mdisability [c]
         + ethnicity [c]
         + windex5 [c]
   by
         MMC3 [c] [rowpct.totaln '' f5.1] + total100 [s] [mean '' f5.1] + 
         MMC4 [c] [rowpct.totaln '' f5.1] + total100 [s] [mean '' f5.1] + 
         nummen[c][count '' f5.0]
  /categories variables = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /titles title=
    "Table TM.12.2: Provider and location of circumcision"
    "Percent distribution of circumcised men age 15-49 by person performing circumcision and the location where circumcision was performed, " + surveyname .
  
new file.
