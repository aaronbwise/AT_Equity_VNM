* Encoding: UTF-8.
* MICS6 SR.1.1.

* v01 - 2018-01-28.
* v02 - 2019-08-27. Last modified to reflect tab plan changes as of 25 July 2019.
* v03 - 2020-07-20. Table sub-title changed based on the latest tab plan. Labels in French and Spanish have been removed. Several changes related to the Water quality and new tab plan.

* The denominators for the household completion and household response rates are:
*- Completion rate: The total number of households selected in the sample.
* - Response rate: The number of households found to be occupied during fieldwork (HH46 = 01, 02, 04, 07).

* The numerator for both completion and response rate is the number of households with complete household questionnaires (HH46 = 01).

* For Water quality testing, 
*- the denominator for the completion rates are the number of sampled households; the numerators are completed water quality test at household (WQ11 = 1) and at source (WQ19 = 1).
* - the denominator for the response rates are the number of eligible households, that is, occupied households selected for water quality testing: 
*HH46 = 01, 02, 04 or 07 and HH9 = 1; the numerators are completed water quality test at household (WQ11 = 1) and at source (WQ19 = 1). 

* The denominator for the women’s response rate is the total number of women age 15-49 (HH49) accumulated from the List of Household Members Module and the numerator is the total number of women age 15-49 with a complete interview (HH53).
 
* The denominator for the men's response rate is the total number of men age 15-49 (HH50) accumulated from the List of Household Members Module and the numerator is the total number of men age 15-49 with a complete interview (HH54). 
 
* The denominator for the response rate for the questionnaire for children under age 5 is the total number of under-5 children (HH51) accumulated from the List of Household Members Module 
* and the numerator is the total number of children under age 5 with a complete interview (HH55).
 
* The denominator for the response rate for the questionnaire for children age 5-17 is the total number of selected children age 5-17 (HH52 =1 if HH52 is >1) 
* accumulated from the List of Household Members Module and the numerator is the total number of children age 5-17 with a complete interview (HH56).

* Overall response rates are calculated for women, men, under-5 and children age 5-17 by multiplying the household response rate by the women's, men's, under-5's and children age 5-17's response rates, respectively.


******.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open the household data file.
get file = 'hh.sav'.

* Give value 1 to each HH to calculate total number of hhs sampled.
compute sampled = 1.

* Give value 1 to each HH occupied to calculate total number of hhs occupied.
recode HH46 (1,2,4,7 = 1) (else = 0) into occupied.

* Give value 1 to each hh interviewed to calculate total no of interviewed HHs.
recode HH46 (1 = 1) (else = 0) into complete.

recode HH52 (1 thru hi = 1)(else = 0) into HH52A.

* Give value 1 to each hh selected for water quality test.
recode HH9 (1 = 1) (else = 0) into wqSelect.

* Give value 1 to each occupied household selected for water quality test.
compute wqOccupied = 0.
if (occupied = 1 and wqSelect = 1) wqOccupied = 1.

* Give value 1 to each water quality test completed at household.
recode WQ11 (1 = 1) (else = 0) into wqhhcomplete.

* Give value 1 to each water quality test completed at source.
recode WQ19 (1 = 1) (else = 0) into wqsocomplete.

compute total = 1.
variable labels total "".
value labels total 1 "Total".

* For urban and rural separately.
* Aggregate the hh data file to calculate the sum of sampled, occupied, complete HHs.
* and sum of eligible and interviewed wmTot age 15-49 and children under age 5.
aggregate outfile = 'tmp1.sav'
  /break   = HH6
  /hhSamp  = sum(sampled)
  /hhOccup = sum(occupied)
  /hhComp  = sum(complete)
  /wqSel  = sum(wqSelect)
  /wqOccup = sum(wqOccupied)
  /wqhhComp  = sum(wqhhcomplete)
  /wqsoComp  = sum(wqsocomplete)
  /wmTot   = sum(HH49)
  /wmComp  = sum(HH53)
  /mnAll  = sum(HH50A)
  /mnTot   = sum(HH50)
  /mnComp  = sum(HH54)
  /ch05Tot   = sum(HH51)
  /ch05Comp  = sum(HH55)
  /ch517All   = sum(HH52)
  /ch517Tot   = sum(HH52A)
  /ch517Comp  = sum(HH56).

* For each region separately.
* Aggregate the hh data file to calculate the sum of sampled, occupied, complete HHs.
* and sum of eligible and interviewed wmTot age 15-49 and children under age 5.
aggregate outfile = 'tmp2.sav'
  /break   = HH7
  /hhSamp  = sum(sampled)
  /hhOccup = sum(occupied)
  /hhComp  = sum(complete)
  /wqSel  = sum(wqSelect)
  /wqOccup = sum(wqOccupied)
  /wqhhComp  = sum(wqhhcomplete)
  /wqsoComp  = sum(wqsocomplete)
  /wmTot   = sum(HH49)
  /wmComp  = sum(HH53)
  /mnAll  = sum(HH50A)
  /mnTot   = sum(HH50)
  /mnComp  = sum(HH54)
  /ch05Tot   = sum(HH51)
  /ch05Comp  = sum(HH55)
  /ch517All   = sum(HH52)
  /ch517Tot   = sum(HH52A)
  /ch517Comp  = sum(HH56).

* For overall country.
* Aggregate the hh data file to calculate the sum of sampled, occupied, complete HHs.
* and sum of eligible and interviewed wmTot age 15-49 and children under age 5.
aggregate outfile = 'tmp3.sav'
  /break   = total
  /hhSamp  = sum(sampled)
  /hhOccup = sum(occupied)
  /hhComp  = sum(complete)
  /wqSel  = sum(wqSelect)
  /wqOccup = sum(wqOccupied)
  /wqhhComp  = sum(wqhhcomplete)
  /wqsoComp  = sum(wqsocomplete)
  /wmTot   = sum(HH49)
  /wmComp  = sum(HH53)
  /mnAll  = sum(HH50A)
  /mnTot   = sum(HH50)
  /mnComp  = sum(HH54)
  /ch05Tot   = sum(HH51)
  /ch05Comp  = sum(HH55)
  /ch517All   = sum(HH52)
  /ch517Tot   = sum(HH52A)
  /ch517Comp  = sum(HH56).

* Add this summary information together in one data file.
get file = 'tmp1.sav'.
add files
  /file = *
  /file = 'tmp2.sav'
  /file = 'tmp3.sav'.

* Compute response rates for HH, WQ, Women, Men and Under5.
compute hhcr = (hhComp / hhSamp) * 100.
compute hhrr = (hhComp / hhOccup) * 100.
compute wqhhcr = (wqhhComp / wqSel) * 100.
compute wqhhrr = (wqhhComp / wqOccup) * 100.
compute wqsocr = (wqsoComp / wqSel) * 100.
compute wqsorr = (wqsoComp / wqOccup) * 100.
compute wmrr = (wmComp / wmTot) * 100.
compute wmor = (hhrr * wmrr) / 100.
compute mnrr = (mnComp / mnTot) * 100.
compute mnor = (hhrr * mnrr) / 100.
compute ch05rr = (ch05Comp / ch05Tot ) * 100.
compute ch05or = (hhrr * ch05rr) / 100.
compute ch517rr = (ch517Comp / ch517Tot ) * 100.
compute ch517or = (hhrr * ch517rr) / 100.

* Compute variables to format the table.
compute hh = 0.
compute wq = 0.
compute wm = 0.
compute mn = 0.
compute ch05 = 0.
compute ch517 = 0.

* Labels in English.
variable labels
   hhSamp        "   Sampled"
  /hhOccup       "   Occupied"
  /hhComp        "   Interviewed"
  /hhcr              "   Household completion rate"
  /hhrr    	     "   Household response rate"
  /wqSel           "   Sampled"
  /wqOccup      "   Occupied"
  /wqhhComp    "   Household water quality test: Completed"
  /wqhhcr    	     "   Household water quality test: Completion rate"
  /wqhhrr    	     "   Household water quality test: Response rate"
  /wqsoComp    "   Source water quality test: Completed"
  /wqsocr    	     "   Source water quality test: Completion rate"
  /wqsorr    	     "   Source water quality test: Response rate"
  /wmTot   	     "    Eligible"
  /wmComp      "    Interviewed"
  /wmrr    	     "    Women's response rate"
  /wmor     	     "    Women's overall response rate"
  /mnAll            "    Number of men in interviewed households"
  /mnTot   	     "    Eligible"
  /mnComp       "    Interviewed"
  /mnrr  	     "    Men's response rate"
  /mnor    	     "    Men's overall response rate"
  /ch05Tot   	     "    Eligible"
  /ch05Comp     "   Mothers/caretakers interviewed "
  /ch05rr    	     "    Under-5's response rate"
  /ch05or   	     "    Under-5's overall response rate"
  /ch517All 	     "    Number of children in interviewed households"
  /ch517Tot 	     "    Eligible"
  /ch517Comp   "    Mothers/caretakers interviewed "
  /ch517rr    	     "    Children age 5-17's response rate"
  /ch517or   	     "    Children age 5-17's overall response rate".

value labels hh 	0 "Households".
value labels wq 	0 "Water quality testing [A]".
value labels wm	0 "Women age 15-49 years".
value labels mn 	0 "Men age 15-49 years [B]".
value labels ch05     	0 "Children under 5 years".
value labels ch517     	0 "Children age 5-17 years [C]".


* Ctables command in English.
ctables
 /format missing=''
 /vlabels variables=total hh wq wm mn ch05 ch517 display=none
 /table hh [c] > (
          	hhSamp [s] [mean '' f5.0] +
          	hhOccup [s] [mean '' f5.0] +
         	hhComp [s] [mean '' f5.0] +
                  hhcr [s] [mean '' f5.1] + 
          	hhrr [s] [mean '' f5.1] 
	     ) +
          wq [c] > (
          	wqSel [s] [mean '' f5.0] +
          	wqOccup [s] [mean '' f5.0] +
          	wqhhComp [s] [mean '' f5.0] +
                  wqhhcr [s] [mean '' f5.1] + 
                  wqhhrr [s] [mean '' f5.1] + 
         	wqsoComp [s] [mean '' f5.0] +
          	wqsocr [s] [mean '' f5.1] +
          	wqsorr [s] [mean '' f5.1] 
	     ) +
         wm [c] > (
          	wmTot [s] [mean '' f5.0] +
          	wmComp [s] [mean '' f5.0] +
          	wmrr [s] [mean '' f5.1] +
          	wmor [s] [mean '' f5.1] 
	    ) +
         mn [c] > (
                  mnAll [s] [mean '' f5.0] +
         	mnTot [s] [mean '' f5.0] +
          	mnComp [s] [mean '' f5.0] +
         	mnrr [s] [mean '' f5.1] +
          	mnor [s] [mean '' f5.1] 
	    ) +
         ch05 [c] > (
          	ch05Tot  [s] [mean '' f5.0] +
          	ch05Comp [s] [mean '' f5.0] +
         	ch05rr [s] [mean '' f5.1] +
          	ch05or [s] [mean '' f5.1]) +
         ch517 [c] > (
          	ch517All  [s] [mean '' f5.0] +
          	ch517Tot  [s] [mean '' f5.0] +
          	ch517Comp [s] [mean '' f5.0] +
         	ch517rr [s] [mean '' f5.1] +
          	ch517or [s] [mean '' f5.1])
  by
         total [c] +
         hh6 [c] +
         hh7 [c]
 /slabels visible = no
 /categories variables=all empty=exclude missing=exclude
 /titles title=
    "Table SR.1.1: Results of household, household water quality testing, women's, men's, under-5's and children age 5-17's interviews"
    "Number of households, households selected for water quality testing, women, men, children under 5, and children age 5-17 by interview results, by area of residence and region, "
    + surveyname
caption =    "[A] The Water Quality Testing Questionnaire was administered to [insert number of selected households] randomly selected households in each cluster"						
                  "[B] The Individual Questionnaire for Men was administered to all men age 15-49 years in every [insert subsample] household"
                  "[C] The Questionnaire for Children Age 5-17 was administered to one randomly selected child in each interviewed household".								
.					

					
new file.

* Delete temporary working files.
erase file = 'tmp1.sav'.
erase file = 'tmp2.sav'.
erase file = 'tmp3.sav'.