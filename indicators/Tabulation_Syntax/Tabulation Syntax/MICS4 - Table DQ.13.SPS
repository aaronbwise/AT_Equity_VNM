* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hl.sav'.
sort cases by hh1 hh2 hl1.

save outfile = 'tmp.sav' /keep hh1 hh2 hl1 hl4 hl6 /rename (hl1=hl9) (hl4=ctsex) (hl6=ctage).

* Choose only the children under 5.
select if (hl6 >= 0 and hl6 <= 4).

* Sort data according to caretaker's line number.
sort cases by hh1 hh2 hl9.
* Add sex of caretaker to household listing file.
match files
  /file = *
  /table = 'tmp.sav'
  /by HH1 HH2 hl9.

weight by hhweight.

compute mother = 2.
if (hl12 > 0) mother = 1.

compute inter = 9.
if (hl9 = hl12) inter = 1.
if (hl9 = hl14) inter = 2.
if (inter = 9 and ctsex = 2 and ctage >= 15) inter = 3.
if (inter = 9 and ctsex = 1 and ctage >= 15) inter = 4.

value labels mother 1 "Mother in the household" 2 "Mother not in the household".

value labels inter 1 "Mother interviewed"  2 "Father interviewed" 3 "Other adult female interviewed" 4 "Other adult male interviewed"  9 "Other person interviewed".

compute total = 1.
variable label total "".
value label total 1 "Number of children under 5".

compute tot1 = 100.
variable label tot1  "Total".
value label tot1 100 "".

* tables
  /format = zero
  /ftotal = tot1 "Total"
  /table = hl6 + tot1 by mother > inter + tot1 + total
  /statistics
  cpct( inter( F5.1 ) '':hl6 )
  /title
    "Table DQ.13: Presence of mother in the household and the person interviewed for the under-5 questionnaire" 
    "Distribution of children under five by whether the mother lives in the same household, and the person interviewed for the under-5 questionnaire, " + surveyname.


ctables
  /vlabels variables  = mother inter total display = none
  /table hl6[c] by mother[c] > inter [c] [LAYERROWPCT.VALIDN,'',f5.1] + tot1 [s] [mean,'',f5.1]+ total [c][count,'',f5.0]
  /categories var=hl6 total = yes empty=exclude 
  /categories var = all empty = exclude missing = exclude
  /slabels visible = no
  /titles title=
    "Table DQ.13: Presence of mother in the household and the person interviewed for the under-5 questionnaire" 
    "Distribution of children under five by whether the mother lives in the same household, and the person interviewed for the under-5 questionnaire, " + surveyname.

COMMENT -- End CTABLES command.

new file.
erase file 'tmp.sav'.

