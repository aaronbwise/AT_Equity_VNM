*v02: 20140718: 
*lines 509 and 510 corrected to reffer to maternal mortality instead of fgm data file.


** CHECK HOUSEHOLD LISTING FILE AGAINST HOUSEHOLD FILE **.

*open the household data file.
get file = 'hh.sav'.

compute check = 1.

*sort the cases by cluster number, household number.
sort cases by HH1 HH2.

*save the sorted cases in a working file.
save outfile = 'tmp.sav'
  /keep = HH1 HH2 check.

*open the household listing data file.
get file = 'hl.sav'.

*sort the cases by cluster number and household number.
sort cases by HH1 HH2.

*merge the household file onto the household listing file.
match files
  /file = *
  /table = 'tmp.sav'
  /by HH1 HH2.

save outfile = 'check.sav'.

get file = 'check.sav'.

select if sysmis(check).

report 
  /format = list 
  /title = "Case present in HOUSEHOLD LISTING file but not in HOUSEHOLD file"
  /variables = HH1 HH2 HL1.

* open a new, blank data file.
new file.

*erase the working file.
erase file = 'tmp.sav'.
erase file = 'check.sav'.

** CHECK WOMEN'S FILE AGAINST THE HOUSEHOLD FILE **.

*open the household file.
get file = 'hh.sav'.

compute check = 1.

*sort the cases by cluster number, household number.
sort cases by HH1 HH2 .

*save the sorted cases in a working file.
save outfile = 'tmp.sav'
  /keep = HH1 HH2 check.

*open the women's data file.
get file = 'wm.sav'.

*sort the cases by cluster number, household number and line number.
sort cases by HH1 HH2 LN.

*merge the household file onto the women's file.
match files
  /file = *
  /table = 'tmp.sav'
  /by HH1 HH2.

save outfile = 'check.sav'.

get file = 'check.sav'.

select if sysmis(check).

report 
  /format = list 
  /title = "Case present in WOMEN file but not in HOUSEHOLD file"
  /variables = HH1 HH2 LN.

* open a new, blank data file.
new file.

*erase the working file.
erase file = 'tmp.sav'.
erase file = 'check.sav'.

** CHECK WOMEN'S FILE AGAINST THE HOUSEHOLD LISTING FILE **.

*open the household listing file.
get file = 'hl.sav'.

compute check = 1.

*sort the cases by cluster number, household number.
sort cases by HH1 HH2 HL1 .

*save the sorted cases in a working file.
save outfile = 'tmp.sav'
  /rename (HL1 = LN)
  /keep = HH1 HH2 LN check.

*open the women's data file.
get file = 'wm.sav'.

*sort the cases by cluster number, household number and line number.
sort cases by HH1 HH2 LN.

*merge the household file onto the women's file.
match files
  /file = *
  /table = 'tmp.sav'
  /by HH1 HH2 LN.

save outfile = 'check.sav'.

get file = 'check.sav'.

select if sysmis(check).

report 
  /format = list 
  /title = "Case present in WOMEN file but not in HOUSEHOLD LISTING file"
  /variables = HH1 HH2 LN.

* open a new, blank data file.
new file.

*erase the working file.
erase file = 'tmp.sav'.
erase file = 'check.sav'.

** CHECK MEN'S FILE AGAINST THE HOUSEHOLD FILE **.

*open the household file.
get file = 'hh.sav'.

compute check = 1.

*sort the cases by cluster number, household number.
sort cases by HH1 HH2 .

*save the sorted cases in a working file.
save outfile = 'tmp.sav'
  /keep = HH1 HH2 check.

*open the men's data file.
get file = 'mn.sav'.

*sort the cases by cluster number, household number and line number.
sort cases by HH1 HH2 LN.

*merge the household file onto the men's file.
match files
  /file = *
  /table = 'tmp.sav'
  /by HH1 HH2.

save outfile = 'check.sav'.

get file = 'check.sav'.

select if sysmis(check).

report 
  /format = list 
  /title = "Case present in MEN file but not in HOUSEHOLD file"
  /variables = HH1 HH2 LN.

* open a new, blank data file.
new file.

*erase the working file.
erase file = 'tmp.sav'.
erase file = 'check.sav'.

** CHECK MEN'S FILE AGAINST THE HOUSEHOLD LISTING FILE **.

*open the household listing file.
get file = 'hl.sav'.

compute check = 1.

*sort the cases by cluster number, household number.
sort cases by HH1 HH2 HL1 .

*save the sorted cases in a working file.
save outfile = 'tmp.sav'
  /rename (HL1 = LN)
  /keep = HH1 HH2 LN check.

*open the men's data file.
get file = 'mn.sav'.

*sort the cases by cluster number, household number and line number.
sort cases by HH1 HH2 LN.

*merge the household file onto the men's file.
match files
  /file = *
  /table = 'tmp.sav'
  /by HH1 HH2 LN.

save outfile = 'check.sav'.

get file = 'check.sav'.

select if sysmis(check).

report 
  /format = list 
  /title = "Case present in MEN file but not in HOUSEHOLD LISTING file"
  /variables = HH1 HH2 LN.

* open a new, blank data file.
new file.

*erase the working file.
erase file = 'tmp.sav'.
erase file = 'check.sav'.

** CHECK CHILDREN'S FILE AGAINST THE HOUSEHOLD FILE **.

* open the household file.
get file = 'hh.sav'.

compute check =1.

*sort the cases by cluster number, household number.
sort cases by HH1 HH2.

*save the sorted cases in a working file.
save outfile = 'tmp.sav'
  /keep = HH1 HH2 check .

*open the child's data file.
get file = 'ch.sav'.

*sort the cases by cluster number, household number and line number.
sort cases by HH1 HH2 LN .

*merge the household listing file onto the child's file.
match files
  /file = *
  /table = 'tmp.sav'
  /by HH1 HH2.

save outfile = 'check.sav'.

get file = 'check.sav'.

select if sysmis(check).

report 
  /format = list 
  /title = "Case present in CHILD file but not in HOUSEHOLD file"
  /variables = HH1 HH2 LN.

* open a new, blank data file.
new file.

*erase the working file.
erase file = 'tmp.sav'.
erase file = 'check.sav'.

** CHECK CHILDREN'S FILE AGAINST THE HOUSEHOLD LISTING FILE **.

* open the household file.
get file = 'hl.sav'.

compute check =1.

*sort the cases by cluster number, household number.
sort cases by HH1 HH2 HL1.

*save the sorted cases in a working file.
save outfile = 'tmp.sav'
  /rename = (HL1 = LN) 
  /keep = HH1 HH2 LN check .

*open the child's data file.
get file = 'ch.sav'.

*sort the cases by cluster number, household number and line number.
sort cases by HH1 HH2 LN .

*merge the household listing file onto the child's file.
match files
  /file = *
  /table = 'tmp.sav'
  /by HH1 HH2 LN.

save outfile = 'check.sav'.

get file = 'check.sav'.

select if sysmis(check).

report 
  /format = list 
  /title = "Case present in CHILD file but not in HOUSEHOLD LISTING file"
  /variables = HH1 HH2 LN.

* open a new, blank data file.
new file.

*erase the working file.
erase file = 'tmp.sav'.
erase file = 'check.sav'.

** CHECK BIRTH HISTORY FILE AGAINST THE HOUSEHOLD FILE **.

*open the household file.
get file = 'hh.sav'.

compute check = 1.

*sort the cases by cluster number, household number.
sort cases by HH1 HH2 .

*save the sorted cases in a working file.
save outfile = 'tmp.sav'
  /keep = HH1 HH2 check.

*open the birth history data file.
get file = 'bh.sav'.

*sort the cases by cluster number, household number, line number and birth history line number.
sort cases by HH1 HH2 LN BHLN.

*merge the household file onto the birth history file.
match files
  /file = *
  /table = 'tmp.sav'
  /by HH1 HH2.

save outfile = 'check.sav'.

get file = 'check.sav'.

select if sysmis(check).

report 
  /format = list 
  /title = "Case present in BIRTH HISTORY file but not in HOUSEHOLD file"
  /variables = HH1 HH2 LN BHLN.

* open a new, blank data file.
new file.

*erase the working file.
erase file = 'tmp.sav'.
erase file = 'check.sav'.

** CHECK BIRTH HISTORY FILE AGAINST THE WOMEN FILE **.

*open the household listing file.
get file = 'wm.sav'.

compute check = 1.

*sort the cases by cluster number, household number.
sort cases by HH1 HH2 LN .

*save the sorted cases in a working file.
save outfile = 'tmp.sav'
  /keep = HH1 HH2 LN check.

*open the birth history data file.
get file = 'bh.sav'.

*sort the cases by cluster number, household number and women's line number.
sort cases by HH1 HH2 LN BHLN.

*merge the women's file onto the birth history file.
match files
  /file = *
  /table = 'tmp.sav'
  /by HH1 HH2 LN.

save outfile = 'check.sav'.

get file = 'check.sav'.

select if sysmis(check).

report 
  /format = list 
  /title = "Case present in BIRTH HISTORY file but not WOMEN file"
  /variables = HH1 HH2 LN BHLN.

* open a new, blank data file.
new file.

*erase the working file.
erase file = 'tmp.sav'.
erase file = 'check.sav'.


** CHECK FGM FILE AGAINST THE HOUSEHOLD FILE **.

*open the household file.
get file = 'hh.sav'.

compute check = 1.

*sort the cases by cluster number, household number.
sort cases by HH1 HH2 .

*save the sorted cases in a working file.
save outfile = 'tmp.sav'
  /keep = HH1 HH2 check.

*open the fgm data file.
get file = 'fg.sav'.

*sort the cases by cluster number, household number, and line number.
sort cases by HH1 HH2 LN FGLN.

*merge the household file onto the fgm file.
match files
  /file = *
  /table = 'tmp.sav'
  /by HH1 HH2.

save outfile = 'check.sav'.

get file = 'check.sav'.

select if sysmis(check).

report 
  /format = list 
  /title = "Case present in FGM file but not in HOUSEHOLD file"
  /variables = HH1 HH2 LN FGLN.

* open a new, blank data file.
new file.

*erase the working file.
erase file = 'tmp.sav'.
erase file = 'check.sav'.

** CHECK FGM FILE AGAINST THE WOMEN FILE **.

*open the women file.
get file = 'wm.sav'.

compute check = 1.

*sort the cases by cluster number, household number.
sort cases by HH1 HH2 LN .

*save the sorted cases in a working file.
save outfile = 'tmp.sav'
  /keep = HH1 HH2 LN check.

*open the FGM data file.
get file = 'fg.sav'.

*sort the cases by cluster number, household number and women's line number.
sort cases by HH1 HH2 LN FGLN.

*merge the women's file onto the FGM file.
match files
  /file = *
  /table = 'tmp.sav'
  /by HH1 HH2 LN.

save outfile = 'check.sav'.

get file = 'check.sav'.

select if sysmis(check).

report 
  /format = list 
  /title = "Case present in FGM file but not WOMEN file"
  /variables = HH1 HH2 LN FGLN.

* open a new, blank data file.
new file.

*erase the working file.
erase file = 'tmp.sav'.
erase file = 'check.sav'.



** CHECK MATERNAL MORTALITY FILE AGAINST THE HOUSEHOLD FILE **.

*open the household file.
get file = 'hh.sav'.

compute check = 1.

*sort the cases by cluster number, household number.
sort cases by HH1 HH2 .

*save the sorted cases in a working file.
save outfile = 'tmp.sav'
  /keep = HH1 HH2 check.

 *open the maternal mortality data file.
get file = 'mm.sav'.

*sort the cases by cluster number, household number, and line number.
sort cases by HH1 HH2 LN MMLN.

* merge the household file onto the maternal mortality file.
match files
  /file = *
  /table = 'tmp.sav'
  /by HH1 HH2.

save outfile = 'check.sav'.

get file = 'check.sav'.

select if sysmis(check).

report 
  /format = list 
  /title = "Case present in MATERNAL MORTALITY file but not in HOUSEHOLD file"
  /variables = HH1 HH2 LN MMLN.

* open a new, blank data file.
new file.

*erase the working file.
erase file = 'tmp.sav'.
erase file = 'check.sav'.

** CHECK MATERNAL MORTALITY FILE AGAINST THE WOMEN FILE **.

*open the women file.
get file = 'wm.sav'.

compute check = 1.

*sort the cases by cluster number, household number.
sort cases by HH1 HH2 LN .

*save the sorted cases in a working file.
save outfile = 'tmp.sav'
  /keep = HH1 HH2 LN check.

*open the MATERNAL MORTALITY data file.
get file = 'mm.sav'.

*sort the cases by cluster number, household number and women's line number.
sort cases by HH1 HH2 LN MMLN.

*merge the women's file onto the MATERNAL MORTALITY file.
match files
  /file = *
  /table = 'tmp.sav'
  /by HH1 HH2 LN.

save outfile = 'check.sav'.

get file = 'check.sav'.

select if sysmis(check).

report 
  /format = list 
  /title = "Case present in MATERNAL MORTALITY file but not WOMEN file"
  /variables = HH1 HH2 LN MMLN.

* open a new, blank data file.
new file.

*erase the working file.
erase file = 'tmp.sav'.
erase file = 'check.sav'.
