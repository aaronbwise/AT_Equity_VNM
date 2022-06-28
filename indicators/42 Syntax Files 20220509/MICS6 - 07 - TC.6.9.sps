* Encoding: windows-1252.
 * Intermittent Preventive Treatment (IPT) is defined as pregnant women who received at least 3 doses of SP/Fansidar (MN16=1 and MN17>=3).					

***********************.

* v03 - 2020-04-14. Labels in French and Spanish have been removed.

include "surveyname.sps".

get file = 'wm.sav'.

select if (WM17 = 1).

weight by wmweight.

* Select women that gave birth in two years preceeding the survey.
select if (CM17 = 1).

compute totalN = 1.
variable labels  totalN "Number of women with a live birth in the last 2 years".

include "define\MICS6 - 06 - TM.sps".

compute medicine=0.
if (MN16=1) medicine=100.
variable labels medicine "Who took any medicine to prevent malaria".

compute sponce = 0.
if (MN16 = 1) sponce = 100.

compute spmore2 = 0.
if (MN16 = 1 and MN17 >= 2 and MN17 < 97) spmore2 = 100.

compute spmore3 = 0.
if (MN16 = 1 and MN17 >= 3 and MN17 < 97) spmore3 = 100.

compute spmore4 = 0.
if (MN16 = 1 and MN17 >= 4 and MN17< 97) spmore4 = 100.

variable labels  sponce "At least once".
variable labels  spmore2 "Two or more times".
variable labels  spmore3 "Three or more times [1]".
variable labels  spmore4 "Four or more times".

compute layer=0.
variable labels  layer "".
value labels layer 0 "Percentage of pregnant women:".
compute layer1=0.
variable labels  layer1 "".
value labels layer1 0 "who took SP/Fansidar:".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

* Ctables command in English.
ctables
  /vlabels variables =  tot layer layer1
         display = none
  /table tot [c] 
         + HH6 [c]
         + HH7 [c]
         + welevel [c]
         + ethnicity [c]
         + windex5 [c]
        by 
                layer[c] > (medicine [s][mean '' f5.1] +  
                layer1[c] > (sponce [s][mean '' f5.1] + spmore2 [s][mean '' f5.1] + spmore3 [s][mean '' f5.1] + spmore4 [s][mean '' f5.1]) )+
                totalN [s][validn '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table TC.6.9: Use of Intermittent Preventive Treatment for malaria (IPTp) by women during pregnancy"
	"Percentage of women age 15-49 years with a live birth in the last 2 years who took intermittent preventive treatment (IPTp) for malaria during the pregnancy of the most recent live birth, "+ surveyname
  caption =
    "[1]  MICS indicator TC.25 - Intermittent preventive treatment for malaria during pregnancy".														

new file.
