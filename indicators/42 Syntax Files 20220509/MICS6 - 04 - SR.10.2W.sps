* Encoding: windows-1252.
* MICS5 TA-02.

* v01 - 2017-06-22.
* v02 - 2019-03-14.
* v03 - 2020-04-09. Labels in French and Spanish have been removed.

* Women who have smoked a whole cigarette before age 15:  
     TA2>00 and TA2<15

* Number of cigarettes in the last 24 hours: 
     TA4 .

***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

* In order to obtain info that UF is in HH, we prepare tmp.sav.
get file = 'hh.sav'.
sort cases by hh1 hh2.

* save variable of the number of UFs in HH.
save outfile = 'tmp.sav'
    /keep = hh1 hh2 hh51.

* Open women dataset.
get file = 'wm.sav'.
sort cases by hh1 hh2 ln.

include "CommonVarsWM.sps".

* merge data.
match files
  /file = *
  /table = 'tmp.sav'
  /by hh1 hh2 .

* Select completed interviews.
select if (WM17 = 1).

* Weight the data by the women weight.
weight by wmweight.

* Generate variable of UF existance in HH.
compute hh51 = 2 - (hh51 > 0) .
variable labels hh51 'Under-5s in the same household'.
value labels hh51
  1 'At least one'
  2 'None'.

* Generate numWomen variable.
compute numWomen = 1.
variable labels numWomen "Number of women age 15-49 years".

* Generate indicators.

*Percentage of women who smoked a whole cigarette before age 15.
compute cigar15 = 0.
if (TA2 > 00 and TA2 < 15) cigar15 = 100.
variable labels cigar15 "Percentage of women who smoked a whole cigarette before age 15 [1]".

* Number of women age 15-49 years who are current cigarette smokers.
do if (TA3 = 1).
+ compute totSmoke = 1.
+ recode TA4 (0 thru 4 = 1) (5 thru 9 = 2) (10 thru 19 = 3) (20 thru 96 = 4) (else = 9) into cigarNum.
end if.

variable labels totSmoke "Number of women who are current cigarette smokers".

variable labels cigarNum "Number of cigarettes in the last 24 hours".
value labels cigarNum 
 1 "Less than 5"
 2 "5-9"
 3 "10-19"
 4 "20+"
 9 "DK/Missing".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

* Ctables command in English.
ctables
  /vlabels variables =  total
           display = none
  /table   total [c]
        + hh6 [c]
        + hh7 [c]
        + $wage [c]
        + welevel [c]
        + hh51 [c]
        + disability [c]
        + ethnicity [c]
        + windex5 [c]
   by
           cigar15 [s] [mean '' f5.1] 
         + numWomen [s][sum '' f5.0] 
         + cigarNum [c] [rowpct.validn,' ',f5.1] 
         + totSmoke [s][sum '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=cigarNum total = yes label = "Total"
  /slabels position=column visible = no
  /titles title=
     "Table SR.10.2W: Age at first use of cigarettes and frequency of use (women)"                        
     "Percentage of women age 15-49 years who smoked a whole cigarette before age 15, " 
     "and percent distribution of current smokers by the number of cigarettes smoked in the last 24 hours, " + surveyname                        
   caption = 
     "[1] MICS indicator SR.15 - Smoking before age 15".  

new file.

erase file = 'tmp.sav'.
