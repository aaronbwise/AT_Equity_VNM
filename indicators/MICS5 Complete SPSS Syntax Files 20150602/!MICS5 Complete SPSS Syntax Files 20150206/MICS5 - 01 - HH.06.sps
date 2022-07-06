* MICS5 HH-06.

* v01 - 2014-02-14.

* Information on housing characteristics are obtained in the Household Characteristics module of the Household Questionnaire:
  Electricity (HC8A), flooring (HC3), roof (HC4), exterior walls (HC5) and rooms used for sleeping (HC2).

* The mean number of persons per room used for sleeping is calculated by dividing the total number of household members (HH11)
  by the number of rooms used for sleeping (HC2). Households with missing information on the number of sleeping rooms are excluded
  from the calculation.

* To limit the size of the table, detailed floor, roof, and exterior wall categories are not shown. If needed, these categories may be
  indicated in a footnote below the table, in the final report.

* Additional relevant housing characteristics may be added to the table if included in the household questionnaire.

* Most of the information collected on these housing characteristics are used in the construction of the wealth index.


***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open household data file.
get file = 'hh.sav'.

* Select interviewed households.
select if (HH9 = 1).

* Weight the data by the household weight.
weight by hhweight.

* prepare background variable floor.
recode hc3
  (11, 12 = 1)
  (21, 22 = 2)
  (31, 32, 33, 34, 35 = 3)
  (96 = 4)
  (97 thru hi = 9) into floor.

variable labels floor "Flooring".

value labels floor
  1 "Natural floor"
  2 "Rudimentary floor"
  3 "Finished floor"
  4 "Other"
  9 "Missing/DK" .

* prepare background variable roof.
recode hc4
  (11, 12, 13 = 1)
  (21, 22, 23, 24 = 2)
  (31, 32, 33, 34, 35, 36 = 3)
  (96 = 4)
  (97 thru hi = 9) into roof.

variable labels roof "Roof".

value labels roof
  1 "Natural roofing"
  2 "Rudimentary roofing"
  3 "Finished roofing"
  4 "Other"
  9 "Missing/DK" .

* prepare background variable walls.
recode hc5
  (11, 12, 13 = 1)
  (21, 22, 23, 24, 25, 26 = 2)
  (31, 32, 33, 34, 35, 36 = 3)
  (96 = 4)
  (97 thru hi = 9) into walls.

variable labels walls "Exterior walls".

value labels walls
  1 "Natural walls"
  2 "Rudimentary walls"
  3 "Finished walls"
  4 "Other"
  9 "Missing/DK" .

* recode number of sleeping rooms in categories.
recode hc2
  (  3 thru 96 = 3)
  (97 thru 99 = 9)
  (else = copy) into sleeprm.

formats sleeprm (F2.0) .

variable labels sleeprm "Rooms used for sleeping".
value labels sleeprm
  3 "3 or more"
  9 "Missing/DK".

* compute mean number of persons per sleeping room.
missing values hc2 (99).
compute persroom = hh11 / hc2.
variable labels persroom "Mean number of persons per room used for sleeping".

* compute total variable.
compute total = 1.
variable labels total "Total".
value labels total 1 " ".

compute numHouseholds = 1.
variable labels numHouseholds "Number of households".
value labels numHouseholds 1 ' '.

* Ctables command in English (currently active, comment it out if using different language).
* The first table.
ctables
  /table  hc8a [c]
        + floor [c]
        + roof [c]
        + walls [c]
        + sleeprm [c]
        + total [c]
   by
          total [c] [colpct.count f5.1]
        + hh6 [c] [colpct.count f5.1]
        + hh7 [c] [colpct.count f5.1]
  /slabels visible = no
  /title title =
     "Table HH.6: Housing characteristics"
     "Percent distribution of households by selected housing characteristics, according to area of residence and regions, " + surveyname .

* The second table.
ctables
  /table  numHouseholds[c][count]
        + persroom[s][mean]
    by
          total[c]
        + hh6[c]
        + hh7[c]
  /slabels visible = no position=row
  /title title =
     "Table HH.6: Housing characteristics"
     "Percent distribution of households by selected housing characteristics, according to area of residence and regions, " + surveyname .

new file.
