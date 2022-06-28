* Encoding: UTF-8.
* Denominators are obtained by weighting the number of households by the number of household members 
* where water quality was assessed for E. coli (HH48 * wqhweight).

* Levels of E.coli are based on the number per 100 mL (WQ26) as follows: Low (0), Moderate (1-10), High (11-100), Very high (101). 
* Households where data are recorded as 998 should be excluded from the denominator. 

* MICS indicator is WQ26>0. 							  

* Note in some countries the sample sizes will be too small to disaggregate all types of drinking water source and 
* these can be combined into groups (e.g. piped water, protected wells and springs). 
																																																   
***.

* v02 - 2019-08-27. Last modified to reflect tab plan changes as of 25 July 2019.
* v03 - 2020-04-14. Subtitle has been edited. Labels in French and Spanish have been removed.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

include "CommonVarsHH.sps".

sort cases by HH1 HH2.

select if (WQ31 = 1).

* Generate E. coli weights for population.
compute wqhweightHH48 = 0.
if (wqhweight>0) wqhweightHH48=wqhweight*HH48.

*Weighting by number of household members.
weight by wqhweightHH48.

compute nhhmem = 1.
variable labels  nhhmem "Number of household members".
value labels nhhmem 1 " ".

compute total = 1.
variable labels  total "Total".
value labels total 1 " ".

compute EC_100_H = $sysmis.
if (WQ26 <998 and WQ26 >= 100)  EC_100_H = 101.
if (WQ26 <101 or WQ26 >=997) EC_100_H = WQ26. 

recode EC_100_H (0=0) (1 thru 10=1) (11 thru 100=2) (101 = 3) (102 thru highest=9) into Risk_H.
variable labels Risk_H "Risk level based on number of E. coli per 100 mL".
value labels Risk_H 0 "Low (<1 per 100 mL)" 1 "Moderate (1-10 per 100 mL)" 2 "High (11-100 per 100 mL)" 3 "Very high (>100 per 100 mL)" 9 "DK/Missing". 

compute  EC_H=0.
if Risk_H <>0 EC_H=100.
variable labels EC_H "Percentage of household population with  E. coli in household drinking water [1]".

select if Risk_H <=3.

*Type of drinking water source.
do if any(WS1, 11, 12, 13, 14).
+ compute impdrinkingWaterSource = 11.
else if (WS1 = 21).
+ compute impdrinkingWaterSource = 12.
else if any(WS1, 31, 41).
+ compute impdrinkingWaterSource = 13.
else if (WS1 = 51).
+ compute impdrinkingWaterSource = 14.
else if any(WS1, 72).
+ compute impdrinkingWaterSource = 15.						 
else if any(WS1, 61, 71).
+ compute impdrinkingWaterSource = 16.
else if any(WS1, 91, 92).
+ compute impdrinkingWaterSource = 17.
else if any(WS1, 32, 42).			  
+ compute unimpdrinkingWaterSource = 21.
else.
+ compute unimpdrinkingWaterSource = 22.
end if.

do if any(impdrinkingWaterSource, 11, 12, 13, 14, 15, 16, 17).
+ compute watersource = 10.
end if.
do if any(unimpdrinkingWaterSource, 21, 22).
+ compute watersource = 20.
end if.

value labels watersource
  10 "Improved sources"
  11 "   Piped water"
  12 "   Tubewell/Borehole"
  13 "   Protected well or spring"
  14 "   Rainwater collection"
  15 "   Water kiosk"	  				 
  16 "   Tanker-truck/Cart will small tank"
  17 "   Bottled/Sachet water"
  20 "Unimproved sources"
  21 "   Unprotected well or spring"
  22 "   Surface water/Other".

* Define Multiple Response Sets.
mrsets
  /mcgroup name = $watersource
           label = 'Main source of drinking water [A]'
           variables = watersource impdrinkingWaterSource unimpdrinkingWaterSource.
  
* Ctables command in English.
ctables
  /table  total [c]
         + HH6 [c]
         + HH7 [c]
         + helevel [c]
         + $watersource [c]
         + ethnicity [c]
         + windex5 [c]
   by 
            Risk_H [c] [rowpct.totaln '' f5.1]
         + EC_H [s] [mean '' f5.1] 
         + nhhmem [s] [count '' f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /categories variables=Risk_H total=yes position= after label= "Total"
  /slabels position=column visible = no 
 /titles title = 
     "Table WS.1.7: Quality of household drinking water"   
     "Percent distribution and percentage of household population at risk of faecal contamination based on number of E. coli detected in household drinking water, " + surveyname
   caption =
     "[1] MICS indicator WS.5 - Faecal contamination of household drinking water"
     "[A] As collected in the Household Questionnaire; may be different than the source drinking water tested". 

new file.
