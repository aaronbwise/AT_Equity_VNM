* Encoding: windows-1252.

*showing only labels at the outputs.
SET TVars=Labels TNumbers=Labels ONumbers=Labels.

* APPEND WEALTH INDEX VARIABLES TO DATA FILES.
* Create wealth data file.
weight off.

sort cases by hh1 hh2.

save outfile="wealth.sav"
 /keep HH1 HH2 wscore windex5 windex10 wscoreu windex5u windex10u wscorer windex5r windex10r.



* Append wealth index values to data files.

*	hh.sav.
get file = 'hh.sav'.
delete variables wscore windex5 windex10 wscoreu windex5u windex10u wscorer windex5r windex10r.
sort cases by HH1 HH2.
match files
  /file = *
  /table = 'wealth.sav'
  /by HH1 HH2.
do if (HH46 <> 1).
recode wscore windex5 windex10 wscoreu windex5u windex10u wscorer windex5r windex10r (lo thru hi, sysmis, 0 = 0).
end if.
execute.
save outfile = 'hh.sav'.

*	hl.sav.
get file = 'hl.sav'.
delete variables wscore windex5 windex10 wscoreu windex5u windex10u wscorer windex5r windex10r.
sort cases by HH1 HH2.
match files
  /file = *
  /table = 'wealth.sav'
  /by HH1 HH2.
save outfile = 'hl.sav'.

*	tn.sav.
get file = 'tn.sav'.
delete variables wscore windex5 windex10 wscoreu windex5u windex10u wscorer windex5r windex10r.
sort cases by HH1 HH2.
match files
  /file = *
  /table = 'wealth.sav'
  /by HH1 HH2.
save outfile = 'tn.sav'.

*	wm.sav.
get file = 'wm.sav'.
delete variables wscore windex5 windex10 wscoreu windex5u windex10u wscorer windex5r windex10r.
sort cases by HH1 HH2.
match files
  /file = *
  /table = 'wealth.sav'
  /by HH1 HH2.
do if (WM17 <> 1).
recode wscore windex5 windex10 wscoreu windex5u windex10u wscorer windex5r windex10r (lo thru hi, sysmis, 0 = 0).
end if.
execute.
save outfile = 'wm.sav'.

*	bh.sav.
get file = 'bh.sav'.
delete variables wscore windex5 windex10 wscoreu windex5u windex10u wscorer windex5r windex10r.
sort cases by HH1 HH2.
match files
  /file = *
  /table = 'wealth.sav'
  /by HH1 HH2.
save outfile = 'bh.sav'.

*	fg.sav.
get file = 'fg.sav'.
delete variables wscore windex5 windex10 wscoreu windex5u windex10u wscorer windex5r windex10r.
sort cases by HH1 HH2.
match files
  /file = *
  /table = 'wealth.sav'
  /by HH1 HH2.
save outfile = 'fg.sav'.

*	mm.sav.
get file = 'mm.sav'.
delete variables wscore windex5 windex10 wscoreu windex5u windex10u wscorer windex5r windex10r.
sort cases by HH1 HH2.
match files
  /file = *
  /table = 'wealth.sav'
  /by HH1 HH2.
save outfile = 'mm.sav'.

*	ch.sav.
get file = 'ch.sav'.
delete variables wscore windex5 windex10 wscoreu windex5u windex10u wscorer windex5r windex10r.
sort cases by HH1 HH2.
match files
  /file = *
  /table = 'wealth.sav'
  /by HH1 HH2.
do if (UF17 <> 1).
recode wscore windex5 windex10 wscoreu windex5u windex10u wscorer windex5r windex10r (lo thru hi, sysmis, 0 = 0).
end if.
execute.
save outfile = 'ch.sav'.

*	fs.sav.
get file = 'fs.sav'.
delete variables wscore windex5 windex10 wscoreu windex5u windex10u wscorer windex5r windex10r.
sort cases by HH1 HH2.
match files
  /file = *
  /table = 'wealth.sav'
  /by HH1 HH2.
do if (FS17 <> 1).
recode wscore windex5 windex10 wscoreu windex5u windex10u wscorer windex5r windex10r (lo thru hi, sysmis, 0 = 0).
end if.
execute.
save outfile = 'fs.sav'.

*	mn.sav.
get file = 'mn.sav'.
delete variables wscore windex5 windex10 wscoreu windex5u windex10u wscorer windex5r windex10r.
sort cases by HH1 HH2.
match files
  /file = *
  /table = 'wealth.sav'
  /by HH1 HH2.
do if (MWM17 <> 1).
recode wscore windex5 windex10 wscoreu windex5u windex10u wscorer windex5r windex10r (lo thru hi, sysmis, 0 = 0).
end if.
execute.
save outfile = 'mn.sav'.


new file.
