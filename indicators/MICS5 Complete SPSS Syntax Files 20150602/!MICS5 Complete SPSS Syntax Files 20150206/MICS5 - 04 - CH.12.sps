*v1 - 2014-04-03.

* Households that use solid fuels for cooking (HC6=06, 07, 08, 09, 10, or 11) as the main type of fuel used for cooking.

* Denominators are obtained by weighting the number of households by the number of household members (HH11).

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

select if (HH9 = 1).

compute hhweight1 = hhweight*HH11.

weight by hhweight1.

compute total = 1.
variable labels  total "".
value labels total 1 "Number of household members".

* Electricity			01
Liquefied Petroleum Gas (LPG)	02
Natural gas			03
Biogas			04
Kerosene			05
Coal / Lignite		06
Charcoal			07
Wood			08 
Straw / Shrubs / Grass		09
Animal dung		10
Agricultural crop residue		11
No food cooked in household	95
Other (specify)		96.

recode HC6 (97, 98, 99 = 99) (else = copy) into HC6.
variable labels  HC6 "Percentage of household members in households using:".
add value labels HC6
6  "Solid fuels: Coal / Lignite"
7  "Solid fuels: Charcoal"
8  "Solid fuels: Wood"
9  "Solid fuels: Straw / Shrubs / Grass"
10 "Solid fuels: Animal dung"
11 "Solid fuels: Agricultural crop residue".

* Households that use solid fuels for cooking (HC6=06, 07, 08, 09, 10, or 11).
recode HC6 (06, 07, 08, 09, 10, 11 = 100) (else  = 0) into sfuels.
variable labels  sfuels "Solid fuels for cooking [1]".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables =  total tot
         display = none
  /table tot [c] + hh7 [c] + hh6 [c] + helevel [c] + windex5 [c] + ethnicity [c] by 
   hc6 [c] [rowpct.validn,'',f5.1] + sfuels [s] [mean,'',f5.1] + total [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /categories var=HC6 total = yes position=after label="Total"
  /slabels position=column visible = no
  /titles title=
   "Table CH.12: Solid fuel use"
		"Percent distribution of household members according to type of cooking fuel mainly used by the household, "+
                                     "and percentage of household members living in households using solid fuels for cooking, " + surveyname
  caption=
    "[1] MICS indicator 3.15 - Use of solid fuels for cooking ".

												
new file.
