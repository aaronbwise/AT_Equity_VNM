* Encoding: windows-1252.
 * "Households that use polluting fuels and technology for cooking ((EU1=07, 08, 09, or 96) and (EU1=06 and EU4<>01)) as the main type of fuel used for cooking and 
  in poorly ventilated locations (EU5=1 or 2 and EU2=2)

 * Denominators are obtained by weighting the number of households by the number of household members (HH48)."													
																	

***.
* v02.2019-03-14.
* v03 - 2020-04-14. Labels in French and Spanish have been removed.
* v04 - 2020-07-27.  At table, instead of using "count" for  "nhhmem" and "numpollutingfuels" variables, "sum" is used. 

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

select if (HH46  = 1).

compute hhweightHH48 = HH48*hhweight.

weight by hhweightHH48.

compute nhhmem = 1.
variable labels  nhhmem "Number of household members".
value labels nhhmem 1 " ".

*Household members living in households using polluting fuels and technology for cooking ((EU1=07, 08, 09, or 96) or (EU1=06 and EU4?01)) as the main type of fuel used for cooking and in poorly ventilated locations (EU5=1 or 2 and EU2=2).
compute pollutingfuels=0.
if ((any (EU1, 7, 8, 9, 96) ) or (EU1=6 and EU4<>1)) pollutingfuels=100.
variable labels pollutingfuels "Percentage of household members living in households with primary reliance on polluting fuels and technology for cooking".
	
compute chimney=0.
if EU2=1 chimney=100.
variable labels chimney "Chimney". 

compute fan=0.
if EU3=1 fan=100.
variable labels fan "Fan".

do if pollutingfuels=100.
+ compute cookingplace=EU5.
end if.

variable labels cookingplace "Place of cooking is:".
value labels cookingplace 1 "In main house: No separate room" 2 "In main house: In a separate room" 
                                        3 "In a separate building"
                                        4 "Outdoors: Open air" 5 "Outdoors: On veranda or covered porch"
                                        6 "Other place" 9 "Missing".

do if pollutingfuels=100.
+ compute numpollutingfuels=1.
+ compute pollutingpoorvent=0.
+ if ((any (EU5, 1, 2)) and EU2=2) pollutingpoorvent=100.
end if.

variable labels pollutingpoorvent "Percentage of household members living in households cooking with polluting fuels and technology in poorly ventilated locations".
variable labels numpollutingfuels "Number of household members living in households using polluting fuels and technology for cooking".

compute layer1 = 0.
value labels layer1 0 "Percentage of household members living in households cooking with polluting fuels and".

compute layer2 = 0.
value labels layer2 0 "Cookstove has".

compute total = 1.
variable labels  total "Total".
value labels total 1 " ".

compute total100 = 100.
variable labels  total100 "Total".
value labels total100 100 " ".
										
* Ctables command in English.
ctables
  /vlabels variables = layer1 layer2
           display = none
  /table   total [c]
         + HH6 [c]
         + HH7 [c]
         + helevel [c]
         + ethnicity [c]
         + windex5 [c]
   by 
             pollutingfuels [s] [mean '' f5.1]  
             + nhhmem [s] [sum '' f5.0]             
             +  layer1 [c] > ((layer2 [c] > (chimney [s] [mean '' f5.1] + fan [s] [mean '' f5.1] ) )
             + cookingplace [c] [rowpct.validn '' f5.1] + total100 [s] [mean '' f5.1] )
             + pollutingpoorvent [s] [mean '' f5.1]  
             + numpollutingfuels [s] [sum '' f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title = 
    "Table TC.4.3:  Polluting fuels and technologies for cooking by type and characteristics of cookstove and place of cooking"
    "Percentage of household members living in households with primary reliance on polluting fuels and technology for cooking and percent distribution of household members " +
     "living in households using polluted fuels for cooking by type and characteristics of cookstove and by place of cooking," + surveyname.

new file.