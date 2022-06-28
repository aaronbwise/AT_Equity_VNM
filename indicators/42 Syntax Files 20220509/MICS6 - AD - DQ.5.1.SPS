* Encoding: UTF-8.

***.
* v02 - 2020-04-14. Several changes in subtitle, header and footnote. Labels in French and Spanish have been removed.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hl.sav'.

weight by hhweight.

* include definition of primarySchoolEntryAge .
include 'define/MICS6 - 08 - LN.sps' .

* select only children less than 25 years of age, for whom the education information were collected.
select if (HL6 < 25).

select if (schage >= 3 and schage <= 24).

if (ED4 <> 1) ED10A = -1.
if (ED4 <> 1) ED10B = 0.
if (ED9 <> 1) ED10A = -1.
if (ED9 <> 1) ED10B  = 0.
if (ED9 = 1 and (ED10A = 0 or ED10A >=4)) ED10B = 0.
if (ED9 = 1 and (ED10A = 8 or ED10A = 9)) ED10A = 98.
if (ED10B >= 97) ED10B = 98.
if (schage = 24 and HL6 = 25) ED10A = 95.
if (schage = 24 and HL6 = 25) ED10B = 0.
variable labels ED10A "".
variable labels ED10B "".
value labels ED10B 0 " ".
compute total = 1.
value labels total 1 "Number of household members age 3-24 years".
add value labels ED10A 
	 -1 "Not attending school" 
	  0 "Early childhood education"
	  1 "Currently attending: Primary school Grade"
	  2 "Currently attending: Lower secondary school Grade"
	  3 "Currently attending: Upper secondary school Grade"
                    4 "Currently attending: Higher than secondary"
                  95 "Not able to determine"
	98 "DK/Missing".
                
add value labels ED10B 98 "DK/Missing".

add value labels schage
24 "24 [A]". 

compute tot1 = 100.
variable labels tot1 "Total".
value labels tot1 100 " ".

formats schage (f5.0).

* Ctables command in English.
ctables
 /vlabels variables = ED10A ED10B total display = none
  /table schage [c] by 
	ED10A[c] > ED10B[c][LAYERROWPCT.VALIDN '' f5.1] + tot1 [s] [mean, '', f5.1] + total [c][count '' f5.0]
  /categories variables=all empty=exclude 
  /slabels visible = no    
  /titles title=  "Table DQ.5.1: School attendance by single age" 
    "Distribution of household population age 3-24 years by educational level and grade attended in the current school year, " + surveyname
  caption = "[A] Those age 25 at the time of interview who were age 24 at beginning of school year are excluded as current attendance was only collected for those age 3-24 years at the time of interview".

new file.
