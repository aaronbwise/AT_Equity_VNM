* Encoding: UTF-8.
recode mmstatus (1, 2 = 1) (3 = 2) (9 = 9) into mmstatus2.
variable labels mmstatus2 "Marital status".
add value labels mmstatus2
  1 "Ever married/in union"
  2 "Never married/in union"
  9 "Missing".

*****************************************************************.
compute mwageAux = mwage.
if (MWB4 <= 17) mwageAux1 = 1.1.
if (MWB4 >= 18 and MWB4 <=19) mwageAux2 = 1.2.

value labels mwageAux
 1    "15-19"
 1.1 "  15-17" 
 1.2 "  18-19"
 2   "20-24"
 3   "25-29"
 4   "30-34"
 5   "35-39"
 6   "40-44"
 7   "45-49".

* Define Multiple Response Sets.
mrsets
  /mcgroup name = $mwage
           label = 'Age'
           variables = mwageAux mwageAux1 mwageAux2.

*******************************************.
recode MWB4 (15 thru 24 = 10) (25 thru 34 = 20) (35 thru 49 = 30) into mwage1.
recode MWB4 (15 thru 19 = 11) (20 thru 24 = 14) into mwage2.
recode MWB4 (15 thru 17 = 12) (18 thru 19 = 13) into mwage3.

value labels mwage1
    10 "15-24 [1]"
    11 "   15-19"
    12 "      15-17"
    13 "      18-19"
    14 "   20-24"
    20 "25-34"
    30 "35-49".

* Define Multiple Response Sets.
mrsets
  /mcgroup name = $mage
           label = 'Age'
           variables = mwage1 mwage2 mwage3.


*****************************************.
recode mwage (1 = 1) (2 = 4) into mwagexAux1 .
recode MWB4
 (15 thru 17 = 2)
 (18 thru 19 = 3)
 (20 thru 22 = 5)
 (23 thru 24 = 6) into mwagexAux2 .

variable labels mwagexAux1 "Age".
value labels mwagexAux1
 1 "15-19"
 2 "    15-17"
 3 "    18-19"
 4 "20-24"
 5 "    20-22"
 6 "    23-24" .

mrsets
  /mcgroup name=$mwagex
   label='Age'
   variables= mwagexAux1 mwagexAux2 .



*****************************************************************.
recode MWB4 (15 thru 24 = 10) (25 thru 29 = 20) (30 thru 39 = 30) (40 thru 49 = 40) into mwage1y.
recode MWB4 (15 thru 19 = 11) (20 thru 24 = 14) into mwage2y.
recode MWB4 (15 thru 17 = 12) (18 thru 19 = 13) into mwage3y.

value labels mwage1y
    10 "15-24 [1]"
    11 "   15-19"
    12 "      15-17"
    13 "      18-19"
    14 "   20-24"
    20 "25-29"
    30 "30-39"
    40 "40-49".

* Define Multiple Response Sets.
mrsets
  /mcgroup name = $mwagey
           label = 'Age'
           variables = mwage1y mwage2y mwage3y.

*****************************************.
recode MWB4 (15 thru 24 = 10) (25 thru 29 = 20) (30 thru 34 = 30) (35 thru 39 = 40) (40 thru 44 = 50) (45 thru 49 = 60) into mwage1w.
recode MWB4 (15 thru 19 = 11) (20 thru 24 = 14) into mwage2w.
recode MWB4 (15 thru 17 = 12) (18 thru 19 = 13) into mwage3w.

value labels mwage1w
    10 "15-24 [1]"
    11 "   15-19"
    12 "      15-17"
    13 "      18-19"
    14 "   20-24"
    20 "25-29"
    30 "30-34"
    40 "35-39"
    50 "40-44"
    60 "45-49".


* Define Multiple Response Sets.
mrsets
  /mcgroup name = $mwagew
           label = 'Age'
           variables = mwage1w mwage2w mwage3w.

*****************************************.
recode MWB4 (15 thru 24 = 10) (25 thru 29 = 20) (30 thru 39 = 30) (40 thru 49 = 40) into mwage1z.
recode MWB4 (15 thru 19 = 11) (20 thru 24 = 14) into mwage2z.
recode MWB4 (15 thru 17 = 12) (18 thru 19 = 13) into mwage3z.

value labels mwage1z
    10 "15-24"
    11 "   15-19"
    12 "      15-17"
    13 "      18-19"
    14 "   20-24"
    20 "25-29"
    30 "30-39"
    40 "40-49".

* Define Multiple Response Sets.
mrsets
  /mcgroup name = $mwagez
           label = 'Age'
           variables = mwage1z mwage2z mwage3z.