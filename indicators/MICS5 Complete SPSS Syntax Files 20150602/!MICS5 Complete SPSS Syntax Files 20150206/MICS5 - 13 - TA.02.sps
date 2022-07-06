* MICS5 TA-02.

* v01 - 2013-06-22.

* Women who have smoked a whole cigarette before age 15:  
     TA2>00 and TA2<15

* Number of cigarettes in the last 24 hours: 
     TA4 .

***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

* In order to obtain info that UF is in HH, we prepare tmp.sav.
get file = 'hh.sav'.

* save variable of the nuber of UFs in HH.
save outfile = 'tmp.sav'
    /keep = hh1 hh2 hh14.

* Open women dataset.
get file = 'wm.sav'.

* merge data.
match files
  /file = *
  /table = 'tmp.sav'
  /by hh1 hh2 .

* Select completed interviews.
select if (WM7 = 1).

* Weight the data by the women weight.
weight by wmweight.

* Generate variable of UF existance in HH.
compute hh14 = 2 - (hh14 > 0) .
variable labels hh14 'Under-5s in the same household'.
value labels hh14
  1 'At least one'
  2 'None'.

* Generate total variable.
compute numWomen = 1 .
variable labels numWomen "Number of women age 15-49 years" .

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

variable labels totSmoke "Number of women age 15-49 years who are current cigarette smokers".

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

ctables
  /vlabels variables =  total
           display = none
  /table   total [c]
         + wage [c]
         + hh7 [c] 
         + hh6 [c] 
         + welevel [c] 
         + hh14 [c] 
         + windex5 [c] 
         + ethnicity [c]  
   by
           cigar15 [s] [mean,'',f5.1] 
         + numWomen [s][sum,'',f5.0] 
         + cigarNum [c] [rowpct.validn,' ',f5.1] 
         + totSmoke [s][sum,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /categories var=cigarNum total = yes label = "Total"
  /slabels position=column visible = no
  /title title=
     "Table TA.2: Age at first use of cigarettes and frequency of use (women)"                        
     "Percentage of women age 15-49 years who smoked a whole cigarette before age 15,  " 
     "and percentage distribution of current smokers by the number of cigarettes smoked in the last 24 hours, " + surveyname                        
   caption = 
     "[1] MICS indicator 12.2 - Smoking before age 15".                                    
                                                        
new file.

erase file = 'tmp.sav'.
