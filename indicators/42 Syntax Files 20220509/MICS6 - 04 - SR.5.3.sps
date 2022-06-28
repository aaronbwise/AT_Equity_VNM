* Encoding: UTF-8.
* MICS6 SR.5.3.

* v01 - 2017-09-21.
* v02 - 2019-08-27. Last modified to reflect tab plan changes as of 25 July 2019.
* v03 - 2020-04-09. Table sub-title and footnote changed based on the latest tab plan. Labels in French and Spanish have been removed.

** Total weighted and unweighted numbers of children age 5-17 should be equal when normalized sample weights are used.

** The total weighted number of children age 5-17 does not necessarily match that presented on age groups 0-4 and 5-17 years in Table SR.4.1. 
** This table is based on completed children age 5-17 interviews only, whereas Table SR.4.1 is based on completed household interviews. The two tables are computed with different sample weights.


***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hl.sav'.

sort cases hh1 hh2 hl1.

save outfile='tmp.sav'
  /keep = hh1 hh2 hl1 hl14 hl4
  /rename = (hl1=ln).

* Open children data file.
get file = 'fs.sav'.

* sort cases in order to perform mergeing.
sort cases hh1 hh2 ln.

* merging with tmp file with mother's line number.
match files
 /file=*
 /table='tmp.sav'
 /by hh1 hh2 ln.

recode HL14 (sysmis = 0) (else = copy).
if (HL14 = FS4)  respondentToQ = 1.
if (HL14 ~= FS4) respondentToQ = 2.
if (FS4 = 90) respondentToQ = 3.

variable labels respondentToQ 'Respondent to the children age 5-17 questionnaire'.
value labels respondentToQ
  1 'Mother'
  2 'Other primary caretaker'
  3 'Emancipated [C]'.

* Select interviewed children.
select if (FS17 = 1).

* In order to add [B] in melevel label.
variable labels melevel "Mother’s education [B]".
recode melevel (sysmis = 90)(else = copy).
add value labels melevel 90 "Emancipated [C]".

* In order to add [D] in disability status.
variable labels fsdisability "Child's functional difficulties [D]".

variable labels caretakerdis "Mother's functional difficulties [E]".
recode caretakerdis (sysmis=90)(else=copy).
add value labels caretakerdis 90 "No information".

*Change the labels on the disaggregate of “Health insurance” have been changed to “Has coverage” and “Has no coverage”.
add value labels fsinsurance 
 1 "Has coverage"
 2 "Has no coverage" 
 9 "Missing/DK".

compute total = 1.
variable labels total "Total".
value labels total 1" ".

compute wp = 0.
variable labels wp " ".
compute numChildren = 0.
variable labels numChildren "Number of households with at least one child age 5 - 17 years".

* * Weight the data by the 5-17 weight for the first part of the table.
* Ctables command in English.
ctables
  /vlabels variables = wp numChildren display = none
  /weight variable = fsweight 
  /table  total [c]
        + hl4 [c]
        + hh6 [c]
        + hh7 [c]
        + fsage [c]
        + melevel [c]
        + respondentToQ [c]
        + fsinsurance [c]
        + fsdisability [c]
        + caretakerdis [c]
        + ethnicity[c]
        + windex5[c]
   by
          wp [s] [colpct.count,'Weighted percent' f5.1]
        + numChildren [s] [count, 'Weighted total number of children age 5-17 years [A]', f5.0]
  /categories variables=all empty=exclude missing = exclude
  /titles title =
     "Table SR.5.3: Children age 5-17's background characteristics"
     "Percent and frequency distribution of children age 5-17 years, " + surveyname
   caption =
            "[A] As one child is randomly selected in each household with at least one child age 5-17 years, the final weight of each child is the weight of the household multiplied with the number of children age 5-17 " +
            "years in the household. This column is the basis for the weighted percent distribution, i.e. the distribution of all children age 5-17 years in sampled households."				
            "[B] In this table and throughout the report where applicable, mother's education refers to educational attainment of the respondent: Mothers (or caretakers, interviewed only if the mother is deceased or is living elsewhere). " +
            "The category of 'Emancipated' applies to children age 15-17 years as described in note C. This category is not presented in individual tables."				
            "[C] Children age 15-17 years were considered emancipated and individually interviewed if not living with his/her mother and the respondent to the Household Questionnaire indicated that the child does not have a primary caretaker."			
            "[D] The results of the Child Functioning module are presented in Chapter 11.1."			
            "[E] In this table and throughout the report, mother's functional difficulties refer to functional difficulty of the respondent as described in note B. " +
            "The category of 'No information' applies to mothers or caretakers to whom the Adult Functioning module was not administered. " +
            "Emancipated children are also included in this category. This category is not presented in individual tables. Please refer to Tables 8.1W and 8.1M for results of the Adult Functioning module."
.

* * Weight the data by the 5-17 household weight for the second part of the table.
* Ctables command in English.
ctables
  /vlabels variables = wp display = none
  /weight variable = fshweight 
  /table  total [c]
        + hl4 [c]
        + hh6 [c]
        + hh7 [c]
        + fsage [c]
        + melevel [c]
        + respondentToQ [c]
        + fsinsurance [c]
        + fsdisability [c]
        + caretakerdis [c]
        + ethnicity[c]
        + windex5[c]
   by
         numChildren [s] [count, 'Weighted', f5.0, 
                           ucount, 'Unweighted', f5.0]
  /categories variables=all empty=exclude missing = exclude
  /titles title =
     "Table SR.5.3: Children age 5-17's background characteristics"
     "Percent and frequency distribution of children age 5-17 years, " + surveyname
   caption =
             "[A] As one child is randomly selected in each household with at least one child age 5-17 years, the final weight of each child is the weight of the household multiplied with the number of children age 5-17 " +
            "years in the household. This column is the basis for the weighted percent distribution, i.e. the distribution of all children age 5-17 years in sampled households."				
            "[B] In this table and throughout the report where applicable, mother's education refers to educational attainment of the respondent: Mothers (or caretakers, interviewed only if the mother is deceased or is living elsewhere). " +
            "The category of 'Emancipated' applies to children age 15-17 years as described in note C. This category is not presented in individual tables."				
            "[C] Children age 15-17 years were considered emancipated and individually interviewed if not living with his/her mother and the respondent to the Household Questionnaire indicated that the child does not have a primary caretaker."			
            "[D] The results of the Child Functioning module are presented in Chapter 11.1."			
            "[E] In this table and throughout the report, mother's functional difficulties refer to functional difficulty of the respondent as described in note B. " +
            "The category of 'No information' applies to mothers or caretakers to whom the Adult Functioning module was not administered. " +
            "Emancipated children are also included in this category. This category is not presented in individual tables. Please refer to Tables 8.1W and 8.1M for results of the Adult Functioning module."
.

new file.

erase file = 'tmp.sav'.
