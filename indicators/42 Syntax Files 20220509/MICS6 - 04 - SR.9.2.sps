* Encoding: UTF-8.
* MICS6 SR.9.2.

* v01 - 2017-11-07.
* v03 - 2020-04-09. Plural has been added to column H. Labels in French and Spanish have been removed.

* Households with radio, tv, computer and internet are those who responded yes to HC7[B], HC9[A], HC11 and HC13, respectively.

* Households with telephone are those who responded yes to either HC7[A] or HC12, or in which any individual woman (or man) age 15-49 responded yes to MT11 (or MMT11).


***.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'wm.sav'.

sort cases by hh1 hh2 ln.

recode MT11 (1 = 1) (else = 0).
aggregate outfile = "tmp1.sav"
/break hh1 hh2 
/fixedW = max (MT11).

get file = 'mn.sav'.
sort cases by hh1 hh2 ln.
recode MMT11 (1 = 1) (else = 0).
aggregate outfile = "tmp2.sav"
/break hh1 hh2 
/fixedM = max (MMT11).

* Open household data file.
get file = 'hh.sav'.

sort cases by hh1 hh2.

* merging with tmp file with mother's line number.
match files
 /file=*
 /table='tmp1.sav'
 /table='tmp2.sav'
 /by hh1 hh2.

* Select interviewed households.
select if (HH46 = 1).

* Weight the data by the household weight.
weight by hhweight.

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of households with a:".

compute layer1 = 0.
variable labels layer1 "".
value labels layer1 0 "Telephone".

recode HC7A (1 = 100) (else = 0) into fixed.
recode HC7B (1 = 100) (else = 0) into radio.
recode HC9A (1 = 100) (else = 0) into tv.
recode HC11 (1 = 100) (else = 0) into computer.
recode HC12 (1 = 100) (else = 0) into mobile.
recode HC13 (1 = 100) (else = 0) into internet.

if (fixedW = 1 or fixedM = 1) mobile = 100.

compute anyphone = 0.
if (fixed = 100 or mobile = 100) anyphone = 100.

variable labels
  radio          "Radio [1]"/
  tv               "Television [2]"/
  fixed           "Fixed line"/
  mobile        "Mobile phone"/
  anyphone    "Any [3]"/
  computer    "Computer [4]"/
  internet       "Percentage of households that have access to the internet at home [5]".

* compute total variable.
compute total = 100.
variable labels total "Total".
value labels total 100 " ".

compute numHouseholds = 1.
variable labels numHouseholds "Number of households".
value labels numHouseholds 1 ' '. 
 
* Ctables command in English.
ctables
  /vlabels variables = layer layer1 display = none
  /format missing=' '
  /table 
        total [c]
        + hh6 [c]
        + hh7 [c]
        + helevel [c]
        + ethnicity[c]
        + windex5[c]
   by    layer [c] >
            (radio [s][mean f5.1]
           + tv [s][mean f5.1]
           + layer1 [c] >           
           (fixed [s][mean f5.1]
           + mobile [s][mean f5.1]
           + anyphone [s][mean f5.1])
           + computer [s][mean f5.1])
           + internet [s][mean f5.1]
           + numHouseholds [s] [count, f5.0]
  /slabels visible = no
  /titles title =
     "Table SR.9.2: Household ownership of ICT equipment and access to internet"
     "Percentage of households with a radio, a television, a telephone and a computer, and have access to the internet at home, " + surveyname 
   caption=
    "[1] MICS indicator SR.4 - Households with a radio" 
    "[2] MICS indicator SR.5 - Households with a television" 
    "[3] MICS indicator SR.6 - Households with a telephone" 
    "[4] MICS indicator SR.7 - Households with a computer" 
    "[5] MICS indicator SR.8 - Households with internet".			

new file.

erase file = "tmp1.sav".
erase file = "tmp2.sav".


