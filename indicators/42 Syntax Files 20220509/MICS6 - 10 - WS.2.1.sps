* Encoding: windows-1252.

* Only households where handwashing facility was observed by the interviewer (HW1=1, 2, 3) and households 
* with no handwashing facility (HW1=4) are included in the denominator of the indicator (HW1=5, 6, and 9 [if any] are excluded). 
* Households with water at handwashing facility (HW2=1) and soap or other cleansing agent at handwashing facility (HW7=A or B) are included in the numerator.
	
* In countries where a large proportion of households (>10%) do not give permission to observe handwashing facilities 
* further analysis of the responses to HW4-HW7 is advised.  

* Denominators are obtained by weighting the number of households by the total number of household members (HH48).
***.

* v01 - 2020-04-14. Labels in French and Spanish have been removed.

***.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

select if (HH46  = 1).

compute hhweightHH48 = HH48*hhweight.
weight by hhweightHH48.

compute nhhmem = 1.
variable labels  nhhmem " ".
value labels nhhmem 1 "Number of household members".

compute layer1 = 0.
variable labels layer1 " ".
value labels layer1 0 "Handwashing facility observed".

compute layer2 = 0.
variable labels layer2 " ".
value labels layer2 0 "Handwashing facility observed and".

compute fixedobserved = 0.
if (HW1 = 1 or HW1 = 2) fixedobserved = 100.
variable labels  fixedobserved "Fixed facility observed".

compute mobileobserved = 0.
if (HW1 = 3) mobileobserved = 100.
variable labels  mobileobserved "Mobile object observed".

compute noplace = 0.
if (HW1 = 4) noplace = 100.
variable labels  noplace "No handwashing facility observed in the dwelling, yard, or plot".

compute nopermission = 0.
if (HW1 >= 5) nopermission = 100.
variable labels  nopermission "No permission to see/Other".

do if (fixedobserved = 100 or mobileobserved = 100).
+ compute numHouseholdsObs = 1.
+ compute water=0.
* Water is available.
+ if HW2=1 water=100.
+ compute Soap = 0.
* Soap present.
+ if (HW7A = "A" or HW7B = "B") Soap = 100.
+ compute Ash = 0.
* Ash, mud, or sand present.
+ if (HW7C = "C") Ash = 100.
end if.

do if (fixedobserved = 100 or mobileobserved = 100 or noplace = 100).
+ compute numHHObsnoplace = 1.
+ compute indWS7 = 0.
+ if (HW2 = 1 and (HW7A = "A" or HW7B = "B")) indWS7 = 100.
end if.

variable labels  water "water available".
variable labels  Soap "soap available".
variable labels  Ash "with ash/mud/sand available".

variable labels indWS7 "Percentage of household members with handwashing facility where water and soap are present[1]".

* Make sure to include entire labels in final table. As labels exceeds 120 characters it had to be truncated by removing > in the dwelling, yard, or plot<.
* Number of household members where handwashing facility was observed or with no handwashing facility in the dwelling, yard, or plot.
value labels numHHObsnoplace 1 "Number of household members where handwashing facility was observed or with no handwashing facility in the dwelling, yard, or plot".

variable labels numHouseholdsObs "".
value labels numHouseholdsObs 1 "Number of household members where handwashing facility was observed".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

compute total100 = 100.
variable labels total100 "Total".
value labels total100 100 "".

* Ctables command in English.
ctables
  /vlabels variables =  layer1 layer2 total nhhmem numHouseholdsObs numHHObsnoplace
         display = none
  /table   total [c]
         + HH6 [c]
         + HH7 [c]
         + helevel [c]
         + ethnicity [c]
         + windex5 [c]
   by
          layer1 [c] > (fixedobserved [s] [mean '' f5.1] + mobileobserved [s] [mean '' f5.1]) + noplace [s] [mean '' f5.1] + nopermission [s] [mean '' f5.1] + total100  [s] [mean '' f5.1] + nhhmem [c] [count '' f5.0]
         +  layer2 [c] > (water [s] [mean '' f5.1] + Soap [s] [mean '' f5.1] + Ash [s] [mean '' f5.1]) + numHouseholdsObs [c] [count '' f5.0]
         + indWS7  [s] [mean '' f5.1]
         + numHHObsnoplace [c] [count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table WS.2.1: Handwashing facility with soap and water on premises" 
      "Percent distribution of household members by observation of handwashing facility and percentage of household members by availability of water and soap or detergent at the handwashing facility, " + surveyname
   caption=
     "[1] MICS indicator WS.7 - Handwashing facility with water and soap; SDG indicators 1.4.1 & 6.2.1"
     "Note: Ash, mud, sand are not as effective as soap and not included in the MICS or SDG indicator. ".

new file.
