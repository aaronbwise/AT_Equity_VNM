* Encoding: windows-1252.
***.
*v2.2019-03-14.
*v03 - 2020-04-14. Labels in French and Spanish have been removed.

include "surveyname.sps".

get file = 'wm.sav'.

include "CommonVarsWM.sps".

select if (WM17 = 1).

weight by wmweight.

* select women that gave birth in two years preceeding the survey.
select if (CM17 = 1).

* definitions of anc, ageAtBirth .
include 'define\MICS6 - 06 - TM.sps' .

variable labels skilledAttendant "Delivery assisted by any skilled attendant [1]".

recode MN22 (1=100) (else=0) into cBefore .
recode MN22 (2=100) (else=0) into cAfter .
recode MN22 (1,2=100) (else=0) into cTotal .
variable labels 
   cBefore "Decided before onset of labour pains"
  /cAfter "Decided after onset of labour pains"
  /cTotal "Total [2]" .

compute cLayer = 0.
value labels cLayer 0 "Percent delivered by C-section" .

compute numWomen = 1.
variable labels numWomen "Number of women with a live birth in the last 2 years".
value labels numWomen 1 "".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

compute total100 = 100.
variable labels total100 "Total".
value labels total100 100 " ".

value labels noVisitsAux1
  0 "None"
  0.1 "1-3 visits"
  1 "4+ visits"
  2 "   8+ visits"
  9 "DK/Missing".

compute DeliveryDoctor       = 100 * (personAtDelivery = 11).
compute DeliveryNurse        = 100 * (personAtDelivery = 12).
compute DeliveryOtherqual = 100 * (personAtDelivery = 13).
compute DeliveryTraditional    = 100 * (personAtDelivery = 14).
compute DeliveryCommunity      = 100 * (personAtDelivery = 15).
compute DeliveryRelative  = 100 * (personAtDelivery = 16).
compute DeliveryOther        = 100 * (personAtDelivery = 97).
compute DeliveryNone         = 100 * (personAtDelivery = 98).

variable labels DeliveryDoctor       "Medical doctor".
variable labels DeliveryNurse        "Nurse / Midwife".
variable labels DeliveryOtherqual "Other qualified".
variable labels DeliveryTraditional  "Traditional birth attendant".
variable labels DeliveryCommunity    "Community / village health worker".
variable labels DeliveryRelative     "Relative / Friend".
variable labels DeliveryOther        "Other/Missing".
variable labels DeliveryNone         "No attendant".

compute layer1 = 0.
value labels layer1 0 "Person assisting the delivery".

compute layer11 = 0.
value labels layer11 0 "Skilled attendant".

compute layer12 = 0.
value labels layer12 0 "Other".

* Define Multiple Response Sets.
mrsets
  /mcgroup name = $antvisits
           label = 'Number of antenatal care visits'
           variables =  noVisitsAux1 noVisitsAux2 .

* Ctables command in English.
ctables
  /vlabels variables = cLayer layer1 layer11 layer12 display = none
  /table   total [c]
         + hh6 [c]
         + hh7 [c]
         + welevel [c]         
         + ageAtBirth [c]
         + $antvisits [c]
         + $deliveryPlace [c]
         + disability [c]
         + ethnicity[c]
         + windex5 [c]     
   by
           layer1 [c] > 
             (layer11 [c] > (DeliveryDoctor [s][mean F3.1]
                          + DeliveryNurse [s][mean F3.1]
                          + DeliveryOtherqual [s][mean F3.1])
            + layer12 [c] > (DeliveryTraditional [s][mean F3.1]
                          + DeliveryCommunity [s][mean F3.1]
                          + DeliveryRelative [s][mean F3.1]
                          + DeliveryOther [s][mean F3.1])
            + DeliveryNone [s][mean F3.1])
         + total100 [s] [mean '' f5.1]
         + skilledAttendant [s] [mean '' f5.1] 
         + cLayer [c] > (cBefore [s] [mean '' f5.1]  + cAfter [s] [mean '' f5.1]  + cTotal [s] [mean '' f5.1] )
         + numWomen [s] [count '' f5.0]
  /categories variables=all empty=exclude
  /slabels position=column visible=no
  /titles title=
      "Table TM.6.2: Assistance during delivery and caesarian section"
      "Percent distribution of women age 15-49 years with a live birth in the last 2 years by person providing assistance at delivery of the most recent live birth, and percentage of most recent live births delivered by C-section, " + surveyname
   caption=
      "[1] MICS indicator TM.9 - Skilled attendant at delivery; SDG indicator 3.1.2"														
      "[2] MICS indicator TM.10 - Caesarean section"
  .
								
new file.

