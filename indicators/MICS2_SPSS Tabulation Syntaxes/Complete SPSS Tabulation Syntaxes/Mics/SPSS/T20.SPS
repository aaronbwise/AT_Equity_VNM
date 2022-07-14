get file = 'wm.sav'.

weight by wmweight.

select if (CM11X = "Y").

compute weighed = 0.
if (MN5 = 1 and MN6 < 9997) weighed = 1.
variable label weighed "Percent of live births weighed at birth".

do if (MN5 = 1 and MN6 < 9997).
+ compute less2500 = 0.
+ if (MN6 < 2500) less2500 = 1.
end if.
variable label less2500 "Live births below 2500 grams".

compute births = 1.
variable label births "Total number of live births".

aggregate outfile = 'tmp.sav'
  /break MN4
  /tweighed = sum(weighed)
  /t2500 = sum(less2500)
  /tbirths = sum(births).

get file = 'tmp.sav'.

compute prop2500 = (t2500/tweighed)*100.
variable label prop2500 "Percent of live births below 2500 grams".

compute est2500 = prop2500*100/tbirths.
variable label est2500 "Estimated number of live births below 2500 grams".

variable label tweighed "Number of weighed births".

variable label t2500 "Number of weighed births below 2500 grams".

variable label tbirths "Total number of births".

tables
  /observation = tweighed t2500 prop2500 tbirths est2500
  /tables = MN4 by tweighed + t2500 + prop2500 + tbirths + est2500
  /statistics
    maximum(tweighed '' (f7.1))
    maximum(t2500 '' (f7.1))
    maximum(prop2500 '' (f7.1))
    maximum(tbirths '' (f7.1))
    maximum(est2500 '' (f7.1))
  /title
    "Working table for table 20".

sort cases by MN4

save outfile = 'tmp.sav'
  /keep MN4 est2500.

get file = 'wm.sav'.

select if (CM11X = "Y").

sort cases by MN4.

match files
  /file = *
  /table = 'tmp.sav'
  /by MN4.

tables
  /observation = est2500
  /ftotal = tot1 "Total"
  /tables = HI7 + HI6 + melevel + tot1 by est2500
  /statistics
    mean(est2500 (f5.1) '')
  /title
    "Table 20: Percentage of live births in the last 12 months that weighed below 2500 grams at birth, Country, Year"
  /caption
    "World Summit for Children Goal => Number 12".

weight by wmweight.

compute weighed = 0.
if (MN5 = 1 and MN6 < 9997) weighed = 100.
variable label weighed "Percent of live births weighed at birth".

compute births = 1.
variable label births "Number of live births".

tables
  /observation = weighed births
  /ftotal = tot1 "Total"
  /tables = HI7 + HI6 + melevel + tot1 by weighed + births
  /statistics
    mean(weighed (f5.1) '')
    count(births (f5.0) '')
  /title
    "Table 20: Percentage of live births in the last 12 months that weighed below 2500 grams at birth, Country, Year"
  /caption
    "World Summit for Children Goal => Number 12".

erase file = 'tmp.sav'.
