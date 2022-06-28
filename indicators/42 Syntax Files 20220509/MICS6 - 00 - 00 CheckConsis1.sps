* Encoding: windows-1252.
erase file='bad.sav'.

*** CREATE AGGREGATE FILE FROM HH MEMBER DATA FILE ***.

get file = 'hl.sav'.

compute member = 1.

* aggregate member cases to a temporary file.
aggregate outfile = 'tmp.sav'
  /break = HH1 HH2
  /totmemb = sum(member).

*open the aggregate file.
get file = 'tmp.sav'.

*sort the cases by cluster number and household number.
sort cases by HH1 HH2 .

*save the sorted cases in a working file.
save outfile = 'tmp.sav'.

*open the household data file.
get file = 'hh.sav'.

*sort the cases by cluster number and household number.
sort cases by HH1 HH2 .

*merge the aggregate data onto the household data file.
match files
  /file = *
  /table = 'tmp.sav'
  /by HH1 HH2 .

save outfile='bad.sav'
  /keep HH1 HH2 HH48 HH49 HH50 HH51 HH52 HH53 HH54 HH50A HH55 HH56 totmemb.

*** CREATE AGGREGATE FILE FROM WOMAN DATA FILE ***.

get file = 'wm.sav'.

compute woman = 1.

compute cwoman = 0.
if (WM17 = 1) cwoman = 1.

* aggregate womens cases to a temporary file.
aggregate outfile = 'tmp.sav'
  /break = HH1 HH2
  /totwoman = sum(woman)
  /totcwoman = sum(cwoman).
 
*open the aggregate file.
get file = 'tmp.sav'.

*sort the cases by cluster number and household number.
sort cases by HH1 HH2.

*save the sorted cases in a working file.
save outfile = 'tmp.sav'.

*open the household data file.
get file = 'bad.sav'.

*sort the cases by cluster number and household number.
sort cases by HH1 HH2.

*merge the aggregate data onto the household data file.
match files
  /file = *
  /table = 'tmp.sav'
  /by HH1 HH2.

save outfile='bad1.sav'
  /keep HH1 HH2 HH48 HH49 HH50 HH51 HH52 HH53 HH54 HH50A HH55 HH56 totmemb totwoman totcwoman.


*** CREATE AGGREGATE FILE FROM MEN DATA FILE ***.

get file = 'mn.sav'.

compute man = 1.

compute cman = 0.
if (MWM17 = 1) cman = 1.

*aggregate sum of child cases to temporary file.

aggregate outfile = 'tmp.sav'
  /break = HH1 HH2
  /totman = sum(man)
  /totcman = sum(cman).
 
*open the aggregate file.
get file = 'tmp.sav'.

*sort the cases by cluster number and household number.
sort cases by HH1 HH2.

*save the sorted cases in a working file.
save outfile = 'tmp.sav'.

*open the household data file.
get file = 'bad1.sav'.

*sort the cases by cluster number and household number.
sort cases by HH1 HH2.

*merge the aggregate data onto the household data file.
match files
  /file = *
  /table = 'tmp.sav'
  /by HH1 HH2.

save outfile='bad2.sav'
  /keep HH1 HH2 HH48 HH49 HH50 HH51 HH52 HH53 HH54 HH50A HH55 HH56 totmemb totwoman totcwoman totman totcman.

*** CREATE AGGREGATE FILE FROM CHILDREN DATA FILE ***.

get file = 'ch.sav'.

compute kid = 1.

compute ckid = 0.
if (UF17 = 1) ckid = 1.

*aggregate sum of child cases to temporary file.

aggregate outfile = 'tmp.sav'
  /break = HH1 HH2
  /totkid = sum(kid)
  /totckid = sum(ckid).
 
*open the aggregate file.
get file = 'tmp.sav'.

*sort the cases by cluster number and household number.
sort cases by HH1 HH2.

*save the sorted cases in a working file.
save outfile = 'tmp.sav'.

*open the household data file.
get file = 'bad2.sav'.

*sort the cases by cluster number and household number.
sort cases by HH1 HH2.

*merge the aggregate data onto the household data file.
match files
  /file = *
  /table = 'tmp.sav'
  /by HH1 HH2.

save outfile='bad3.sav'
  /keep HH1 HH2 HH48 HH49 HH50 HH51 HH52 HH53 HH54 HH50A HH55 HH56 totmemb totwoman totcwoman totman totcman totkid totckid.

** CHECK AGGREGATE TOTALS AGAINST HOUSEHOLD TOTALS **.

get file='bad3.sav'.

if sysmis(totmemb) totmemb = 0.
if sysmis(totwoman) totwoman = 0.
if sysmis(totman) totman = 0.
if sysmis(totkid) totkid = 0.

if sysmis(totcwoman) totcwoman = 0.
if sysmis(totcman) totcman = 0.
if sysmis(totckid) totckid = 0.

if sysmis(HH48) HH48 = 0.
if sysmis(HH49) HH49 = 0.
if sysmis(HH50) HH50 = 0.
if sysmis(HH51) HH51 = 0.
if sysmis(HH52) HH52 = 0.
if sysmis(HH53) HH53 = 0.
if sysmis(HH54) HH54 = 0.
if sysmis(HH50A) HH50A = 0.
if sysmis(HH55) HH55 = 0.
if sysmis(HH56) HH56 = 0.

compute badmemb = 0.
if totmemb <> HH48 badmemb = 1.
compute badwom=0.
if totwoman <> HH49 badwom = 1.
compute badcwom=0.
if totcwoman <> HH53 badcwom = 1.
compute badman=0.
if totman <> HH50 badman = 1.
compute badcman=0.
if totcman <> HH54 badcman = 1.
compute badkid=0.
if totkid <> HH51 badkid = 1.
compute badckid=0.
if totckid <> HH55 badckid = 1.

select if badmemb = 1 or badwom = 1 or badman = 1 or badkid = 1 or badcwom = 1 or badcman = 1 or badckid = 1.
save outfile = 'bad.sav'.

get file='bad.sav'.
select if badmemb = 1 or badwom = 1 or badman = 1 or badkid = 1.

report 
  /format = automatic list
  /title = "MICS6 " "Listing of inconsistencies between cases reported " "at household level and within the women's, men's and children's files"
  /footnote = "Inconsistency information also saved in BAD.SAV"
  /variables = HH48 totmemb "# in" "HHMem" "file" HH49  totwoman "# in" "Woman" "file" HH50A totman "# in" "Man" "file" HH51  totkid "# in" "child" "file"
  /break = HH1 HH2 'Cluster' 'Household'.

* open a new, empty file.
new file.

get file='bad.sav'.
select if  badcwom = 1 or badcman = 1 or badckid = 1.

report 
  /format = automatic list
  /title = "MICS6 " "Listing of inconsistencies between COMPLETED cases reported " "at household level and within the women's, men's and children's files"
  /footnote = "Inconsistency information also saved in BAD.SAV"
  /variables = HH53  totcwoman "# completed in" "Woman" "file" HH54 totcman "# completed in" "Man" "file" HH51  totckid "# completed in" "child" "file"
  /break = HH1 HH2 'Cluster' 'Household'.

* clean up temporary files.
erase file='bad1.sav'.
erase file='bad2.sav'.
erase file='bad3.sav'.
erase file='tmp.sav'.

* open a new, empty file.
new file.