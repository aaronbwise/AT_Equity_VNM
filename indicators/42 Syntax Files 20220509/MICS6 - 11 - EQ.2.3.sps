* Encoding: windows-1252.
* Children under age 5 with health insurance coverage: UB9=1.

***.
* v02 - 2019-08-28. Last modified to reflect tab plan changes as of 25 July 2019.
* v03 - 2020-04-21  Labels in French and Spanish have been removed.
***.

include "surveyname.sps".

* Open children data file.
get file = 'ch.sav'.

* sort cases in order to perform mergeing.
sort cases HH1 HH2 LN.

* Select interviewed children.
select if (UF17 = 1).

* Weight the data by the under-5 weight.
weight by chweight.

compute hinsurance=0.
if UB9=1 hinsurance=100.
variable labels hinsurance "Percentage covered by any health insurance [1]".

compute numCH = 1.
value labels numCH 1 "Number of children under age 5".

do if (UB9=1).
+ compute numCHinsurance = 1.
+ value labels numCHinsurance 1 "Number of children under age 5 covered by health insurance".
+ compute typeinsuranceA=0.
+ compute typeinsuranceB=0.
+ compute typeinsuranceC=0.
+ compute typeinsuranceD=0.
+ compute typeinsuranceX=0.
+if UB10A="A" typeinsuranceA=100.
+if UB10B="B" typeinsuranceB=100.
+if UB10C="C" typeinsuranceC=100.
+if UB10D="D" typeinsuranceD=100.
+if UB10X="X" typeinsuranceX=100.
end if.

variable labels typeinsuranceA "Mutual health organization - Community-based health insurance". 
variable labels typeinsuranceB "Health insurance through employer". 
variable labels typeinsuranceC "Social security". 
variable labels typeinsuranceD "Other privately purchased commercial health insurance".
variable labels typeinsuranceX "Other".	

compute layer1 = 1.
variable labels layer1 "".
value labels layer1 1 "Among children under age 5 covered by health insurance, percentage reported they were insured by".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

variable labels cdisability "Functional difficulties (age 2-4 years) [A]".
		
* Ctables command in English.
ctables
  /vlabels variables =  layer1 numCH numCHinsurance
           display = none
  /table  total [c]
        + HH6 [c]
        + HH7 [c]
        + cage_11 [c]
        + melevel [c]
        + cdisability [c]
        + ethnicity[c]
        + windex5[c]
   by
            hinsurance [s] [mean '' f5.1]
        + numCH [c][count '' f5.0]
        + layer1 [c] > ( typeinsuranceA [s] [mean '' f5.1] 
        + typeinsuranceB [s] [mean '' f5.1] 
        + typeinsuranceC [s] [mean '' f5.1] 
        + typeinsuranceD [s] [mean '' f5.1] 
        + typeinsuranceX [s] [mean '' f5.1] )
        + numCHinsurance [c][count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
     "Table EQ.2.3: Health insurance coverage (children under age 5)"
  	 "Percentage of children under age 5 covered by health insurance, and, among those covered, percentage covered by various health insurance plans, " + surveyname
   caption=
     "[1] MICS indicator EQ.2c - Health insurance coverage (children under age 5)"
     "[A] Children age 0-1 years are excluded, as functional difficulties are only collected for age 2-4 years"
.

new file.

