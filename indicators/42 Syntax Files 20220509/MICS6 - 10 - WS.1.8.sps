* Encoding: UTF-8.
* Denominators are obtained by weighting the number of households by the number of household members 
* where water quality was assessed for E. coli (HH48 * wqsweight).

* MICS indicator: Safely managed drinking water sources are defined as improved (WS1=11, 12, 13, 14, 21, 31, 41, 51, 61, 71, 72, 91, 92), 
* located on premises (WS1 or WS2=11, 12) or (WS3=1 or 2), 
* available when needed (WS7=2) and free from faecal contamination at the source (WQ27=0).

* Note in some countries the sample sizes will be too small to disaggregate all types of drinking water source and 
* these can be combined into groups (e.g. piped water, protected wells and springs). 

																																																	   
***.

* v02 - 2019-08-27. Last modified to reflect tab plan changes as of 25 July 2019.
* v03 - 2020-04-14. Labels in French and Spanish have been removed.
* v04 - 2020-05-30. Tablle columns and lables changed due to the tab plan as of May 28 2020 .
* v05 - 2020-07-10. Definition of water on premises updated, by removing code 13.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

sort cases by HH1 HH2.

* include definition of drinking water sources: both improved and unimproved .
include "define/MICS6 - 10 - WS.sps" .

include "CommonVarsHH.sps".

select if (WQ31 = 1).

* Generate E. coli weights for population.
compute wqsweightHH48 = 0.
if (wqsweight>0) wqsweightHH48=wqsweight*HH48.

*Weighting by number of household members.
weight by wqsweightHH48.

compute nhhmem = 1.
variable labels  nhhmem "Number of household members with information on water quality".
value labels nhhmem 1 " ".

compute total = 1.
variable labels  total "Total".
value labels total 1 " ".

compute EC_100_S = $sysmis.
if (WQ27 <997 and WQ27 >= 100)  EC_100_S = 101.
if (WQ27 <101 or WQ27 >=997 ) EC_100_S = WQ27. 

recode EC_100_S (0=0) (1 thru 10=1) (11 thru 100=2) (101 = 3) (102 thru highest=9) into Risk_S.
variable labels Risk_S "Risk level based on number of E. coli per 100 mL".
value labels Risk_S 0 "Low (<1 per 100 mL)" 1 "Moderate (1-10 per 100 mL)" 2 "High (11-100 per 100 mL)" 3 "Very high (>100 per 100 mL)" 9 "DK/Missing". 

compute  WithoutEC_S=0.
if Risk_S = 0 WithoutEC_S=100.
variable labels WithoutEC_S "Without E. coli in drinking water source".

*sufficient water.
compute sufficentwater=0.
if WS7= 2 sufficentwater=100.
variable labels sufficentwater "With drinking water available in sufficient quantities".

* Water on premises.
compute wpremises = 0.
if ( any(WS1, 11, 12) or
     any(WS2, 11, 12) or
     any(WS3, 1, 2) )        wpremises = 100.
variable labels wpremises "Drinking water accessible on premises".

compute indSDG611 = 0.
if (drinkingWater = 1 and WithoutEC_S = 100 and sufficentwater = 100 and wpremises = 100) indSDG611=100.
variable labels indSDG611 "Percentage of household members with an improved drinking water source located on premises, free of E. coli and available when needed [1]".

select if Risk_S<=3.

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

if drinkingWater=1 layer1=1. 
variable labels layer1 "".
value labels layer1 1 "Improved sources".

if drinkingWater=2 layer2=1. 
variable labels layer2 "".
value labels layer2 1 "Unimproved sources".

if drinkingWater=1 nhhmemimp=1. 
variable labels  nhhmemimp "Number of household members with information on water quality who are using improved sources".
value labels nhhmemimp 1 " ".

if drinkingWater=2 nhhmemunimp=1. 
variable labels  nhhmemunimp "Number of household members with information on water quality who are using unimproved sources".
value labels nhhmemunimp 1 " ".

* Ctables command in English.
ctables
  /vlabels variables =  layer1 layer2
           display = none
  /format missing = "na" 
  /table  total [c]
         + HH6 [c]
         + HH7 [c]
         + helevel [c]
         + $watersource [c]
         + ethnicity [c]
         + windex5 [c]
   by 
      layer1 [c] > (
         WithoutEC_S [s] [mean '' f5.1] 
         + sufficentwater [s] [mean '' f5.1] 
         + wpremises [s] [mean '' f5.1] 
         + nhhmemimp [s] [count '' f5.0] )
   + layer2 [c] > (
         WithoutEC_S [s] [mean '' f5.1] 
         + sufficentwater [s] [mean '' f5.1] 
         + wpremises [s] [mean '' f5.1]
         + nhhmemunimp [s] [count '' f5.0]  )
         + indSDG611 [s] [mean '' f5.1] 
         + nhhmem [s] [count '' f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no 
 /titles title = 
     "Table WS.1.8: Safely managed drinking water services"   
     "Percentage of household population with drinking water free from faecal contamination, available when needed, and accessible on premises, " +
     "for users of improved and unimproved drinking water sources and percentage of household members with an improved drinking water source located " +
     "on premises, free of E. coli and available when needed, " + surveyname
   caption =
     "[1] MICS indicator WS.6 - Use of safely managed drinking water services; SDG indicator 6.1.1"
     "[A] As collected in the Household Questionnaire; may be different than the source drinking water tested"
     "na: not applicable".
	 
new file.
