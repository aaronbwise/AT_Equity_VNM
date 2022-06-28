* Encoding: UTF-8.

/*****************************************************************************/
/*  MICS6: Standard.
/*  Chapter 8. Learn.
/*  LN.3. Parental involvement.
/*  Table LN.3.2: School-related reasons for inability to attend class.
/*.
/*  Tab Plan version: 3 March 2021.
/*.
/*  Updates:.
/*    [20210321] - Implementing Tab Plan of 3 March 2021.
/*      - In the subtitle "years" has been added to read "...children age 7-14 years...". 
/*      - A new note [A] has been added, shifting existing notes.
/*    [20200414 - v04].
/*      - Footnote has been added.
/*      - Labels in French and Spanish have been removed.
/*    [20200306 - v03].
/*      - "+ recode ED11 (11 = 1) (2 thru 6 = 2) (else = 9) into schoolManagment.".
/*                ... corrected to ...
/*        "+ recode ED11 (1 = 1) (2 thru 6 = 2) (else = 9) into schoolManagment.".
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
variable labels attendingSchool "Percentage of children attending school".

* Children in Public are: ED11=1; Non-public: ED11=2-6. Children for whom the respondent did not know the management sector,
ED11=8, if present in data, can be shown separately or also suppressed from disaggregate by adding this condition to note B (second sentence):
"Children out of school, attending ECE or for whom the sector was not known by respondent are not shown.".
do if (ED10A > 0).
+ recode ED11 (1 = 1) (2 thru 6 = 2) (else = 9) into schoolManagment.
end if.
variable labels schoolManagment "School management [B]".
value labels schoolManagment
1 "Public"
2 "Non-public"
9 "DK/Missing".

do if (attendingSchool = 100).

*Percentage of children who in the last year could not attend class due absence of teacher or school closure: PR12 [A]=1, PR12 [B]=1, PR12 [C]=1, PR12 [X]=1 or PR13=1.
compute noClass = 0.
if (PR12A=1 or PR12B=1 or PR12C=1 or PR12X=1 or PR13=1) noClass = 100.
variable labels noClass "Percentage of children who in the last year could not attend class due to absence of teacher or school closure".

compute numAttending = 1.

end if.

do if (noClass = 100).

compute naturalDisasters = 0.
if (PR12A = 1) naturalDisasters = 100.

compute manMade = 0.
if (PR12B = 1) manMade = 100.

compute strike = 0.
if (PR12C = 1) strike = 100.

compute other = 0.
if (PR12X = 1) other = 100.

compute absence = 0.
if (PR13 = 1) absence = 100.

compute strikeAbsence = 0.
if (PR12C = 1 or PR13 = 1) strikeAbsence = 100.

compute numNotAttending = 1.

end if.

do if (strikeAbsence = 100).

compute contactingSchool = 0.
if (PR15=1) contactingSchool = 100.

compute numNotAttending2 = 1.

end if.

compute layer = 0.
variable labels layer " ".
value labels layer 0 "Percentage of children unable to attend class in the last year due to a school-related reason:".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

variable labels noClass "Percentage of children who in the last year could not attend class due to absence of teacher or school closure".
variable labels numAttending "Number of children age 7-14 years attending school".
variable labels naturalDisasters "Natural disasters".
variable labels manMade "Man-made disasters".
variable labels strike "Teacher strike".
variable labels other "Other".
variable labels absence "Teacher absence".
variable labels strikeAbsence "Teacher strike or absence".
variable labels numNotAttending " Number of children age 7-14 who could not attend class in the last year due to a school-related reason".
variable labels contactingSchool "Percentage of adult household members contacting school officials or governing body representatives on instances of teacher strike or absence [1]".
variable labels numNotAttending2 " Number of children age 7-14 years who could not attend class in the last year due to teacher strike or absence".

recode CB8A (0=0)(1=1)(2=2)(3,4, 5 = 3) (8,9 = 9)(else = 10) into school.
variable labels school "School attendance".
value lables school
0 "Early childhood education"
1 "Primary"
2 "Lower secondary"
3 "Upper secondary"
9 "DK/Missing"
10 "Out-of-school".

variable labels caretakerdis "Mother's functional difficulties [C]".

add value labels schage 6 "6 [A]".

/*****************************************************************************/

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /format missing = "na"
  /vlabels variables = layer
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
           noClass [s] [mean '' f5.1]
           + numAttending [s] [validn '' f5.0]
           + layer [c] > (naturalDisasters [s] [mean '' f5.1] + manMade [s] [mean '' f5.1] + strike [s] [mean '' f5.1] + other [s] [mean '' f5.1] + absence [s] [mean '' f5.1] + strikeAbsence [s] [mean '' f5.1])
           + numNotAttending [s] [validn '' f5.0]
           + contactingSchool [s] [mean '' f5.1]
           + numNotAttending2 [s] [validn '' f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table LN.3.2: School-related reasons for inability to attend class"
     "Percentage of children age 7-14 years not able to attend class due to absence of teacher or school closure, by reason for inability, " +
     "and percentage of adult household members contacting school officials or governing body representatives on instances of teacher strike or absence, " + surveyname
   caption =
   "[1] MICS indicator LN.17 - Contact with school concerning teacher strike or absence"
   "[A] As eligibility for the Parental Involvement and Foundational Learning Skills modules was determined based on age at time of interview (age 7-14 years), " +
   "the disaggregate of Age at beginning of school year inevitably presents children who were age 6 years at the beginning of the school year."
   "[B] School management sector was collected for children attending primary education or higher. Children out of school or attending ECE are not shown."
   "[C] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."
  .

/*****************************************************************************/

new file.

erase file='tmpschmng.sav'.
