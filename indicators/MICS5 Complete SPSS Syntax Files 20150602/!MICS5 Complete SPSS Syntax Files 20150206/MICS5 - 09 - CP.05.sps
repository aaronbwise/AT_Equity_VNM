* MICS5 CP-05.

* v02 - 2014-04-07.
* v03 - 2014-04-21.
* variable SL6 changed to correct SL1 (total number of children).

* Random selection of one child age 1-17 years per household is carried out during fieldwork for administering the child labour and/or child 
  discipline modules. 
* The child discipline module is administered for children age 1-14 from among those randomly selected. 

* To account for the random selection, the household sample weight is multiplied by the total number of children age 1-17 in each household; 
  this weight is used when producing this table.

* Columns of the table refer to the following:
    (B) Only non-violent discipline: (CD3A=1 or CD3B=1 or CD3E=1 ) and (CD3C, CD3D, CD3F, CD3G, CD3H, CD3I, CD3J, CD3K=2)
    (C) Psychological aggression: CD3D=1 or CD3H=1
    (D) Any physical punishment: CD3C=1 or CD3F=1 or CD3G=1 or CD3I=1 or CD3J=1 or CD3K=1
    (E) Severe physical punishment: CD3I=1 or CD3K=1
    (F) Any violent discipline method: CD3C, CD3D, CD3F, CD3G, CD3H, CD3I, CD3J or CD3K=1

* Child disciplining methods in this table should be considered as lower bounds of the actual discipline methods used by the household members, 
  since children who may have been separated from the household members (e.g. at boarding school) during the past month are considered not to 
  have been subjected to any disciplining method.

***.

include "surveyname.sps".

get file = 'hl.sav'.
sort cases by HH1 HH2 HL1 .
save outfile = 'tmp.sav'
  /rename (HL1 = SL9B)
  /keep HH1 HH2 SL9B HL4 melevel  .

get file = 'hh.sav' .
select if (not sysmis(SL9B)) .
sort cases by HH1 HH2 SL9B.

match files
  /file = *
  /table = "tmp.sav"
  /by HH1 HH2 SL9B
  .

* calculate total number of children age 1 - 17 unweighted in order to properly normalize weights.
aggregate 
  /outfile = * mode = addvariables
  /totunw = sum (SL1).

* compute temporary weight needed for normalization process.
compute tmpw = hhweight * SL1.

weight by tmpw.

* calculate total number of households with at least one child age 1 - 17 unweighted in order to properly normalize weights.
aggregate 
  /outfile = * mode = addvariables
  /totw = N (SL1).

compute slweight = tmpw*totunw/totw.

weight by slweight.

select if (SL9C >= 1 and SL9C <= 14).

recode SL9C (1, 2 = 1) (3, 4 = 2) (5 thru 9 = 3) (10 thru 14 = 4) into ageGroup .
variable labels ageGroup "Age" .
value labels ageGroup
  1 "1-2 years"
  2 "3-4 years"
  3 "5-9 years"
  4 "10-14 years" .

* (F) Any violent discipline method . 
compute anyViolent = 0 .
if (any(1, CD3C, CD3D, CD3F, CD3G, CD3H, CD3I, CD3J, CD3K)) anyViolent = 100 .

* (B) Only non-violent discipline . 
compute nonViolent = 0.
if (any(1, CD3A, CD3B, CD3E) and anyViolent=0)  nonViolent = 100 .

* (C) Psychological aggression .
compute anyPsychological = 0 .
if (any(1, CD3D, CD3H)) anyPsychological = 100 .

* (D) Any physical punishment . 
compute anyPhysical = 0 .
if (any(1, CD3C, CD3F, CD3G, CD3I, CD3J, CD3K)) anyPhysical =  100 .

* (E) Severe physical punishment .
compute severePhysical = 0 .
if (any(1, CD3I, CD3K)) severePhysical = 100 .

variable labels
   nonViolent "Only non-violent discipline"
  /anyPsychological "Psychological  aggression"
  /anyPhysical "Any"
  /severePhysical "Severe"
  /anyViolent "Any violent discipline method [1]" .

compute numChildren = 1.
value labels numChildren 1 "Number of children age 1-14 years".

compute layer = 1.
value labels layer 1 "Percentage of children age 1-14 years who experienced:" .

compute layerPhysical = 1.
value labels layerPhysical 1 "Physical punishment" .

compute total = 1.
variable labels total "Total".
value labels total 1 " ".


* Ctables command in English (currently active, comment it out if using different language).
ctables
   /vlabels variables = layer layerPhysical numChildren
            display = none
   /table  total [c]
         + hl4 [c] 
         + hh7 [c] 
         + hh6 [c] 
         + ageGroup [c] 
         + helevel [c] 
         + windex5 [c] 
         + ethnicity [c]
    by 
           layer [c] > (
             nonViolent [s][mean,'',f5.1]
           + anyPsychological [s][mean,'',f5.1]
           + layerPhysical [c] > (
               anyPhysical [s][mean,'',f5.1] 
             + severePhysical [s][mean,'',f5.1] ) 
           + anyViolent [s][mean,'',f5.1] ) 
         + numChildren [c] [count,'',f5.0] 
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
    "Table CP.5: Child discipline"
    "Percentage of children age 1-14 years by child disciplining methods experienced during the last one month, " + surveyname
   caption =
     "[1] MICS indicator 8.3 - Violent discipline".

new file.

