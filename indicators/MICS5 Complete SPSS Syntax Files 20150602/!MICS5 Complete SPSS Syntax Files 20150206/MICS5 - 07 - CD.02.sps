* MICS5 CD-02.

* v01 - 2014-03-17.
* v02 - 2014-04-22.
* cd2 - Line 40:
     /keep = hh1 hh2 hl1 hl12 hl14 changed to /keep = hh1 hh2 hl1 hl12 hl14 felevel.

* Indicator 6.2 is calculated as: Engagement of household members over age 15 in four or more
  activities (EC7 [A] to [F] = A, B or X).

* Both indicator 6.2 and the mean number of activities in which household members engage with
  the child are calculated irrespective of the number of household members and whether mother
  or father are living in the household.

* For father's and mother's engagement (indicators 6.3 and 6.4) only responses ""B"" and ""A""
  are taken into account, respectively, while the denominator is confined to those children
  actually living with their father and mother, respectively.

* These denominators are established using data from the List of Household Members:
  HL11 and HL12, for mothers, and HL13 and HL14, for fathers.

* The maximum number of activities is 6, as asked in the under-5 questionnaire.
* The activities include (EC7): (A) Reading books to or looking at picture books with the
  child, (B) Telling stories to the child, (C) Singing songs to or with the child, including
  lullabies, (D) Taking the child outside the home, compound, yard, or enclosure,
  (E) Playing with the child, and (F) Naming, counting, or drawing things to or with the
  child.

***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

* open hl file to get info regarding mother (hl12) and father (hl14) being in household.
get file = 'hl.sav'.

* sorting the data.
sort cases by hh1 hh2 hl1.

* creating tmp file.
save outfile = 'tmp.sav'
     /keep = hh1 hh2 hl1 hl12 hl14 felevel
     /rename = (hl1 = ln) .

* Open household members data file.
get file = 'ch.sav'.

* merging the data .
match files
  /file = *
  /table = 'tmp.sav'
  /by hh1 hh2 ln.

* recode variables in order to calculate percetages.
recode hl12 (sysmis, 0 = 0) (else = 100).

recode hl14 (sysmis, 0 = 0) (else = 100).

variable labels
  hl12 'Biological mother'/
  hl14 'Biological father' .

* Select completed under 5 questionnaires.
select if (UF9  = 1).


* calculation of the indicators.
* 1 MICS indicator 6.2 - Support for learning.
compute ind62sum = 
	((EC7AA='A') or (EC7AB='B') or (EC7AX='X')) +
	((EC7BA='A') or (EC7BB='B') or (EC7BX='X')) +
	((EC7CA='A') or (EC7CB='B') or (EC7CX='X')) +
	((EC7DA='A') or (EC7DB='B') or (EC7DX='X')) +
	((EC7EA='A') or (EC7EB='B') or (EC7EX='X')) +
	((EC7FA='A') or (EC7FB='B') or (EC7FX='X')) .

compute ind62 = (ind62sum >= 4) * 100 .

* 2 MICS Indicator 6.3 - Father’s support for learning.
compute ind63sum = (EC7AB='B') +
                   (EC7BB='B') +
                   (EC7CB='B') +
                   (EC7DB='B') +
                   (EC7EB='B') +
                   (EC7FB='B') .

compute ind63 = (ind63sum >= 4) * 100 .

* 3 MICS Indicator 6.4 - Mother’s support for learning.
compute ind64sum = (EC7AA='A') +
                   (EC7BA='A') +
                   (EC7CA='A') +
                   (EC7DA='A') +
                   (EC7EA='A') +
                   (EC7FA='A') .

compute ind64 = (ind64sum >= 4) * 100 .


* labeling variables for table heading.
variable labels
  ind62  "Percentage of children with whom adult household members have engaged in four or more activities [1]"
 /ind62sum "Mean number of activities with adult household members"
 /ind63  "Percentage of children with whom biological fathers have engaged in four or more activities [2]"
 /ind63sum "Mean number of activities with biological fathers"
 /ind64  "Percentage of children with whom biological mothers have engaged in four or more activities [3]"
 /ind64sum "Mean number of activities with biological mothers".


* Select only children 36 to 59 months old.
select if (cage >= 36 and  cage <= 59).

* Weight the data by the children weight.
weight by chweight.

* Generating age groups.
recode  cage
  (36 thru 47 = 1)
  (48 thru 59 = 2) into ageGr.
variable labels ageGr 'Age of child'.
value labels ageGr
  1 '36-47 months'
  2 '48-59 months'.

* Generate total.
compute total = 1.
compute tot2 = 1.
compute tot3 = 1.
compute tot4 = 1.
if (hl14>0) tot63 = 1 .
if (hl12>0) tot64 = 1 .
variable labels total "Total".
value labels
  /total  1 " "
  /ind62 1 "Percentage of children age 36-59 months attending early childhood education [1]"
  /tot3  1 "Number of children age 36-59 months"
  /tot4  1 "Percentage of children living with their:"
  /tot63 1 "Number of children age 36-59 months living with their biological fathers"
  /tot64 1 "Number of children age 36-59 months living with their biological mothers".


* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = tot2 tot3 tot4 tot63 tot64 display = none
  /table  total[c]
        + hl4 [c]
        + hh7 [c]
        + hh6 [c]
        + ageGr [c]
        + melevel [c]
        + felevel [c]
        + windex5[c]
        + ethnicity [c]
   by
          ind62  [s] [mean f5.1]
        + ind62sum [s] [mean f5.1]
        + tot4[c] > ( 
            hl14 [s] [mean f5.1]
          + hl12 [s] [mean f5.1] )
        + tot3[c] [count f5.0]
        + ind63  [s] [mean f5.1]
        + ind63sum [s] [mean f5.1]
        + tot63  [c] [count f5.0]
        + ind64  [s] [mean f5.1]
        + ind64sum [s] [mean f5.1]
        + tot64  [c] [count f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels visible=no
  /title title=
    "Table CD.2: Support for learning"
    "Percentage of children age 36-59 months with whom adult household members engaged in activities that promote learning and " +
    "school readiness during the last three days, and engagement in such activities by biological fathers and mothers, " + surveyname
   caption=
    "[1] MICS indicator 6.2 - Support for learning"
    "[2] MICS Indicator 6.3 - Father’s support for learning"
    "[3] MICS Indicator 6.4 - Mother’s support for learning"
    "[a] The background characteristic ""Mother's education"" refers to the education level of the respondent"
    + " to the Questionnaire for Children Under Five, and covers both mothers and primary caretakers, who are"
    + " interviewed when the mother is not listed in the same household. Since indicator 6.4 reports on the biological"
    + " mother's support for learning, this background characteristic refers to only the educational levels of biological mothers when calculated for the indicator in question."
  .

new file.

erase file = 'tmp.sav'.