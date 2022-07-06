*                      Import data weights from excel: weights.xls.


get data 
   /type=xls
   /file='weights.xls'
   /sheet=name 'Output'
   /cellrange=full
   /readnames=on.

format hhweight wmweight chweight mnweight (f9.6).
variable labels hhweight "Household sample weight".
variable labels wmweight "Women's sample weight".
variable labels chweight "Children's sample weight".
variable labels mnweight "Men's sample weight".

sort cases by HH1.

save outfile = 'hhwgt.sav'
  /keep HH1 HHWEIGHT.

save outfile = 'wmwgt.sav'
  /keep HH1 WMWEIGHT.

save outfile = 'chwgt.sav'
  /keep HH1 CHWEIGHT.

save outfile = 'mnwgt.sav'
  /keep HH1 MNWEIGHT.

*		Add household weights to the household file.
get file = 'hh.sav'.

delete var hhweight.

sort cases by HH1.

match files
  /file = *
  /table = 'hhwgt.sav'
  /by HH1.

if (HH9 <> 1) HHWEIGHT = 0.

save outfile = 'hh.sav'.

*		Add household weights to the household listing file.
get file = 'hl.sav'.

delete var hhweight.

sort cases by HH1.

match files
  /file = *
  /table = 'hhwgt.sav'
  /by HH1.

save outfile = 'hl.sav'.

*		Add household weights to the TN file.
get file = 'tn.sav'.

delete var hhweight.

sort cases by HH1.

match files
  /file = *
  /table = 'hhwgt.sav'
  /by HH1.

save outfile = 'tn.sav'.

*		Add women's weights to the women file.
get file = 'wm.sav'.

delete var wmweight.

sort cases by HH1.

match files
  /file = *
  /table = 'wmwgt.sav'
  /by HH1.

if (WM7 <> 1) WMWEIGHT = 0.

save outfile = 'wm.sav'.

*		Add women's weights to the BH file. 
get file = 'bh.sav'.

delete var wmweight.

sort cases by HH1.

match files
  /file = *
  /table = 'wmwgt.sav'
  /by HH1.

save outfile = 'bh.sav'.

*		Add women's weights to the FG file. 
get file = 'fg.sav'.

delete var wmweight.

sort cases by HH1.

match files
  /file = *
  /table = 'wmwgt.sav'
  /by HH1.

save outfile = 'fg.sav'.

*		Add women's weights to the MM file. 
get file = 'mm.sav'.

delete var wmweight.

sort cases by HH1.

match files
  /file = *
  /table = 'wmwgt.sav'
  /by HH1.

save outfile = 'mm.sav'.


*		Add children's weights to the children file.
get file = 'ch.sav'.

delete var chweight.

sort cases by HH1.

match files
  /file = *
  /table = 'chwgt.sav'
  /by HH1.

if (UF9 <> 1) CHWEIGHT = 0.

save outfile = 'ch.sav'.


*		Add men weights to the men file.
get file = 'mn.sav'.

delete var mnweight.

sort cases by HH1.

match files
  /file = *
  /table = 'mnwgt.sav'
  /by HH1.

if (MWM7 <> 1) MNWEIGHT = 0.

save outfile = 'mn.sav'.


*		Delete working files.
new file.
erase file = 'hhwgt.sav'.
erase file = 'wmwgt.sav'.
erase file = 'chwgt.sav'.
erase file = 'mnwgt.sav'.
