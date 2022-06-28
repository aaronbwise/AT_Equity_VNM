* Encoding: windows-1252.
 * "Households that use clean fuels and technologies for cooking (EU1=01, 02, 03, 04, 05, or (EU1=06 and EU4=01)).
 * Note: A liquid fuel stove (EU1=06) is considered clean if used with ethanol/alcohol (EU4=01)

 * Households that use solid fuels for cooking ((EU1=07, 08, 09, or 96) and (EU1=06 and EU4 <> (01, 02, 03))) as the main type of fuel used for cooking.

 * Denominators are obtained by weighting the number of households by the number of household members (HH48)."																		

***.

* v02. 2019-03-14.
* v03 - 2019-08-27. Correction made for calculation of variable solidftech.
* v04 - 2020-04-14. Labels in French and Spanish have been removed.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

select if (HH46  = 1).

compute hhweightHH48 = HH48*hhweight.

weight by hhweightHH48.

compute nhhmem = 1.
variable labels  nhhmem "Number of household members".
value labels nhhmem 1 " ".

*Household members that live in households using clean fuels and technologies for cooking (EU1=01, 02, 03, 04, 05, or (EU1=06 and EU4=01)).
*Note: A liquid fuel stove (EU1=06) is considered clean if used with ethanol/alcohol (EU4=01).
compute cleanfuels=0.
if ((any (EU1,1,2,3,4,5) ) or (EU1=6 and EU4=1)) cleanfuels=100.
variable labels cleanfuels "Clean fuels and technologies".

compute alcohol=0.
if cleanfuels=0 and EU4=1 alcohol=100.
variable labels alcohol "Alcohol/ Ethanol".

compute gasoline=0.
if cleanfuels=0 and EU4=2 gasoline=100.
variable labels gasoline "Gasoline/ Diesel".

compute kerosene=0.
if cleanfuels=0 and EU4=3 kerosene=100.
variable labels kerosene "Kerosene/ Paraffin".

compute coal=0.
if cleanfuels=0 and EU4=4 coal=100.
variable labels coal "Coal/ Lignite".

compute charcoal=0.
if cleanfuels=0 and EU4=5 charcoal=100.
variable labels charcoal "Charcoal".

compute wood=0.
if cleanfuels=0 and EU4=6 wood=100.
variable labels wood "Wood".

compute crop=0.
if cleanfuels=0 and EU4=7 crop=100.
variable labels crop "Crop residue / Grass/ Straw/ Shrubs".

compute animaldung=0.
if cleanfuels=0 and EU4=8 animaldung=100.
variable labels animaldung "Animal dung/ waste".

compute pbiomass=0.
if cleanfuels=0 and EU4=9 pbiomass=100.
variable labels pbiomass "Processed biomass (pellets) or woodchips".

compute garbage=0.
if cleanfuels=0 and EU4=10 garbage=100.
variable labels garbage "Garbage/ Plastic".

compute sawdust=0.
if cleanfuels=0 and EU4=11 sawdust=100.
variable labels sawdust "Sawdust".

compute other=0.
if cleanfuels=0 and EU4=96 other=100.
variable labels other "Other fuel for cooking".

compute nofood=0.
if EU1=97 nofood=100.
variable labels nofood "No food cooked in the household".

compute missingfuel=0.
if EU1 = 99 or EU4=99 missingfuel=100.
variable labels missingfuel "Missing".

*Household members living in households using solid fuels and technology for cooking ((EU1=07, 08, 09, or 96) or (EU1=06 and EU4?01, 02, 03)) as the main type of fuel used for cooking.
compute solidftech=0.
if (any(EU1,7,8,9,96) or (EU1=06 and not any(EU4,1,2,3))) solidftech=100.
 * if (charcoal = 100 or wood = 100 or crop = 100 or animaldung = 100 or pbiomass = 100 or garbage = 100 or sawdust = 100) solidftech=100.
variable labels solidftech "Solid fuels and technology for cooking".

compute layer1 = 0.
value labels layer1 0 "Percentage of household members in households with primary reliance on:".

compute layer2 = 0.
value labels layer2 0 "Solid fuels for cooking".

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
          layer1 [c] > ((cleanfuels [s] [mean '' f5.1] + alcohol [s] [mean '' f5.1] + gasoline [s] [mean '' f5.1] + kerosene [s] [mean '' f5.1] ) +
             layer2 [c] > (coal [s] [mean '' f5.1]
             + charcoal [s] [mean '' f5.1]  
             + wood [s] [mean '' f5.1]  
             + crop [s] [mean '' f5.1]  
             + animaldung [s] [mean '' f5.1]  
             + pbiomass [s] [mean '' f5.1]  
             + garbage [s] [mean '' f5.1]  
             + sawdust [s] [mean '' f5.1]  ))
             + other [s] [mean '' f5.1]  
             + nofood [s] [mean '' f5.1]  
             + missingfuel [s] [mean '' f5.1]  
         + total100 [s] [mean '' f5.1] 
         + solidftech [s] [mean '' f5.1] 
         + nhhmem [s] [count '' f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title = 
    "Table TC.4.2: Primary reliance on solid fuels for cooking"
    "Percent distribution of household members living in households with primary reliance on clean and other fuels and technology for cooking and " +
    "percentage of household members living in households using polluting fuels and technologies for cooking, " + surveyname
.
  
new file.