* Encoding: windows-1252.
*V2. updated 7 September 2018.
 * Households that use clean fuels and technologies for space heating (EU6=01 OR (EU8=01, 02, 03, 04, 05, OR 06)).

 * Denominators are obtained by weighting the number of households by the number of household members (HH48).

* v03 - 2020-04-14. Table sub-title changed based on the latest tab plan. Labels in French and Spanish have been removed.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open household data file.
get file = 'hh.sav'.

select if (HH46 = 1).

sort cases by HH1 HH2.

* Save data file of person collecting water as only variables.
save outfile = 'tmpEU.sav'
  /keep HH1 HH2 EU6 EU8 .

new file.

get file = 'hl.sav'.

sort cases by HH1 HH2.

* Merge the person collecting the water with the household file. 
match files
  /file = *
  /table = 'tmpEU.sav'
  /by HH1 HH2.

weight by hhweight.

compute cleanEHeat = 2 .
if EU6 = 1 or any(EU8, 1, 2, 3, 4, 5, 6)  cleanEHeat = 1 .
if EU6 = 1 EU8 = $sysmis.

variable labels cleanEHeat "Percentage of household members in households with primary reliance on".
value labels cleanEHeat
  1 "Clean fuels for space heating[A]:"
  2 "Polluting fuels for space heating[A]:".

do if EU6 <> 97.
+compute cleannumnhh=1.
+recode cleanEHeat (1 = 100) (else = 0) into cleanEnergyHeat.
end if.

variable labels cleanEnergyHeat "Primary reliance on clean fuels and technologies for space heating (in households that reported the use of space heating) [1]".

compute centralHeat = 0.
if (EU6 = 1) centralHeat = 100.
variable labels centralHeat "Central heating".

* compute total variable.
compute total100 = 100.
variable labels total100 "Total".
value labels total100 100 " ".

* compute total variable.
compute total = 1.
variable labels total "Total".
value labels total 1 " ".

compute nospace = 0.
if EU6 = 97 nospace = 100.
variable labels nospace "No space heating in the household".

compute nhhmem = 1.
variable labels nhhmem "Number of household members".
value labels nhhmem 1 ' '.

variable labels cleannumnhh "Number of household members (living in households that reported the use of space heating)".
value labels cleannumnhh 1 ' '.
	 
* Ctables command in English.
ctables
  /vlabels variables = eu8 display = none
  /table total [c]
        + HH6 [c]
        + hh7 [c]
        + helevel [c]
        + ethnicity[c]
        + windex5[c]
   by    centralHeat [s] [mean '' f5.1] + cleanEHeat [c] > (eu8 [c] [layerrowpct.totaln '' f5.1]) + nospace [s] [mean '' f5.1] + total100 [s] [mean '' f5.1] 
         + nhhmem [s] [count '' f5.0]  
         + cleanEnergyHeat [s] [mean '' f5.1] 
         + cleannumnhh [c] [count '' f5.0] 
  /slabels visible = no
  /categories variables = all empty = exclude
  /titles title =
    "Table TC.4.4: Primary reliance on clean fuels and technologies for space heating"
    "Percent distribution of household members by type of fuel mainly used for space heating by the household, and percentage of household members living in households using clean fuels and technologies for space heating, " + surveyname 
   caption=
    "[1] MICS indicator TC.16 - Primary reliance on clean fuels and technologies for space heating" 
    "[A] For those living in households that are not using central heating".
																									
new file.

erase file =  'tmpEU.sav'.