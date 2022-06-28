* Encoding: UTF-8.

* Basic sanitation services are improved and not shared: (WS11=11, 12, 13, 18, 21, 22, 31) and (WS15=2)

* Public facility: WS16=2. 

* Number of households sharing toilet facilities is based on responses to WS11.

* Denominators are obtained by weighting the number of households by the number of household members (HH48). 

* The distribution of users of between types of improved and unimproved sanitation facilities are as shown in Table WS.3.1.
***.

* v01 - 2020-04-14. Labels in French and Spanish have been removed.
* v02 - 2021.03.03. An additional SDG reference has been added to the MICS Indicator note
***.

include "surveyname.sps".

get file = 'hh.sav'.

select if (HH46  = 1).

compute hhweightHH48 = HH48*hhweight.
weight by hhweightHH48.

compute nhhmem = 1.
variable labels  nhhmem "Number of household members".
value labels nhhmem 1 " ".

* include definition of drinking  water and sanitation facilities.
include "define/MICS6 - 10 - WS.sps" .

do if (toiletType = 1).
+ compute shared1 = sharedToilet.
end if.
variable labels shared1 "Users of improved sanitation facilities".
value labels shared1
  0 "Not shared [1]"
  1 "Shared by: 5 households or less"
  2 "Shared by: More than 5 households"
  3 "Public facility"
  9 "DK/Missing".

do if (toiletType = 2).
+ compute shared2 = sharedToilet.
end if.
variable labels shared2 "Users of unimproved sanitation facilities".
value labels shared2
  0 "Not shared"
  1 "Shared by: 5 households or less"
  2 "Shared by: More than 5 households"
  3 "Public facility"
  9 "DK/Missing".

do if (toiletType = 3).
+ compute shared3 = 1.
end if.
variable labels  shared3 "".
value labels shared3 1 "Open defecation (no facility, bush, field)".

if WS11=95 WS14=4.
variable labels WS14 "Location of sanitation facility".
add value labels WS14  4 "Open defecation (no facility, bush, field)".

compute total = 1.
variable labels  total "Total".
value labels total 1 " ".

compute total100 = 100.
variable labels  total100 "Total".
value labels total100 100 " ".

* Ctables command in English.
ctables
  /format missing = "na" 
  /vlabels variables = shared3
           display = none
  /table   total [c]
         + HH6 [c]
         + HH7 [c]
         + helevel [c]
         + WS14 [c]
         + ethnicity [c]
         + windex5 [c]
   by
           shared1 [c] [rowpct.totaln '' f5.1]
         + shared2 [c] [rowpct.totaln '' f5.1]
         + shared3 [c] [rowpct.totaln '' f5.1]
         + total100 [s] [mean '' f5.1]
         + nhhmem[s][sum '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table WS.3.2: Use basic and limited sanitation services"
    "Percent distribution of household population by use of private and public sanitation facilities and use of shared facilities, "+ 
    "by users of improved and unimproved sanitation facilities, " + surveyname
   caption =
     "[1] MICS indicator WS.9 - Use of basic sanitation services; SDG indicators 1.4.1 & 3.8.1 & 6.2.1"
     "na: not applicable".


new file.

