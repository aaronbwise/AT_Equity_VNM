include "surveyname.sps".

get file = 'hl.sav'.

compute nofather = 0.
if (HL13 <> 1 or HL14 = 0) nofather = 100.
variable label nofather "Percentage of children not living with their natural father".

sort cases by HH1 HH2 HL1.

save outfile = "tmp.sav"
 /keep HH1 HH2 HL1 nofather felevel
 /rename (HL1 = LN).

get file = 'ch.sav'.

select if (UF9 = 1).
select if (cage>=36).
sort cases by HH1 HH2 LN.

match files
  /file = *
  /table='tmp.sav'
  /by HH1 HH2 LN.

weight by chweight.

compute total = 1.
variable labels total "".
value labels total 1 "Number of children aged 36-59 months".

compute layer = 0.
value labels layer 0 "Percentage of children aged 36-59 months".
variable labels layer "".

compute layer1 = 0.
value labels layer1 0 "Mean number of activities".
variable labels layer1 "".

compute activity = 0.
if (EC7AA = "A" or EC7AB = "B" or EC7AX = "X") activity = activity + 1.
if (EC7BA = "A" or EC7BB = "B" or EC7BX = "X") activity = activity + 1.
if (EC7CA = "A" or EC7CB = "B" or EC7CX = "X") activity = activity + 1.
if (EC7DA = "A" or EC7DB = "B" or EC7DX = "X") activity = activity + 1.
if (EC7EA = "A" or EC7EB = "B" or EC7EX = "X") activity = activity + 1.
if (EC7FA = "A" or EC7FB = "B" or EC7FX = "X") activity = activity + 1.

variable labels activity "Any adult household member engaged with the child".

recode activity (4 thru hi = 100) (else = 0) into activ4.
variable labels activ4 "With whom adult household members engaged in four or more activities [1]".

count factive = EC7AB EC7BB EC7CB EC7DB EC7EB EC7FB ("B").
variable labels factive "The father engaged with the child".

recode factive (1 thru hi = 100) (else = 0) into fact.
variable labels fact "With whom the father engaged in one or more activities [2]".

recode cage (36 thru 47 = 1) (else = 2) into age2.
variable labels age2 "Age".
value labels age2 1 "36-47 months" 2 "48-59 months".

compute tot1 = 1.
variable labels tot1 "Total".
value labels tot1 1" ".

* For labels in French uncomment commands bellow.

* variable labels nofather " Pourcentage d'enfants ne vivant pas avec leur père biologique".
* value labels total 1 " Nombre d'enfants âgés de 36-59 mois".
* value labels layer 0 " Pourcentage d'enfants âgés de 36-59 mois".
* value labels layer1 0 " Nombre moyen d'activities".
* variable labels activity " N'importe quel membre adulte du ménage s'est adonné à des activités avec l'enfant".
* variable labels activ4 " Avec qui des membres adultes du ménage se sont adonnés à quatre activités ou plus [1]".
* variable labels factive " Le père s'est adonné à des activités avec l'enfant".
* variable labels fact " Avec qui le père s'est adonné à une ou plusieurs activités [2]".
* value labels age2 1 "36-47 mois " 2 "48-59 mois ".

* Ctables command in English (currently active, comment it out if using different language).

ctables
  /vlabels variables = layer layer1 total
    display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + age2 [c] + melevel [c] + felevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
  layer [c] > (activ4 [s] [mean,'',f5.1] + fact [s] [mean,'',f5.1]) +  layer1 [c] > (activity [s] [mean,'',f5.1]+ factive [s] [mean,'',f5.1]) + nofather [s] [mean,'',f5.1] + total [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible=no
  /title title=
	"Table CD.2: Support for learning"
	"Percentage of children age 36-59 months with whom an adult household member engaged in activities " +
                  "that promote learning and school readiness during the last three days, " + surveyname
  caption =
    "[1] MICS indicator 6.1"
    "[2] MICS Indicator 6.2".

* Ctables command in French.
*
ctables
  /vlabels variables = layer layer1 total
    display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + age2 [c] + melevel [c] + felevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
  layer [c] > (activ4 [s] [mean,'',f5.1] + fact [s] [mean,'',f5.1]) +  layer1 [c] > (activity [s] [mean,'',f5.1]+ factive [s] [mean,'',f5.1]) + nofather [s] [mean,'',f5.1] + total [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible=no
  /title title=
	"Tableau CD.2: Soutien à l'apprentissage"
	"Pourcentage d'enfants âgés de 36-59 mois avec qui un membre adulte du ménage s'est adonné à des activités favorisant " +
                  "l'apprentissage et la maturité scolaire durant les trois derniers jours, " + surveyname
  caption =
    "[1] Indicateur MICS 6.1"
    "[2] Indicateur MICS 6.2".	

new file.

*delete working files.
erase file = 'tmp.sav'.
