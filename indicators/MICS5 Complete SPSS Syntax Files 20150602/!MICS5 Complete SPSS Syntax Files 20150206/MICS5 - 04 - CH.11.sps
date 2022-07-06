*v1 - 2014-04-03.
*v2 - 2014-04-21.
*The sub-title is updated.

* In this table, the percentages will not add to 100 since some mothers/caretakers may have indicated more than one symptom.

****.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = "ch.sav".

compute mother = 1.
variable labels  mother "Mother of a child under 5".

sort cases by HH1 HH2 UF6.

save outfile = "tmp.sav"
  /keep HH1 HH2 UF6 mother
  /rename UF6 = LN.

get file = "tmp.sav".
aggregate 
  /outfile='tmp1.sav'
  /break=HH1 HH2 LN
  /mother=mean(mother).

get file = 'wm.sav'.

sort cases by HH1 HH2 LN.

match files
  /file = *
  /table = 'tmp1.sav'
  /by HH1 HH2 LN.

select if (mother = 1).

select if (WM7 = 1).

weight by wmweight.

compute total = 1.
value labels total 1 "Number of mothers / caretakers of children age 0-59 months".
variable labels  total "".

compute layer1 = 1.
variable labels  layer1 " ".
value labels layer1 1 "Percentage of mothers / caretakers who think that a child should be taken immediately to a health facility if the child:".

compute drink = 0.
if (IS2A = "A") drink = 100.
variable labels  drink "Is not able to drink or breastfeed".

compute sicker = 0.
if (IS2B = "B") sicker = 100.
variable labels  sicker "Becomes sicker".

compute fever = 0.
if (IS2C = "C") fever = 100.
variable labels  fever "Develops a fever".

compute fast = 0.
if (IS2D = "D") fast = 100.
variable labels  fast "Has fast breathing".

compute breath = 0.
if (IS2E = "E") breath = 100.
variable labels  breath "Has difficulty breathing".

compute blood = 0.
if (IS2F = "F") blood = 100.
variable labels  blood "Has blood in stool".

compute poorly = 0.
if (IS2G = "G") poorly = 100.
variable labels  poorly "Is drinking poorly".

compute other = 0.
if (IS2X = "X" | IS2Y = "Y" | IS2Z = "Z") other = 100.
variable labels  other "Has other symptoms".
compute twosigns = 0.

* The two danger signs of pneumonia are fast breathing (IS2=D) and difficult breathing (IS2=E).
if (IS2D = "D" or IS2E = "E") twosigns = 100.
variable labels  twosigns "Mothers/caretakers who recognize at least one of the two danger signs of pneumonia (fast and/or difficult breathing) ".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = tot layer1 total
         display = none
  /table  tot [c] + hh7 [c] + hh6 [c] + welevel [c] +  windex5[c] + ethnicity [c] by 
  	layer1 [c] > (drink [s] [mean,'',f5.1] + sicker [s] [mean,'',f5.1] +
                                     fever [s] [mean,'',f5.1] + fast [s] [mean,'',f5.1] +
                                     breath [s] [mean,'',f5.1] + blood [s] [mean,'',f5.1] +
                                     poorly [s] [mean,'',f5.1] + other [s] [mean,'',f5.1])+
 	twosigns [s] [mean,'',f5.1] + total [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table CH.11: Knowledge of the two danger signs of pneumonia"
      	"Percentage of women age 15-49 years who are mothers or caretakers of children under age 5 "
	"by symptoms that would cause them to take a child under age 5 immediately to a health facility, "
	"and percentage of mothers who recognize fast or difficult breathing as signs for seeking care immediately, "+ surveyname.							

new file.
*erase the working files.
erase file = 'tmp.sav'.
erase file = 'tmp1.sav'.
