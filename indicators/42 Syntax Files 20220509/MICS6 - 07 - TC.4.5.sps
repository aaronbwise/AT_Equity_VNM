* Encoding: windows-1252.
 * Type of space heating used: EU6
Presence of chimney: EU7

 * Denominators are obtained by weighting the number of households by the number of household members (HH48).

* v02 - 2020-04-14. Labels in French and Spanish have been removed.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open household data file.
get file = 'hh.sav'.

select if (HH46 = 1).

sort cases by HH1 HH2.

* Save data file of person collecting water as only variables.
save outfile = 'tmpEU.sav'
  /keep HH1 HH2 EU6 EU7 .

new file.

get file = 'hl.sav'.

sort cases by HH1 HH2.

* Merge the person collecting the water with the household file. 
match files
  /file = *
  /table = 'tmpEU.sav'
  /by HH1 HH2.

weight by hhweight.

compute spacemanchim=0.
if EU6=2 and EU7=1 spacemanchim=100.
compute spacemannochim=0.
if EU6=2 and EU7=2 spacemannochim=100.
compute spacetradchim=0.
if EU6=3 and EU7=1 spacetradchim=100.
compute spacetradnochim=0.
if EU6=3 and EU7=2 spacetradnochim=100.
compute cookmanchim=0.
if EU6=4 and EU7=1 cookmanchim=100.
compute cookmannochim=0.
if EU6=4 and EU7=2 cookmannochim=100.
compute cooktradchim=0.
if EU6=5 and EU7=1 cooktradchim=100.
compute cooktradnochim=0.
if EU6=5 and EU7=2 cooktradnochim=100.
compute threestone=0.
if EU6=6  threestone=100.
compute other=0.
if EU6=96  other=100.

variable labels spacemanchim "with chimney".
variable labels spacetradchim "with chimney".
variable labels cookmanchim  "with chimney".
variable labels cooktradchim "with chimney".

variable labels spacemannochim "without chimney".
variable labels spacetradnochim "without chimney".
variable labels cookmannochim  "without chimney".
variable labels cooktradnochim "without chimney".

variable labels threestone "Three stone stove / Open fire for space heating".
variable labels other "Other".

compute centralHeat = 0.
if (EU6 = 1) centralHeat = 100.
variable labels centralHeat "Central heating".

compute nospace=0.
if EU6=97 nospace=100.
variable labels nospace "No space heating in the household".


 compute dkmissing =0. 
if EU6>=98 or (centralHeat = 0 and nospace=0 and EU7>=8) dkmissing =100.
variable labels dkmissing "DK/Missing".

* compute total variable.
compute total100 = 100.
variable labels total100 "Total".
value labels total100 100 " ".

* compute total variable.
compute total = 1.
variable labels total "Total".
value labels total 1 " ".

compute nhhmem = 1.
variable labels nhhmem "Number of household members".
value labels nhhmem 1 ' '.

compute layer1 =1.
compute layer2 =1.
compute layer3 =1.
compute layer4 =1.
compute layer5 =1.

value labels layer1 1 "Percentage of household members mainly using:"
  /layer2 1 "Space heater"
  /layer3 1 "Cookstove for space heating"
  /layer4 1 "Manufactured"
  /layer5 1 "Traditional" .
  
* Ctables command in English.
ctables
  /vlabels variables = layer1 layer2 layer3 layer4 layer5
           display = none
  /table total [c]
        + HH6 [c]
        + hh7 [c]
        + helevel [c]
        + ethnicity[c]
        + windex5[c]
   by    centralHeat [s] [mean '' f5.1] + 
         layer1 [c] > (layer2 [c] > (layer4 [c] > (spacemanchim [s] [mean '' f5.1] + spacemannochim [s] [mean '' f5.1] ) + layer5 [c] > (spacetradchim [s] [mean '' f5.1] + spacetradnochim [s] [mean '' f5.1] ) ) + 
                           (layer3 [c] > (layer4 [c] > (cookmanchim [s] [mean '' f5.1] + cookmannochim [s] [mean '' f5.1] ) + layer5 [c] > (cooktradchim [s] [mean '' f5.1] + cooktradnochim [s] [mean '' f5.1] ) ) ) +
                     threestone [s] [mean '' f5.1] + other [s] [mean '' f5.1]   ) + nospace [s] [mean '' f5.1] + dkmissing [s] [mean '' f5.1] + total100 [s] [mean '' f5.1] 
       + nhhmem [s] [count '' f5.0] 
  /slabels visible = no
  /categories variables = all empty = exclude
  /titles title =
    "Table TC.4.5: Type of space heater mainly used and presence of chimney"
     "Percent distribution of household members by the type of space heating mainly used in the household and presence of chimney, " + surveyname.
																																						
new file.

erase file = 'tmpEU.sav'.
