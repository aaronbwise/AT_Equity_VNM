* Encoding: UTF-8.
* MICS6 SR.2.1.

* v01 - 2019-03-14.
* v03 - 2020-04-09. Table sub-title and footnotes changed based on the latest tab plan. Labels in French and Spanish have been removed. 

** Information on housing characteristics are obtained in the Household Characteristics module of the Household Questionnaire: Electricity (HC8), flooring (HC4), roof (HC5), exterior walls (HC6) and rooms used for sleeping (HC3).
** The mean number of persons per room used for sleeping is calculated by dividing the total number of household members (HH48) by the number of rooms used for sleeping (HC3)
    Households with missing information on the number of sleeping rooms are excluded from the calculation.
** The percentage of household members that has access to electricity is computed by weighing each household with number of household members (HC8=1 or 2).
** To limit the size of the table, detailed floor, roof, and exterior wall categories are not shown. If needed, these categories may be indicated in a footnote below the table, in the final report.
** Additional relevant housing characteristics may be added to the table if included in the household questionnaire.
** Most of the information collected on these housing characteristics are used in the construction of the wealth index.

***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open household data file.
get file = 'hh.sav'.

* Select interviewed households.
select if (HH46 = 1).

* Weight the data by the household weight.
weight by hhweight.

* Electricity.
variable labels hc8 "Electricity".
value labels hc8
1 "Yes, interconnected grid"
2 "Yes, off-grid"
3 "No"
9 "DK/Missing".

* Energy use for cooking.
* Households that use clean fuels and technologies for cooking (EU1=01, 02, 03, 04, 05, or (EU1=06 and EU4=01).
* Note: A liquid fuel stove (EU1=06) is considered clean if used with ethanol/alcohol (EU4=01).
compute energy = 9.
if (eu1 > 5 and eu1 < 97) energy = 2.
if (eu1 <= 5 or (eu1 = 6 and eu4 = 1))  energy = 1.
if (eu1 = 97) energy = 3.
variable labels energy "Energy use for cooking [A]".
value labels energy 
1 "Clean fuels and technologies"
2 "Other fuels"
3 "No cooking done in the household"
9 "DK/Missing".

* Internet access at home.
variable labels hc13 "Internet access at home [B]".
value labels hc13
1 "Yes"
2 "No"
9 "DK/Missing".

* prepare background variable floor.
recode hc4
  (11, 12 = 1)
  (21, 22 = 2)
  (31, 32, 33, 34, 35 = 3)
  (96 = 4)
  (97 thru hi = 9) into floor.

variable labels floor "Main material of flooring [C]".

value labels floor
  1 "Natural floor"
  2 "Rudimentary floor"
  3 "Finished floor"
  4 "Other"
  9 "DK/Missing" .

* prepare background variable roof.
recode hc5
  (11, 12, 13 = 1)
  (21, 22, 23, 24 = 2)
  (31, 32, 33, 34, 35, 36 = 3)
  (96 = 4)
  (97 thru hi = 9) into roof.

variable labels roof "Main material of roof [C]".

value labels roof
  1 "Natural roofing"
  2 "Rudimentary roofing"
  3 "Finished roofing"
  4 "Other"
  9 "DK/Missing" .

* prepare background variable walls.
recode hc6
  (11, 12, 13 = 1)
  (21, 22, 23, 24, 25, 26 = 2)
  (31, 32, 33, 34, 35, 36 = 3)
  (96 = 4)
  (97 thru hi = 9) into walls.

variable labels walls "Main material of exterior walls [C]".

value labels walls
  1 "Natural walls"
  2 "Rudimentary walls"
  3 "Finished walls"
  4 "Other"
  9 "DK/Missing" .

* recode number of sleeping rooms in categories.
recode hc3
  (  3 thru 96 = 3)
  (97 thru 99 = 9)
  (else = copy) into sleeprm.

formats sleeprm (F2.0) .

variable labels sleeprm "Rooms used for sleeping".
value labels sleeprm
  3 "3 or more"
  9 "DK/Missing".

* compute mean number of persons per sleeping room.
missing values hc3 (99).
compute persroom = hh48 / hc3.
variable labels persroom "Mean number of persons per room used for sleeping".

* percentage of household members with access to electricity in the household.
recode hc8 (1, 2 = 100) (else = 0) into electricity. 
variable labels electricity "Percentage of household members with access to electricity in the household [1]".

* compute total variable.
compute total = 1.
variable labels total "Total".
value labels total 1 " ".

compute tot = 1.
variable labels tot "".
value labels tot 1 "Total".

compute numHouseholds = 1.
variable labels numHouseholds "Number of households".
value labels numHouseholds 1 ' '.

compute numMembers = 1.
variable labels numMembers "Number of household members".
value labels numMembers 1 ' '.

* Ctables command in English.
* The first table.
ctables
  /vlabels variables=tot display=none      
  /table 
        total [c] 
        + hc8 [c]
        + energy [c]
        + hc13 [c]
        + floor [c]
        + roof [c]
        + walls [c]
        + sleeprm [c]
   by
          tot [c] [colpct.count f5.1]
        + hh6 [c] [colpct.count f5.1]
        + hh7 [c] [colpct.count f5.1]
  /categories variables = all empty = exclude          
  /slabels visible = no
  /titles title =
     "Table SR.2.1: Housing characteristics"
     "Percent distribution of households by selected housing characteristics, by area of residence and region, " + surveyname 
   caption = "[1] MICS indicator SR.1 - Access to electricity; SDG Indicator 7.1.1"
                  "[A] Calculated for households. For percentage of household members living in households using clean fuels and technologies for cooking, please refer to Table TC.4.1"						
                  "[B] See Table SR.9.2 for details and indicators on ICT devices in households"
                  "[C] Please refer Household Questionnaire in Appendix E, questions HC4, HC5 and HC6 for definitions of natural, rudimentary, finished and other".

* The second table.
ctables
  /vlabels variables=tot display=none    
  /table  numHouseholds[c][count]
        + persroom[s][mean]
    by
          tot[c]
        + hh6[c]
        + hh7[c]
  /categories variables = all empty = exclude           
  /slabels visible = no position=row
  /titles title =
     "Table SR.2.1: Housing characteristics"
     "Percent distribution of households by selected housing characteristics, by area of residence and region, " + surveyname 
   caption = "[1] MICS indicator SR.1 - Access to electricity; SDG Indicator 7.1.1"
                  "[A] Calculated for households. For percentage of household members living in households using clean fuels and technologies for cooking, please refer to Table TC.4.1"						
                  "[B] See Table SR.9.2 for details and indicators on ICT devices in households"
                  "[C] Please refer Household Questionnaire in Appendix E, questions HC4, HC5 and HC6 for definitions of natural, rudimentary, finished and other".
						
  
* The third table.
compute hhweight1 = hhweight * HH48.
weight by hhweight1.

ctables
  /vlabels variables=tot display=none   
  /table  
        electricity[s][mean f5.1]
        + numMembers[c][count]
    by
          tot[c]
        + hh6[c]
        + hh7[c]
  /categories variables = all empty = exclude         
  /slabels visible = no position=row
  /titles title =
     "Table SR.2.1: Housing characteristics"
     "Percent distribution of households by selected housing characteristics, according to area of residence and region, " + surveyname 
   caption = "[1] MICS indicator SR.1 - Access to electricity; SDG Indicator 7.1.1"
                  "[A] Calculated for households. For percentage of household members living in households using clean fuels and technologies for cooking, please refer to Table TC.4.1"						
                  "[B] See Table SR.9.2 for details and indicators on ICT devices in households"
                  "[C] Please refer Household Questionnaire in Appendix E, questions HC4, HC5 and HC6 for definitions of natural, rudimentary, finished and other".									
  
new file.
