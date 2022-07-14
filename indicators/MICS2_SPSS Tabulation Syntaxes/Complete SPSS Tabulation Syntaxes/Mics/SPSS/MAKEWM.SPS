*define a MACRO that merges 2 files with 3 ID variables.
define !merge (file1 = !tokens(1)
               /mvar1 = !tokens(1)
               /mvar2 = !tokens(1)
               /mvar3 = !tokens(1)
               /file2 = !tokens(1)
               /name1 = !tokens(1)
               /name2 = !tokens(1)
               /name3 = !tokens(1)).
get file = !file1.
sort cases by !mvar1 !mvar2 !mvar3.
save outfile = 'tmp.sav'
  /rename = (!mvar1 = !name1) (!mvar2 = !name2) (!mvar3 = !name3).
get file = !file2.
sort cases by !name1 !name2 !name3.
match files
  /file = *
  /table = 'tmp.sav'
  /by !name1 !name2 !name3.
save outfile = !file2.
get file = !file2.
erase file = 'tmp.sav'.
!enddefine.

*add variables from the household listing file.
!merge file1=hl.sav mvar1=HI1 mvar2=HI2 mvar3=HL1 file2=wm.sav name1=WICLNO name2=WIHHNO name3=WILNNO.

save outfile = 'wmtmp.sav'.

get file = 'wmtmp.sav'.

*5-year age group.
compute cmcdoi = (HI3Y - 1900)*12 + HI3M.
variable label cmcdoi "Date of interview (CMC)".

*set random number seed.
set seed = 1003.

do if (WI3AY < 9996 and WI3AM < 96).
  compute wdob = (WI3AY - 1900)*12 + WI3AM.
  compute wage = trunc(((cmcdoi - wdob)/12)/5) - 2.
else if (WI3AY < 9996).
  compute wdob = (WI3AY - 1900)*12 + trunc(rv.uniform(1.00,12.99)).
  compute wage = trunc(((cmcdoi - wdob)/12)/5) - 2.
  if (wage = 0) wage = 1.
  if (wage = 8) wage = 7.
else.
  compute wdob = 9999.
  compute wage = trunc(WI3B/5) - 2.
end if.
variable label wage "Age".
value label wage
  1 "15-19"
  2 "20-24"
  3 "25-29"
  4 "30-34"
  5 "35-39"
  6 "40-44"
  7 "45-49".
variable label wdob "Date of birth (CMC)".
missing values wdob (9999).

*marital status.
recode CU1 (1 = 1) (2 = 2) (3 = 3) into mstatus.
variable label mstatus "Marital status".
value label mstatus
  1 "Currently married"
  2 "Formerly married"
  3 "Never married".

*total children ever born.
do if (CM1 = 1).
  compute ceb = CM9.
else.
  compute ceb = 0.
end if.
variable label ceb "Children ever born".

*number of dead children.
do if (CM7 = 1).
  compute deadkids = CM8A + CM8B.
else.
  compute deadkids = 0.
end if.
variable label deadkids "Dead children".

*heard of aids.
recode HA1 (1 = 100) (else = 0) into aids.
variable label aids "Heard of AIDS".

*save the women's file.
save outfile = 'wm.sav'
  /drop = CL2 CL3 CL4 CL5 CL6 CL7 CL8 CL9.

get file = 'wm.sav'.

erase file = 'wmtmp.sav'.
