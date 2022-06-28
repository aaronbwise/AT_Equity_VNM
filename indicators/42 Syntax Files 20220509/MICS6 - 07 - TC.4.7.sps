* Encoding: windows-1252.

 * Households that use clean fuels and technologies for cooking, space heating, and lighting (EU1=01, 02, 03, 04, 05, or (EU1=06 and EU4=01)) AND (EU6=01 OR (EU8=01, 02, 03, 04, 05, OR 06)) AND (EU9=01, 02, 03, 04, OR 05).

 * Denominators are obtained by weighting the number of households by the number of household members (HH48).

* v02. updated 7 September 2018.
* v03 - 2020-04-14. Labels in French and Spanish have been removed.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open household data file.
get file = 'hh.sav'.

select if (HH46 = 1).

sort cases by HH1 HH2.

* Save data file of person collecting water as only variables.
save outfile = 'tmpEU.sav'
  /keep HH1 HH2 EU1 EU4 EU6 EU7 EU8 EU9 .

new file.

get file = 'hl.sav'.

sort cases by HH1 HH2.

* Merge the person collecting the water with the household file. 
match files
  /file = *
  /table = 'tmpEU.sav'
  /by HH1 HH2.

weight by hhweight.

compute primarycooking = 0.
if ((any (EU1, 1,2,3,4,5,97) ) or (EU1 = 6 and EU4 = 1)) primarycooking = 100.
variable labels primarycooking "Primary reliance on clean fuels and technologies for cooking".

compute primaryheating = 0.
if (EU6 = 1 or EU6 = 97 or (any (EU8, 1,2,3,4,5,6) )) primaryheating = 100.
variable labels primaryheating "Primary reliance on clean fuels and technologies for space heating".

compute primarylight = 0. 
 if any(EU9, 1, 2, 3, 4, 5, 97) primarylight = 100 .
variable labels primarylight "Primary reliance on clean fuels and technologies for lighting".

compute primaryall = 0.
if (primarycooking = 100 and primaryheating = 100 and primarylight = 100) primaryall = 100.
variable labels primaryall "Primary reliance on clean fuels and technologies for cooking, space heating and lighting [1],[A]".

* compute total variable.
compute total = 1.
variable labels total "Total".
value labels total 1 " ".

compute nhhmem = 1.
variable labels nhhmem "Number of household members".
value labels nhhmem 1 ' '.

* Ctables command in English.
ctables
  /vlabels variables = eu9 display = none
  /table total [c]
        + HH6 [c]
        + hh7 [c]
        + helevel [c]
        + ethnicity[c]
        + windex5[c]
   by    primaryall [s] [mean '' f5.1]  + nhhmem [s] [count '' f5.0] 
  /slabels visible = no
  /categories variables = all empty = exclude
  /titles title =
    "Table TC.4.7: Primary reliance on clean fuels and technologies for cooking, space heating, and lighting"
     "Percentage of household members living in households using clean fuels and technologies for cooking, space heating, and lighting, " + surveyname
   caption=
   "[1] MICS indicator TC.18 - Primary reliance on clean fuels and technologies for cooking, space heating, and lighting; SDG Indicator 7.1.2"
   "[A] In order to be able to calculate the indicator, household members living in households that report no cooking, no space heating, or no lighting are not excluded from the numerator"
.
				
new file.

erase file = 'tmpEU.sav'.
