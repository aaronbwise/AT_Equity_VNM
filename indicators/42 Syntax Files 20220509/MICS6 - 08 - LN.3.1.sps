* Encoding: UTF-8.

/*****************************************************************************/
/*  MICS6: Standard.
/*  Chapter 8. Learn.
/*  LN.3. Parental involvement.
/*  Table LN.3.1: Parental involvement in school.
/*.
/*  Tab Plan version: 3 March 2021.
/*.
/*  Updates:.
/*    [20210409] - Implementing Tab Plan of 3 March 2021.
/*      - Title has been changed.
/*      - In the subtitle "years" has been added to read "…children age 7-14 years…". 
/*      - A new note [A] has been added, shifting existing notes.
/*      - Note [B] has been edited.
/*    [20200414 - v04].
/*      - Footnote has been added.
/*      - Labels in French and Spanish have been removed.
/*    [20200306 - v03].
/*      - "+ recode ED11 (11 = 1) (2 thru 6 = 2) (8,9 = 9) (else = sysmis) into schoolManagment.".
/*                ... corrected to ...
/*        "+ recode ED11 (1 = 1) (2 thru 6 = 2) (8,9 = 9) (else = sysmis) into schoolManagment.".
/*    [20190827 - v02].
/*      - Last modified to reflect tab plan changes as of 25 July 2019.
/*.
/*****************************************************************************/

include "surveyname.sps".

*Save info on school management sector from household listing file.
get file =  'hl.sav' .
select if (HL6 >= 7 and HL6 <= 14).

sort cases by HH1 HH2 HL1.

save outfile = 'tmpschmng.sav'
  /keep HH1 HH2 HL1 ED10A ED11
  /rename HL1 = LN.
new file.

get file = 'fs.sav'.
sort cases by HH1 HH2 LN.

* Merge the school management info from the household listing file.
match files
  /file = *
  /table = 'tmpschmng.sav'
  /by HH1 HH2 LN .

include "define/MICS6 - 08 - LN.sps".

weight by fsweight.

select if (CB3 >=7 and CB3<=14).

/*****************************************************************************/

compute attendingSchool = 0.
if (CB7 = 1) attendingSchool = 100.
variable labels attendingSchool "Percentage of children attending school [B]".

compute NumChildren = 1.
variable labels NumChildren "Number of children age 7-14 years".

do if (attendingSchool = 100).

*Percentage of children for whom an adult household member in the last year received a report card for the child: PR10=1.
compute receivedCard = 0.
if (PR10=1) receivedCard = 100.

 * Involvement by adult in school management in last year
- School has a governing body open to parents: PR7=1
- Attended meeting called by governing body: PR8=1
- A meeting discussed key education/financial issues: PR9 [A]=1 or PR9 [B]=1.

compute govBody = 0.
if (PR7=1) govBody = 100.

compute govBodyMeeting = 0.
if (PR8=1) govBodyMeeting = 100.

compute EdMeeting = 0.
if (PR9A=1 or PR9B = 1) EdMeeting = 100.

 * Involvement by adult in school activities in last year
- Attended school celebration or a sport event: PR11 [A]=1
- Met with teachers to discuss child's progress: PR11 [B]=1.

compute event = 0.
if (PR11A = 1) event = 100.

compute progress = 0.
if (PR11B = 1) progress = 100.

compute numAttending = 1.

end if.

compute layer1 = 0.
compute layer2 = 0.

variable labels layer1 "".
value labels layer1 0 "Involvement by adult in school management in last year".

variable labels layer2 "".
value labels layer2 0 "Involvement by adult in school activities in last year   ".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

variable labels receivedCard "Percentage of children for whom an adult household member in the last year received a report card for the child [1]".
variable labels numAttending "Number of children age 7-14 years attending school".
variable labels govBody "School has a governing body open to parents [2]".
variable labels govBodyMeeting "Attended meeting called by governing body [3]".
variable labels EdMeeting "A meeting discussed key education/ financial issues [4]".
variable labels event "Attended school celebration or a sport event".
variable labels progress "Met with teachers to discuss child's progress [5]".

recode CB8A (0=0)(1=1)(2=2)(3,4, 5 = 3) (8,9 = 9)(else = 10) into school.
variable labels school "School attendance [B]".
value labels school
0 "Early childhood education"
1 "Primary"
2 "Lower secondary"
3 "Upper secondary"
9 "DK/Missing"
10 "Out-of-school".

* Children in Public are: ED11=1; Non-public: ED11=2-6. Children for whom the respondent did not know the management sector,
ED11=8, if present in data, can be shown separately or also suppressed from disaggregate by adding this condition to note B (second sentence):
"Children out of school, attending ECE or for whom the sector was not known by respondent are not shown.".
do if (ED10A > 0).
+ recode ED11 (1 = 1) (2 thru 6 = 2) (8,9 = 9) (else = sysmis) into schoolManagment.
end if.
variable labels schoolManagment "School management [C]".
value labels schoolManagment
1 "Public"
2 "Non-public"
9 "DK/Missing".

variable labels caretakerdis "Mother's functional difficulties [D]".

add value labels schage 6 "6 [A]".

/*****************************************************************************/

* Ctables command in English.
ctables
  /format missing = "na"
  /vlabels variables = layer1 layer2
           display = none
  /table   total [c]
        + hl4 [c]
         + hh6 [c]
         + hh7 [c]
         + schage [c]
         + school [c]
         + melevel [c]
         + schoolManagment [c]
         + fsdisability [c]
         + caretakerdis [c]
         + ethnicity [c]
         + windex5 [c]
   by
           attendingSchool [s] [mean '' f5.1]
           + NumChildren [s] [validn '' f5.0]
           + receivedCard [s] [mean '' f5.1]
           + layer1 [c] > (govBody [s] [mean '' f5.1] + govBodyMeeting [s] [mean '' f5.1] + EdMeeting [s] [mean '' f5.1])
           + layer2 [c] > (event [s] [mean '' f5.1] + progress [s] [mean '' f5.1])
           + numAttending [s] [validn '' f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible=no
  /titles title=
    "Table LN.3.1: Support for child learning at school"
     "Percentage of children age 7-14 years attending school and, among those, percentage of children for whom an adult member of the household received a report card for the child, " +
     "and involvement of adults in school management and school activities in the last year, " + surveyname
   caption =
    "[1] MICS indicator LN.12 - Availability of information on children's school performance"
    "[2] MICS indicator LN.13 - Opportunity to participate in school management"
    "[3] MICS indicator LN.14: Participation in school management"
    "[4] MICS indicator LN.15 - Effective participation in school management"
    "[5] MICS indicator LN.16 - Discussion with teachers regarding children's progress"
    "[A] As eligibility for the Parental Involvement and Foundational Learning Skills modules was determined based on age at time of interview (age 7-14 years), " +
    "the disaggregate of Age at beginning of school year inevitably presents children who were age 6 years at the beginning of the school year."
    "[B] Attendance to school here is not directly comparable to adjusted net attendance rates reported in preceding tables, " +
    "which utilise information on all children in the sample. This and subsequent tables present results of the Parental Involvement and Foundational Learning Skills " +
    "modules administered to mothers or caretakers of a randomly selected subsample of children age 7-14 years."
    "[C] School management sector was collected for children attending primary education or higher. Children out of school or attending ECE are not shown."
    "[D] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."
    "na: not applicable"
.

/*****************************************************************************/

new file.

erase file='tmpschmng.sav'.
