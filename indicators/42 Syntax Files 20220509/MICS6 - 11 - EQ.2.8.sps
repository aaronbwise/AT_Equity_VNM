* Encoding: windows-1252.
 * School tuition or other school related support: For members age 5-24, ED12=1 or ED14=1
***.

* v02 - 2019-08-28. Last modified to reflect tab plan changes as of 25 July 2019.
* v03 - 2020-04-21  Labels in French and Spanish have been removed.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file= 'hl.sav'.

select if (HL6>=5 and HL6<=24) and (ED10A>0 and ED10A<8).

weight by hhweight.

*School tuition or other school related support: For members age 5-24, ED12=1 or ED14=1.
compute EDtuitionsupport=0.
if (ED12=1) EDtuitionsupport=100.
variable labels EDtuitionsupport "School tuition support".

compute EDothersupport=0.
if (ED14=1) EDothersupport=100.
variable labels EDothersupport "Other school related support".

compute EDsupport=0.
if (EDtuitionsupport=100 or EDothersupport=100) EDsupport=100.
variable labels EDsupport "School tuition or other school related support [1]".

compute none=0.
if (EDsupport=0) none=100.
variable labels none "No school support".

*School management: ED11=1; Non-public: ED11=2-6. Children for whom the respondent did not know the management sector, ED11=8, if present in data, can be shown separately.

recode ED11 (1 = 1) (2 thru 6 = 2) (8,9 = 9) (else = sysmis) into schoolManagment.
variable labels schoolManagment "School management".
value labels schoolManagment
1 "Public"
2 "Non-public"
9 "DK/Missing".

recode HL6 (5 thru 9 = 1) (10 thru 14 = 2) (15 thru 19 = 3) (20 thru 24 = 4) into chage.
variable labels chage "Age".
value labels chage 1 "5-9" 2 "10-14" 3 "15-19" 4 "20-24".

compute layer1 = 0.
variable labels layer1 " ".
value labels layer1 0 "Education related financial or material support".

compute nchild = 1.
variable labels  nchild "Number of household members age 5-24 years currently attending school".
value labels nchild 1 " ".

compute total = 1.
variable labels  total "Total".
value labels total 1 " ".

* Ctables command in English.
ctables
  /vlabels variables = layer1
           display = none
  /table   total [c]
         + HL4 [c]
         + HH6 [c]
         + HH7 [c]
         + chage [c]
         + schoolManagment [c]
         + helevel [c]
         + ethnicity [c]
         + windex5 [c]
   by 
            layer1 [c] > 
           (EDtuitionsupport [s] [mean '' f5.1] 
         + EDothersupport [s] [mean '' f5.1] 
         + EDsupport [s] [mean '' f5.1] )
         + none [s] [mean '' f5.1]
         + nchild [s] [count '' f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title = 
    "Table EQ.2.8: Coverage of school support programmes: Members age 5-24 in all households"
    "Percentage of children and young people age 5-24 years in all households who are currently attending school who received support for school tuition " +
    "and other school related support during the current school year, " + surveyname
   caption =
     "[1] MICS indicator EQ.6 - Support for school-related support"	
.
                 
new file.

