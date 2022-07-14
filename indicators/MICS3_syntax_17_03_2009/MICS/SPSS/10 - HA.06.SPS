get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

compute place = 0.
if (HA18 = 1 or HA15 = 1 or MN5 = 1) place = 100.
variable label place "Know a place to get tested *".

compute tested = 0.
if (HA15 = 1 or MN5 = 1) tested = 100.
variable label tested "Have been tested **".

compute total = 1.
variable label total "Number of women".
value label total 1 "".

do if (tested = 100).
+ compute results = 0.
+ if (HA16 = 1 or MN6 = 1) results = 100.
+ compute ttotal = 1.
end if.
variable label results "If tested, have been told result".
value label ttotal 1 "".
variable label ttotal "Number of women who have been tested for HIV".

tables
  /format = zero
  /observation place tested results
  /ftotal = tot1 "Total"
  /table = HH7 + HH6 + wage + melevel + wlthind5 + HC1B + tot1 by
    place + tested + total + results + ttotal
  /statistics
    mean(place (f5.1) '')
    mean(tested (f5.1) '')
    count(total (f5.0) '')
    mean(results (f5.1) '')
    count(ttotal (f5.0) '')
  /title
    "Table HA.6: Knowledge of a facility for HIV testing"
		"Percentage of women aged 15-49 years who know where to get an HIV test, "+
		"percentage of women who have been tested and, of those tested the "+
		"percentage who have been told the result, Country, Year"
  /caption
    "* MICS Indicator 87"
		"** MICS Indicator 88".

new file.
