* Encoding: UTF-8.
* MICS6 SR.5.2.

* v01 - 2017-09-21.
* v02 - 2019-08-27. Last modified to reflect tab plan changes as of 25 July 2019.
* v03 - 2020-04-09. Table sub-title and footnote changed based on the latest tab plan. Labels in French and Spanish have been removed.

** Total weighted and unweighted numbers of children under 5 should be equal when normalized sample weights are used.

** The total weighted number of under-5 children does not necessarily match that presented on age group 0-4 years in Table SR.4.1. 
** This table is based on completed under-5 interviews only, whereas Table SR.4.1 is based on completed household interviews. The two tables are computed with different sample weights.


***.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hl.sav'.

sort cases hh1 hh2 hl1.

save outfile='tmp.sav'
  /keep = hh1 hh2 hl1 hl14 
  /rename = (hl1=ln).

* Open children data file.
get file = 'ch.sav'.

* sort cases in order to perform mergeing.
sort cases hh1 hh2 ln.

* merging with tmp file with mother's line number.
match files
 /file=*
 /table='tmp.sav'
 /by hh1 hh2 ln.

recode HL14 (sysmis = 0) (else = copy).
if (HL14 = UF4)  respondentToQ = 1.
if (HL14 ~= UF4) respondentToQ = 2.

variable labels respondentToQ 'Respondent to the under-5 questionnaire'.
value labels respondentToQ
  1 'Mother'
  2 'Other primary caretaker'.

* Select interviewed children.
select if (UF17 = 1).

* Weight the data by the under-5 weight.
weight by chweight.

* In order to add [A] in melevel label.
variable labels melevel "Mother’s education [A]".

* In order to add [B] in disability status.
variable labels cdisability "Functional difficulties (age 2-4 years) [B] [C]".

* In order to add [C] in disability status of caretaker.
variable labels caretakerdis "Mother's functional difficulties [D]".
recode caretakerdis (sysmis = 90) (else = copy).
add value labels caretakerdis 90 "No information".

*Change the labels on the disaggregate of “Health insurance” have been changed to “Has coverage” and “Has no coverage”.
add value labels cinsurance 
 1 "Has coverage"
 2 "Has no coverage" 
 9 "Missing/DK".

compute total = 1.
variable labels total "Total".
value labels total 1" ".

compute wp = 0.
variable labels wp " ".
compute numChildren = 0.
variable labels numChildren "Number of under-5 children".

* Ctables command in English.
ctables
  /vlabels variables = wp display = none
  /table  total [c]
        + hl4 [c]
        + hh6 [c]
        + hh7 [c]
        + cage_6 [c]
        + melevel [c]
        + respondentToQ [c]
        + cinsurance [c]
        + cdisability [c]
        + caretakerdis [c]
        + ethnicity[c]
        + windex5[c]
   by
          wp [s] [colpct.count,'Weighted percent' f5.1]
        + numChildren [s] [count, 'Weighted', f5.0, 
                           ucount, 'Unweighted', f5.0]
  /categories variables=all empty=exclude missing = exclude
  /titles title =
     "Table SR.5.2: Children under 5's background characteristics"
     "Percent and frequency distribution of children under five years, " + surveyname
   caption =
            "[A]  In this table and throughout the report, mother's education refers to educational attainment of the respondent: Mothers (or caretakers, interviewed only if the mother is deceased or is living elsewhere)"  		
            "[B] The results of the Child Functioning module are presented in Chapter 11.1."
            "[C] Children age 0-1 years are excluded, as functional difficulties are only collected for age 2-4 years."            	
            "[D] In this table and throughout the report, mother's functional difficulties refer to functional difficulty of the respondent as described in note A. " +
            "The category of 'No information' applies to mothers or caretakers to whom the Adult Functioning module was not administered. " +
            "This category is not presented in individual tables. Please refer to Tables 8.1W and 8.1M for results of the Adult Functioning module"
.

new file.

erase file = 'tmp.sav'.
