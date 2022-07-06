* MICS5 HH-08.

* v01 - 2014-03-11.
* v02 - 2015-04-21: subtitle updated.
 
* Wealth index quintiles are constructed by using data on housing characteristics, household
  and personal assets, and on water and sanitation via principal components analysis.

* Household members should be equally distributed to the five wealth index quintiles for the
  total sample, in the first row of the table (percentages that deviate from the equal
  distribution of 20 percent per quintile by 0.1 - 0.2 percent are permissible).
* Other background characteristics (such as Religion/Language/Ethnicity, education and sex
  of household head) may be added to the table, if needed.

***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open household data file.
get file = 'hl.sav'.

* Weight the data by the household weight.
weight by hhweight.

* compute total variables.
compute total = 100.
variable labels total "Total".
value labels total 100 " ".

compute numHouseholdMemebers = 1.
variable labels numHouseholdMemebers "Number of household members".
value labels numHouseholdMemebers 1 ' '.

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /format missing=' '
  /table  total[c]
        + hh6[c]
        + hh7[c]
   by
          windex5[c][rowpct f5.1]
        + total[c][rowpct f5.1]
        + numHouseholdMemebers[c][count]
  /slabels visible = no position=column
  /title title =
     "Table HH.8: Wealth quintiles"
     "Percent distribution of the household population by wealth index quintile, according to area of residence and regions, " + surveyname .

new file.
