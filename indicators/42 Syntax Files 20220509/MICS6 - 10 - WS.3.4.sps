* Encoding: UTF-8.

 * Column B (safely disposed of in situ) comes from Table 3.3, summing columns D, H, I, M, Q, R, multiplied by the proportion of the population using on-site improved sanitation facilities
 * Column C (unsafely discharged) comes from Table 3.3, summing columns E, F, N, O, multiplied by the proportion of the population using on-site improved sanitation facilities
 * Column D (removal of wastes for treatment) comes from Table 3.3, summing columns B, C, G, K, L, P, multiplied by the proportion of the population using on-site improved sanitation facilities
 * Note that the above column references are based on the standard Table WS.3.3 and must be updated if any additional columns are inserted or if any are deleted.
 * Column E (connected to sewer) comes from WS11 = 11 or 18
 * Column F (unimproved sanitation) comes from WS11 = 14, 23, 41, 51, 96
 * Column G (open defecation) comes from WS11 = 95

***.

* v02 - 2019-08-28. Last modified to reflect tab plan changes as of 25 July 2019.
* v03 - 2020-04-14. Labels in French and Spanish have been removed.
* v04 - 2021.03.03. A new note A has been added to table for column "Connected to sewer". 

include "surveyname.sps".

get file = 'hh.sav'.

include "CommonVarsHH.sps".
select if (HH46  = 1).

recode WS11 (12 = 1) (13, 21, 22, 31 = 2) (else=3) into onsite. 
variable labels onsite "Type of onsite sanitation facility".
value labels onsite 1 "Flush to septic tank" 2 "Latrines and other improved" 3 "Unimproved or not onsite".

compute hhweightHH48 = HH48*hhweight.
weight by hhweightHH48.

compute nhhmem = 1.
variable labels  nhhmem "Number of household members".
value labels nhhmem 1 " ".

* include definition of drinking  water and sanitation facilities.
include "define/MICS6 - 10 - WS.sps" .

*Septic tank.

compute septicemptiedproviderplant=0.
if  (onsite=1 and WS13 = 1) septicemptiedproviderplant=100.
variable labels septicemptiedproviderplant "Removed by a service provider to treatment".

compute septicemptiedproviderDK=0.
if  (onsite=1 and WS13 = 3) septicemptiedproviderDK=100.
variable labels septicemptiedproviderDK "Removed by a service provider to DK".

compute septicemptiedpit=0.
if  (onsite=1 and (WS13 = 2 or WS13 = 4)) septicemptiedpit=100.
variable labels septicemptiedpit "Buried in a covered pit".

compute septicemptiedHHpit=0.
if  (onsite=1 and WS13 = 5) septicemptiedHHpit=100.
variable labels septicemptiedHHpit "To uncovered pit, open ground, water body or elsewhere".

compute septicemptiedother=0.
if  (onsite=1 and WS13 = 6) septicemptiedother=100.
variable labels septicemptiedother "Other".

compute septicemptiedDK=0.
if  (onsite=1 and WS13 = 8) septicemptiedDK=100.
variable labels septicemptiedDK "DK where wastes were taken".

compute septicneveremptied=0.
if  (onsite=1 and WS12 = 4) septicneveremptied=100.
variable labels septicneveremptied "Never emptied".

compute septicDKemptied=0.
if  (onsite=1  and WS12 >= 8) septicDKemptied=100.
variable labels septicDKemptied "DK if ever emptied/Missing".

* other improved on-site sanitation facilities.

compute Oonsiteemptiedproviderplant=0.
if  (onsite=2 and WS13 = 1) Oonsiteemptiedproviderplant=100.
variable labels Oonsiteemptiedproviderplant "Removed by a service provider to treatment".

compute OonsiteemptiedproviderDK=0.
if  (onsite=2 and WS13 = 3) OonsiteemptiedproviderDK=100.
variable labels OonsiteemptiedproviderDK "Removed by a service provider to DK".

compute Oonsiteemptiedpit=0.
if  (onsite=2 and (WS13 = 2 or WS13 = 4)) Oonsiteemptiedpit=100.
variable labels Oonsiteemptiedpit "Buried in a covered pit".

compute OonsiteemptiedHHpit=0.
if  (onsite=2 and WS13 = 5) OonsiteemptiedHHpit=100.
variable labels OonsiteemptiedHHpit "To uncovered pit, open ground, water body or elsewhere".

compute Oonsiteemptiedother=0.
if  (onsite=2 and WS13 = 6) Oonsiteemptiedother=100.
variable labels Oonsiteemptiedother "Other".

compute OonsiteemptiedDK=0.
if  (onsite=2 and WS13 = 8) OonsiteemptiedDK=100.
variable labels OonsiteemptiedDK "DK where wastes were taken".

compute Oonsiteneveremptied=0.
if  (onsite=2 and WS12 = 4) Oonsiteneveremptied=100.
variable labels Oonsiteneveremptied "Never emptied".

compute OonsiteDKemptied=0.
if  (onsite=2  and WS12 >= 8) OonsiteDKemptied=100.
variable labels OonsiteDKemptied "DK if ever emptied/Missing".

compute safedisposal=0.
if (septicemptiedpit=100 or septicneveremptied=100 or septicDKemptied=100 or Oonsiteemptiedpit=100 or Oonsiteneveremptied=100 or OonsiteDKemptied=100) safedisposal=100.
variable labels safedisposal "Safe disposal in situ of excreta from on-site sanitation facilities".

compute unsafedisposal=0.
if (septicemptiedHHpit=100 or septicemptiedother=100 or OonsiteemptiedHHpit=100 or Oonsiteemptiedother=100) unsafedisposal=100.
variable labels unsafedisposal "Unsafe disposal of excreta from on-site sanitation facilities".

compute treatment=0.
if (septicemptiedproviderplant=100 or septicemptiedproviderDK=100 or septicemptiedDK=100 or Oonsiteemptiedproviderplant=100 or OonsiteemptiedproviderDK=100 or OonsiteemptiedDK=100) treatment=100.
variable labels treatment "Removal of excreta for treatment off-site [1]".

compute connectedsewer=0.
if WS11=11 or WS11=18 connectedsewer=100.
variable labels connectedsewer "Connected to sewer [A]".

recode WS11 (14,23,41,51,96=100) (else =0) into usingimproved.
variable labels usingimproved "Using unimproved sanitation facilities".

compute opendefecation=0.
if WS11=95 opendefecation=100.
variable labels opendefecation "Practising open defecation".

compute missingx=0.
if WS11 > 97 missingx=100.
variable labels missingx "Missing".

compute layer1 = 0.
variable labels layer1 " ".
value labels layer1 0 "Using improved on-site sanitation systems (including shared)".

compute total = 1.
variable labels  total "Total".
value labels total 1 " ".

compute total100 = 100.
variable labels  total100 "Total".
value labels total100 100 " ".

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
           layer1 [c] > (safedisposal [s] [mean '' f5.1] + unsafedisposal [s] [mean '' f5.1] + treatment [s] [mean '' f5.1])
          + connectedsewer [s] [mean '' f5.1] + usingimproved [s] [mean '' f5.1] + opendefecation [s] [mean '' f5.1] + missingx [s] [mean '' f5.1] + Total100 [s] [mean '' f5.1]
          + nhhmem[s][sum '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table WS.3.4: Management of excreta from household sanitation facilities"
    "Percent distribution of household population by management of excreta from household sanitation facilities, " + surveyname
   caption =
     "[1] MICS indicator WS.11 - Removal of excreta for treatment off-site; SDG indicator 6.2.1"
     "[A] Includes flush/pour flush facilities that respondents do not know to where they flush."
.

new file.

