*v02 - 2014-04-22.
*variable SL6 corrected to SL1.

* Updated 4/13/2015.
* weight by hhweight added to the syntax.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

select if (HH9 = 1).

weight by hhweight.

recode SL1 (97, 98, 99 = 9) (2 thru 96 = 2) (sysmis = 0)(else = copy) .

variable labels SL1 "Number of children age 1-17 years".
value labels SL1 0 "None" 1 "One" 2 "Two or more"  9 "Missing/DK".

do if (SL1 >= 2).

compute with2c = 1.
compute correct = 0.
if (CD_FLAG = 1) correct = 100.

end if.

variable labels with2c "Number of households with 2 or more children age 1-17 years".
value labels with2c 1 " ".

variable labels correct "Percent of households where correct selection was performed".

compute tot1 = 1.
variable labels tot1 "Total".
value labels tot1 1 " ".

compute tothh = 1.
variable labels tothh "Number of households".
value labels tothh 1 " ".

compute total = 100.
variable labels total "Total".
value labels total 100 " ".

ctables
  /table tot1 [c] + hh7 [c] + hh6 [c] + windex5 [c]  by SL1 [c] [rowpct.validn, '',f5.1] + tothh [s] [sum,'',f5.0] + correct [s] [mean,'',f5.1]  + with2c [s] [validn,'',f5.0]
  /categories var=all empty=exclude missing = exclude
  /categories var = SL1 total = yes
  /slabels visible = no
  /titles title="Table DQ.21: Selection of children age 1-17 years for the child labour and child discipline modules"  
	"Percent distribution of households by the number of children age 1-17 years, "+
                   "and the percentage of households with at least two children age 1-17 years where "+
	"where correct selection of one child for the child labour and child discipline modules was performed, " + surveyname.
							
new file.

