* Encoding: windows-1252.
 * Children age 5-17 with health insurance coverage: CB11=1

***.
* v02 - 2019-08-28. Last modified to reflect tab plan changes as of 25 July 2019.
* v03 - 2020-04-11 The disaggregate of Mother’s education level has been edited. Note B has been edited. Labels in French and Spanish have been removed.
***.

include "surveyname.sps".

* Open children data file.
get file = 'fs.sav'.

include "CommonVarsFS.sps".

* sort cases in order to perform mergeing.
sort cases HH1 HH2 LN.

* Select interviewed children.
select if (FS17 = 1).

* Weight the data by the 5-17 weight.
weight by fsweight.

compute hinsurance=0.
if CB11=1 hinsurance=100.
variable labels hinsurance "Percentage covered by any health insurance [1]".

compute numFS = 1.
value labels numFS 1 "Number of children age 5-17 years".

do if (CB11=1).
+ compute numFSinsurance = 1.
+ value labels numFSinsurance 1 "Number of children age 5-17 years covered by health insurance".
+ compute typeinsuranceA=0.
+ compute typeinsuranceB=0.
+ compute typeinsuranceC=0.
+ compute typeinsuranceD=0.
+ compute typeinsuranceX=0.
+if CB12A="A" typeinsuranceA=100.
+if CB12B="B" typeinsuranceB=100.
+if CB12C="C" typeinsuranceC=100.
+if CB12D="D" typeinsuranceD=100.
+if CB12X="X" typeinsuranceX=100.
end if.

variable labels typeinsuranceA "Mutual health organization - Community-based health insurance". 
variable labels typeinsuranceB "Health insurance through employer". 
variable labels typeinsuranceC "Social security". 
variable labels typeinsuranceD "Other privately purchased commercial health insurance".
variable labels typeinsuranceX "Other".	

compute layer1 = 1.
variable labels layer1 "".
value labels layer1 1 "Among children age 5-17 years covered by health insurance, percentage reported they were insured by".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

variable labels schoolAttendance "School attendance".
value labels schoolAttendance 1 "Attending [A]" 2 "Not attending" .
variable labels melevel "Mother’s education [B]".


* Ctables command in English.
ctables
  /vlabels variables =  layer1 numFS numFSinsurance
           display = none
  /table  total [c]
        + HH6 [c]
        + HH7 [c]
        + fsage [c]
        + schoolAttendance [c]
        + melevel [c]
        + fsdisability [c]
        + ethnicity[c]
        + windex5[c]
   by
            hinsurance [s] [mean '' f5.1]
        + numFS [c][count '' f5.0]
        + layer1 [c] > ( typeinsuranceA [s] [mean '' f5.1] 
        + typeinsuranceB [s] [mean '' f5.1] 
        + typeinsuranceC [s] [mean '' f5.1] 
        + typeinsuranceD [s] [mean '' f5.1] 
        + typeinsuranceX [s] [mean '' f5.1] )
        + numFSinsurance [c][count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
     "Table EQ.2.2: Health insurance coverage (children age 5-17)"
  	 "Percentage of children age 5-17 years covered by health insurance, and, among those covered, percentage covered by various health insurance plans, " + surveyname
   caption=
     "[1] MICS indicator EQ.2b - Health insurance coverage (children age 5-17)"
     "[A] Includes attendance to early childhood education"
     "[B] The disaggregate of Mother's education is not available for children age 15-17 years identified as emancipated."     
.						

new file.
