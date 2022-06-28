* Encoding: UTF-8.
***.

* v02 - 2020-04-14. Subtitle has been edited. Labels in French and Spanish have been removed.
* v03 - 2020.03.03. Reference to SDG indicator at the note have been deleted. 

***.
* Improved sanitation facilities are: WS11=11, 12, 13, 15, 18, 21, 22, and 31.

* Denominators are obtained by weighting the number of households by the number of household members (HH48). 

***.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

select if (HH46  = 1).

compute hhweightHH48 = HH48*hhweight.
weight by hhweightHH48.

compute nhhmem = 1.
variable labels  nhhmem "Number of household members".
value labels nhhmem 1 " ".

* include definition of sanitation facilities .
include "define/MICS6 - 10 - WS.sps" .

recode WS11 (97,98, 99 = 99) .
variable labels  WS11 "".
add value labels WS11 
	95 " " 
	99 "DK/Missing".

compute improvepercent=0.
if toiletType=1 improvepercent=100.
variable labels improvepercent "Percentage using improved sanitation [1]".

compute total = 1.
variable labels  total "Total".
value labels total 1 " ".

compute total100 = 100.
variable labels  total100 "Total".
value labels total100 100 " ".

if WS11 = 95 WS14 = 4.
variable labels WS14 "Location of sanitation facility".
add value labels WS14 4 "Open defecation (no facility, bush, field)".

variable labels toiletType "Type of sanitation facility used by household".
add value labels toiletType 1 "Improved sanitation facility" 2 "Unimproved sanitation facility" 3"Open defecation (no facility, bush, field)".

* Ctables command in English.
ctables
  /vlabels variables = WS11 
           display = none
  /table   total [c]
         + HH6 [c]
         + HH7 [c]
         + helevel [c]
         + WS14 [c]
         + ethnicity [c]
         + windex5 [c]
   by
           toiletType [c] >  WS11 [c] [layerrowpct.validn '' f5.1]
         + total100 [s] [mean '' f5.1]
         + improvepercent [s] [mean '' f5.1]
         + nhhmem [s] [count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table WS.3.1: Use of improved and unimproved sanitation facilities"
    "Percent distribution of household population by type of sanitation facility used by the household, " + surveyname
   caption=
     "[1] MICS indicator WS.8 - Use of improved sanitation facilities"
     "na: not applicable".

new file.
