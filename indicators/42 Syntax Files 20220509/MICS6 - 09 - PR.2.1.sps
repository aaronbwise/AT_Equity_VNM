* Encoding: UTF-8.
***.

* v02 - 2019-08-27. Last modified to reflect tab plan changes as of 25 July 2019.
* v03 - 2020-04-21. The disaggregate of Mother’s functional difficulties has been edited and a new note C has been inserted. Labels in French and Spanish have been removed.

* The child discipline module is administered in both the Questionnaire for Children Under Five and the Questionnaire for Children Age 5-17. 
* The module is administered for all children age 1-4, but only to one randomly selected child age 5-17 (if age 5-14). 
* To account for the random selection, the household sample weight is multiplied by the total number of children age 5-17 in each household; this weight is used when producing data on 5-14 year old children in this table.

 * Columns of the table refer to the following (the question numbers are preceded by either U or F, e.g. UCD2A or FCD2A, indicating Under 5 (U) or 5-17 (F), respectively):
(B) Only non-violent discipline: (CD2A=1 or CD2B=1 or CD2E=1 ) and (CD2C, CD2D, CD2F, CD2G, CD2H, CD2I, CD2J, CD2K=2)
(C) Psychological aggression: CD2D=1 or CD2H=1
(D) Any physical punishment: CD2C=1 or CD2F=1 or CD2G=1 or CD2I=1 or CD2J=1 or CD2K=1
(E) Severe physical punishment: CD2I=1 or CD2K=1
(F) Any violent discipline method: CD2C, CD2D, CD2F, CD2G, CD2H, CD2I, CD2J or CD2K=1

* Child disciplining methods in this table should be considered as lower bounds of the actual discipline methods used by the household members, 
* since children who may have been separated from the household members (e.g. at boarding school) during the past month are considered not to have been subjected to any disciplining method.

include "surveyname.sps".

get file = "fs.sav".

sort cases hh1 hh2 ln.

rename variables 
FS17 = result
FCD2A = CD2A
FCD2B = CD2B
FCD2C = CD2C
FCD2D = CD2D
FCD2E = CD2E
FCD2F = CD2F
FCD2G = CD2G
FCD2H = CD2H
FCD2I = CD2I
FCD2J = CD2J
FCD2K = CD2K
fsdisability = disability
fsweight = hweight
CB3 = age.

save outfile = "tmpfs.sav"/keep  HH1 HH2 LN CD2A CD2B CD2C CD2D CD2E CD2F CD2G  CD2H CD2I CD2J CD2K hweight melevel
disability caretakerdis ethnicity wscore windex5 windex10 wscoreu windex5u windex10u wscorer windex5r windex10r age hh6 hh7 hl4 result.

get file = "ch.sav".

sort cases by hh1 hh2 ln.

rename variables 
UF17 = result
UCD2A = CD2A
UCD2B = CD2B
UCD2C = CD2C
UCD2D = CD2D
UCD2E = CD2E
UCD2F = CD2F
UCD2G = CD2G
UCD2H = CD2H
UCD2I = CD2I
UCD2J = CD2J
UCD2K = CD2K
cdisability = disability
chweight = hweight
ub2 = age.

save outfile = "tmpch.sav"/keep hh1 hh2 ln CD2A CD2B CD2C CD2D CD2E CD2F CD2G  CD2H CD2I CD2J CD2K hweight melevel
disability caretakerdis ethnicity wscore windex5 windex10 wscoreu windex5u windex10u wscorer windex5r windex10r age hh6 hh7 hl4 result.

get file = "tmpch.sav".

add files file = * /file = "tmpfs.sav".

select if (result = 1).

select if (age > 0 and age < 15).

weight by hweight.

recode age (1, 2 = 1) (3, 4 = 2) (5 thru 9 = 3) (10 thru 14 = 4) into ageGroup .
variable labels ageGroup "Age" .
value labels ageGroup
  1 "1-2"
  2 "3-4"
  3 "5-9"
  4 "10-14" .


* (F) Any violent discipline method . 
compute anyViolent = 0 .
if (any(1, CD2C, CD2D, CD2F, CD2G, CD2H, CD2I, CD2J, CD2K)) anyViolent = 100 .

* (B) Only non-violent discipline . 
compute nonViolent = 0.
if (any(1, CD2A, CD2B, CD2E) and anyViolent=0)  nonViolent = 100 .

* (C) Psychological aggression .
compute anyPsychological = 0 .
if (any(1, CD2D, CD2H)) anyPsychological = 100 .

* (D) Any physical punishment . 
compute anyPhysical = 0 .
if (any(1, CD2C, CD2F, CD2G, CD2I, CD2J, CD2K)) anyPhysical =  100 .

* (E) Severe physical punishment .
compute severePhysical = 0 .
if (any(1, CD2I, CD2K)) severePhysical = 100 .

variable labels
   nonViolent "Only non-violent discipline"
  /anyPsychological "Psychological  aggression"
  /anyPhysical "Any"
  /severePhysical "Severe [A]"
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

variable labels disability "Child's functional difficulties (age 2-14 years) [B]".
variable labels caretakerdis "Mother's functional difficulties [C]".
		
* Ctables command in English.
ctables
   /vlabels variables = layer layerPhysical numChildren
            display = none
   /table  total [c]
         + hl4 [c] 
         + hh6 [c] 
         + hh7 [c] 
         + ageGroup [c] 
         + melevel [c] 
         + disability [c]
         + caretakerdis [c]
         + ethnicity [c]
         + windex5 [c] 
    by 
           layer [c] > (
             nonViolent [s][mean '' f5.1]
           + anyPsychological [s][mean '' f5.1]
           + layerPhysical [c] > (
               anyPhysical [s][mean '' f5.1] 
             + severePhysical [s][mean '' f5.1] ) 
           + anyViolent [s][mean '' f5.1] ) 
         + numChildren [c] [count '' f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table PR.2.1: Child discipline"
    "Percentage of children age 1-14 years by child disciplining methods experienced during the last one month, " + surveyname
   caption =
     "[1] MICS indicator PR.2 - Violent discipline; SDG 16.2.1"				
     "[A] Severe physical punishment includes: 1) Hit or slapped on the face, head or ears or 2) Beat up, that is, hit over and over as hard as one could	"				
     "[B] Children age 1 year are excluded, as functional difficulties are only collected for age 2-14 years."
     "[C] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."	
.	
	 
new file.

erase file = "tmpch.sav".
erase file = "tmpfs.sav".

