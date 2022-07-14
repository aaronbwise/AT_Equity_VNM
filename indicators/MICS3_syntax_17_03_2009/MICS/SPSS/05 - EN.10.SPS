get file = 'hh.sav'.

select if (hh9 = 1).

* select those in urban area; add capital city if it is not all urban.
select if (HH6 = 1).

weight by hhweight.

compute total = 1.
value label total 1 "".
variable label total "Number of housholds".

recode HC3 (11 thru 16 = 100) (else = 0) into fnatural.
variable label fnatural "Dwelling has natural floor material".

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
compute hazardf = 0.
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
if ((fnatural = 100 and  tworep  = 100) or narrow = 100 or fourhaz = 100) 
  ndurab = 100.
variable label ndurab "Percent of households living in dwelling considered non-durable".

compute formal  = 100.
if (HC15B = 1 or HC15CA = 'A' or HC15CB = 'B' or HC15D = 1) formal = 0.
variable label formal "Household does not have formal documentation for the residence".

recode HC15F (2 = 100) (else = 0) into eviction.
variable label eviction "Respondent feels there is a risk of eviction".

compute lsecur = 0.
if (formal = 100 or eviction = 100) lsecur = 100.
variable label lsecur "Lack of security of tenure".

compute npersr = trunc(HH11/HC2).
variable label npersr "Number of persons per sleeping  room".

compute over3 = 0.
if (npersr >= 4) over3 = 100.
variable label over3 "Over-crowding: more than three persons per sleeping room".

compute limprov = 100.
if (WS1 = 11 or  WS1 = 12 or WS1 = 13 or WS1 = 21 or WS1 = 31 or WS1 = 41 or 
  WS1 = 51) limprov = 0.
if ((WS2 = 11 or WS2 = 12 or WS2 = 13 or WS2 = 21 or WS2 = 31 or WS2 = 41 or 
  WS2 = 51) and WS1 = 91) limprov = 0. 
variable label limprov "Lack of use of improved water source".

recode WS7 (11,12,13,21,22,31 = 0) (else = 100) into lsanit.
variable label lsanit "Lack of use of improved sanitation".

compute nhslum = 0.
if (ndurab = 100 or lsecur = 100 or over3 = 100 or limprov = 100 or lsanit = 100) nhslum = 100.
variable label nhslum "Percent of households considered to be living in slum housing".

if (nhslum = 100) totals = 1.
variable label totals "Number of households living in slum housing".

compute pop = 0.
if (nhslum = 100) pop = HH11.
variable label pop "Number of household members considered to be living in slum housing".

aggregate outfile = 'tmp1.sav'
  /break    = helevel
  /ndurable = means(ndurab)
  /lsecure  = means(lsecur)
  /over3p   = means(over3)
  /limprove = means(limprov)
  /lsanitat = means(lsanit)
  /hslum    = means(nhslum)
  /stotal   = sum(total)
  /spop     = sum(pop)
  /shh11    = sum(hh11).

aggregate outfile = 'tmp2.sav'
  /break    = wlthind5
  /ndurable = means(ndurab)
  /lsecure  = means(lsecur)
  /over3p   = means(over3)
  /limprove = means(limprov)
  /lsanitat = means(lsanit)
  /hslum    = means(nhslum)
  /stotal   = sum(total)
  /spop     = sum(pop)
  /shh11    = sum(hh11).

aggregate outfile = 'tmp3.sav'
  /break    = HC1B
  /ndurable = means(ndurab)
  /lsecure  = means(lsecur)
  /over3p   = means(over3)
  /limprove = means(limprov)
  /lsanitat = means(lsanit)
  /hslum    = means(nhslum)
  /stotal   = sum(total)
  /spop     = sum(pop)
  /shh11    = sum(hh11).

aggregate outfile = 'tmp6.sav'
  /break    = total
  /ndurable = means(ndurab)
  /lsecure  = means(lsecur)
  /over3p   = means(over3)
  /limprove = means(limprov)
  /lsanitat = means(lsanit)
  /hslum    = means(nhslum)
  /stotal   = sum(total)
  /spop     = sum(pop)
  /shh11    = sum(hh11).

get file = 'tmp1.sav'.

add files
  /file = *
  /file = 'tmp2.sav'
  /file = 'tmp3.sav'
  /file = 'tmp6.sav'.

variable label ndurable  "Dwelling considered non durable".
variable label lsecure "Lack of security of tenure".
variable label over3p "Over crowding more than three persons per sleeping room".
variable label limprove "Lack of use of improved water source".
variable label lsanitat "Lack of use of improved sanitation".
variable label hslum "Percent of households considered to be living in slum housing *".
variable label stotal "Number of households".
variable label spop "Number of household members living in dwelling considered non-durable".
variable label shh11 "Number of household members".

compute percent = (spop/shh11)*100.
variable label percent "Percent of households members considered to be living in slum housing".

tables
  /format = zero
  /observation = ndurable lsecure over3p limprove lsanitat hslum stotal percent
	  shh11
  /ftotal = tot1 "Total" 
  /table =  helevel + wlthind5 + HC1B + total by 
	  ndurable + lsecure + over3p + limprove + lsanitat + hslum + stotal + 
		percent + shh11
  /statistics
    mean(ndurable (f5.1) '')
    mean(lsecure (f5.1) '')
    mean(over3p (f5.1) '')
    mean(limprove (f5.1) '')
    mean(lsanitat (f5.1) '')
    mean(hslum (f5.1) '')
    sum(stotal (f5.0) '')
    mean(percent (f5.1) '')
    sum(shh11 (f5.0) '')
  /title
    "Table EN.10: Slum housing"
		"Percentage of households and household members in urban areas (or capital city) "+
                        "that are considered as living in slum housing,  by background characterictics, Country, Year"
  /caption
    "*MICS Indicator 95; MDG Indicator 32".

new file.
erase file = 'tmp1.sav'.
erase file = 'tmp2.sav'.
erase file = 'tmp3.sav'.
erase file = 'tmp6.sav'.