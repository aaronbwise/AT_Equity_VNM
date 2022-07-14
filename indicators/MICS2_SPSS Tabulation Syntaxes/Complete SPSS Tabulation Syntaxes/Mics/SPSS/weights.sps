*define a MACRO that merges 2 files with 2 ID variables.
define !merge (file1 = !tokens(1)
               /file2 = !tokens(1)
               /mvar1 = !tokens(1)
               /mvar2 = !tokens(1)).
get file = !file1.
sort cases by !mvar1 !mvar2.
save outfile = 'tmp.sav'.
get file = !file2.
sort cases by !mvar1 !mvar2.
match files
  /file = *
  /table = 'tmp.sav'
  /by !mvar1 !mvar2.
save outfile = !file2.
get file = !file2.
erase file = 'tmp.sav'.
!enddefine.

get file = 'weights.sav'.

save outfile = 'hhwgt.sav'
  /keep HI6 HI7 HHWEIGHT.

save outfile = 'hlwgt.sav'
  /keep HI6 HI7 HHWEIGHT.

save outfile = 'wmwgt.sav'
  /keep HI6 HI7 WMWEIGHT.

save outfile = 'chwgt.sav'
  /keep HI6 HI7 CHWEIGHT.

*add household weights to the household file.
!merge file1=hhwgt.sav file2=hh.sav mvar1=HI6 mvar2=HI7.

*add household weights to the household listing file.
!merge file1=hlwgt.sav file2=hl.sav mvar1=HI6 mvar2=HI7.

*add women's weights to the women file.
!merge file1=wmwgt.sav file2=wm.sav mvar1=HI6 mvar2=HI7.

*add children's weights to the children file.
!merge file1=chwgt.sav file2=ch.sav mvar1=HI6 mvar2=HI7.

get file = 'hh.sav'.

if (HI10 <> 1) HHWEIGHT = 0.

save outfile = 'hh.sav'.

erase file = 'hhwgt.sav'.
erase file = 'hlwgt.sav'.
erase file = 'wmwgt.sav'.
erase file = 'chwgt.sav'.
