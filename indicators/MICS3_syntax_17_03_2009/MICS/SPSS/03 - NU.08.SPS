get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

select if (CM12 = "Y" or CM12 = "O" or CM12 = "S").

compute weighed = 0.
do if (MN11 < 9.996).
+ compute weighed = 1.
+ compute less2500 = 0.
+ if (MN11 < 2.500) less2500 = 1.
+ compute w2500 = 0.
+ if (MN11 = 2.500) w2500 = 1.
end if.
variable label weighed "Percent of live births weighed at birth".
variable label less2500 "Number of births weighing < 2500 grams".
variable label w2500 "Number of births weighing exactly 2500 grams".

compute births = 1.
variable label births "Total number of live births".

recode MN9 (8=9).
value label MN9
 1 "Very large"
 2 "Larger than average"
 3 "Average"
 4 "Smaller than average"
 5 "Very small"
 9 "DK/Missing".

aggregate outfile = 'tmp.sav'
  /break MN9
  /tweighed = sum(weighed)
  /t2500 = sum(less2500)
  /we2500 = sum(w2500)
  /tbirths = sum(births).

get file = 'tmp.sav'.

variable label tweighed "Number of weighed births".
variable label t2500 "Number of births weighing < 2500 g".
variable label we2500 "Number of births weighing exactly 2500 g".
variable label tbirths "Total number of births".

compute tot2500 = t2500+(we2500*0.25).
variable label tot2500 "Adjusted number of births < 2500 g".

if (tweighed > 0) prop2500 = tot2500/tweighed.
variable label prop2500 "Proportion of births weighing < 2500 g".

compute est2500 = prop2500*tbirths.
variable label est2500 "Estimated number < 2500 g".

if (sysmis(t2500)) t2500 = 0.
if (sysmis(prop2500)) prop2500 = 0.
if (sysmis(est2500)) est2500 = 0.
if (sysmis(we2500)) we2500 = 0.
if (sysmis(tot2500)) tot2500 = 0.

sort cases by MN9

save outfile = 'tmp2.sav'.

* General Tables.
tables
  /format zero
  /observation= tweighed t2500 we2500 prop2500 tbirths est2500
  /ftotal=tot1 "Total"
  /table=mn9 + tot1  by tweighed + t2500 + we2500 + prop2500 + tbirths + est2500
  /statistics
  sum( tweighed '' (f7.1))
  sum( t2500 '' (f7.1))
  sum( we2500 '' (f7.1))
  sum( prop2500 '' (f7.3))
  sum( tbirths '' (f7.1))
  sum( est2500 '' (f7.1))
  /title "Low birth weight estimation".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

select if (CM12 = "Y" or CM12 = "O" or CM12 = "S").

recode MN9 (8=9).
value label MN9
 1 "Very large"
 2 "Larger than average"
 3 "Average"
 4 "Smaller than average"
 5 "Very small"
 9 "DK/Missing".

sort cases by MN9.

match files
  /file = *
  /table = 'tmp2.sav'
  /by MN9.

compute lowb = prop2500 * 100.
variable label lowb "Percent of live births below 2500 grams *".

compute weighed = 0.
if ( MN11 < 9.996) weighed = 100.
variable label weighed "Percent of live births weighed at birth **".

compute births = 1.
value label births 1 "".
variable label births "Number of live births".

recode MN11 (9.996 thru 9.999 = sysmis).

tables
  /format = zero
  /observation = weighed lowb
  /ftotal = tot1 "Total"
  /table =  HH7 + HH6 + melevel + wlthind5 + HC1B + tot1
		by lowb + weighed + births
  /statistics
    mean(lowb (f7.1) '')
    mean(weighed (f7.1) '')
    count(births (f5.0) '')
  /title
    "Table NU.8 : Low birth weight infants"
		"Percentage of live births in the 2 years preceding the survey that "+
		"weighed below 2500 grams at birth, country, year"
  /caption
    "* MICS Indicator 9"
		"** MICS Indicator 10".

new file.

*delete working files.
erase file = 'tmp.sav'.
erase file = 'tmp2.sav'.
