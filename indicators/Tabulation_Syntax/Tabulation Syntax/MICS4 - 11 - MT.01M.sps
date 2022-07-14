include "surveyname.sps".

get file = 'mn.sav'.

select if (MWM7 = 1).

weight by mnweight.

compute total = 1.
variable labels total "".
value labels total 1 "Number of men age 15-49 years".

recode MT2 (1,2 = 100) (else = 0) into read1w.
variable labels read1w "Read a newspaper at least once a week".

recode MT3 (1,2 = 100) (else = 0) into listen1w.
variable labels listen1w "Listen to the radio at least once a week".

recode MT4 (1,2 = 100) (else = 0) into watch1w.
variable labels watch1w "Watch television at least once a week".

*Men who are exposed to all three media at least once a week are: MT2=1 or 2 and MT3=1 or 2 and MT4=1 or 2.
compute three = 0.
if (read1w = 100 and listen1w = 100 and watch1w = 100) three = 100.
variable labels three "All three media at least once a week [1]".

*Men are considered not to be exposed to media at least once a week when MT2=3 or 4 and MT3=3 or 4 and MT4=3 or 4.
compute none = 0.
if ((MT2=3 or MT2 = 4) and (MT3=3 or  MT3 = 4) and (MT4=3 or MT4 = 4)) none = 100.
variable labels none "No media at least once a week".

compute layer0 = 0.
variable labels layer0 "".
value labels layer0 0 "Percentage of men age 15-49 who:".

compute tot = 1.
variable labels tot "".
value labels tot 1 "Total".

ctables
  /vlabels variables =  total layer0 tot   display = none
  /table mage [c] + hh7 [c] + hh6 [c] + mmelevel [c] + windex5 [c] + ethnicity [c] + tot [c] by
                   layer0 [c] > (read1w [s] [mean,'',f5.1] + listen1w [s] [mean,'',f5.1] + watch1w [s] [mean,'',f5.1]) +
                   three[s] [mean,'',f5.1] + none [s] [mean,'',f5.1] +
                   total[c][count,'',comma5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table MT.1M: Exposure to mass media"
    "Percentage of men age 15-49 years who are exposed to specific mass media on a weekly basis, " + surveyname
  caption =
     	"[1] MICS indicator MT.1".

new file.
