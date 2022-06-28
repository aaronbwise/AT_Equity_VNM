* Encoding: windows-1252.
 * "The denominator includes all women, including those who have not heard of AIDS (HA1=2).

 * Women who know at least one of the three means are women who answered 'yes' to at least one of the three means of transmission (HA8[A]=1 or HA8[B]=1 or HA8[C]=1).

 * Those who know all three means are those who answered ‘yes’ to all three means (HA8[A]=1 and HA8[B]=1 and HA8[C]=1).

 * Those who know at least one of the three means and also that risk can be reduced by mother taking special drugs are women who answered 'yes' to 
   at least one of the three means of transmission and also answered 'yes' to HA10 ((HA8[A]=1 or HA8[B]=1 or HA8[C]=1) and HA10=1).

 * "By breastfeeding and that risk can be reduced by mother taking special drugs during pregnancy" are those who responded 'yes' to both HA8[C] and HA10.

 * The column labelled ‘Do not know any of the specific means of HIV transmission from mother to child’ includes women who responded 'no' or 'don't know' to all HA8[A]-[C] or to HA1.								


***.

* v02.2019-03-14.
* v03 - 2020-04-14. Labels in French and Spanish have been removed.

include "surveyname.sps".

get file = 'wm.sav'.

include "CommonVarsWM.sps".

select if (WM17 = 1).

weight by wmweight.

include 'define\MICS6 - 06 - TM.sps' .

compute atLeastOneanddrugs=0.
if (atLeastOne=100 and HA10=1) atLeastOneanddrugs=100.
variable labels atLeastOneanddrugs "By at least one of the three means and that risk can be reduced by mother taking special drugs during pregnancy". 

compute breastfeedinganddrugs=0.
if (HA8C=1 and HA10=1) breastfeedinganddrugs=100.
variable labels breastfeedinganddrugs "By breastfeeding and that risk can be reduced by mother taking special drugs during pregnancy". 

compute layer0 = 0.
variable labels layer0 "".
value labels layer0 0 "Percentage of women who:".

compute layer1 = 0.
variable labels layer1 "".
value labels layer1 0 "Know HIV can be transmitted from mother to child:".

compute numWomen = 1.
variable labels numWomen "".
value labels numWomen 1 "Number of women".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

* ctables command in English.
ctables
  /vlabels variables =  numWomen layer0 layer1 total 
           display = none
  /table   total [c] 
         + HH6 [c]
         + HH7 [c]
         + $wagez [c]
         + welevel [c]
         + mstatus2 [c]
         + disability [c]
         + ethnicity [c]
         + windex5 [c]
   by 
          layer0 [c] > ((
              layer1 [c] > (
              duringPregnancy [s] [mean '' f5.1]
              + duringDelivery [s] [mean '' f5.1] 
              + byBreastfeeding [s] [mean '' f5.1] 
              + atLeastOne [s] [mean '' f5.1]
              + allThree [s] [mean '' f5.1] )
             + layer1 [c] > (
                atLeastOneanddrugs [s] [mean '' f5.1]
              + breastfeedinganddrugs [s] [mean '' f5.1]))
           + none [s] [mean '' f5.1])
         + numWomen[c][count '' f5.0]
  /categories variables = all empty = exclude missing = exclude
  /slabels visible = no
  /titles title=
    "Table TM.11.2W: Knowledge of mother-to-child HIV transmission (women)"
    "Percentage of women age 15-49 years who correctly identify means of HIV transmission from mother to child, " + surveyname
   caption = 
    "[1] MICS indicator TM.30 - Knowledge of mother-to-child transmission of HIV"
  .

new file.
