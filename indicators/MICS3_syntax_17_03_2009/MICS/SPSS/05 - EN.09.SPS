get file = 'hh.sav'.

select if (HH9 = 1).

* select those in urban area; add capital city if it is not all urban.
select if (HH6 = 1).

weight by hhweight.

compute total = 1.
value label total 1 "".
variable label total "Number of housholds".

recode HC3 (11 thru 16 = 100) (else = 0) into fnatur.
variable label fnatur "Dwelling has natural floor material".

compute poora = 0.
if (HC15IA = "A") poora = 100.
compute poorb = 0.
if (HC15IB = "B") poorb = 100.
compute poorc = 0.
if (HC15IC = "C") poorc = 100.
compute poord = 0.
if (HC15ID = "D") poord = 100.
compute poore = 0.
if (HC15IE = "E") poore = 100.
compute poorf  = 0.
if (HC15IF = "F") poorf = 100.

count poor = poora poorb poorc poord poore poorf  (100).

compute tworep = 0.
if (poor >= 2) tworep = 100.
variable label tworep "Dwelling is in poor condition".

compute narrow  = 0.
if (HC15JA = "A" and HC15JB = "B") narrow  = 100.
variable label narrow "Dwelling is vulnerable to accidents".

compute hazarda = 0.
if (HC15HA = "A") hazarda = 100.
compute hazardb = 0.
if (HC15HB = "B") hazardb = 100.
compute hazardc = 0.
if (HC15HC = "C") hazardc = 100.
compute hazardd = 0.
if (HC15HD = "D") hazardd = 100.
compute hazarde = 0.
if (HC15HE = "E") hazarde = 100.
compute hazardf  = 0.
if (HC15HF = "F") hazardf = 100.
compute hazardg = 0.
if (HC15HG = "G") hazardg = 100.
compute hazardh = 0.
if (HC15HH = "H") hazardh = 100.
compute hazardi = 0.
if (HC15HI = "I") hazardi = 100.

count hazard = hazarda hazardb hazardc hazardd hazarde hazardf hazardg hazardh 
  hazardi (100).

compute fourhaz = 0.
if (hazard >= 4) fourhaz = 100.
variable label fourhaz "Dwelling located in hazardous location".

compute ndurab = 0.
if ((fnatur = 100 and  tworep  = 100) or narrow = 100 or fourhaz = 100) 
  ndurab = 100.
variable label ndurab "Percent of households living in dwelling considered non-durable".

do if (ndurab = 100).
+ compute totals = 1.
+ compute pop = hh11.
end if.
variable label totals "Number of households considered non-durable".
variable label pop "Number of household members living in non-durable dwelling".

aggregate outfile = 'tmp1.sav'
  /break    = helevel
  /fnatural = means(fnatur)
  /spoor    = means(tworep)
  /snarrow  = means(narrow)
  /sfourhaz = means(fourhaz)
  /ndurable = means(ndurab)
  /spop     = sum(pop)
  /shh11    = sum(hh11)
  /stotal   = sum(total).

aggregate outfile = 'tmp2.sav'
  /break    = wlthind5
  /fnatural = means(fnatur)
  /spoor    = means(tworep)
  /snarrow  = means(narrow)
  /sfourhaz = means(fourhaz)
  /ndurable = means(ndurab)
  /spop     = sum(pop)
  /shh11    = sum(hh11)
  /stotal   = sum(total).

aggregate outfile = 'tmp3.sav'
  /break    = HC1B
  /fnatural = means(fnatur)
  /spoor    = means(tworep)
  /snarrow  = means(narrow)
  /sfourhaz = means(fourhaz)
  /ndurable = means(ndurab)
  /spop     = sum(pop)
  /shh11    = sum(hh11)
  /stotal   = sum(total).

aggregate outfile = 'tmp6.sav'
  /break    = total
  /fnatural = means(fnatur)
  /spoor    = means(tworep)
  /snarrow  = means(narrow)
  /sfourhaz = means(fourhaz)
  /ndurable = means(ndurab)
  /spop     = sum(pop)
  /shh11    = sum(hh11)
  /stotal   = sum(total).

get file = 'tmp1.sav'.

add files
  /file = *
  /file = 'tmp2.sav'
  /file = 'tmp3.sav'
  /file = 'tmp6.sav'.

variable label fnatural "Dwelling has natural floor material".
variable label spoor "Dwelling is in poor condition".
variable label snarrow "Dwelling is vulnerable to accidents".
variable label sfourhaz "Dwelling located in hazardous location".
variable label ndurable  "Percent of households living in dwellings considered non durable *".
variable label spop "Number of household members living in dwellings considered non durable".
variable label shh11 "Number of household members".
variable label stotal "Number of households".

compute percent = (spop/shh11)*100.
variable label percent "Percent of household members living in dwelling considered non-durable".

tables
  /format = zero
  /observation = fnatural spoor snarrow sfourhaz ndurable stotal percent shh11
  /ftotal = tot1 "Total"
  /table = helevel + wlthind5 + HC1B + total by 
	  fnatural + spoor + snarrow + sfourhaz + ndurable + stotal + percent + shh11
  /statistics
    mean(fnatural (f5.1) '')
    mean(spoor (f5.1) '')
    mean(snarrow (f5.1) '')
    mean(sfourhaz (f5.1) '')
    mean(ndurable (f5.1) '')
    sum(stotal (f5.0) '')
    mean(percent (f5.1) '')
    sum(shh11 (f5.0) '')
  /title
    "Table EN.9: Durability of housing"
		"Percentage of households and household members living in dwellings in "+
		"urban areas (or capital city) that are not considered durable "+
    "by background characteristics, Country, Year"
  /caption
    "* MICS Indicator 94".

new file.
erase file = 'tmp1.sav'.
erase file = 'tmp2.sav'.
erase file = 'tmp3.sav'.
erase file = 'tmp6.sav'.