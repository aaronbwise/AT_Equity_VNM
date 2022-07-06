* MICS5 MT-01M.

* v01 - 2013-06-22.

*Men who are exposed to all three media at least once a week are:
    (MMT2=1 or 2) and (MMT3=1 or 2) and (MMT4=1 or 2).

* Men exposed to any media at least once a week are:
    (MMT2=1 or 2) or (MMT3=1 or 2) or (MMT4=1 or 2).

* Men are considered not to be exposed to any of the media at least once a week when
     (MMT2>2 or MWB7=1 or MWB7=5) and (MMT3>2) and (MMT4>2).

* Note that the percentages in the table do not add to 100.

***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open men dataset.
get file = 'mn.sav'.

* Select completed interviews.
select if (MWM7 = 1).

* Weight the data by the men weight.
weight by mnweight.

* Generate numMen variable.
compute numMen = 1.
variable labels numMen "".
value labels numMen 1 "Number of men age 15-49 years".

* Generate indicators.
recode MMT2 (1,2 = 100) (else = 0) into read1w.
variable labels read1w "Read a newspaper at least once a week".

recode MMT3 (1,2 = 100) (else = 0) into listen1w.
variable labels listen1w "Listen to the radio at least once a week".

recode MMT4 (1,2 = 100) (else = 0) into watch1w.
variable labels watch1w "Watch television at least once a week".

* Men who are exposed to all three media at least once a week.
* (MMT2=1 or 2) and (MMT3=1 or 2) and (MMT4=1 or 2).
compute three = 0.
if (read1w = 100 and listen1w = 100 and watch1w = 100) three = 100.
variable labels three "All three media at least once a week [1]".

* Men exposed to any media at least once a week are: (MMT2=1 or 2) or (MMT3=1 or 2) or (MMT4=1 or 2).
compute any1w = 0.
if (read1w = 100 or listen1w = 100 or watch1w = 100) any1w = 100.
variable labels any1w "Any media at least once a week".

* Men are considered not to be exposed to any of the media at least once a week when.
* (MMT2>2 or MWB7=1 or MWB7=5) and (MMT3>2) and (MMT4>2). 
compute none = 0.
if (((MMT2 > 2 and MMT2 < 8) or MWB7 = 1 or MWB7 = 5) and (MMT3 > 2 and MMT3 < 8) and (MMT4 > 2 and MMT4 < 8)) none = 100.
variable labels none "None of the media at least once a week".

compute layer0 = 0.
variable labels layer0 "".
value labels layer0 0 "Percentage of men age 15-49 who:".

compute total = 1.
variable labels total "".
value labels total 1 "Total".


ctables
  /vlabels variables =  numMen layer0 total
         display = none
  /table   total [c]
         + mwage [c]
         + hh7 [c]
         + hh6 [c]
         + mwelevel [c]
         + windex5 [c]
         + ethnicity [c]
   by
           layer0 [c] > ( read1w [s] [mean,'',f5.1]
                        + listen1w [s] [mean,'',f5.1]
                        + watch1w [s] [mean,'',f5.1])
         + three[s] [mean,'',f5.1]
         + any1w[s] [mean,'',f5.1]
         + none [s] [mean,'',f5.1]
         + numMen[c][count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
     "Table MT.1M: Exposure to mass media (men)"
     "Percentage of men age 15-49 years who are exposed to specific mass media on a weekly basis, " + surveyname
   caption =
     "[1] MICS indicator 10.1 - Exposure to mass media [M]".

new file.
