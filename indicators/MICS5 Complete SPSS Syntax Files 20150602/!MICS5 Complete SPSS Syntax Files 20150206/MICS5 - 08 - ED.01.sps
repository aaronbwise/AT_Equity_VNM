* MICS5 ED-01.

* v01 - 2014-03-04.

* Percentage of women age 15-24 years who are able to read a short simple statement about everyday life (WB7=3)
  or who attended secondary or higher education (WB4=2 or 3) are classified as literate.

* The percentage not known includes those for whom no sentence in the required language was available (WB7=4)
  or for whom no response was reported.
* If the percentage of the population for whom literacy status is not known exceeds 10 percent in any category,
  caution should be exercised in the interpretation of the results.

* Note that the percentage literate among women with secondary education and higher should be equal to 100 percent,
  based on the standard questionnaires. Women with secondary education or higher are assumed to be literate and are
  not asked to read the statement.

***.


include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

select if (wage = 1 or wage = 2).

compute literate  = 0.
if (WB4 = 2 or WB4 = 3 or WB7 = 3) literate = 100.
variable labels literate "Percentage literate [1]".

compute notKnown = 0.
if (WB7 = 4 or WB7 = 8 or WB7 = 9) notKnown = 100.
variable labels notKnown "Percentage not known ".

compute numWomen = 1.
variable labels numWomen "Number of women age 15-24 years".
value labels numWomen 1 "".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /table   total[c]
         + hh7 [c]
         + hh6 [c]
         + welevel [c]
         + wage[c]
         + windex5 [c]
         + ethnicity[c]
   by
           literate [s] [mean,'',f5.1]
         + notKnown [s] [mean,'',f5.1]
         + numWomen[s][sum,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
    "Table ED.1: Literacy (young women)"
    "Percentage of women age 15-24 years who are literate, " + surveyname
   caption =
    "[1] MICS indicator 7.1; MDG indicator 2.3 - Literacy rate among young women"
  .

new file.
