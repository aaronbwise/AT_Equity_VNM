* MICS5 HH-07.

* v01 - 2014-03-11.

* Information on household and personal assets are obtained in the Household Characteristics module of the Household Questionnaire:
  Radio (HC8B), television (HC8C), Non-mobile telephone (HC8D), refrigerator (HC8E), agricultural land (HC11), farm animals/livestock (HC13),
  watch (HC9A), mobile telephone (HC9B), bicycle (HC9C), motorcycle or scooter (HC9D), animal-drawn cart (HC9E), car or truck (HC9F),
  boat with a motor (HC9G), and ownership of bank account (HC15); Ownership of dwelling is based on responses to HC10.

* Additional household and personal assets should to be added to the questionnaires (for wealth index construction) and shown in this table.

* Missing/DK values are included in the denominators and households with missing information are considered not to own or have these assets.
* However, a careful examination of the extent of missing values needs to be undertaken prior to the construction of this table.
* If Missing/DK cases exceed 5 percent, this should be shown in the table.

* Most of the information collected on household and personal assets are used in the construction of the wealth index.

***.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open household data file.
get file = 'hh.sav'.

* Select interviewed households.
select if (HH9 = 1).

* Weight the data by the household weight.
weight by hhweight.

* recode variables to 100/0 as we are going to calculate the mean.
* missing values are treated as recoded to 0.
recode hc8b hc8c hc8d hc8e hc11 hc13 hc9a hc9b hc9c hc9d hc9e hc9f hc9g hc15
     (1 = 100)
     (else = 0).

* producing variables for housing.
compute own    = (hc10 = 1) * 100 .
compute notown = (hc10 = 2 or hc10 = 6) * 100 .
compute rent   = (hc10 = 2) * 100 .
compute other  = (hc10 = 6) * 100 .
compute mis   = (hc10 = 9) * 100 .

variable labels
  own    "Owned by a household member"/
  notown "Not owned"/
  rent   "    Rented"/
  other  "    Other"/
  mis   "Missing/DK".

* compute total variable.
compute total = 100.
variable labels total "Total".
value labels total 100 " ".

compute numHouseholds = 1.
variable labels numHouseholds "Number of households".
value labels numHouseholds 1 ' '.

* producing the layers in tables.
compute empty1 = 0.
compute empty2 = 0.
compute empty3 = 0.
compute empty4 = 0.

variable labels
  hc11 "Agricultural land"/
  hc13 "Farm animals/Livestock" /
  hc15 "Bank account".

value labels 
  empty1 0 "Percentage of households that own a"/
  empty2 0 "Percentage of households that own"   /
  empty3 0 "Percentage of households where at least one member owns or has a"/
  empty4 0 "Ownership of dwelling".


* Ctables command in English (currently active, comment it out if using different language).
* For first table.
ctables
  /vlabels variables = empty1 empty2 empty3 empty4 display = none
  /format missing=' '
  /table empty1[c] >
            (hc8b [s][mean f5.1]
           + hc8c [s][mean f5.1]
           + hc8d [s][mean f5.1]
           + hc8e [s][mean f5.1])
         + empty2[c] >
            (hc11 [s][mean f5.1]
           + hc13 [s][mean f5.1])
         + empty3[c] >
            (hc9a [s][mean f5.1]
           + hc9b [s][mean f5.1]
           + hc9c [s][mean f5.1]
           + hc9d [s][mean f5.1]
           + hc9e [s][mean f5.1]
           + hc9f [s][mean f5.1]
           + hc9g [s][mean f5.1]
           + hc15 [s][mean f5.1])
         + empty4[c] >
           (own    [s][mean f5.1]
           + notown [s][mean f5.1]
           + rent   [s][mean f5.1]
           + other  [s][mean f5.1]
           + mis   [s][mean f5.1])
         + total [s][mean f5.1]
   by
           total [c]
         + hh6 [c]
         + hh7 [c]
  /slabels visible = no
  /title title =
     "Table HH.7: Household and personal assets"
     "Percentage of households by ownership of selected household and personal assets, and percent distribution by ownership of dwelling, "
    	"according to area of residence and regions, " + surveyname .

* The second table.
ctables
  /table  numHouseholds[c][count]
    by
          total[c]
        + hh6[c]
        + hh7[c]
  /slabels visible = no position=row
  /title title =
     "Table HH.7: Household and personal assets"
     "Percentage of households by ownership of selected household and personal assets, and percent distribution by ownership of dwelling, "
	    "according to area of residence and regions, " + surveyname .


new file.


