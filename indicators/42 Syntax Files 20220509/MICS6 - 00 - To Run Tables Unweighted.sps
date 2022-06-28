* Encoding: windows-1252.

* define location of syntax file.
cd "C:\MICS6\SPSS".

* bacup the weight variables and make a dummy weight variable =1.  
get file 'hh.sav'.
rename variables hhweight=hhorg.
compute hhweight = 1.
rename variables wqhweight=wqhorg.
compute wqhweight = 1.
rename variables wqsweight=wqsorg.
compute wqsweight = 1.
save outfile='hh.sav'.
new file.

get file 'hl.sav'.
rename variables hhweight=hhorg.
compute hhweight = 1.
save outfile='hl.sav'.
new file.

get file 'tn.sav'.
rename variables hhweight=hhorg.
compute hhweight = 1.
save outfile='tn.sav'.
new file.

get file 'wm.sav'.
rename variables wmweight=wmorg.
compute wmweight = 1.
save outfile='wm.sav'.
new file.

get file 'bh.sav'.
rename variables wmweight=wmorg.
compute wmweight = 1.
save outfile='bh.sav'.
new file.

get file 'fg.sav'.
rename variables wmweight=wmorg.
compute wmweight = 1.
save outfile='fg.sav'.
new file.

get file 'mm.sav'.
rename variables wmweight=wmorg.
compute wmweight = 1.
save outfile='mm.sav'.
new file.

get file 'ch.sav'.
rename variables chweight=chorg.
compute chweight = 1.
save outfile='ch.sav'.
new file.

get file 'fs.sav'.
rename variables fshweight=fshorg.
compute fshweight = 1.
rename variables fsweight=fsorg.
compute fsweight = 1.
save outfile='fs.sav'.
new file.

get file 'mn.sav'.
rename variables mnweight=mnorg.
compute mnweight = 1.
save outfile='mn.sav'.
new file.


************************************************************************.
*run all syntaxes.
insert file = '.\MICS6 - 00 - All Tables UNW in Sheets.sps'.

************************************************************************.
*change the weights back to original.
get file 'hh.sav'.
delete variables hhweight.
rename variables hhorg=hhweight.
delete variables wqhweight.
rename variables wqhorg=wqhweight.
delete variables wqsweight.
rename variables wqsorg=wqsweight.
save outfile='hh.sav'.
new file.

get file 'hl.sav'.
delete variables hhweight.
rename variables hhorg=hhweight.
save outfile='hl.sav'.
new file.

get file 'tn.sav'.
delete variables hhweight.
rename variables hhorg=hhweight.
save outfile='tn.sav'.
new file.

get file 'wm.sav'.
delete variables wmweight.
rename variables wmorg=wmweight.
save outfile='wm.sav'.
new file.

get file 'bh.sav'.
delete variables wmweight.
rename variables wmorg=wmweight.
save outfile='bh.sav'.
new file.

get file 'fg.sav'.
delete variables wmweight.
rename variables wmorg=wmweight.
save outfile='fg.sav'.
new file.

get file 'mm.sav'.
delete variables wmweight.
rename variables wmorg=wmweight.
save outfile='mm.sav'.
new file.

get file 'ch.sav'.
delete variables chweight.
rename variables chorg=chweight.
save outfile='ch.sav'.
new file.

get file 'fs.sav'.
delete variables fshweight.
rename variables fshorg=fshweight.
delete variables fsweight.
rename variables fsorg=fsweight.
save outfile='fs.sav'.
new file.

get file 'mn.sav'.
delete variables mnweight.
rename variables mnorg=mnweight.
save outfile='mn.sav'.
new file.