* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

select if (HH9 = 1).

recode CD6 (98,99 = 9) (5 thru 97 = 5) (sysmis = 0)(else = copy) .

variable label CD6 "Number of households by number of children 2-14".
value labels CD6 0 "None" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5+" 9 "Missing/DK".

select if (CD6 >=2).

compute with2c = 1.
compute correct = 0.
if (CD_FLAG = 1) correct = 100.

variable label with2c "Number of households with 2 or more children age 2-14 years".
value label with2c 1 " ".

variable label correct "Percent of households where correct selection was performed".

compute tot1 = 1.
variable label tot1 "Total".
value label tot1 1 " ".

compute total = 100.
variable label total "Total".
value label total 100 " ".

ctables
  /table hh7 [c] + hh6 [c] + cd6 [c] + tot1 [c] by correct [s] [mean,'',f5.1]  + with2c [validn,'',f5.0]
  /categories var=all empty=exclude missing = exclude
  /slabels visible = no
  /titles title="Table DQ.14: Selection of children age 2-14 years for the child discipline module"  
                   "Percent of households with at least two children age 2-14 years where correct selection of one child for the child discipline module was performed, " + surveyname.

new file.

