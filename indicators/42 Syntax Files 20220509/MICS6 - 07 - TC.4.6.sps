* Encoding: windows-1252.
*V2. updated 7 September 2018.
 * Households that use clean fuels and technologies for lighting (EU9=01, 02, 03, 04, OR 05).

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
  /keep HH1 HH2 EU9 .

new file.

get file = 'hl.sav'.

sort cases by HH1 HH2.

* Merge the person collecting the water with the household file. 
match files
  /file = *
  /table = 'tmpEU.sav'
  /by HH1 HH2.

weight by hhweight.

do if EU9 < 95.
compute cleanlight = 2 .
+ if any(EU9, 1, 2, 3, 4, 5)  cleanlight = 1 .
end if.

variable labels cleanlight "Percentage of household members in households with primary reliance on".
value labels cleanlight 1 "Clean fuels for lighting:" 2 "Polluting fuels for lighting:". 

* compute total variable.
compute total100 = 100.
variable labels total100 "Total".
value labels total100 100 " ".

* compute total variable.
compute total = 1.
variable labels total "Total".
value labels total 1 " ".

do if EU9 <>97.
+compute cleannumnhh=1.
+compute primaryreliance = 0. 
+if any(EU9, 1, 2, 3, 4, 5)  primaryreliance = 100 .
end if.

variable labels primaryreliance "Primary reliance on clean fuels and technologies for lighting in households that reported the use of lighting [1]".

compute other = 0. 
if EU9 = 96  other = 100 .
variable labels other "Other fuel for lighting".

compute nospace = 0.
if EU9 = 97 nospace = 100.
variable labels nospace "No lighting in the household".

compute missingx = 0. 
 if EU9 = 99 missingx = 100 .
variable labels missingx "Missing".

compute nhhmem = 1.
variable labels nhhmem "Number of household members".
value labels nhhmem 1 ' '.

variable labels cleannumnhh "Number of household members (in households that reported the use of lighting)".
value labels cleannumnhh 1 ' '.

* Ctables command in English.
ctables
  /vlabels variables = EU9 display = none
  /table total [c]
        + HH6 [c]
        + hh7 [c]
        + helevel [c]
        + ethnicity[c]
        + windex5[c]
   by    cleanlight [c] > (eu9 [c] [layerrowpct.totaln '' f5.1])  + other [s] [mean '' f5.1]  + nospace [s] [mean '' f5.1]  + missingx [s] [mean '' f5.1]  + total100 [s] [mean '' f5.1] 
     + nhhmem [s] [count '' f5.0]
     + primaryreliance [s] [mean '' f5.1]
     + cleannumnhh [c] [count '' f5.0] 
  /slabels visible = no
  /categories variables = all empty = exclude
  /titles title =
    "Table TC.4.6: Primary reliance on clean fuels and technologies for lighting"
     "Percent distribution of household members by type of lighting fuel mainly used for lighting by the household, and percentage of household members living in households using clean fuels and technologies for lighting, " + surveyname
   caption=
   "[1] MICS indicator TC.17 - Primary reliance on clean fuels and technologies for lighting".
																																						
new file.

erase file = 'tmpEU.sav'.