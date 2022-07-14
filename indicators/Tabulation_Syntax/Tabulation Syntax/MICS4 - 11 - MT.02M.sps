include "surveyname.sps".

get file = 'mn.sav'.

select if (MWM = 1).

select if (mage = 1 or mage = 2).

weight by mnweight.

compute total = 1.
variable labels total "".
value labels total 1 "Number of men age 15-24 years".

recode MT6 (1 = 100) (else = 0) into compev.
variable labels compev "Ever used a computer".

recode MT7 (1 = 100) (else = 0) into comp12.
variable labels comp12 "Used a computer during the last 12 months [1]".

recode MT8 (1, 2 = 100) (else = 0) into comp1w.
variable labels comp1w "Used a computer at least once a week during the last one month".

recode MT9 (1 = 100) (else = 0) into intev.
variable labels intev "Ever used the internet".

recode MT10 (1 = 100) (else = 0) into int12.
variable labels int12 "Used the internet during the last 12 months [2]".

recode MT11 (1, 2 = 100) (else = 0) into int1w.
variable labels int1w "Used the internet at least once a week during the last one month".

compute layer0 = 0.
variable labels layer0 "".
value labels layer0 0 "Percentage of men age 15-24 who have:".

compute tot = 1.
variable labels tot "".
value labels tot 1 "Total".

ctables
  /vlabels variables =  total layer0 tot   display = none
  /table mage [c] + hh7 [c] + hh6 [c] + melevel [c] + windex5 [c] + ethnicity [c] + tot [c] by
                   layer0 [c] > (compev [s] [mean,'',f5.1] + comp12 [s] [mean,'',f5.1] + comp1w [s] [mean,'',f5.1]) +
                   layer0 [c] > (intev [s] [mean,'',f5.1] + int12 [s] [mean,'',f5.1] + int1w [s] [mean,'',f5.1]) +
                   total[c][count,'',comma5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table MT.2M: Use of computers and internet"
    "Percentage of young men age 15-24 who have ever used a computer, " +
    "percentage who have used a computer during the last 12 months, " +
    "and frequency of use during the last one month, " + surveyname
  caption =
    "[1] MICS indicator MT.2"
    "[2] MICS indicator MT.3".

new file.
