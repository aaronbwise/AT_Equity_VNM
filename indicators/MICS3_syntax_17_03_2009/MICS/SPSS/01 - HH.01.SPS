get file = 'hh.sav'.

compute sampled = 1.

recode HH9 (1,2,3,6 = 1) (else = 0) into occupied.

recode HH9 (1 = 1) (else = 0) into complete.

compute total = 1.
variable label total "Total".
value label total 1 "".

aggregate outfile = 'tmp1.sav'
  /break   = HH6
  /hhsamp  = sum(sampled)
  /hhoccup = sum(occupied)
  /hhcomp  = sum(complete)
  /women   = sum(HH12)
  /cwomen  = sum(HH13)
  /kids    = sum(HH14)
  /ckids   = sum(HH15).

aggregate outfile = 'tmp2.sav'
  /break   = HH7
  /hhsamp  = sum(sampled)
  /hhoccup = sum(occupied)
  /hhcomp  = sum(complete)
  /women   = sum(HH12)
  /cwomen  = sum(HH13)
  /kids    = sum(HH14)
  /ckids   = sum(HH15).

aggregate outfile = 'tmp3.sav'
  /break   = total
  /hhsamp  = sum(sampled)
  /hhoccup = sum(occupied)
  /hhcomp  = sum(complete)
  /women   = sum(HH12)
  /cwomen  = sum(HH13)
  /kids    = sum(HH14)
  /ckids   = sum(HH15).

get file = 'tmp1.sav'.

add files
  /file = *
  /file = 'tmp2.sav'
  /file = 'tmp3.sav'.

variable label
  hhsamp   "Sampled households"
  /hhoccup "Occupied households"
  /hhcomp  "Interviewed households"
  /women   "Eligible women"
  /cwomen  "Interviewed women"
  /kids    "Eligible children under 5"
  /ckids   "Mother/Caretaker Interviewed "
.

compute hhrr = (hhcomp/hhoccup)*100.
variable label hhrr "Household response rate".

compute wmrr = (cwomen/women)*100.
variable label wmrr "Women response rate".

compute orw = (hhrr*wmrr)/100.
variable label orw "Women's overall response rate".

compute chrr = (ckids/kids)*100.
variable label chrr "Child response rate".

compute orc = (hhrr*chrr)/100.
variable label orc "Children's overall response rate".

tables
  /format = zero
  /observation = hhsamp hhoccup hhcomp hhrr women cwomen wmrr orw kids ckids 
	  chrr orc
  /table = hhsamp + hhoccup + hhcomp + hhrr + women + cwomen + wmrr + orw + 
	  kids + ckids + chrr + orc BY HH6 + HH7 + total
  /statistics
    maximum(hhsamp '' (f7.0))
    maximum(hhoccup '' (f7.0))
    maximum(hhcomp '' (f7.0))
    maximum(hhrr '' (f7.1))
    maximum(women '' (f7.0))
    maximum(cwomen'' (f7.0))
    maximum(wmrr '' (f7.1))
    maximum(orw '' (f7.1))
    maximum(kids '' (f7.0))
    maximum(ckids '' (f7.0))
    maximum(chrr '' (f7.1))
    maximum(orc '' (f7.1))
  /title
    "Table HH.1: Results of household and individual interviews" 
		"Numbers of households, women and children under 5 by results of the "+
		"household, women's and under-five's interviews, and household, women's "+
		"and under-five's response rates, Country, Year".

new file.

*delete working files.
erase file = 'tmp1.sav'.
erase file = 'tmp2.sav'.
erase file = 'tmp3.sav'.
