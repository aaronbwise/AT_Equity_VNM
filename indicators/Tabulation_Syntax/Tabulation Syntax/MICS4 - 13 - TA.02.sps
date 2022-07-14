include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

compute total = 1.
variable label total "".
value label total 1 "Number of women age 15-49 years".

* Maternity status.
do if (CP1 = 1).
+ compute matstat = 1.
else if (UN11G = "G").
+ compute matstat = 2.
else.
+ compute matstat = 3.
end if.
variable label matstat "Maternity status".
value label matstat
	1 "Pregnant"
	2 "Breastfeeding (not pregnant)"
	3 "Neither".

*Percentage of women who smoked a whole cigarette before age 15.
compute cigar15 = 0.
if (TA1 = 1 and (TA2 > 00 and TA2 < 15)) cigar15 = 100.
variable label cigar15 "Percentage of women who smoked a whole cigarette before age 15 [1]".

* Number of women age 15-49 years who are current cigarette smokers.
do if (TA3 = 1).
+ compute totsmoke = 1.
+ recode TA4 (0 thru 4 = 1) (5 thru 9 = 2) (10 thru 19 = 3) (20 thru 96 = 4) (else = 9) into cigarnum.
end if.

variable label totsmoke "".
value label totsmoke 1 "Number of women age 15-49 years who are current cigarette smokers".

variable label cigarnum "Number of cigarettes in the last 24 hours".
value label cigarnum 
 1 "Less than 5"
 2 "5-9"
 3 "10-19"
 4 "20+"
 9 "DK/Missing".

compute tot = 1.
variable label tot "".
value label tot 1 "Total".

ctables
  /vlabels variables =  total totsmoke tot
         display = none
  /table wage [c] + hh7 [c] + hh6 [c] + welevel [c] + matstat [c] + windex5 [c] + ethnicity [c] + tot [c] by
	 cigar15 [s] [mean,'',f5.1] + total[c][count,'',f5.0] + 
                   cigarnum [c] [rowpct.validn,' ',f5.1] + totsmoke[c][count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /categories var=cigarnum total = yes label = "Total"
  /slabels position=column visible = no
  /title title=
	"Table TA.2: Age at first use of cigarettes and frequency of use"						
	"Percentage of women age 15-49 years who smoked a whole cigarette before age 15,  " 
	"and percentage distribution of current smokers by the number of cigarettes smoked in the last 24 hours, " + surveyname						
 caption = 
     	"[1] MICS indicator TA.2".									
														
new file.
