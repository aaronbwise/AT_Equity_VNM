* Encoding: UTF-8.
recode mstatus (1, 2 = 1) (3 = 2) (9 = 9) into mstatus2.
variable labels mstatus2 "Marital status".
add value labels mstatus2
  1 "Ever married/in union"
  2 "Never married/in union"
  9 "Missing".

*****************************************************************.
compute wageAux = wage.
if (WB4 <= 17) wageAux1 = 1.1.
if (WB4 >= 18 and WB4 <=19) wageAux2 = 1.2.

value labels wageAux
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
  /mcgroup name = $wage
           label = 'Age'
           variables = wageAux wageAux1 wageAux2.

*******************************************.
recode WB4 (15 thru 24 = 10) (25 thru 34 = 20) (35 thru 49 = 30) into wage1.
recode WB4 (15 thru 19 = 11) (20 thru 24 = 14) into wage2.
recode WB4 (15 thru 17 = 12) (18 thru 19 = 13) into wage3.

value labels wage1
    10 "15-24 [1]"
    11 "   15-19"
    12 "      15-17"
    13 "      18-19"
    14 "   20-24"
    20 "25-34"
    30 "35-49".

* Define Multiple Response Sets.
mrsets
  /mcgroup name = $age
           label = 'Age'
           variables = wage1 wage2 wage3.


*****************************************.
recode wage (1 = 1) (2 = 4) into wagexAux1 .
recode WB4
 (15 thru 17 = 2)
 (18 thru 19 = 3)
 (20 thru 22 = 5)
 (23 thru 24 = 6) into wagexAux2 .

variable labels wagexAux1 "Age".
value labels wagexAux1
 1 "15-19"
 2 "    15-17"
 3 "    18-19"
 4 "20-24"
 5 "    20-22"
 6 "    23-24" .

mrsets
  /mcgroup name=$wagex
   label='Age'
   variables= wagexAux1 wagexAux2 .


*****************************************.
recode WB4 (15 thru 24 = 10) (25 thru 29 = 20) (30 thru 39 = 30) (40 thru 49 = 40) into wage1y.
recode WB4 (15 thru 19 = 11) (20 thru 24 = 14) into wage2y.
recode WB4 (15 thru 17 = 12) (18 thru 19 = 13) into wage3y.

value labels wage1y
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
  /mcgroup name = $wagey
           label = 'Age'
           variables = wage1y wage2y wage3y.


*****************************************.
recode WB4 (15 thru 24 = 10) (25 thru 29 = 20) (30 thru 34 = 30) (35 thru 39 = 40) (40 thru 44 = 50) (45 thru 49 = 60) into wage1w.
recode WB4 (15 thru 19 = 11) (20 thru 24 = 14) into wage2w.
recode WB4 (15 thru 17 = 12) (18 thru 19 = 13) into wage3w.

value labels wage1w
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
  /mcgroup name = $wagew
           label = 'Age'
           variables = wage1w wage2w wage3w.

*****************************************.
recode WB4 (15 thru 24 = 10) (25 thru 29 = 20) (30 thru 39 = 30) (40 thru 49 = 40) into wage1z.
recode WB4 (15 thru 19 = 11) (20 thru 24 = 14) into wage2z.
recode WB4 (15 thru 17 = 12) (18 thru 19 = 13) into wage3z.

value labels wage1z
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
  /mcgroup name = $wagez
           label = 'Age'
           variables = wage1z wage2z wage3z.

*******************************************.
recode WB4 (15 thru 19 = 1) (20 thru 24 = 2) (25 thru 29 = 3) (30 thru 39 = 4) (40 thru 49 = 5) into wageu.
value labels wageu
    1 "15-19"
    2 "20-24"
    3 "25-29"
    4 "30-39"
    5 "40-49".
variable labels wageu "Age".


*****************************************.
recode WB4 (15 thru 19 = 10) (20 thru 24 = 20) (25 thru 29 = 25) (30 thru 39 = 30) (40 thru 49 = 40) into wage1xx.
recode WB4 (15 thru 17 = 12) (18 thru 19 = 13) into wage2xx.

value labels wage1xx
    10 "15-19"
    12 "  15-17"
    13 "  18-19"
    20 "20-24"
    25 "25-29"
    30 "30-39"
    40 "40-49".

* Define Multiple Response Sets.
mrsets
  /mcgroup name = $wagexx
           label = 'Age'
           variables = wage1xx wage2xx.

