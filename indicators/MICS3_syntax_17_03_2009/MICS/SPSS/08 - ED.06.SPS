get file = 'hl.sav'.

weight by hhweight.

* the following code assumes that the primary school graduation age is 10 (HL5) (see maxage) and
* that the fifth grade is the last primary grade (ED6B and ED8B) (see higrade); 
* change these values to reflect the situation in your country.

* NEXT TWO LINES SHOULD BE ADDED IF THE SURVEY WAS CONDUCTED HALF A YEAR OR LATER THAN THE BEGINNING OF THE SCHOOL YEAR. 
*compute hl5 = hl5-1.
*variable label hl5 "Age at beginning of school year".

* Primary school graduation age.
compute maxage = 10.
* Last primary grade.
compute higrade = 6.

compute pageg = 0.
if (HL5 = maxage) pageg  = 1.

compute prepeat = 0.
if (((ED6A = 1 and ED6B >= higrade and ED6B < 8) or (ED6A >= 2 and ED6A < 8)) and ED8A = ED6A and ED8B  = ED6B and HL5 = maxage) prepeat = 1.

compute plgrade = 0.
if (((ED6A = 1 and ED6B >= higrade and ED6B < 8) or (ED6A >= 2 and ED6A < 8)) and HL5 = maxage and prepeat = 0) plgrade  = 1.

compute cass = 0.
if (ED6A = 2 and ED8A = 1 and ED8B = higrade) cass  = 1.

compute lgps = 0.
if (ED8A = 1 and ED8B = higrade) lgps  = 1.

compute total = 1.
variable label total "Total".
value label total 1 "".

aggregate outfile = 'tmp1.sav'
  /break    = HL4
  /nplgrade = sum(plgrade)
  /npageg   = sum(pageg)
  /ncass    = sum(cass)
  /nlgps    = sum(lgps).

aggregate outfile = 'tmp2.sav'
  /break    = HH7
  /nplgrade = sum(plgrade)
  /npageg   = sum(pageg)
  /ncass    = sum(cass)
  /nlgps    = sum(lgps).

aggregate outfile = 'tmp3.sav'
  /break    = HH6
  /nplgrade = sum(plgrade)
  /npageg   = sum(pageg)
  /ncass    = sum(cass)
  /nlgps    = sum(lgps).

aggregate outfile = 'tmp4.sav'
  /break    = melevel
  /nplgrade = sum(plgrade)
  /npageg   = sum(pageg)
  /ncass    = sum(cass)
  /nlgps    = sum(lgps).

aggregate outfile = 'tmp5.sav'
  /break    = wlthind5
  /nplgrade = sum(plgrade)
  /npageg   = sum(pageg)
  /ncass    = sum(cass)
  /nlgps    = sum(lgps).

aggregate outfile = 'tmp6.sav'
  /break    = HC1B
  /nplgrade = sum(plgrade)
  /npageg   = sum(pageg)
  /ncass    = sum(cass)
  /nlgps    = sum(lgps).

aggregate outfile = 'tmp7.sav'
  /break    = total
  /nplgrade = sum(plgrade)
  /npageg   = sum(pageg)
  /nprepeat = sum(prepeat)
  /ncass    = sum(cass)
  /nlgps    = sum(lgps).

get file = 'tmp1.sav'.

add files
  /file = *
  /file = 'tmp2.sav'
  /file = 'tmp3.sav'
  /file = 'tmp4.sav'
  /file = 'tmp5.sav'
  /file = 'tmp6.sav'
  /file = 'tmp7.sav'.

variable label
  nplgrade  "Number of children of primary graduation age in last primary grade"
  /npageg   "Number of children of primary school completion age"
  /nprepeat "Number of repeaters"
  /ncass    "Number of children in first secondary grade who were in primary last year"
  /nlgps    "Number of children who were in the last grade of primary school the previous year"
.

if (npageg > 0) npscr = (nplgrade/npageg)*100.
variable label npscr "Net primary school completion rate *".

if (nlgps > 0) trse = (ncass/nlgps)*100.
variable label trse "Transition rate to secondary education **".

tables
  /format = zero
  /observation = npscr npageg  trse nlgps
  /table = HL4 + HH7 + HH6 + melevel + wlthind5 + HC1B + total BY 
	  npscr + npageg + trse + nlgps
  /statistics
    mean(npscr (f5.1) '')
    sum(npageg (f5.0) '')
    mean(trse (f5.1) '')
    sum(nlgps (f5.0) '')
  /title
    "Table ED.6: Primary school completion and transition to secondary education"
		"Primary school completion rate and transition rate to secondary education, Country, year"
  /caption
    "* MICS Indicator 59; MDG Indicator 7b"
    "** MICS Indicator 58".
new file.

*delete working files.
erase file = 'tmp1.sav'.
erase file = 'tmp2.sav'.
erase file = 'tmp3.sav'.
erase file = 'tmp4.sav'.
erase file = 'tmp5.sav'.
erase file = 'tmp6.sav'.
erase file = 'tmp7.sav'.
