* APPEND WEALTH INDEX VARIABLES TO DATA FILES.

* Create wealth data file.
weight off.

delete variables wscore windex5 wscoreu windex5u wscorer windex5r.

sort cases by hh1 hh2.

rename variables (com1 = wscore) (ncom1 = windex5) (urb1 = wscoreu) (nurb1 = windex5u) (rur1 = wscorer) (nrur1 = windex5r).

save outfile="wealth.sav"
 /keep HH1 HH2 wscore windex5 wscoreu windex5u wscorer windex5r.



* Append wealth index values to data files.

*	hh.sav.
get file = 'hh.sav'.
delete variables wscore windex5 wscoreu windex5u wscorer windex5r.
sort cases by HH1 HH2.
match files
  /file = *
  /table = 'wealth.sav'
  /by HH1 HH2.
do if (hh9 <> 1).
recode wscore windex5 wscoreu windex5u wscorer windex5r (lo thru hi, sysmis, 0 = 0).
end if.
execute.
save outfile = 'hh.sav'.

*	hl.sav.
get file = 'hl.sav'.
delete variables wscore windex5 wscoreu windex5u wscorer windex5r.
sort cases by HH1 HH2.
match files
  /file = *
  /table = 'wealth.sav'
  /by HH1 HH2.
save outfile = 'hl.sav'.


*	wm.sav.
get file = 'wm.sav'.
delete variables wscore windex5 wscoreu windex5u wscorer windex5r.
sort cases by HH1 HH2.
match files
  /file = *
  /table = 'wealth.sav'
  /by HH1 HH2.
do if (wm7 <> 1).
recode wscore windex5 wscoreu windex5u wscorer windex5r (lo thru hi, sysmis, 0 = 0).
end if.
execute.
save outfile = 'wm.sav'.


*	ch.sav.
get file = 'ch.sav'.
delete variables wscore windex5 wscoreu windex5u wscorer windex5r.
sort cases by HH1 HH2.
match files
  /file = *
  /table = 'wealth.sav'
  /by HH1 HH2.
do if (uf9 <> 1).
recode wscore windex5 wscoreu windex5u wscorer windex5r (lo thru hi, sysmis, 0 = 0).
end if.
execute.
save outfile = 'ch.sav'.


*	tn.sav.
get file = 'tn.sav'.
delete variables wscore windex5 wscoreu windex5u wscorer windex5r.
sort cases by HH1 HH2.
match files
  /file = *
  /table = 'wealth.sav'
  /by HH1 HH2.
save outfile = 'tn.sav'.


*	fg.sav.
get file = 'fg.sav'.
delete variables wscore windex5 wscoreu windex5u wscorer windex5r.
sort cases by HH1 HH2.
match files
  /file = *
  /table = 'wealth.sav'
  /by HH1 HH2.
save outfile = 'fg.sav'.


*	mm.sav.
get file = 'mm.sav'.
delete variables wscore windex5 wscoreu windex5u wscorer windex5r.
sort cases by HH1 HH2.
match files
  /file = *
  /table = 'wealth.sav'
  /by HH1 HH2.
save outfile = 'mm.sav'.


*	bh.sav.
get file = 'bh.sav'.
delete variables wscore windex5 wscoreu windex5u wscorer windex5r.
sort cases by HH1 HH2.
match files
  /file = *
  /table = 'wealth.sav'
  /by HH1 HH2.
save outfile = 'bh.sav'.


*	mn.sav.
get file = 'mn.sav'.
delete variables wscore windex5 wscoreu windex5u wscorer windex5r.
sort cases by HH1 HH2.
match files
  /file = *
  /table = 'wealth.sav'
  /by HH1 HH2.
do if (mwm7 <> 1).
recode wscore windex5 wscoreu windex5u wscorer windex5r (lo thru hi, sysmis, 0 = 0).
end if.
execute.
save outfile = 'mn.sav'.


new file.
