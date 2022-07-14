*create a weights file for each unit of analysis.
get file = 'weights.sav'.

format hhweight wmweight chweight (f9.6).
variable label hhweight "Household sample weight".
variable label wmweight "Women's sample weight".
variable label chweight "Children's sample weight".

sort cases by HH1.

save outfile = 'hhwgt.sav'
  /keep HH1 HHWEIGHT.

save outfile = 'hlwgt.sav'
  /keep HH1 HHWEIGHT.

save outfile = 'wmwgt.sav'
  /keep HH1 WMWEIGHT.

save outfile = 'chwgt.sav'
  /keep HH1 CHWEIGHT.

*add household weights to the household file.
get file = 'hh.sav'.

delete var hhweight.

sort cases by HH1.

match files
  /file = *
  /table = 'hhwgt.sav'
  /by HH1.

if (HH9 <> 1) HHWEIGHT = 0.

save outfile = 'hh.sav'.

*add household weights to the household listing file.
get file = 'hl.sav'.

delete var hhweight.

sort cases by HH1.

match files
  /file = *
  /table = 'hlwgt.sav'
  /by HH1.

save outfile = 'hl.sav'.

*add women's weights to the women file.
get file = 'wm.sav'.

delete var wmweight.

sort cases by HH1.

match files
  /file = *
  /table = 'wmwgt.sav'
  /by HH1.

if (WM7 <> 1) WMWEIGHT = 0.

save outfile = 'wm.sav'.

*add children's weights to the children file.
get file = 'ch.sav'.

delete var chweight.

sort cases by HH1.

match files
  /file = *
  /table = 'chwgt.sav'
  /by HH1.

if (UF9 <> 1) CHWEIGHT = 0.

save outfile = 'ch.sav'.

*delete working files.
new file.
erase file = 'hhwgt.sav'.
erase file = 'hlwgt.sav'.
erase file = 'wmwgt.sav'.
erase file = 'chwgt.sav'.
