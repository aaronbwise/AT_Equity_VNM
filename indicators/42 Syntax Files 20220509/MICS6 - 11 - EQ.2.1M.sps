* Encoding: windows-1252.
 * Men with health insurance coverage: MWB18=1

***.
* v02 - 2019-08-28. Last modified to reflect tab plan changes as of 25 July 2019.
* v03 - 2020-04-11 Labels in French and Spanish have been removed.
***.

include "surveyname.sps".

get file="mn.sav".

include "CommonVarsMN.sps".

select if (MWM17 = 1).

weight by mnweight.

compute hinsurance=0.
if MWB18=1 hinsurance=100.
variable labels hinsurance "Percentage covered by any health insurance [1]".

compute numMen = 1.
value labels numMen 1 "Number of men".

do if (MWB18=1).
+ compute numMinsurance = 1.
+ value labels numMinsurance 1 "Number of men covered by health insurance".
+ compute typeinsuranceA=0.
+ compute typeinsuranceB=0.
+ compute typeinsuranceC=0.
+ compute typeinsuranceD=0.
+ compute typeinsuranceX=0.
+if MWB19A="A" typeinsuranceA=100.
+if MWB19B="B" typeinsuranceB=100.
+if MWB19C="C" typeinsuranceC=100.
+if MWB19D="D" typeinsuranceD=100.
+if MWB19X="X" typeinsuranceX=100.
end if.

variable labels typeinsuranceA "Mutual health organization - Community-based health insurance". 
variable labels typeinsuranceB "Health insurance through employer". 
variable labels typeinsuranceC "Social security". 
variable labels typeinsuranceD "Other privately purchased commercial health insurance".
variable labels typeinsuranceX "Other".	

compute layer1 = 1.
variable labels layer1 "".
value labels layer1 1 "Among men covered by health insurance, percentage reporting they were insured by".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".
		
* Ctables command in English.
ctables
  /vlabels variables =  layer1 numMen numMinsurance
           display = none
  /table  total [c]
         + HH6 [c]
         + HH7 [c]
         + mwage [c]
         + mwelevel [c]
         + mmstatus2 [c]
         + mdisability [c]
         + ethnicity [c]
         + windex5 [c]
   by
            hinsurance [s] [mean '' f5.1]
        + numMen [c][count '' f5.0]
        + layer1 [c] > ( typeinsuranceA [s] [mean '' f5.1] 
        + typeinsuranceB [s] [mean '' f5.1] 
        + typeinsuranceC [s] [mean '' f5.1] 
        + typeinsuranceD [s] [mean '' f5.1] 
        + typeinsuranceX [s] [mean '' f5.1] )
        + numMinsurance [c][count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
     "Table EQ.2.1M: Health insurance coverage (men)"
  	 "Percentage of men age 15-49 years covered by health insurance, and, among those covered, percentage covered by various health insurance plans, " + surveyname
   caption=
     "[1] MICS indicator EQ.2a - Health insurance coverage".

new file.
