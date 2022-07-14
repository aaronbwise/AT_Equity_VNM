* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open the children's file.
get file = 'ch.sav'.

* Select completed interviews.
select if (UF9 = 1).

* Total variables.
compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* Compute digits reported for decimals for weight.
do if (AN3 < 99).
+ compute measure = mod (AN3*10,10).
end if.
variable labels measure "Digits".
formats measure (f1.0).

* Total variables.
compute tot = 1.
variable labels tot "Total".

* Aggregate sums for each separate digit.
aggregate outfile = "tmp1.sav"
  /break = measure
  /ttwgt = sum(tot).

* Compute digits reported for decimals for height.
do if (AN4 < 999).
+ compute measure = mod (AN4*10,10).
end if.
variable labels measure "Digits".
formats measure (f1.0).

* Aggregate sums for each separate digit.
aggregate outfile = "tmp2.sav"
  /break   = measure
  /tthgt = sum(tot).

* Add this summary information together in one data file.
get file = 'tmp1.sav'.
match files
  /file = *
  /file = 'tmp2.sav'
  /by measure.

rename variables (measure = digit).

variable labels ttwgt "Weight".
variable labels tthgt  "Height".

ctables
  /vlabels variables = digit display=label
  /pcompute &cat1 = expr ([0]+[5])
  /pproperties &cat1 LABEL = "0 or 5" format=count f5.0 hidesourcecats = no 
  /table  digit [c] by ttwgt [s] [sum,'Number',f5.0,tablepct.sum,'Percent',f5.1] + tthgt [s] [sum,'Number',f5.0,tablepct.sum,'Percent',f5.1] 
  /categories var = digit [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, &cat1, othernm] total = yes position = after
  /titles title=
   "Table DQ.8: Heaping in anthropometric measurements"
   "Distribution of weight and height/length measurements by digits reported for decimals, " + surveyname.

new file.

erase file = "tmp1.sav".
erase file = "tmp2.sav".
