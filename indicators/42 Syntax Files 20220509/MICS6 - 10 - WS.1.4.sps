* Encoding: UTF-8.

***.
* v02 - 2020-04-14. The age disaggregate has been changed. The subtitle has been edited.Labels in French and Spanish have been removed.
* v03 - 2020-07-10. Definition of water on premises updated, by removing code 13.
* v04 - 2021.03.03. Definition of Households without drinking water on premises and where household members are primarily responsible for collecting water updated. 

***.

***.
* Households without drinking water on premises and where household members are primarily responsible for collecting water: ((WS1=61, 71 or 72) or (WS2=61, 71 or 72) or WS3=3) AND WS4>000

* Time spent collecting water is WS6 multiplied by average roundtrip travel time (WS4) and divided by 7. 

* Denominators are obtained by weighting the number of households by the total number of household members (HH48).

***.

get file = 'hl.sav'.

* Sort the cases by cluster number, household number and line number.
sort cases by HH1 HH2 HL1.

* Customize the household member education level categories.
recode ED5A (1 = 1) (2 = 2) (3,4 = 3)  (8,9 = 9) (else = 0) into elevel.
variable labels elevel "Education".
value labels elevel
  0 "None/ECE"
  1 "Primary"
  2 "Lower secondary"
  3 "Upper secondary or higher"  
  9 "DK/Missing".

* Save data file of person collecting water as only variables.
save outfile = 'tmppersoncwater.sav'
  /keep HH1 HH2 HL1 HL4 HL6 elevel 
  /rename HL1 = WS5.

new file.

get file = 'hh.sav'.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

sort cases by HH1 HH2.

* Merge the person collecting the water with the household file. 
match files
  /file = *
  /table = 'tmppersoncwater.sav'
  /by HH1 HH2 WS5.

* Water not on premises.
compute withoutWater = 0.
if (any(WS1, 61, 71, 72) or any (WS2, 61, 71, 72) or (WS3=3)) withoutWater=100.
variable labels  withoutWater "Percentage of household members without drinking water on premises".

*selecting households without drinking water on premises and where household members are primarily responsible for collecting water.
select if (HH46  = 1 and withoutWater=100 and WS4>0).

compute hhweightHH48 = HH48*hhweight.
weight by hhweightHH48.

compute nhhmem  = 1.
variable labels  nhhmem "Number of household members without drinking water on premises and where household members are primarily responsible for collecting water".
value labels nhhmem 1 "".

compute time1=$sysmis.
if (WS4<995 and WS6<95) time1=trunc(WS4*WS6/7).
recode time1
  (0 thru 30 = 1)
  (31 thru 60 = 2)
  (61 thru 180 = 3)
  (181 thru highest = 4) into averagetime.
if (WS4>995 or WS6>95) averagetime= 9.

variable labels  averagetime "Average time spent collecting water per day".
value labels averagetime
    1 "Up to 30 minutes"
    2 "From 31 mins to 1 hour"
    3 "Over 1 hour to 3 hours"
    4 "Over 3 hours"
    9 "DK/Missing" .

recode HL6 (0 thru 14 = 1) (15 thru 19 = 2) (20 thru 24 = 3) (25 thru 49 = 4) (50 thru 95 = 5) (98,99 = 9) into age1.
variable labels age1 "Age".
recode HL6 (0 thru 9 = 0.1)  into age2.
recode HL6 (15 thru 17 = 2.1)  into age3.
recode HL6 (18 thru 19 = 2.2)  into age4.
value labels age1 0.1 "0-9" 1 "0-14" 2 "15-19" 2.1 " 15-17" 2.2 " 18-19" 3 "20-24" 4 "25-49" 5 "50+" 9 "DK/Missing". 

* Define Multiple Response Sets.
mrsets
  /mcgroup name = $age
           label = 'Age'
           variables = age1 age2 age3 age4.

* include definition of drinkingWater .
include "define/MICS6 - 10 - WS.sps" .

compute total = 1.
variable labels  total "Total".
value labels total 1 " ".

compute total100 = 100.
variable labels  total100 "Total".
value labels total100 100 " ".

variable labels drinkingWater "Source of drinking water".
value labels drinkingWater 1 "Improved" 2 "Unimproved".

* Ctables command in English.
ctables
  /table   total [c]
         + HH6 [c]
         + HH7 [c]
         + elevel [c]
         + $age [c]
         + HL4 [c]
         + drinkingWater [c]
         + ethnicity [c]
         + windex5 [c]
   by
             averagetime[c][layerrowpct.validn '' f5.1]
         + total100 [s] [mean '' f5.1]
         + nhhmem [s] [count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table WS.1.4: Time spent collecting water "
    "Percent distribution of average time spent collecting water by person usually responsible for water collection, " + surveyname
  .

new file.

erase file = 'tmppersoncwater.sav'.
