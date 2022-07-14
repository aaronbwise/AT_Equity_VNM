* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF9 = 1).

compute total = 1.
variable labels total  " ".
value labels total 1 "Number of children under 5".

compute wnmeas  = 0.
if ((AN3 >= 99 or AN2 <> 1) and AG1M < 97 and AG1Y < 9997) wnmeas = 100.
variable labels wnmeas "Weight not measured".

compute dkdate  = 0.
if ((AG1M>=97 or AG1Y>=9997) and AN3< 99) dkdate = 100.
variable labels dkdate "Incomplete date of birth".

compute both  = 0.
if ((AG1M>=97 or AG1Y>=9997) and (AN3>=99 or AN2 <> 1)) both = 100.
variable labels both "Weight not measured, incomplete date of birth".

compute flag = 0.
if (WAZFLAG = 1 and wnmeas = 0 and dkdate = 0 and both = 0) flag = 100.
variable labels flag "Flagged cases (outliers)".

compute vdatew  = 0.
if (AG1M < 97 and AG1Y < 9997 and AN3 < 99 and flag = 0) vdatew = 100.
variable labels vdatew "Valid weight and date of birth".

compute excluded = 0.
if (wnmeas = 100 or dkdate = 100 or both = 100 or flag = 100) excluded = 100.
variable labels excluded "Percent of children excluded from analysis".

compute tot = 100.
variable labels tot "Total".
value labels tot 100 " ".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Reason for exclusion from analysis".

variable labels cage_6 "Weight by age".
value labels cage_6 1 "<6 months" 2 "6-11 months" 3 "12-23 months" 4 "24-35 months" 5 "36-47 months" 6 "48-59 months".

ctables
  /vlabels variables =  total layer
         display = none
  /TABLE CAGE_6 [c] + tot [c] by 
	vdatew [s] [mean,f5.1] + 	layer[c] >(wnmeas [s] [mean,f5.1] + dkdate [s] [mean,f5.1] + both [s] [mean,f5.1] + flag [s][mean,f5.1] ) + tot [s] [mean,f5.1] + excluded [s][mean,f5.1]
                + total [c] [count,f5.0]  
  /slabels position = column visible = no
  /TITLES TITLE=
   "Table DQ.7: Completeness of information for anthropometric indicators"
   "Distribution of children under 5 by completeness of information for anthropometric indicators, " + surveyname.
COMMENT -- End CTABLES command.

new file.

*______________________________________________________________________________________________________________.

get file = 'ch.sav'.

select if (UF9 = 1).

compute total = 1.
variable labels total  " ".
value labels total 1 "Number of children under 5".

compute hnmeas  = 0.
if ((AN4 >= 999 or AN2 <> 1) and AG1M < 97 and AG1Y < 9997) hnmeas = 100.
variable labels hnmeas "Height not measured".

compute dkdate  = 0.
if ((AG1M >= 97 or AG1Y>=9997) and AN4 < 999) dkdate = 100.
variable labels dkdate "Incomplete date of birth".

compute both  = 0.
if ((AG1M>=97 or AG1Y>=9997) and (AN4 >= 999 or AN2 <> 1)) both = 100.
variable labels both "Height not measured, incomplete date of birth".

compute flag = 0.
if (HAZFLAG = 1 and hnmeas = 0 and dkdate = 0 and both = 0) flag = 100.
variable labels flag "Flagged cases (outliers)".

compute vdateh  = 0.
if (AG1M < 97 and AG1Y < 9997 and AN4 < 999 and flag = 0) vdateh = 100.
variable labels vdateh "Valid height and date of birth".

compute excluded = 0.
if (hnmeas = 100 or dkdate = 100 or both = 100 or flag = 100) excluded = 100.
variable labels excluded "Percent of children excluded from analysis".

compute tot = 100.
variable label tot "Total".
value label tot 100 " ".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Reason for exclusion from analysis".

variable labels cage_6 "Height by age".
value labels cage_6 1 "<6 months" 2 "6-11 months" 3 "12-23 months" 4 "24-35 months" 5 "36-47 months" 6 "48-59 months".

ctables
  /vlabels variables =  total layer
         display = none
  /TABLE CAGE_6 [c] + tot [c] by 
	vdateh [s] [mean,f5.1] + 	layer[c] >(hnmeas [s] [mean,f5.1] + dkdate [s] [mean,f5.1] + both [s] [mean,f5.1] + flag [s][mean,f5.1] ) + tot [s] [mean,f5.1] + excluded [s][mean,f5.1]
                + total [c] [count,f5.0]  
  /slabels position = column visible = no
  /TITLES TITLE=
   "Table DQ.7: Completeness of information for anthropometric indicators"
   "Distribution of children under 5 by completeness of information for anthropometric indicators, " + surveyname.

new file.

*______________________________________________________________________________________________________________.


get file = 'ch.sav'.

select if (UF9 = 1).

compute total = 1.
variable labels total  " ".
value labels total 1 "Number of children under 5".

compute wnmeas  = 0.
if (AN3 >= 99 and AN4 < 999 and AG1M < 97 and AG1Y < 9997) wnmeas = 100.
variable labels wnmeas "Weight not measured".

compute hnmeas  = 0.
if (AN3 < 99 and AN4 >= 999 and AG1M < 97 and AG1Y < 9997) hnmeas = 100.
variable labels hnmeas "Height not measured".

compute wgthgt  = 0.
if (((AN3 >= 99 and AN4 >= 999) or AN2<>1) and AG1M < 97 and AG1Y < 9997) wgthgt = 100.
variable labels wgthgt "Weight and height not measured".

compute flag = 0.
if (WHZFLAG = 1 and wnmeas = 0 and hnmeas = 0 and wgthgt = 0) flag = 100.
variable labels flag "Flagged cases (outliers)".

compute vdatew  = 0.
if (AN3 < 99 and AN4 < 999 and flag = 0 and AG1M < 97 and AG1Y < 9997) vdatew = 100.
variable labels vdatew "Valid weight and height".

compute excluded = 0.
if (wnmeas = 100 or hnmeas = 100 or wgthgt = 100 or flag = 100) excluded = 100.
variable labels excluded "Percent of children excluded from analysis".

compute tot = 100.
variable labels tot "Total".
value labels tot 100 " ".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Reason for exclusion from analysis".

COMMENT -- Begin commenting out TABLES command to be converted to CTABLES.
 *tables
 *  /format = zero
 *  /observation= mmb myb mweight mheight mhw
 *  /table= mmb+ myb + mweight + mheight + mhw  by (statistics)
 *  /statistics
 *    mean(mmb (F5.1) 'Percent with missing information')
 *    validn(mmb (F5.0) 'Number')
 *    mean(myb (F5.1) 'Percent with missing information')
 *    validn(myb (F5.0) 'Number')
 *    mean(mweight (F5.1) 'Percent with missing information')
 *    validn(mweight (F5.0) 'Number')
 *    mean(mheight (F5.1) 'Percent with missing information')
 *    validn(mheight (F5.0) 'Number')
 *    mean(mhw (F5.1) 'Percent with missing information')
 *    validn(mhw (F5.0) 'Number')
 *  /title
 *    "Table DQ.6: Percentage of observations missing information for selected questions and indicators (Under-5 questionnaire, weighted), Country, Year"
 *.
COMMENT -- End commenting out TABLES command.
COMMENT -- Begin CTABLES command.

variable labels cage_6 "Weight by height".
value labels cage_6 1 "<6 months" 2 "6-11 months" 3 "12-23 months" 4 "24-35 months" 5 "36-47 months" 6 "48-59 months".

ctables
  /vlabels variables =  total layer
         display = none
  /TABLE CAGE_6 [c] + tot [c] by 
	vdatew [s] [mean,f5.1] + 	layer[c] >(wnmeas [s] [mean,f5.1]  + hnmeas [s] [mean,f5.1] + wgthgt [s] [mean,f5.1] + flag [s][mean,f5.1] ) + 
                  tot [s] [mean,f5.1] + excluded [s][mean,f5.1]
                + total [c] [count,f5.0]  
  /slabels position = column visible = no
  /TITLES TITLE=
   "Table DQ.7: Completeness of information for anthropometric indicators"
   "Distribution of children under 5 by completeness of information for anthropometric indicators, " + surveyname.
COMMENT -- End CTABLES command.

new file.



