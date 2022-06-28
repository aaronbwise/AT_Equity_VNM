* Encoding: UTF-8.

/*****************************************************************************/
/*  MICS6: Standard.
/*  Chapter 8. Learn.
/*  LN.3. Parental involvement.
/*  Table LN.3.3: Learning environment at home.
/*.
/*  Tab Plan version: 3 March 2021.
/*.
/*  Updates:.
/*    [20210409] - Implementing Tab Plan of 3 March 2021.
/*      - The subtitle has been edited.
/*      - In variable 'sameL' the label has been changed to "Percentage of children who at home use the language also used by teachers at school [3]".
/*      - A new note [B] has been added, shifting the previous note [B] to [C].
/*    [20200414 - v02].
/*      - The disaggregate on Mother's functional difficulties has been edited, including a note.
/*      - Column labels have been updated.
/*      - Note [A] has been added.
/*      - Labels in French and Spanish have been removed.
/*.
/*****************************************************************************/

include "surveyname.sps".

get file = 'fs.sav'.

weight by fsweight.

select if CB3 >=7 and CB3<=14.

/*****************************************************************************/

compute attendingSchool = 0.
if (CB7 = 1) attendingSchool = 100.
variable labels attendingSchool "Percentage of children attending school".

* Children with 3 or more books to read at home: PR3>02 and PR3<=10.
* Children who read books or are read to at home: FL6A=1 or FL6B=1.
* - The denominators for these columns are likely different and therefore presented separately.

compute books3More = 0.
if (PR3>2 and PR3<=10) books3More = 100.
variable labels books3More "Percentage of children with 3 or more books to read at home [1]".

compute numChildren1 = 1.
variable labels numChildren1 "Number of children age 7-14 years".

do if (FL28 = 1).

compute readAtHome = 0.
if (FL6A=1 or FL6B=1) readAtHome = 100.
variable labels readAtHome "Percentage of children who read books or are read to at home [2]".

compute numChildren2 = 1.
variable labels numChildren2 "Number of children age 7-14 years".

end if.

do if (attendingSchool = 100).

compute haveHomework = 0.
if (PR5=1) haveHomework = 100.
variable labels haveHomework "Percentage of children who have homework".

compute numChildren3 = 1.
variable labels numChildren3 "Number of children age 7-14 years attending school".

end if.

* Children who at home use the language also used by teachers at school: FL7=FL9.
*Denominator: Children attending school (CB7/ED9=1).
*- The denominators for these columns are likely different and therefore presented separately.

do if (FL28 = 1 and attendingSchool = 100).

compute sameL = 0.
if (FL7=FL9) sameL = 100.
variable labels sameL "Percentage of children who at home use the language also used by teachers at school [3]".

compute numChildren4 = 1.
variable labels numChildren4 "Number of children age 7-14 years attending school".

end if.

do if (haveHomework = 100).

compute helpHomework = 0.
if (PR6=1) helpHomework = 100.
variable labels helpHomework "Percentage of children who receive help with homework [4]".

compute numChildren5 = 1.
variable labels numChildren5 "Number of children age 7-14 attending school and have homework".

end if.

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

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

add value labels schage 6 "6 [B]".

/*****************************************************************************/

* Ctables command in English.
ctables
  /format missing = "na"
  /table   total [c]
        + hl4 [c]
         + hh6 [c]
         + hh7 [c]
         + schage [c]
         + school [c]
         + melevel [c]
         + fsdisability [c]
         + caretakerdis [c]
         + ethnicity [c]
         + windex5 [c]
   by
           books3More [s] [mean '' f5.1]
           + numChildren1 [s] [validn '' f5.0]
           + readAtHome [s] [mean '' f5.1]
           + numChildren2 [s] [validn '' f5.0]
           + haveHomework [s] [mean '' f5.1]
           + numChildren3 [s] [validn '' f5.0]
           + sameL [s] [mean '' f5.1]
           + numChildren4 [s] [validn '' f5.0]
           + helpHomework [s] [mean '' f5.1]
           + numChildren5 [s] [validn '' f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /titles title=
    "Table LN.3.3: Learning environment at home"
    "Percentage of children age 7-14 years [A] with 3 or more books to read and percentage who read or are read to at home, " +
    "percentage of children age 7-14 years who have homework and percentage whose teachers use the language also spoken " +
    "at home among children who attend school, and percentage of children who receive help with homework among those who have homework, " + surveyname
   caption =
   "[1] MICS indicator LN.18 - Availability of books at home"
   "[2] MICS indicator LN.19 - Reading habit at home"
   "[3] MICS indicator LN.20 - School and home languages"
   "[4] MICS indicator LN.21 - Support with homework"
   "[A] This table utilises information collected in both the Parental Involvement and Foundational Learning Skills modules. Note that otherwise identical denominators may be slightly different, " +
        "as the Foundational Learning Skills module includes consent of respondent to interview child and assent and availability of child to be interviewed. This invariably reduces the number of cases for data collected in this module."
   "[B] As eligibility for the Parental Involvement and Foundational Learning Skills modules was determined based on age at time of interview (age 7-14 years), " +
   "the disaggregate of Age at beginning of school year inevitably presents children who were age 6 years at the beginning of the school year."
   "[C] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."
   "na: not applicable"
.

/*****************************************************************************/

new file.
