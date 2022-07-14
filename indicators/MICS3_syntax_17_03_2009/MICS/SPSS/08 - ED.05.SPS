get file 'hl.sav'.

weight by hhweight.

compute total = 1.
variable label total "Total".
value label total 1 "".

compute z10t = 0.
compute z12t = 0.
if (ED8A = 1 and ED8B = 1 and ED4 <> 1) z10t = 1.
if (ED8A = 1 and ED8B = 1 and ED6A = 1 and ED6B = 2) z12t = 1.
variable label z10t "Number in 1st grade last year who are not in school this year".
variable label z12t "Number in 1st grade last year who are in 2nd grade this year".

compute z20t = 0.
compute z23t = 0.
if (ED8A = 1 and ED8B = 2 and ED4 <> 1) z20t = 1.
if (ED8A = 1 and ED8B = 2 and ED6A = 1 and ED6B = 3) z23t = 1.
variable label z20t "Number in 2nd grade last year who are not in school this year".
variable label z23t "Number in 2nd grade last year who are in 3rd grade this year".

compute z30t = 0.
compute z34t = 0.
if (ED8A = 1 and ED8B = 3 and ED4 <> 1) z30t = 1.
if (ED8A = 1 and ED8B = 3 and ED6A = 1 and ED6B = 4) z34t = 1.
variable label z30t "Number in 3rd grade last year who are not in school this year".
variable label z34t "Number in 3rd grade last year who are in 4th grade this year".

compute z40t = 0.
compute z45t = 0.
if (ED8A = 1 and ED8B = 4 and ED4 <> 1) z40t = 1.
if (ED8A = 1 and ED8B = 4 and ED6A = 1 and ED6B = 5) z45t = 1.
variable label z40t "Number in 4th grade last year who are not in school this year".
variable label z45t "Number in 4th grade last year who are in 5th grade this year".

aggregate outfile = 'tmp1.sav'
  /break = HL4
  /z10   = sum(z10t)
  /z12   = sum(z12t)
  /z20   = sum(z20t)
  /z23   = sum(z23t)
  /z30   = sum(z30t)
  /z34   = sum(z34t)
  /z40   = sum(z40t)
  /z45   = sum(z45t).

aggregate outfile = 'tmp2.sav'
  /break = HH7
  /z10   = sum(z10t)
  /z12   = sum(z12t)
  /z20   = sum(z20t)
  /z23   = sum(z23t)
  /z30   = sum(z30t)
  /z34   = sum(z34t)
  /z40   = sum(z40t)
  /z45   = sum(z45t).

aggregate outfile = 'tmp3.sav'
  /break = HH6
  /z10   = sum(z10t)
  /z12   = sum(z12t)
  /z20   = sum(z20t)
  /z23   = sum(z23t)
  /z30   = sum(z30t)
  /z34   = sum(z34t)
  /z40   = sum(z40t)
  /z45   = sum(z45t).

aggregate outfile = 'tmp4.sav'
  /break = melevel
  /z10   = sum(z10t)
  /z12   = sum(z12t)
  /z20   = sum(z20t)
  /z23   = sum(z23t)
  /z30   = sum(z30t)
  /z34   = sum(z34t)
  /z40   = sum(z40t)
  /z45   = sum(z45t).

aggregate outfile = 'tmp5.sav'
  /break = wlthind5
  /z10   = sum(z10t)
  /z12   = sum(z12t)
  /z20   = sum(z20t)
  /z23   = sum(z23t)
  /z30   = sum(z30t)
  /z34   = sum(z34t)
  /z40   = sum(z40t)
  /z45   = sum(z45t).

aggregate outfile = 'tmp6.sav'
  /break = HC1B
  /z10   = sum(z10t)
  /z12   = sum(z12t)
  /z20   = sum(z20t)
  /z23   = sum(z23t)
  /z30   = sum(z30t)
  /z34   = sum(z34t)
  /z40   = sum(z40t)
  /z45   = sum(z45t).

aggregate outfile = 'tmp7.sav'
  /break = total
  /z10   = sum(z10t)
  /z12   = sum(z12t)
  /z20   = sum(z20t)
  /z23   = sum(z23t)
  /z30   = sum(z30t)
  /z34   = sum(z34t)
  /z40   = sum(z40t)
  /z45   = sum(z45t).

get file = 'tmp1.sav'.

add files
  /file = *
  /file = 'tmp2.sav'
  /file = 'tmp3.sav'
  /file = 'tmp4.sav'
  /file = 'tmp5.sav'
  /file = 'tmp6.sav'
  /file = 'tmp7.sav'.

if (z12+z10 > 0) y1 = (z12/(z12+z10))*100.
if (z23+z20 > 0) y2 = (z23/(z23+z20))*100.
if (z34+z30 > 0) y3 = (z34/(z34+z30))*100.
if (z45+z40 > 0) y4 = (z45/(z45+z40))*100.
compute y5 = (y1*y2*y3*y4)/1000000.

variable label y1 "Percent attending 2nd grade who were in 1st grade last year".
variable label y2 "Percent attending 3rd grade who were in 2nd grade last year".
variable label y3 "Percent attending 4th grade who were in 3rd grade last year".
variable label y4 "Percent attending 5th grade who were in 4th grade last year".
variable label y5 "Percent who reach grade 5 of those who enter 1st grade *".
value label total 1 "".

tables
  /format = zero
  /observation = y1 y2 y3 y4 y5
  /table = HL4 + HH7 + HH6 + melevel + wlthind5 + HC1B + total by 
	  y1 + y2 + y3 + y4 + y5
  /statistics
    mean(y1 (f5.1) '')
    mean(y2 (f5.1) '')
    mean(y3 (f5.1) '')
    mean(y4 (f5.1) '')
    mean(y5 (f5.1) '')
  /title
    "Table ED.5: Children reaching grade 5"
		"Percentage of children entering first grade of primary school who "+
		"eventually reach grade 5, Country, Year"
  /caption
    "* MICS Indicator 57 ; MDG Indicator 7".

new file.

erase file = 'tmp1.sav'.
erase file = 'tmp2.sav'.
erase file = 'tmp3.sav'.
erase file = 'tmp4.sav'.
erase file = 'tmp5.sav'.
erase file = 'tmp6.sav'.
erase file = 'tmp7.sav'.
