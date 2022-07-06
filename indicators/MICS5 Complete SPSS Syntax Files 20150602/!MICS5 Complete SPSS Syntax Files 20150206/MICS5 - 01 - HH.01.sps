* MICS5 HH-01.

* v02 - 2014-02-14.
* v03 - 2015-04-21: subtitle changed.

* The denominator for the household response rate is the number of households found to be occupied during fieldwork (HH9 = 01, 02, 04, 07);
  the numerator is the number of households with complete household questionnaires (HH9 = 01).
* The denominator for the women’s response rate is the number of eligible women enumerated in the household listing form (HH12);
  the numerator is the number of women with a complete interview (HH13).  The denominator for the men's response rate is the number of
  eligible men enumerated in the household listing form (HH13A); the numerator is the number of men with a complete interview (HH13B).
* The denominator for the response rate for the questionnaire for children under 5 is the number of under-5 children identified in the
  household listing form (HH14); the numerator is the number of complete questionnaires for children under 5 (HH15).

* Overall response rates are calculated for women, men and under-5's by multiplying the household response rate with the women's, men's and
  under-5's response rates, respectively.

***.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open the household data file.
get file = 'hh.sav'.

* Give value 1 to each HH to calculate total number of hhs sampled.
compute sampled = 1.

* Give value 1 to each HH occupied to calculate total number of hhs occupied.
recode HH9 (1,2,4,7 = 1) (else = 0) into occupied.

* Give value 1 to each hh interviewed to calculate total no of interviewed HHs.
recode HH9 (1 = 1) (else = 0) into complete.

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
  /wmTot   = sum(HH12)
  /wmComp  = sum(HH13)
  /mnTot   = sum(HH13A)
  /mnComp  = sum(HH13B)
  /chTot   = sum(HH14)
  /chComp  = sum(HH15).

* For each region separately.
* Aggregate the hh data file to calculate the sum of sampled, occupied, complete HHs.
* and sum of eligible and interviewed wmTot age 15-49 and children under age 5.
aggregate outfile = 'tmp2.sav'
  /break   = HH7
  /hhSamp  = sum(sampled)
  /hhOccup = sum(occupied)
  /hhComp  = sum(complete)
  /wmTot   = sum(HH12)
  /wmComp  = sum(HH13)
  /mnTot   = sum(HH13A)
  /mnComp  = sum(HH13B)
  /chTot   = sum(HH14)
  /chComp  = sum(HH15).

* For overall country.
* Aggregate the hh data file to calculate the sum of sampled, occupied, complete HHs.
* and sum of eligible and interviewed wmTot age 15-49 and children under age 5.
aggregate outfile = 'tmp3.sav'
  /break   = total
  /hhSamp  = sum(sampled)
  /hhOccup = sum(occupied)
  /hhComp  = sum(complete)
  /wmTot   = sum(HH12)
  /wmComp  = sum(HH13)
  /mnTot   = sum(HH13A)
  /mnComp  = sum(HH13B)
  /chTot   = sum(HH14)
  /chComp  = sum(HH15).

* Add this summary information together in one data file.
get file = 'tmp1.sav'.
add files
  /file = *
  /file = 'tmp2.sav'
  /file = 'tmp3.sav'.

* Compute response rates for HH, Women, Men and Under5.
compute hhrr = (hhComp / hhOccup) * 100.
compute wmrr = (wmComp / wmTot) * 100.
compute wmor = (hhrr * wmrr) / 100.
compute mnrr = (mnComp / mnTot) * 100.
compute mnor = (hhrr * mnrr) / 100.
compute chrr = (chComp / chTot ) * 100.
compute chor = (hhrr * chrr) / 100.

* Compute variables to format the table.
compute hh = 0.
compute wm = 0.
compute mn = 0.
compute ch = 0.

* Labels in English.
variable labels
   hhSamp 	"   Sampled"
  /hhOccup	"   Occupied"
  /hhComp	"   Interviewed"
  /hhrr    	"   Household response rate"
  /wmTot   	"    Eligible"
  /wmComp  "    Interviewed"
  /wmrr    	"    Women's response rate"
  /wmor     	"    Women's overall response rate"
  /mnTot   	"    Eligible"
  /mnComp  "    Interviewed"
  /mnrr  	"    Men's response rate"
  /mnor    	"    Men's overall response rate"
  /chTot   	"    Eligible"
  /chComp  	"    Mothers/caretakers interviewed "
  /chrr    	"    Under-5's response rate"
  /chor   	"    Under-5's overall response rate".

value labels hh 	0 "Households".
value labels wm	0 "Women".
value labels mn 	0 "Men".
value labels ch     	0 "Children under 5".

* Ctables command in English (currently active, comment it out if using different language).
ctables
 /format missing=''
 /vlabels variables=total hh wm mn ch display=none
 /table hh [c] > (
          	hhSamp [s] [mean,'',f5.0] +
          	hhOccup [s] [mean,'',f5.0] +
         	hhComp [s] [mean,'',f5.0] +
          	hhrr [s] [mean,'',f5.1] 
	     ) +
         wm [c] > (
          	wmTot [s] [mean,'',f5.0] +
          	wmComp [s] [mean,'',f5.0] +
          	wmrr [s] [mean,'',f5.1] +
          	wmor [s] [mean,'',f5.1] 
	    ) +
         mn [c] > (
         	mnTot [s] [mean,'',f5.0] +
          	mnComp [s] [mean,'',f5.0] +
         	mnrr [s] [mean,'',f5.1] +
          	mnor [s] [mean,'',f5.1] 
	    ) +
         ch [c] > (
          	chTot  [s] [mean,'',f5.0] +
          	chComp [s] [mean,'',f5.0] +
         	chrr [s] [mean,'',f5.1] +
          	chor [s] [mean,'',f5.1])
  by
         total [c] +
         hh6 [c] +
         hh7 [c]
 /slabels visible = no
 /categories var=all empty=exclude missing=exclude
 /title title=
    "Table HH.1: Results of household, women's, men's and under-5 interviews"
    "Number of households, women, men, and children under 5 by interview results, "+
    "and household, women's, men's and under-5's response rates, " + surveyname
.



new file.

* Delete temporary working files.
erase file = 'tmp1.sav'.
erase file = 'tmp2.sav'.
erase file = 'tmp3.sav'.
