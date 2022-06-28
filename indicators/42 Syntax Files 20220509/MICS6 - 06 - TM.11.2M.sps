* Encoding: windows-1252.
 * "The denominator includes all men, including those who have not heard of AIDS (MHA1=2).

 * Men who know at least one of the three means are men who answered 'yes' to at least one of the three means of transmission (MHA8[A]=1 or MHA8[B]=1 or MHA8[C]=1).

 * Those who know all three means are those who answered ‘yes’ to all three means (MHA8[A]=1 and MHA8[B]=1 and MHA8[C]=1).

 * Those who know at least one of the three means and also that risk can be reduced by mother taking special drugs are men who answered 'yes' to at least one of the 
 three means of transmission and also answered 'yes' to MHA10 ((MHA8[A]=1 or MHA8[B]=1 or MHA8[C]=1) and MHA10=1).

 * "By breastfeeding and that risk can be reduced by mother taking special drugs during pregnancy" are those who responded 'yes' to both MHA8[C] and MHA10.

 * The column labelled ‘Do not know any of the specific means of HIV transmission from mother to child’ includes men who responded 'no' or 'don't know' to all MHA8[A]-[C] or to MHA1.									

***.

* v02.2019-03-14.
* v03 - 2020-04-14. Labels in French and Spanish have been removed.

include "surveyname.sps".

get file = 'mn.sav'.

include "CommonVarsMN.sps".

select if (MWM17 = 1).

weight by mnweight.

* include TM.M . 
include 'define\MICS6 - 06 - TM.M.sps' .

compute atLeastOneanddrugs=0.
if (atLeastOne=100 and MHA10=1) atLeastOneanddrugs=100.
variable labels atLeastOneanddrugs "By at least one of the three means and that risk can be reduced by mother taking special drugs during pregnancy". 

compute breastfeedinganddrugs=0.
if (MHA8C=1 and MHA10=1) breastfeedinganddrugs=100.
variable labels breastfeedinganddrugs "By breastfeeding and that risk can be reduced by mother taking special drugs during pregnancy". 

compute layer0 = 0.
variable labels layer0 "".
value labels layer0 0 "Percentage of men who:".

compute layer1 = 0.
variable labels layer1 "".
value labels layer1 0 "Know HIV can be transmitted from mother to child:".

compute numMen = 1.
variable labels numMen "".
value labels numMen 1 "Number of men".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

* ctables command in English.
ctables
  /vlabels variables =  numMen layer0 layer1 total 
           display = none
  /table   total [c] 
         + HH6 [c]
         + HH7 [c]
         + $mwagez [c]
         + mwelevel [c]
         + mmstatus2 [c]
         + mdisability [c]
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
         + numMen[c][count '' f5.0]
  /categories variables = all empty = exclude missing = exclude
  /slabels visible = no
  /titles title=
    "Table TM.11.2M: Knowledge of mother-to-child HIV transmission (men)"
    "Percentage of men age 15-49 years who correctly identify means of HIV transmission from mother to child, " + surveyname
   caption = 
    "[1] MICS indicator TM.30 - Knowledge of mother-to-child transmission of HIV "
  .

new file.
