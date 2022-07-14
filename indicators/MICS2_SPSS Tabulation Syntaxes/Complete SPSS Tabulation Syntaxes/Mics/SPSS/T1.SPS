*define a MACRO that merges 2 files.
define !agg (aggvar = !tokens(1)
            /file1 = !tokens(1)
            /file2 = !tokens(1)
            /file3 = !tokens(1)).
aggregate outfile = !file1
  /break = !aggvar
  /hhsamp = sum(sampled)
  /hhoccup = sum(occupied)
  /hhcomp = sum(complete).
aggregate outfile = !file2
  /break = !aggvar
  /women = sum(HI11)
  /cwomen = sum(HI12).
aggregate outfile = !file3
  /break = !aggvar
  /kids = sum(HI13)
  /ckids = sum(HI14).
!enddefine.

*define a MACRO that merges 2 files.
define !merge (file1 = !tokens(1)
              /file2 = !tokens(1)
              /mvars = !tokens(1)).
get file = !file1.
sort cases by !mvars.
save outfile = !file1.
get file = !file2.
sort cases by !mvars.
match files
  /file = *
  /table = !file1
  /by !mvars.
save outfile = !file2.
!enddefine.

get file = 'hh.sav'.

compute sampled = 1.

recode HI10 (1,2,3 = 1) (else = 0) into occupied.

recode HI10 (1 = 1) (else = 0) into complete.

compute total = 1.
variable labels total "Total".
value labels total 1 "".

!agg aggvar=HI6 file1=tmp1.sav file2=tmp2.sav file3=tmp3.sav.

!agg aggvar=total file1=tmp4.sav file2=tmp5.sav file3=tmp6.sav.

!merge file1=tmp1.sav file2=tmp2.sav mvars=HI6.
!merge file1=tmp2.sav file2=tmp3.sav mvars=HI6.

!merge file1=tmp4.sav file2=tmp5.sav mvars=total.
!merge file1=tmp5.sav file2=tmp6.sav mvars=total.

get file = 'tmp3.sav'.

add files
  /file=*
  /file='tmp6.sav'.

variable labels
  hhsamp    "Sampled households"
  /hhoccup  "Occupied households"
  /hhcomp   "Completed households"
  /women    "Eligible women"
  /cwomen   "Interviewed women"
  /kids     "Children under 5"
  /ckids    "Interviewed children under 5"
.

compute hhrr = (hhcomp/hhoccup)*100.
variable labels hhrr "Household response rate".

compute wmrr = (cwomen/women)*100.
variable labels wmrr "Women response rate".

compute chrr = (ckids/kids)*100.
variable labels chrr "Child response rate".

tables
  /observation = hhsamp hhoccup hhcomp hhrr women cwomen wmrr kids ckids chrr
  /table = hhsamp + hhoccup + hhcomp + hhrr + women + cwomen + wmrr + kids +
           ckids + chrr  BY HI6 + total
  /statistics
    maximum(hhsamp '' (f7.0))
    maximum(hhoccup '' (f7.0))
    maximum(hhcomp '' (f7.0))
    maximum(hhrr '' (f7.1))
    maximum(women '' (f7.0))
    maximum(cwomen'' (f7.0))
    maximum(wmrr '' (f7.1))
    maximum(kids '' (f7.0))
    maximum(ckids '' (f7.0))
    maximum(chrr '' (f7.1))
  /title
    "Table 1: Number of households and women, and response rates, Country, Year".

new file.

*delete working files.
erase file = 'tmp1.sav'.
erase file = 'tmp2.sav'.
erase file = 'tmp3.sav'.
erase file = 'tmp4.sav'.
erase file = 'tmp5.sav'.
erase file = 'tmp6.sav'.
