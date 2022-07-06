* MICS5 ED-01M.

* v01 - 2014-03-18.

* Percentage of men age 15-24 years who are able to read a short simple statement about everyday life (MWB7=3)
  or who attended secondary or higher education (MWB4=2 or 3) are classified as literate.

* The percentage not known includes those for whom no sentence in the required language was available (MWB7=4)
  or for whom no response was reported.
* If the percentage of the population for whom literacy status is not known exceeds 10 percent in any category,
  caution should be exercised in the interpretation of the results.

* Note that the percentage literate among men with secondary education and higher should be equal to 100 percent,
  based on the standard questionnaires. Men with secondary education or higher are assumed to be literate and are not
  asked to read the statement.

***.


include "surveyname.sps".

get file = 'mn.sav'.

select if (MWM7 = 1).

weight by mnweight.

select if (mwage = 1 or mwage = 2).

compute literate  = 0.
if (MWB4 = 2 or MWB4 = 3 or MWB7 = 3) literate = 100.
variable labels literate "Percentage literate [1]".

compute notKnown = 0.
if (MWB7 = 4 or MWB7 = 8 or MWB7 = 9) notKnown = 100.
variable labels notKnown "Percentage not known ".

compute numMen = 1.
variable labels numMen "Number of men age 15-24 years".
value labels numMen 1 "".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /table   total[c]
         + hh7 [c]
         + hh6 [c]
         + mwelevel [c]
         + mwage[c]
         + windex5 [c]
         + ethnicity[c]
   by
           literate [s] [mean,'',f5.1]
         + notKnown [s] [mean,'',f5.1]
         + numMen[s][sum,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
    "Table ED.1M: Literacy (young men)"
     "Percentage of men age 15-24 years who are literate, " + surveyname
   caption =
    "[1] MICS indicator 7.1; MDG indicator 2.3 - Literacy rate among young men [M]"
  .

new file.
