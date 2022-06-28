* Encoding: UTF-8.

* For definitions, see Tables WS.1.2,  WS 2.1 and WS.3.2.

* Denominators are obtained by weighting the number of households by the total number of household members (HH48) .
											
* v02 - 2019-08-28. Last modified to reflect tab plan changes as of 25 July 2019.
* v03 - 2020-04-14. Labels in French and Spanish have been removed.
* v04 - 2020-07-10. Definition of water on premises updated, by removing code 13.

***.

***.

include "surveyname.sps".

get file = 'hh.sav'.

select if (HH46  = 1).

compute hhweightHH48 = HH48*hhweight.
weight by hhweightHH48.

compute nhhmem  = 1.
value labels nhhmem 1 "".
variable labels nhhmem "Number of household members".

* include definition of drinkingWater .
include "define/MICS6 - 10 - WS.sps" .

* Water.
compute drinkingLayer = 0.
value labels drinkingLayer 0 "Drinking water".

recode WS4
  (0 = 2)
 (1 thru 30 = 2)
  (31 thru 990 = 3)
  (998, 999 = 9) into time.

* Water on premises.
if ( any(WS1, 11, 12) or
     any(WS2, 11, 12) or
     any(WS3, 1, 2) )        time = 1.

variable labels  time "Time to source of drinking water".
value labels time
    1 "Water on premises"
    2 "Up to and including 30 minutes [A]"
    3 "More than 30 minutes"
    9 "DK/Missing" .

if (drinkingwater=1 and time <=2) drinking =1. 
if (drinkingwater=1 and time >=3) drinking =2. 
if (drinkingwater=2) drinking =3. 
if (WS1=81) drinking =4. 
variable labels drinking "Drinking water".
value labels drinking 1 "Basic service [1]" 2 "Limited service" 3 "Unimproved" 4 " Surface water".

compute sanitation=toiletType+1.
if (toiletType=1 and sharedToilet = 0) sanitation=1.
variable labels sanitation "Sanitation".
value labels sanitation 1 "Basic service [2]" 2 "Limited service" 3 "Unimproved" 4 " Open defecation" 10 "Missing".

compute handwashing=4.
if HW1<=3 handwashing = 2.
if HW1=4 handwashing = 3.
if (HW1<=4) and (HW2=1 and (HW7A="A" or HW7B="B")) handwashing = 1.
variable labels handwashing "Handwashing [A]".
value labels handwashing 1 "Basic facility [B]" 2 "Limited facility" 3 "No facility" 4 " No permission to see/Other".

compute basictotal=0.
if (drinking=1 and sanitation=1 and handwashing=1) basictotal=100.
variable labels basictotal "Basic drinking water, sanitation and hygiene service".

compute total = 100.
variable labels total "Total".
value labels total 100 " ".

compute layer1 = 0.
value labels layer1 0 "Percentage of household population using:".
	 
* Ctables command in English.
ctables
 /vlabels variables = layer1
           display = none 
 /table   total [c]
        + HH6 [c]
        + HH7 [c]
        + helevel [c]
        + ethnicity [c]
        + windex5 [c]
  by
             layer1 [c] > (drinking [c] [rowpct.totaln '' f5.1]
          + sanitation [c] [rowpct.totaln '' f5.1]     
          + handwashing [c] [rowpct.totaln '' f5.1]   
          + basictotal [s] [mean '' f5.1])   
          + nhhmem [s] [count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=drinking sanitation handwashing total=yes position= after label= "Total"
  /slabels position=column visible = no
  /titles title=
    "Table WS.3.6: Drinking water, sanitation and handwashing ladders"
    "Percentage of household population by drinking water, sanitation and handwashing ladders, " + surveyname
   caption =
    "[1] MICS indicator WS.2 - Use of basic drinking water services; SDG Indicator 1.4	"
    "[2] MICS indicator WS.9 - Use of basic sanitation services; SDG indicators 1.4.1 & 6.2.1"
    "[A] For the purposes of calculating the ladders, 'No permission to see / other' is included in the denominator."
    "[B] Differs from the MICS indicator WS.7 'Handwashing facility with water and soap' (SDG indicators 1.4.1 & 6.2.1) as it includes 'No permission to see / other'. See table WS2.1 for MICS indicator WS.7".
  .																

new file.
