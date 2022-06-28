* Encoding: UTF-8.

/*****************************************************************************/
/*  MICS6: Standard.
/*  Chapter 8. Learn.
/*  LN.4. Foundational learning skills.
/*  Table LN.4.2: Foundational numeracy skills.
/*.
/*  Tab Plan version: 3 March 2021.
/*.
/*  Updates:.
/*    [20211026] 
/*      - Variables HL13 and HL17 added to the line 42:  /keep HH1 HH2 HL1 HL12 HL13 HL16 HL17
/*    [20210321] - Implementing Tab Plan of 3 March 2021.
/*      - Title has changed.
/*      - In the subtitle "years" has been added to read "...children age 7-14 years...".
/*      - An additional age disaggregate has been included (10-14).
/*      - Indicator notes [1], [2] and [3] have been edited to reflect updated terminology.
/*      - Two new indicator notes have been inserted as [5] and [6], shifting previous 5-7 to 7-9.
/*      - A new note [A] has been added, shifting existing note [A] to [B].
/*    [20200909 - v04].
/*      - Added orphanhood status for calculation of parity indices.
/*    [20200421 - v03].
/*      - The disaggregate on Mother's functional difficulties has been edited, including a note.
/*      - Labels in French and Spanish have been removed.
/*    [20190827 - v02].
/*      - Last modified to reflect tab plan changes as of 25 July 2019.
/*.
/*****************************************************************************/

* The table presents three indicators, one of which may require customisation: MICS Indicator LN.22b is measured on children with age for primary grades 2 and 3.
* Following the standard used throughout the standard LN tables,
* the indicator is set age age 7 and 8, as children start school at age 6.
* For example, if primary grade 1 is set at age 7 in a country, this indicator should instead be measured on age group 8-9.

include "surveyname.sps".

get file = 'hl.sav'.

sort cases by HH1 HH2 HL1.
save outfile = "orphantemp.sav"
 /keep HH1 HH2 HL1 HL12 HL13 HL16 HL17
 /rename HL1=LN.

get file = 'fs.sav'.

include "CommonVarsFS.sps".

sort cases by HH1 HH2 LN.
match files
  /file = *
  /table = 'orphantemp.sav'
  /by HH1 HH2 LN.

weight by fsweight.

*The denominator includes all children with a completed module (FL28=01).
select if (FL28 = 1).

select if CB3 >=7 and CB3 <=14.

/*****************************************************************************/

 * Percentage of children who successfully complete:
- A number reading task: All FL23=1
- A number discrimination task: All FL24=1
- An addition task: All FL25=1
- A pattern recognition and completion task: All FL27=1
- Demonstrate foundational numeracy skills: All of the above.

count numberReadTarget = FL23A FL23B FL23C FL23D FL23E FL23F (1).
compute numberRead = 0.
if (numberReadTarget = 6) numberRead = 100.
variable labels numberRead "Percentage of children who successfully completed tasks of: Number reading".

compute numberDiscr  = 0.
*if (FL24A = "7" and FL24B = "24" and FL24C = "58" and FL24D = "67" and FL24E = "154" ) numberDiscr = 100.
if (FL24A = 1 and FL24B = 1 and FL24C = 1  and FL24D = 1 and FL24E = 1) numberDiscr = 100.
variable labels numberDiscr "Percentage of children who successfully completed tasks of: Number discrimination".

compute numberAdd  = 0.
*if (FL25A = "5" and FL25B = "14" and FL25C = "10" and FL25D = "19" and FL25E = "36") numberAdd = 100.
if (FL25A = 1 and FL25B = 1 and FL25C = 1 and FL25D = 1 and FL25E =1) numberAdd = 100.
variable labels numberAdd "Percentage of children who successfully completed tasks of: Addition".

compute numberPattern = 0.
*if (FL27A = "8" and FL27B = "16" and FL27C = "30" and FL27D = "8" and FL27E = "14") numberPattern = 100.
if (FL27A = 1 and FL27B = 1 and FL27C = 1  and FL27D = 1 and FL27E = 1) numberPattern = 100.
variable labels numberPattern "Pattern recognition and completion".

compute numSkill = 0.
if (numberRead = 100 and numberDiscr = 100 and numberAdd = 100 and numberPattern = 100) numSkill = 100.
variable labels numSkill "Percentage of children who demonstrate foundational numeracy skills [1],[2],[3],[7],[8],[9]".

compute numChildren = 1.
variable labels numChildren "Number of children age 7-14 years".
value labels numChildren 1 "Number of children age 7-14 years".

compute tot= 1.
variable labels tot "Total".
value labels tot 1 " ".

compute total = 1.
variable labels total "Total [1],[4]".
value labels total 1 " ".

compute layer = 0.
value labels layer 0 "Percentage of children who successfully completed tasks of:".

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
 6    "6 [A]"
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
+compute numSkillGirls = 0.
+ if (numSkill = 100 and HL4 = 2) numSkillGirls = 100.
end if.
variable labels numSkillGirls " ".
do if (HL4=1).
+compute numSkillBoys = 0.
+ if (numSkill = 100 and HL4 = 1) numSkillBoys = 100.
end if.
variable labels numSkillBoys " ".

/*****************************************************************************/

* macro for aggregating numSkill variable for various background characteristics.
define aggreg ( temp = !tokens(1) / breakvr = !tokens(1) / func = !tokens(1) / invar1 = !tokens(1) / invar2 = !tokens(1) ).
  aggregate outfile = !temp
  /break = !breakvr
  /!concat(!invar1,!func) =  !concat(!func,"(",!invar1,")")
  /!concat(!invar2,!func) =  !concat(!func,"(",!invar2,")").
!enddefine.

/*****************************************************************************/

* aggregate for all background characteristics.
aggreg temp = "tmp1.sav" breakvr = total func = mean invar1 = numSkillGirls invar2 = numSkillBoys .
aggreg temp = "tmp2.sav" breakvr = hh6 func = mean invar1 = numSkillGirls invar2 = numSkillBoys .
aggreg temp = "tmp3.sav" breakvr = hh7 func = mean invar1 = numSkillGirls invar2 = numSkillBoys .
aggreg temp = "tmp4.sav" breakvr = schageAux func = mean invar1 = numSkillGirls invar2 = numSkillBoys .
aggreg temp = "tmp4a.sav" breakvr = schageAux1 func = mean invar1 = numSkillGirls invar2 = numSkillBoys .
aggreg temp = "tmp4b.sav" breakvr = schageAux2 func = mean invar1 = numSkillGirls invar2 = numSkillBoys .
aggreg temp = "tmp5.sav" breakvr = schoolAux func = mean invar1 = numSkillGirls invar2 = numSkillBoys .
aggreg temp = "tmp5a.sav" breakvr = schoolAux1 func = mean invar1 = numSkillGirls invar2 = numSkillBoys .
aggreg temp = "tmp5b.sav" breakvr = schoolAux2 func = mean invar1 = numSkillGirls invar2 = numSkillBoys .
aggreg temp = "tmp6.sav" breakvr = melevel func = mean invar1 = numSkillGirls invar2 = numSkillBoys .
aggreg temp = "tmp7.sav" breakvr = fsdisability func = mean invar1 = numSkillGirls invar2 = numSkillBoys .
aggreg temp = "tmp8.sav" breakvr = caretakerdis func = mean invar1 = numSkillGirls invar2 = numSkillBoys .
aggreg temp = "tmp9.sav" breakvr = ethnicity func = mean invar1 = numSkillGirls invar2 = numSkillBoys .
aggreg temp = "tmp10.sav" breakvr = windex5 func = mean invar1 = numSkillGirls invar2 = numSkillBoys .

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
/file ="tmp10.sav".

/*****************************************************************************/

weight by fsweight.

compute GPI = -1.
if numSkillBoysmean>0 GPI = numSkillGirlsmean/numSkillBoysmean.
variable labels GPI "Gender Parity Index for foundational numeracy skills [4],[5],[6]".
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

variable labels caretakerdis "Mother's functional difficulties [A]".

compute filter = (survey = 1).
filter by filter.

/*****************************************************************************/

* Ctables command in English.
ctables
  /format missing = "na"
  /vlabels variables = layer numChildren numberRead numberDiscr numberAdd numberPattern numSkill HL4 tot
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
          hl4 [c] > (layer [c] >(numberRead [s] [mean,'Number reading',f5.1] +
                       numberDiscr [s] [mean,'Number discrimination',f5.1]  +
                       numberAdd [s] [mean,'Addition',f5.1] +
                       numberPattern [s] [mean,'Pattern recognition and completion',f5.1]) +
                       numSkill [s] [mean,'Percentage of children who demonstrate foundational numeracy skills',f5.1] +
                       numChildren [s] [validn,'Number of children age 7-14 years',f5.0]) +
          tot [c] > (layer [c] >(numberRead [s] [mean,'Number reading',f5.1] +
                       numberDiscr [s] [mean,'Number discrimination',f5.1]  +
                       numberAdd [s] [mean,'Addition',f5.1] +
                       numberPattern [s] [mean,'Pattern recognition and completion',f5.1]) +
                       numSkill [s] [mean,'Percentage of children who demonstrate foundational numeracy skills [1],[2],[3],[7],[8],[9]',f5.1] +
                       numChildren [s] [validn,'Number of children age 7-14 years',f5.0])
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column
  /titles title=
    "Table LN.4.2: Foundational numeracy skills"
    "Percentage of children aged 7-14 years who demonstrate foundational numeracy skills by successfully completing four foundational numeracy tasks, by sex, " + surveyname
   caption =
    "[1] MICS indicator LN.22d - Foundational reading and numeracy skills (numeracy, age 7-14)"
    "[2] MICS indicator LN.22e - Foundational reading and numeracy skills (numeracy, age for grade 2/3)"
    "[3] MICS indicator LN.22f - Foundational reading and numeracy skills (numeracy, attending grade 2/3); SDG indicator 4.1.1"
    "[4] MICS indicator LN.11a - Parity indices - numeracy, age 7-14 (gender); SDG indicator 4.5.1"
    "[5] MICS indicator LN.11a - Parity indices - numeracy, age for grade 2/3 (gender); SDG indicator 4.5.1"
    "[6] MICS indicator LN.11a - Parity indices - numeracy, attending grade 2/3 (gender); SDG indicator 4.5.1"
    "[7] MICS indicator LN.11b - Parity indices - numeracy, age 7-14 (wealth); SDG indicator 4.5.1"
    "[8] MICS indicator LN.11c - Parity indices - numeracy, age 7-14 (area); SDG indicator 4.5.1"
    "[9] MICS indicator LN.11d - Parity indices - numeracy, age 7-14 (functioning); SDG indicator 4.5.1"
    "[A] As eligibility for the Parental Involvement and Foundational Learning Skills modules was determined based on age at time of interview (age 7-14 years), " +
          "the disaggregate of Age at beginning of school year inevitably presents children who were age 6 years at the beginning of the school year."
    "[B] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."
    "na: not applicable"
.

filter off.
compute filter = (sysmis(survey)).
filter by filter.
weight off.

* Ctables command in English.
* Part 2. Calculation of GPI.
ctables
  /format missing = "na"
  /vlabels variables = layer numChildren numberRead numberDiscr numberAdd numberPattern numSkill HL4 tot
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
            GPI [s] [mean,'Gender Parity Index for foundational numeracy skills [4],[5],[6]',f5.2]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column
  /titles title=
    "Table LN.4.2: Foundational numeracy skills"
    "Percentage of children aged 7-14 years who demonstrate foundational numeracy skills by successfully completing four foundational numeracy tasks, by sex, " + surveyname
   caption =
    "[1] MICS indicator LN.22d - Foundational reading and numeracy skills (numeracy, age 7-14)"
    "[2] MICS indicator LN.22e - Foundational reading and numeracy skills (numeracy, age for grade 2/3)"
    "[3] MICS indicator LN.22f - Foundational reading and numeracy skills (numeracy, attending grade 2/3); SDG indicator 4.1.1"
    "[4] MICS indicator LN.11a - Parity indices - numeracy, age 7-14 (gender); SDG indicator 4.5.1"
    "[5] MICS indicator LN.11a - Parity indices - numeracy, age for grade 2/3 (gender); SDG indicator 4.5.1"
    "[6] MICS indicator LN.11a - Parity indices - numeracy, attending grade 2/3 (gender); SDG indicator 4.5.1"
    "[7] MICS indicator LN.11b - Parity indices - numeracy, age 7-14 (wealth); SDG indicator 4.5.1"
    "[8] MICS indicator LN.11c - Parity indices - numeracy, age 7-14 (area); SDG indicator 4.5.1"
    "[9] MICS indicator LN.11d - Parity indices - numeracy, age 7-14 (functioning); SDG indicator 4.5.1"
    "[A] As eligibility for the Parental Involvement and Foundational Learning Skills modules was determined based on age at time of interview (age 7-14 years), " +
          "the disaggregate of Age at beginning of school year inevitably presents children who were age 6 years at the beginning of the school year."
    "[B] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."
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
