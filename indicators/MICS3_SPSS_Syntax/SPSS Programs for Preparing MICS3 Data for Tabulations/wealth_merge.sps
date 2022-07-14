*create a wealth index file for each unit of analysis.
get file = 'wealth.sav'.

sort cases by HH1 HH2.

save outfile = 'hhwlth.sav'
  /keep HH1 HH2 wlthscor wlthind5.

*add wealth index to the household file.
get file = 'hh.sav'.

delete var wlthind5 wlthscor.

sort cases by HH1 HH2.

match files
  /file = *
  /table = 'hhwlth.sav'
  /by HH1 HH2.

*set wealth index for incomplete households equal to 0.
if (HH9 <> 1) wlthind5 = 0.
if (HH9 <> 1) wlthscor = 0.

save outfile = 'hh.sav'.

*add wealth index to the household listing file.
get file = 'hl.sav'.

delete var wlthind5 wlthscor.

sort cases by HH1 HH2.

match files
  /file = *
  /table = 'hhwlth.sav'
  /by HH1 HH2.

save outfile = 'hl.sav'.

*add wealth index to the women file.
get file = 'wm.sav'.

delete var wlthind5 wlthscor.

sort cases by HH1 HH2.

match files
  /file = *
  /table = 'hhwlth.sav'
  /by HH1 HH2.

*set wealth index for incomplete womens interviews equal to 0.
if (WM7 <> 1) wlthind5 = 0.
if (WM7 <> 1) wlthscor = 0.
save outfile = 'wm.sav'.

*add wealth index to the children file.
get file = 'ch.sav'.

delete var wlthind5 wlthscor.

sort cases by HH1 HH2.

match files
  /file = *
  /table = 'hhwlth.sav'
  /by HH1 HH2.

*set wealth index for incomplete child interviews equal to 0.
if (UF9 <> 1) wlthind5 = 0.
if (UF9 <> 1) wlthscor = 0.

save outfile = 'ch.sav'.

*delete working files.
new file.
erase file = 'hhwlth.sav'.

