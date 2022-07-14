*define a MACRO that merges 2 files.
define !merge (file1 = !tokens(1)
              /file2 = !tokens(1)
              /mvars = !tokens(2)).
get file = !file1.
sort cases by !mvars.
save outfile = 'tmp.sav'.
get file = !file2.
sort cases by !mvars.
match files
  /file = *
  /table = 'tmp.sav'
  /by !mvars.
save outfile = !file2.
get file = !file2.
erase file = 'tmp.sav'.
!enddefine.

*add variables from the household file.
!merge file1=hh.sav file2=hl.sav mvars=HI1 HI2.

recode HL4 (0 thru 70 = copy) (71 thru 96 = 70) (97,99 = 99) into memage.
variable labels memage "Age".
value labels memage
  70  "70+"
  99  "Missing/DK".
format memage(f5.0).

save outfile = 'hl.sav'.

*erase file = 'tmp.sav'.
