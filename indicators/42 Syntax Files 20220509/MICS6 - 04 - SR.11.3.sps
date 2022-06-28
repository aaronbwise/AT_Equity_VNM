* Encoding: windows-1252.
* MICS6 SR.11.3.

* v02 - 2019-08-27. Last modified to reflect tab plan changes as of 25 July 2019.
* v03 - 2020-04-09. Labels in French and Spanish have been removed.

** Children who are not living with at least one biological parent, either because the parents live elsewhere or because the parents are dead:
** (HL12=2 or HL13=2) and (HL16=2 or HL17=2)

** Relationship to head of household: HL3. "Other relative" is HL3=04, 09, 10, 11 and 12.

** Note that relationship code 03 is impossible. Codes 06 and 07 are also not tabulated as this would require the household respondent to have identified a very young child as head of household. Any such cases are recoded to "Inconsistent".

** The percentage of children living in households headed by a family member are those for whom the head of household is a family member, i.e. 
** child is not head of household, servant, other (not related) or have been recorded with an inconsistent code (HL3<>01, 14, 96 or 97).

***.

include "surveyname.sps".

get file="hl.sav".

* select children 0-17 listed in the HL.
select if (HL6 <= 17) .

* weight data by household weight.
weight by hhweight.

* Calculate child's orphanhood status.
compute oStatus = 9.
if (HL12 = 1 and HL16 = 1) oStatus = 1.
if (HL12 = 1 and HL16 = 2) oStatus = 2.
if (HL12 = 2 and HL16 = 1) oStatus = 3.
if (HL12 = 2 and HL16 = 2) oStatus = 4.
if (HL12 >=8 or HL16 >= 8) oStatus = 9.
variable labels oStatus "Orphanhood status".
value labels oStatus
1 "Both parents alive"
2 "Only mother alive"
3 "Only father alive"
4 "Both parents deceased"
9 "Unknown".

compute notWithP = 0.
if ((HL12=2 or HL13=2) and (HL16=2 or HL17=2)) notWithP = 100.
variable labels notWithP "Percentage of children living with neither biological parent [1]".

compute numChildren = 1.
value labels numChildren 1 "Number of children age 0-17 years".

do if (notWithP = 100).
* Note that relationship code 03 is impossible. Codes 06 and 07 are also not tabulated as this would require the household respondent to have identified a very young child as head of household. Any such cases are recoded to "Inconsistent".
+ recode HL3 (04, 09, 10, 11, 12 = 10) (03, 06, 07, 97, 98, 99 = 99) (else = copy) into HL3r.
+ compute numNotPar = 1.
+ compute livingMember = 0.
+ if (HL3r > 1 and HL3r < 14) livingMember = 100.
end if.

variable labels HL3r "Child's relationship to head of household".
value labels HL3r
1 "Child is head of household"
2 "Spouse/ Partner"
5 "Grand-child"
8 "Brother/ Sister"
10 "Other relative"
13 "Adopted/ Foster/ Stepchild"
14 "Servant (Live-in)"
96 "Other not related"
99 "Inconsistent/DK/Missing".

value labels numNotPar 1 "Number of children age 0-17 years not living with a biological parent".

variable labels livingMember "Percentage of children living in households headed by a family member [A]".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

recode HL6
  ( 0 thru  4 = 1)
  ( 5 thru  9 = 2)
  (10 thru 14 = 3)
  (15 thru 17 = 4) into ageGroups .
variable labels ageGroups "Age".
value labels ageGroups
  1 "0-4"
  2 "5-9"
  3 "10-14"
  4 "15-17" .
  
* Ctables command in English.
ctables
  /vlabels variables =  numChildren numNotPar
           display = none
  /table  total [c]
        + hl4 [c]
        + hh6 [c]
        + hh7 [c]
        + ageGroups [c]
        + oStatus [c]
        + ethnicity [c]
        + windex5 [c]
   by  notWithP [s] [mean, '', f5.1]
        + numChildren [c][count '' f5.0]
        + HL3r [c]  [rowpct '' f5.1] 
        + livingMember [s] [mean, '', f5.1]
        + numNotPar [c][count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=HL3r total=yes position=after label="Total"
  /slabels position=column visible = no
  /titles title=
     "Table SR.11.3: Children not in parental care"
  	 "Percent distribution of children age 0-17 years not living with a biological parent according to relationship to head of household and percentage living in households headed by a family member, " + surveyname
   caption=
       "[1] MICS indicator SR.18 - Children’s living arrangements"											
       "[A] Excludes households headed by the child, servants and other not related"
  .

new file.
