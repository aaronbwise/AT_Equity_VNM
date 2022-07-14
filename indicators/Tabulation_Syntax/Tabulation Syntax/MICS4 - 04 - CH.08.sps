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

if (IS2D = "D" and IS2E = "E") twosigns = 100.
variable labels  twosigns "Mothers / caretakers who recognize the two danger "+
  "signs of pneumonia".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

* For labels in French uncomment commands bellow.

* value labels total 1 " Nombre de mères/gardiennes des enfants âgés de 0-59 mois".
* value labels layer1 1 " Pourcentage des mères/gardiennes des enfants âgés de 0-59 mois qui pensent qu'on doit " +
	"emmener immédiatement l'enfant dans une structure sanitaire s'il:".

* variable labels  drink " ne peut pas boire ou être allaité au sein".
* variable labels  sicker " devient plus malade".
* variable labels  fever " développe une fièvre".
* variable labels  fast " a une respiration rapide".
* variable labels  breath " a une une difficulté respiratoire".
* variable labels  blood " a du sang dans les selles".
* variable labels  poorly " boit peu".
* variable labels  other " a d'autres symptômes".
* variable labels  twosigns " Mères/gardiennes qui reconnaissent les deux indicateurs d'alerte de la pneumonie".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = tot layer1 total
         display = none
  /table hh7 [c] + hh6 [c] + welevel [c] + windex5[c] + ethnicity [c] + tot [c] by 
  	layer1 [c] > (drink [s] [mean,'',f5.1] + sicker [s] [mean,'',f5.1] +
                                     fever [s] [mean,'',f5.1] + fast [s] [mean,'',f5.1] +
                                     breath [s] [mean,'',f5.1] + blood [s] [mean,'',f5.1] +
                                     poorly [s] [mean,'',f5.1] + other [s] [mean,'',f5.1])+
 	twosigns [s] [mean,'',f5.1] + total [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table CH.8: Knowledge of the two danger signs of pneumonia"
        "Percentage of mothers and caretakers of children age 0-59 months by "+
        "symptoms that would cause them to take the child immediately to a health facility, " +
        "and percentage of mothers who recognize fast and difficult breathing as signs for " +
        "seeking care immediately, " + surveyname.

* Ctables command in French.
*
ctables
  /vlabels variables = tot layer1 total
         display = none
  /table hh7 [c] + hh6 [c] + welevel [c] + windex5[c] + ethnicity [c] + tot [c] by 
  	layer1 [c] > (drink [s] [mean,'',f5.1] + sicker [s] [mean,'',f5.1] +
                                     fever [s] [mean,'',f5.1] + fast [s] [mean,'',f5.1] +
                                     breath [s] [mean,'',f5.1] + blood [s] [mean,'',f5.1] +
                                     poorly [s] [mean,'',f5.1] + other [s] [mean,'',f5.1])+
 	twosigns [s] [mean,'',f5.1] + total [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Tableau CH.8: Connaissance des deux indicateurs d'alerte de la pneumonie"
        "Pourcentage des mères et gardiennes des enfants âgés de 0-59 mois selon les "+
        "symptômes qui les pousseraient à emmener immédiatement l'enfant dans une structure sanitaire, " +
        "et pourcentage des mères qui savent que la respiration rapide et difficile est un signe nécessitant un " +
        " recours immédiat à un traitement, " + surveyname.

new file.

*erase the working files.
erase file = 'tmp.sav'.
erase file = 'tmp1.sav'.



