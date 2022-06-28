* Encoding: UTF-8.

/*****************************************************************************/
/*  MICS6: Standard.
/*  Chapter 8. Learn.
/*  LN.4. Foundational learning skills.
/*  Table LN.4.1: Foundational reading skills.
/*.
/*  Tab Plan version: 3 March 2021.
/*.
/*  Updates:.
/*    [20211026] 
/*      - Variables HL13 and HL17 added to the line 67:  /keep HH1 HH2 HL1 HL12 HL13 HL16 HL17
/*    [20210409] - Implementing Tab Plan of 3 March 2021.
/*      - Title has changed.
/*      - The subtitle has been edited.
/*      - Change in defining 'aLiteral' now includes (FL21BA=1 and FL21BB=1 and FL21BD=1), previously (FL21BA=1 and FL21BB=1 and FL21BC=1).
/*      - Change in defining  'aInferential' now includes (FL21BC=1 and FL21BE=1), previously (FL21BE=1 and FL21BF=1).
/*      - In variable 'notAvailable' the label has been changed to "Percentage of children for whom the reading tasks were not available in appropriate language [A]".
/*      - An additional age disaggregate has been included (10-14).
/*      - Indicator notes [1], [2] and [3] have been edited to reflect updated terminology.
/*      - Two new indicator notes have been inserted as [5] and [6], shifting previous 5-7 to 7-9.
/*      - New notes [A] and [B] have been added, shifting existing note [A] to [C].
/*    [20200909 - v05].
/*      - Added orphanhood status for calculation of parity indices.
/*    [20200421 - v04].
/*      - Algorithm updated to include new version of the questionnaires as well as new version of tab plan.
/*      - In variable 'readingSkill' in the label "demonstrated" has been changed to "demonstrate".
/*      - The disaggregate on Mother's functional difficulties has been edited, including a note.
/*      - Labels in French and Spanish have been removed.
/*    [20191002 - v03].
/*      - Last modified to reflect tab plan changes as of 2 October 2019.
/*    [20190827 - v02].
/*      - Last modified to reflect tab plan changes as of 25 July 2019.
/*.
/*****************************************************************************/

 * Percentage of children who [Updated as per Tab Plan of 3 March 2021.]:
- Read 90% of words in a story correctly: FL19>=90% or FL21O>=90%
- Correctly answer three literal comprehension questions: (FL19>=90% and FL21B[A]=1 and FL21B[B]=1 and FL21B[D]=1) or (FL21O>=90% and FL22[A]=1 and FL22[B]=1 and FL22[C]=1)
- Correctly answer two inferential comprehension questions: (FL19>=90% and FL21B[C]=1 and FL21B[E]=1) or (FL21O>=90% and FL22[E]=1 and FL22[F]=1)
- Demonstrate foundational reading skills: All of the above in the same language, that is, (FL19>=90% and FL21B[A]=1 and FL21B[B]=1 and FL21B[D]=1 and FL21B[C]=1
and FL21B[E]=1) or (FL21O>=90% and FL22[A]=1 and FL22[B]=1 and FL22[C]=1 and FL22[E]=1 and FL22[F]=1)

 * Only the total panel includes the column "Percentage of children for whom the reading book was not available in appropriate language".
 *  The algorithm for this is: FL7>=21 and FL9>=21 or blank. Note the categories accepted for FL9 and FL7 are those for which no reading book was available. This must be customised in syntax.

 * The total pane also holds the gender parity index, which is one of the parity indices included in the table.
 * This column is automatically populated, whereas this is not the case for the ratios in the disaggregate "Parity indices".
 * These must be manually calculated, similar to as described under table LN.2.8. Note that tables LN.4.1 and LN.4.2 have the additional parity index on Functional difficulties,
   which is not possible in table LN.2.8. Check the denominator of percentages in both numerator and denominator of each ratio, especially in the gender parity index, which may require suppression as per standard approach.

 * The denominator includes all children with a completed module (FL28=01).

 * One indicator may require customisation: MICS Indicator LN.22b is measured on children with age for primary grades 2 and 3.
 * Following the standard used throughout the standard LN tables, the indicator is set at age 7 and 8, as children start school at age 6.
 * For example, if primary grade 1 is set at age 7 in a country, this indicator should instead be measured on age group 8-9.

***.

include "surveyname.sps".

get file = 'hl.sav'.

sort cases by HH1 HH2 HL1.
save outfile = "orphantemp.sav"
 /keep HH1 HH2 HL1 HL12 HL13 HL16 HL17
 /rename HL1=LN.

get file = 'fs.sav'.

sort cases by HH1 HH2 LN.
match files
  /file = *
  /table = 'orphantemp.sav'
  /by HH1 HH2 LN.

weight by fsweight.

*The denominator includes all children with a completed module (FL28=01).
select if (FL28 = 1).

select if CB3>=7 and CB3 <=14.

/*****************************************************************************/

* First story.
compute target1 = 0.
if (FL20A < 99 and FL20B < 99) target1 = FL20A - FL20B.
* Second story.
compute target2 = 0.
if (FL21PA < 99 and FL21PB < 99) target2 = FL21PA - FL21PB.

* Replace 72 and 61 below with total number of words in two stories in your survey.
compute readCorrect = 0.
if (target1 >= 0.9 * 72) or (target2 >= 0.9 * 61) readCorrect = 100.
variable labels readCorrect " ".

compute aLiteral = 0.
if readCorrect = 100 and (FL21BA=1 and FL21BB=1 and FL21BD=1) aLiteral = 100.    /* Updated as per Tab Plan of 3 March 2021 */
if readCorrect = 100 and (FL22A=1 and FL22B=1 and FL22C=1) aLiteral = 100.
variable labels aLiteral " ".

compute aInferential = 0.
if readCorrect = 100 and (FL21BC=1 and FL21BE=1) aInferential = 100.    /* Updated as per Tab Plan of 3 March 2021 */
if readCorrect = 100 and (FL22E=1 and FL22F=1) aInferential = 100.
variable labels aInferential " ".

compute readingSkill = 0.
if (readCorrect = 100 and aLiteral = 100 and aInferential = 100) readingSkill = 100.
variable labels readingSkill " ".

compute numChildren = 1.
variable labels numChildren " ".
value labels numChildren 1 " ".

 * Only the total panel includes the column "Percentage of children for whom the reading book was not available in appropriate language".
 *  The algorithm for this is: FL7>=21 and FL9>=21 or blank. Note the categories accepted for FL9 and FL7 are those for which no reading book was available. This must be customised in syntax.
compute notAvailable = 0.
if ((FL7 >=21 or sysmis(FL7)) and (FL9 >=21 or sysmis(FL9))) notAvailable = 100.
variable labels notAvailable "Percentage of children for whom the reading tasks were not available in appropriate language [A]".

compute tot = 1.
variable labels tot "Total".
value labels tot 1 " ".

compute total = 1.
variable labels total "".
value labels total 1 "Total [1],[4]".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage who correctly answered comprehension questions".

* Proxi variable that will allow for GPI to be properly displayed.
compute survey = 1.

/*****************************************************************************/

recode CB8A (0=0)(1=10)(2=20)(3,4 = 30) (8,9 = 99)(else = 100) into school.
variable labels school "School attendance".
value labels school
0 "Early childhood education"
10 "Primary"
20 "Lower secondary"
30 "Upper secondary +"
99 "DK/Missing"
100 "Out-of-school".

compute schoolAux = school.
if ((CB8A = 1 or CB8A = 2) and CB8B < 97)  schoolAux1 = school + CB8B.
if ((CB8A = 1 or CB8A = 2) and CB8B >= 97) schoolAux1 = 99.
if (CB8A = 1 and (CB8B = 2 or CB8B = 3)) schoolAux2 = 11.1.

value labels schoolAux
0      "Early childhood education"
10    "Primary"
11     "  Grade 1"
11.1  "  Grade 2-3 [3],[6]"
12     "    Grade 2"
13     "    Grade 3"
14     "  Grade 4"
15     "  Grade 5"
16     "  Grade 6"
20    "Lower secondary"
21     "  Grade 1"
22     "  Grade 2"
23     "  Grade 3"
30     "Upper secondary"
99     "DK/Missing"
100   "Out-of-school".

compute schageAux = schage.
if (schage = 7 or schage = 8) schageAux1 = 6.1.
if (schage >= 10 and schage <= 14) schageAux2 = 9.1.

value labels schageAux
 6    "6 [B]"
 6.1 "7-8 [2],[5]"
 7    "   7"
 8    "   8"
 9    "9"
 9.1 "10-14"
 10  "    10"
 11  "    11"
 12  "    12"
 13  "    13"
 14  "    14".

* orhpanhood status for parity indices.
compute orphanStatus = 9.
if (HL12 = 2 and HL16 = 2) orphanStatus=1.
if (HL12 = 1 and HL16 = 1) and (HL13 = 1 or HL17 = 1) orphanStatus = 2.
if (HL12 >= 8 or HL16 >= 8) orphanStatus=9.
variable labels orphanStatus "Orphanhood status".
value labels orphanStatus
1 "Orphans (not to be presented in the table - needed for parity indices)"
2 "Non-Orphans (not to be presented in the table - needed for parity indices)"
9 "Unknown (not to be presented in the table - needed for parity indices)".

* generate parity index.
* first separate for girls and boys.
do if (HL4=2).
+compute readingSkillGirls = 0.
+if (readCorrect = 100 and aLiteral = 100 and aInferential = 100 and hl4 = 2) readingSkillGirls = 100.
end if.
variable labels readingSkillGirls " ".
do if (HL4=1).
+compute readingSkillBoys = 0.
+if (readCorrect = 100 and aLiteral = 100 and aInferential = 100 and hl4 = 1) readingSkillBoys = 100.
end if.
variable labels readingSkillBoys " ".

/*****************************************************************************/

* macro for aggregating readingSkill variable for various background characteristics.

define aggreg ( temp = !tokens(1) / breakvr = !tokens(1) / func = !tokens(1) / invar1 = !tokens(1) / invar2 = !tokens(1) ).
  aggregate outfile = !temp
  /break = !breakvr
  /!concat(!invar1,!func) =  !concat(!func,"(",!invar1,")")
  /!concat(!invar2,!func) =  !concat(!func,"(",!invar2,")").
!enddefine.

/*****************************************************************************/

* aggregate for all background characteristics.
aggreg temp = "tmp1.sav" breakvr = total func = mean invar1 = readingSkillGirls invar2 = readingSkillBoys .
aggreg temp = "tmp2.sav" breakvr = hh6 func = mean invar1 = readingSkillGirls invar2 = readingSkillBoys .
aggreg temp = "tmp3.sav" breakvr = hh7 func = mean invar1 = readingSkillGirls invar2 = readingSkillBoys .
aggreg temp = "tmp4.sav" breakvr = schageAux func = mean invar1 = readingSkillGirls invar2 = readingSkillBoys .
aggreg temp = "tmp4a.sav" breakvr = schageAux1 func = mean invar1 = readingSkillGirls invar2 = readingSkillBoys .
aggreg temp = "tmp4b.sav" breakvr = schageAux2 func = mean invar1 = readingSkillGirls invar2 = readingSkillBoys .
aggreg temp = "tmp5.sav" breakvr = schoolAux func = mean invar1 = readingSkillGirls invar2 = readingSkillBoys .
aggreg temp = "tmp5a.sav" breakvr = schoolAux1 func = mean invar1 = readingSkillGirls invar2 = readingSkillBoys .
aggreg temp = "tmp5b.sav" breakvr = schoolAux2 func = mean invar1 = readingSkillGirls invar2 = readingSkillBoys .
aggreg temp = "tmp6.sav" breakvr = melevel func = mean invar1 = readingSkillGirls invar2 = readingSkillBoys .
aggreg temp = "tmp7.sav" breakvr = fsdisability func = mean invar1 = readingSkillGirls invar2 = readingSkillBoys .
aggreg temp = "tmp8.sav" breakvr = caretakerdis func = mean invar1 = readingSkillGirls invar2 = readingSkillBoys .
aggreg temp = "tmp9.sav" breakvr = ethnicity func = mean invar1 = readingSkillGirls invar2 = readingSkillBoys .
aggreg temp = "tmp10.sav" breakvr = windex5 func = mean invar1 = readingSkillGirls invar2 = readingSkillBoys .

add files
/file=*
/file ="tmp1.sav"
/file ="tmp2.sav"
/file ="tmp3.sav"
/file ="tmp4.sav"
/file ="tmp4a.sav"
/file ="tmp4b.sav"
/file ="tmp5.sav"
/file ="tmp5a.sav"
/file ="tmp5b.sav"
/file ="tmp6.sav"
/file ="tmp7.sav"
/file ="tmp8.sav"
/file ="tmp9.sav"
/file ="tmp10.sav"
.

/*****************************************************************************/

weight by fsweight.

compute GPI = -1.
if readingSkillBoysmean>0 GPI = readingSkillGirlsmean/readingSkillBoysmean.
variable labels GPI "Gender Parity Index for foundational reading skills [4],[5],[6]".
missing values GPI (-1).

* Define Multiple Response Sets.
mrsets
  /mcgroup name = $school
           label = 'School attendance'
           variables = schoolAux schoolAux1 schoolAux2.

* Define Multiple Response Sets.
mrsets
  /mcgroup name = $schage
           label = 'Age at beginning of school year'
           variables = schageAux schageAux1 schageAux2.

variable labels caretakerdis "Mother's functional difficulties [C]".

compute filter = (survey = 1).
filter by filter.

/*****************************************************************************/

* Ctables command in English.
ctables
  /format missing = "na"
  /vlabels variables = numChildren readCorrect aLiteral aInferential readingSkill notAvailable HL4 total layer
           display = none
  /table   total [c]
         + hh6 [c]
         + hh7 [c]
         + $schage [c]
         + $school [c]
         + melevel [c]
         + fsdisability [c]
         + caretakerdis [c]
         + ethnicity [c]
         + windex5 [c]
         + orphanStatus [c]
   by
          hl4 [c] > (readCorrect [s] [mean,'Percentage who correctly read 90% of words in a story',f5.1] +
                       layer [c] >(aLiteral [s] [mean,'Three literal',f5.1]  +
                       aInferential [s] [mean,'Two inferential',f5.1]) +
                       readingSkill [s] [mean,'Percentage who demonstrate foundational reading skills',f5.1] +
                       numChildren [s] [validn,'Number of children age 7-14 years',f5.0]) +
          tot [c] > (readCorrect [s] [mean,'Percentage who correctly read 90% of words in a story',f5.1] +
                       layer [c] >(aLiteral [s] [mean,'Three literal',f5.1]  +
                       aInferential [s] [mean,'Two inferential',f5.1]) +
                       readingSkill [s] [mean,'Percentage of children who demonstrate foundational reading skills [1],[2],[3],[7],[8],[9]',f5.1] +
                       notAvailable [s] [mean,'Percentage of children for whom the reading tasks were not available in appropriate language [A]',f5.1] +
                       numChildren [s] [validn,'Number of children age 7-14 years',f5.0])
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /titles title=
    "Table LN.4.1: Foundational reading skills"
    "Percentage of children aged 7-14 years who demonstrate foundational reading skills by successfully completing three foundational reading tasks in English, French or Spanish, by sex, " + surveyname
   caption =
        "[1] MICS indicator LN.22a - Foundational reading and numeracy skills (reading, age 7-14)"
        "[2] MICS indicator LN.22b - Foundational reading and numeracy skills (reading, age for grade 2/3)"
        "[3] MICS indicator LN.22c - Foundational reading and numeracy skills (reading, attending grade 2/3); SDG indicator 4.1.1"
        "[4] MICS indicator LN.11a - Parity indices - reading, age 7-14 (gender); SDG indicator 4.5.1"
        "[5] MICS indicator LN.11a - Parity indices - reading, age for grade 2/3 (gender); SDG indicator 4.5.1"
        "[6] MICS indicator LN.11a - Parity indices - reading, attending grade 2/3 (gender); SDG indicator 4.5.1"
        "[7] MICS indicator LN.11b - Parity indices - reading, age 7-14 (wealth); SDG indicator 4.5.1"
        "[8] MICS indicator LN.11c - Parity indices - reading, age 7-14 (area); SDG indicator 4.5.1"
        "[9] MICS indicator LN.11d - Parity indices - reading, age 7-14 (functioning); SDG indicator 4.5.1"
        "[A] The reading tasks were available in English, French and Spanish. Children were assessed in the language (mainly) spoken by " +
        "teachers or alternatively in the language (mainly) spoken at home. Children for whom both indicated languages were not available for " +
        "assessment are recorded here, though children may subsequently have elected to attempt the assesment in one of available languages."
        "[B] As eligibility for the Parental Involvement and Foundational Learning Skills modules was determined based on age at time of interview (age 7-14 years), " +
        "the disaggregate of Age at beginning of school year inevitably presents children who were age 6 years at the beginning of the school year."
        "[C] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."
        "na: not applicable"
.

* Generate gpi.

filter off.
compute filter = (sysmis(survey)).
filter by filter.
weight off.

* Part 2. Calculation of GPI.
* Ctables command in English.
ctables
  /format missing = "na"
  /vlabels variables = numChildren readCorrect aLiteral aInferential readingSkill notAvailable HL4 total layer
           display = none
  /table   total [c]
         + hh6 [c]
         + hh7 [c]
         + $schage [c]
         + $school [c]
         + melevel [c]
         + fsdisability [c]
         + caretakerdis [c]
         + ethnicity [c]
         + windex5 [c]
         + orphanStatus [c]
   by
         GPI [s] [mean,'Gender Parity Index for foundational reading skills [4],[5],[6]',f5.2]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /titles title=
    "Table LN.4.1: Foundational reading skills"
    "Percentage of children aged 7-14 years who demonstrate foundational reading skills by successfully completing three foundational reading tasks in English, French or Spanish, by sex, " + surveyname
   caption =
        "[1] MICS indicator LN.22a - Foundational reading and numeracy skills (reading, age 7-14)"
        "[2] MICS indicator LN.22b - Foundational reading and numeracy skills (reading, age for grade 2/3)"
        "[3] MICS indicator LN.22c - Foundational reading and numeracy skills (reading, attending grade 2/3); SDG indicator 4.1.1"
        "[4] MICS indicator LN.11a - Parity indices - reading, age 7-14 (gender); SDG indicator 4.5.1"
        "[5] MICS indicator LN.11a - Parity indices - reading, age for grade 2/3 (gender); SDG indicator 4.5.1"
        "[6] MICS indicator LN.11a - Parity indices - reading, attending grade 2/3 (gender); SDG indicator 4.5.1"
        "[7] MICS indicator LN.11b - Parity indices - reading, age 7-14 (wealth); SDG indicator 4.5.1"
        "[8] MICS indicator LN.11c - Parity indices - reading, age 7-14 (area); SDG indicator 4.5.1"
        "[9] MICS indicator LN.11d - Parity indices - reading, age 7-14 (functioning); SDG indicator 4.5.1"
        "[A] The reading tasks were available in English, French and Spanish. Children were assessed in the language (mainly) spoken by " +
        "teachers or alternatively in the language (mainly) spoken at home. Children for whom both indicated languages were not available for " +
        "assessment are recorded here, though children may subsequently have elected to attempt the assesment in one of available languages."
        "[B] As eligibility for the Parental Involvement and Foundational Learning Skills modules was determined based on age at time of interview (age 7-14 years), " +
        "the disaggregate of Age at beginning of school year inevitably presents children who were age 6 years at the beginning of the school year."
        "[C] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."
        "na: not applicable"
.

/*****************************************************************************/

new file.

erase files ="tmp1.sav".
erase files ="tmp2.sav".
erase files ="tmp3.sav".
erase files ="tmp4.sav".
erase files ="tmp4a.sav".
erase files ="tmp4b.sav".
erase files ="tmp5.sav".
erase files ="tmp5a.sav".
erase files ="tmp5b.sav".
erase files ="tmp6.sav".
erase files ="tmp7.sav".
erase files ="tmp8.sav".
erase files ="tmp9.sav".
erase files ="tmp10.sav".
erase files ="orphantemp.sav".
