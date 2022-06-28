* Encoding: windows-1252.
* MICS5 CP-09.

* v01 - 2013-10-24.
* v02 - 2014-04-22.
* variable WomanAge renamed to wage.
* v03 - 2020-04-21. Subtitle has been edited. Labels in French and Spanish have been removed.
***.

* Currently married or in union
    (MA1=1 or 2) women age 15-19 and 20-24 according to the difference in age with their husbands/partners
    (MA2<>98 and ((MA2-(WB1-WM6)>=10) or (MA2-WB2>=10))= <0, 0-4, 5-9, 10+) .

***.

include "surveyname.sps".

get file = "wm.sav".

include "CommonVarsWM.sps".

select if (WM17 = 1).

weight by wmweight.

select if (any(MA1, 1, 2) and any(wage, 1, 2)).

if (MA2 < 96) ageDifference = MA2 - rnd((wdoi-wdob)/12,1) .
variable labels ageDifference "Age difference with partner".

do if (wage = 1).
+ compute numWomen15_19 = 1.
+ recode ageDifference (lo thru -1 = 1) (0 thru 4 = 2) (5 thru 9 = 3) (10 thru hi = 4) (sysmis = 9) into ageDifference1.
end if.

value labels numWomen15_19 1 "Number of women age 15-19 years currently married/in union".

variable labels ageDifference1 "Percentage of currently married/in union women age 15-19 years whose husband or partner is:".
value labels ageDifference1
  1 "Younger"
  2 "0-4 years older"
  3 "5-9 years older"
  4 "10+ years older [1]"
  9 "Husband/partner's age unknown".

do if (wage = 2).
+ compute numWomen20_24 = 1.
+ recode ageDifference (lo thru -1 = 1) (0 thru 4 = 2) (5 thru 9 = 3) (10 thru hi = 4) (sysmis = 9) into ageDifference2.
end if.

variable labels numWomen20_24 "".
value labels numWomen20_24 1 "Number of women age 20-24 years currently married/in union".

variable labels ageDifference2 "Percentage of currently married/in union women age 20-24 years whose husband or partner is:".
value labels ageDifference2
  1 "Younger"
  2 "0-4 years older"
  3 "5-9 years older"
  4 "10+ years older [2]"
  9 "Husband/partner's age unknown".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".
	 
* Ctables command in English.
ctables
  /vlabels variables = numWomen15_19 numWomen20_24
           display = none
  /table  total [c]
        + hh6 [c]
        + hh7 [c]
        + welevel [c]
        + disability [c]
        + ethnicity [c]
        + windex5 [c]
   by
          ageDifference1 [c] [rowpct.validn '' f5.1]
        + numWomen15_19 [c] [count '' f5.0]
        + ageDifference2 [c] [rowpct.validn '' f5.1]
        + numWomen20_24 [c] [count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables= ageDifference1 ageDifference2 total = yes position = after labels = "Total"
  /slabels position=column visible = no
  /titles title=
     "Table PR.4.3: Spousal age difference"
     "Percent distribution of women currently married/in union age 15-19 and 20-24 years by age difference with their husband or partner, " + surveyname
   caption=
     "[1] MICS indicator PR.7a - Spousal age difference (among women age 15-19)"
     "[2] MICS indicator PR.7b - Spousal age difference (among women age 20-24)"
  .

new file.
