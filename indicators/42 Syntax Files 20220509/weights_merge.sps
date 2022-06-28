* Encoding: windows-1252.
*                      Import data weights from excel: weights.xls.
cd "C:\MICS6\SPSS".

get data 
   /type=xlsx
   /file="weights.xlsx"
   /sheet=name "Output_Standard"
   /cellrange=full
   /readnames=on.

formats hhweight wmweight chweight fshweight mnweight wqhweight wqsweight (f9.6).
variable labels 
  hhweight     "Household sample weight"
  wmweight    "Woman's sample weight"
  chweight     "Children under 5's sample weight"
  fshweight    "Children 5-17's household sample weight"
  mnweight     "Men's sample weight"
  wqhweight    "Weight for household WQT"
  wqsweight    "Weight for source WQT".

sort cases by HH1.

save outfile = "hhwgt.sav"
  /keep HH1 hhweight.

save outfile = "wmwgt.sav"
  /keep HH1 wmweight
  /rename HH1=WM1.

save outfile = "chwgt.sav"
  /keep HH1 chweight
  /rename HH1=UF1.

save outfile = "fshwgt.sav"
  /keep HH1 fshweight
  /rename HH1=FS1.

save outfile = "mnwgt.sav"
  /keep HH1 mnweight
  /rename HH1=MWM1.

save outfile = "wqhwgt.sav"
  /keep HH1 wqhweight.

save outfile = "wqswgt.sav"
  /keep HH1 wqsweight.

*		Add household weights to the household file.
get file = "hh.sav".

delete variables hhweight wqhweight wqsweight.

sort cases by HH1 HH2.

match files
  /file = *
  /table = "hhwgt.sav"
  /table = "wqhwgt.sav"
  /table = "wqswgt.sav"
  /by HH1.

if (HH46 <> 1) hhweight = 0.
if (HH46 <> 1) wqhweight = 0.
if (HH46 <> 1) wqsweight = 0.

save outfile = "hh.sav".

*		Add household weights to the household listing file.
get file = "hl.sav".

delete variables hhweight.

sort cases by HH1 HH2 HL1.

match files
  /file = *
  /table = "hhwgt.sav"
  /by HH1.

save outfile = "hl.sav".

*		Add household weights to the ITN file.
get file = "tn.sav".

delete variables hhweight.

sort cases by HH1 HH2.

match files
  /file = *
  /table = "hhwgt.sav"
  /by HH1.

save outfile = "tn.sav".


*		Add women's weights to the women file.
get file = "wm.sav".

delete variables wmweight.

sort cases by WM1 WM2 WM3.

match files
  /file = *
  /table = "wmwgt.sav"
  /by WM1.

if (WM17 <> 1) wmweight = 0.

save outfile = "wm.sav".

*		Add women's weights to the BH file. 
get file = 'bh.sav'.

delete variables wmweight.

sort cases WM1 WM2 WM3 BH0.

match files
  /file = *
  /table = 'wmwgt.sav'
  /by WM1.

save outfile = 'bh.sav'.

*		Add women's weights to the FG file. 
get file = 'fg.sav'.

delete variables wmweight.

sort cases WM1 WM2 WM3 FGLN.

match files
  /file = *
  /table = 'wmwgt.sav'
  /by WM1.

save outfile = 'fg.sav'.

*		Add women's weights to the MM file. 
get file = 'mm.sav'.

delete variables wmweight.

sort cases WM1 WM2 WM3 MMLN.

match files
  /file = *
  /table = 'wmwgt.sav'
  /by WM1.

save outfile = 'mm.sav'.

*		Add children's weights to the children file.
get file = "ch.sav".

delete variables chweight.

sort cases by UF1 UF2 UF3.

match files
  /file = *
  /table = "chwgt.sav"
  /by UF1.

if (UF17 <> 1) chweight = 0.

save outfile = "ch.sav".

*		Add children 5-17's household weights to the children 5-17 file.
get file = "fs.sav".

delete variables fshweight.

sort cases by FS1 FS2 FS3.

match files
  /file = *
  /table = "fshwgt.sav"
  /by FS1.

compute fsweight = HH52 * fshweight.
formats fsweight (f9.6).
variable labels fsweight "Children 5-17's sample weight".

if (FS17 <> 1) fshweight = 0.
if (FS17 <> 1) fsweight = 0.

save outfile = "fs.sav".

*		Add men's weights to the men file.
get file = "mn.sav".

delete variables mnweight.

sort cases by MWM1 MWM2 MWM3.

match files
  /file = *
  /table = "mnwgt.sav"
  /by MWM1.

if (MWM17 <> 1) mnweight = 0.

save outfile = "mn.sav".

new file.

*		Delete working files.
erase file = "hhwgt.sav".
erase file = "wmwgt.sav".
erase file = "chwgt.sav".
erase file = "fshwgt.sav".
erase file = "mnwgt.sav".
erase file = "wqhwgt.sav".
erase file = "wqswgt.sav".






