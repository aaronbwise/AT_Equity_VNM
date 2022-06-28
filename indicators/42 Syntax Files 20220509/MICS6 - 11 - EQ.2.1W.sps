* Encoding: windows-1252.
 * Women with health insurance coverage: WB18=1

***.
* v02 - 2019-08-28. Last modified to reflect tab plan changes as of 25 July 2019.
* v03 - 2020-04-11 Labels in French and Spanish have been removed.
***.

include "surveyname.sps".

get file="wm.sav".

include "CommonVarsWM.sps".

select if (WM17 = 1).

weight by wmweight.

compute hinsurance=0.
if WB18=1 hinsurance=100.
variable labels hinsurance "Percentage covered by any health insurance [1]".

compute numWomen = 1.
value labels numWomen 1 "Number of women".

do if (WB18=1).
+ compute numWinsurance = 1.
+ value labels numWinsurance 1 "Number of women covered by health insurance".
+ compute typeinsuranceA=0.
+ compute typeinsuranceB=0.
+ compute typeinsuranceC=0.
+ compute typeinsuranceD=0.
+ compute typeinsuranceX=0.
+if WB19A="A" typeinsuranceA=100.
+if WB19B="B" typeinsuranceB=100.
+if WB19C="C" typeinsuranceC=100.
+if WB19D="D" typeinsuranceD=100.
+if WB19X="X" typeinsuranceX=100.
end if.

variable labels typeinsuranceA "Mutual health organization - Community-based health insurance". 
variable labels typeinsuranceB "Health insurance through employer". 
variable labels typeinsuranceC "Social security". 
variable labels typeinsuranceD "Other privately purchased commercial health insurance".
variable labels typeinsuranceX "Other".	

compute layer1 = 1.
variable labels layer1 "".
value labels layer1 1 "Among women covered by health insurance, percentage reporting they were insured by".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".
				
* Ctables command in English.
ctables
  /vlabels variables =  layer1 numWomen numWinsurance
           display = none
  /table  total [c]
         + HH6 [c]
         + HH7 [c]
         + wage [c]
         + welevel [c]
         + mstatus2 [c]
         + disability [c]
         + ethnicity [c]
         + windex5 [c]
   by
            hinsurance [s] [mean '' f5.1]
        + numWomen [c][count '' f5.0]
        + layer1 [c] > ( typeinsuranceA [s] [mean '' f5.1] 
        + typeinsuranceB [s] [mean '' f5.1] 
        + typeinsuranceC [s] [mean '' f5.1] 
        + typeinsuranceD [s] [mean '' f5.1] 
        + typeinsuranceX [s] [mean '' f5.1] )
        + numWinsurance [c][count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
     "Table EQ.2.1W: Health insurance coverage (women)"
  	 "Percentage of women age 15-49 years covered by health insurance, and, among those covered, percentage covered by various health insurance plans, " + surveyname
   caption=
     "[1] MICS indicator EQ.2a - Health insurance coverage"
  .

new file.
