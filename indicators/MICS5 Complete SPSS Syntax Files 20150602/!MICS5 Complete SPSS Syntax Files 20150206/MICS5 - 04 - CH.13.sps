*v1-2014-03-19.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

select if (HH9 = 1).

compute hhweight1 = hhweight*HH11.

weight by hhweight1.

* Households that use solid fuels for cooking (HC6=06, 07, 08, 09, 10, or 11) as the main type of fuel used for cooking.
recode HC6 (06, 07, 08, 09, 10, 11 = 100) (else  = 0) into sfuels.
variable labels  sfuels "Solid fuels for cooking".

select if (sfuels = 100).

compute total = 1.
variable labels  total "".
value labels total 1 "Number of household members in households using solid fuels for cooking".

* HC7: 
In the house:
In a separate room used as kitchen	1
Elsewhere in the house	2
In a separate building	3
Outdoors	4
Other (specify)	6.

variable labels  HC7 "Place of cooking:".
add value labels HC7
1 "In the house: In a separate room used as kitchen"
2 "In the house: Elsewhere in the house"
6 "Other place".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables =  total tot
         display = none
  /table  tot [c] + hh7 [c] + hh6 [c] + helevel [c] + windex5 [c] + ethnicity [c]  by 
   hc7 [c] [rowpct.validn,'',f5.1] +  total [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /categories var=HC7 total = yes position=after label="Total"
  /slabels position=column visible = no
  /titles title=
   "Table CH.13: Solid fuel use by place of cooking"
		"Percent distribution of household members in households using solid fuels by place of cooking, " + surveyname.
new file.
