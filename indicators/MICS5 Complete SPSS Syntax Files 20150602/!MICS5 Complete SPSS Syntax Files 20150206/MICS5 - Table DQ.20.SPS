* Updated 04/13/2015.
* Significant changes across the syntax. Please replace with new version.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hl.sav'.
sort cases by hh1 hh2 hl1.

save outfile = 'tmp.sav' /keep hh1 hh2 hl1 hl4 hl6 /rename (hl1=hl15) (hl4=ctsex) (hl6=ctage).

* Choose only the children under 5.
select if (hl6 >= 0 and hl6 <= 4).

* Sort data according to caretaker's line number.
sort cases by hh1 hh2 hl15.
* Add sex of caretaker to household listing file.
match files
  /file = *
  /table = 'tmp.sav'
  /by HH1 HH2 hl15.

weight by hhweight.

compute mother = 2.
if (hl12 > 0) mother = 1.

compute inter = 9.
if (hl15 = hl12) inter = 1.
if (hl15 = hl14) inter = 2.
if (inter = 9 and ctsex = 2 and ctage >= 15) inter = 3.
if (inter = 9 and ctsex = 1 and ctage >= 15) inter = 4.

value labels mother 1 "Mother in the household" 2 "Mother not in the household and primary caretaker identified:".

value labels inter 1 " " 2 "Father" 3 "Other adult female" 4 "Other adult male"  9 "Missing".

compute total = 1.
variable labels total "".
value labels total 1 "Number of children under 5".

compute tot1 = 100.
variable labels tot1  "Total".
value labels tot1 100 "".

ctables
  /vlabels variables  = mother inter total display = none
  /table hl6[c] by mother[c] > inter [c] [LAYERROWPCT.VALIDN,'',f5.1] + tot1 [s] [mean,'',f5.1]+ total [c][count,'',f5.0]
  /categories var=hl6 total = yes position = before empty=exclude 
  /categories var = all empty = exclude missing = exclude
  /slabels visible = no
  /titles title=
    "Table DQ.20: Respondent to the under-5 questionnaire" 
    "Distribution of children under five by respondent to the under-5 questionnaire, " + surveyname.										

new file.
erase file 'tmp.sav'.

