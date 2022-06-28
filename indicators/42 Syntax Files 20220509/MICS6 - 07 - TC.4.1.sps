* Encoding: windows-1252.
*V2. updated 7 September 2018.
 * "Households that use clean fuels and technologies for cooking (EU1=01, 02, 03, 04, 05, or (EU1=06 and EU4=01).

 * Note: A liquid fuel stove (EU1=06) is considered clean if used with ethanol/alcohol (EU4=01)

 * Denominators are obtained by weighting the number of households by the number of household members (HH48)."																


***.
* v02. 2019-03-14.
* v03 - 2020-04-14. Table sub-title changed based on the latest tab plan. Labels in French and Spanish have been removed.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

select if (HH46  = 1).

compute hhweightHH48 = HH48*hhweight.

weight by hhweightHH48.

compute nhhmem = 1.
variable labels  nhhmem "Number of household members".
value labels nhhmem 1 " ".

* Clean fuels and technologies for cooking (EU1=01, 02, 03, 04, 05, or (EU1=06 and EU4=01)).
recode EU1 (6 thru highest= sysmis) (else=copy) into cleanfuels.
if (EU1=6 and EU4=1) cleanfuels=6.
variable labels cleanfuels "Clean fuels and technologies for cooking and using".
value labels cleanfuels 1 "Electric stove" 2 "Solar cooker" 3 "Liquefied Petroleum Gas (LPG) / Cooking gas stove"
                                    4 "Piped natural gas stove" 5 "Biogas stove" 6 "Liquid fuel stove using alcohol / ethanol".

recode EU1 (1 thru 5= sysmis) (97 thru highest = sysmis) (else=copy) into otherfuels.
if (EU1=6 and EU4<>1) otherfuels=6.
variable labels otherfuels "Other fuels for cooking and using".
value labels otherfuels 6 "Liquid fuel stove not using alcohol / ethanol" 7 "Manufactured solid fuel stove" 8 "Traditional solid fuel stove" 9 "Three stone stove / Open fire" 96 "Other cookstove".									

recode EU1 (1 thru 96 = sysmis) (else=copy) into nofoodother.
variable labels nofoodother " ".
value labels nofoodother 97 "No food cooked in the household" 99 "Missing".	

*Household members living in households that reported cooking (EU1<>97) and using clean fuels and technologies for cooking (EU1=01, 02, 03, 04, 05, or (EU1=06 and EU4=01)).
do if EU1 <> 97.
+compute cleannumnhh=1.
+compute primary = 0 .
+if EU1 <= 5 or (EU1=6 and EU4=1) primary=100.
end if.

variable labels primary "Primary reliance on clean fuels and technologies for cooking (in households that reported cooking) [1]".

variable labels cleannumnhh "Number of household members (living in households that reported cooking)".
value labels cleannumnhh 1 ' '.

compute total = 1.
variable labels  total "Total".
value labels total 1 " ".

compute total100 = 100.
variable labels  total100 "Total".
value labels total100 100 " ".

compute layer = 0.
variable labels  layer "".
value labels layer 0 "Percentage of household members in households with primary reliance on:".

* Ctables command in English.
ctables
  /vlabels variables = layer 
         display = none
  /table   total [c]
         + HH6 [c]  
         + HH7 [c]
         + helevel [c]
         + ethnicity [c]
         + windex5 [c]
   by 
          layer [c] > (cleanfuels [c] [rowpct.totaln '' f5.1]
         + otherfuels [c] [rowpct.totaln '' f5.1]
         + nofoodother [c] [rowpct.totaln '' f5.1])
         + total100 [s] [mean '' f5.1] 
         + nhhmem [c] [count '' f5.0] 
         + primary [s] [mean,'',f5.1]          
         + cleannumnhh [c] [count '' f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title = 
    "Table TC.4.1: Primary reliance on clean fuels and technologies for cooking"
    "Percent distribution of household members by type of cookstove mainly used by the household and percentage of household members living in households using clean fuels and technologies for cooking, " + surveyname
 caption=
    "[1] MICS indicator TC.15 - Primary reliance on clean fuels and technologies for cooking".
     
   	   
new file.
