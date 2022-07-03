﻿* Encoding: windows-1252.
* MICS6 SR.9.3M.

* v01 - 2017-09-22.
* v02 - 2019-03-14.
* v03 - 2019-08-27. Last modified to reflect tab plan changes as of 25 July 2019.
* v03 - 2020-04-09. Labels in French and Spanish have been removed.

** The table consists of three panels, one for each of computer, mobile phone and internet use.

** Respondents who have ever used a computer are those responding yes to MT4. Those that used in the last 3 months are those responding 1, 2 or 3 in MT5 and those using at least once a week are MT5=2 or 3.

** Ownership of mobile phone: MT11=1. Similar to current use of computers, the use of mobile phone in the last 3 months is MT12=1, 2 or 3 and those using at least weekly are MT12=2 or 3.

** Ever use of internet is MT9=1 or MT6[C]=1 or MT6[F]=1. Similar to above, the current use is captured through MT10.


***.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open men dataset.
get file = 'mn.sav'.

include "CommonVarsMN.sps".

* Select completed interviews.
select if (MWM17 = 1).

* Weight the data by the men weight.
weight by mnweight.

* Generate numMen variable.
compute numMen = 1.
variable labels numMen "".
value labels numMen 1 "Number of men".

* Generate indicators.
* Respondents who have ever used a computer are those responding yes to MMT4. Those that used in the last 3 months are those responding 1, 2 or 3 in MMT5 and those using at least once a week are MMT5=2 or 3.
recode MMT4 (1 = 100) (else = 0) into compev.
variable labels compev "Ever".

recode MMT5 (1, 2, 3= 100) (else = 0) into comp3.
variable labels comp3 "During the last 3 months [1]".

recode MMT5 (2, 3 = 100) (else = 0) into comp1w.
variable labels comp1w "At least once a week during the last 3 months".

* Ownership of mobile phone: MMT11=1. Similar to current use of computers, the use of mobile phone in the last 3 months is MMT12=1, 2 or 3 and those using at least weekly are MMT12=2 or 3.
recode MMT11 (1 = 100) (else = 0) into mobile.
variable labels mobile "Own a mobile phone [2]".

recode MMT12 (1, 2, 3= 100) (else = 0) into mobile3.
variable labels mobile3 "During the last 3 months [3]".

recode MMT12 (2, 3 = 100) (else = 0) into mobile1w.
variable labels mobile1w "At least once a week during the last 3 months".

* Ever use of internet is MMT9=1 or MMT6[C]=1 or MMT6[F]=1. Similar to above, the current use is captured through MMT10.
recode MMT9 (1 = 100) (else = 0) into intev.
if (MMT6C = 1 or MMT6F = 1) intev = 100.
variable labels intev "Ever".

recode MMT10 (1, 2, 3 = 100) (else = 0) into int3.
variable labels int3 "During the last 3 months [4]".

recode MMT10 (2, 3 = 100) (else = 0) into int1w.
variable labels int1w "At least once a week during the last three months [5]".

compute layer0 = 0.
variable labels layer0 "".
value labels layer0 0 "Percentage of men who:".

compute layer1 = 0.
variable labels layer1 "".
value labels layer1 0 "Used a computer".

compute layer2 = 0.
variable labels layer2 "".
value labels layer2 0 "Used a mobile phone".

compute layer3 = 0.
variable labels layer3 "".
value labels layer3 0 "Used internet".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

* Ctables command in English.
ctables
  /vlabels variables =  numMen layer0 layer1 layer2 layer3 total
         display = none
  /table   total [c]
        + hh6 [c]
        + hh7 [c]
        + $mwage [c]
        + mwelevel [c]
        + mdisability [c]
        + ethnicity [c]
        + windex5 [c]
      by
           layer0 [c] > ( layer1 [c] > (compev [s] [mean '' f5.1]
                        + comp3 [s] [mean '' f5.1]
                        + comp1w [s] [mean '' f5.1])
                        + mobile [s] [mean '' f5.1]
                        + layer2 [c] > (mobile3 [s] [mean '' f5.1]
                        + mobile1w [s] [mean '' f5.1])
                        + layer3 [c] > (intev [s] [mean '' f5.1]
                        + int3 [s] [mean '' f5.1]
                        + int1w [s] [mean '' f5.1] ))
         + numMen[c][count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
     "Table SR.9.3M: Use of ICT (men)"
      "Percentage of men age 15-49 years who have ever used a computer, the internet and who own a mobile phone, " +
      "percentage who have used during the last 3 months and percentage who have used at least once weekly during the last 3 months, "
     + surveyname
   caption =
        "[1] MICS indicator SR.9 - Use of computer"
        "[2] MICS indicator SR.10 - Ownership of mobile phone; SDG indicator 5.b.1"												
        "[3] MICS indicator SR.11 - Use of mobile phone"									
        "[4] MICS indicator SR.12a - Use of internet (during the last 3 months); SDG indicator 17.8.1"												
        "[5] MICS indicator SR.12b - Use of internet (at least once a week during the last 3 months)".

new file.