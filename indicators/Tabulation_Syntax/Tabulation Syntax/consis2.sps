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
  /title = "Case present in Household listing file but not in household file"
  /variables = HH1 HH2 HL1.

* open a new, blank data file.
new file.

*erase the working file.
erase file = 'tmp.sav'.
erase file = 'check.sav'.

** CHECK WOMEN'S FILE AGAINST THE HOUSEHOLD FILE **.

*open the household file.
get file = 'HH.sav'.

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
  /title = "Case present in womens file but not in household file"
  /variables = HH1 HH2 LN.

* open a new, blank data file.
new file.

*erase the working file.
erase file = 'tmp.sav'.
erase file = 'check.sav'.

** CHECK WOMEN'S FILE AGAINST THE HOUSEHOLD LISTING FILE **.

*open the household listing file.
get file = 'HL.sav'.

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
  /title = "Case present in womens file but not in household listing file"
  /variables = HH1 HH2 LN.

* open a new, blank data file.
new file.

*erase the working file.
erase file = 'tmp.sav'.
erase file = 'check.sav'.

** CHECK MEN'S FILE AGAINST THE HOUSEHOLD FILE **.

*open the household file.
get file = 'HH.sav'.

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
  /title = "Case present in mens file but not in household file"
  /variables = HH1 HH2 LN.

* open a new, blank data file.
new file.

*erase the working file.
erase file = 'tmp.sav'.
erase file = 'check.sav'.

** CHECK MEN'S FILE AGAINST THE HOUSEHOLD LISTING FILE **.

*open the household listing file.
get file = 'HL.sav'.

compute check = 1.

*sort the cases by cluster number, household number.
sort cases by HH1 HH2 HL1 .

*save the sorted cases in a working file.
save outfile = 'tmp.sav'
  /rename (HL1 = LN)
  /keep = HH1 HH2 LN check.

*open the women's data file.
get file = 'mn.sav'.

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
  /title = "Case present in mens file but not in household listing file"
  /variables = HH1 HH2 LN.

* open a new, blank data file.
new file.

*erase the working file.
erase file = 'tmp.sav'.
erase file = 'check.sav'.

** CHECK CHILDREN'S FILE AGAINST THE HOUSEHOLD FILE **.

* open the household file.
get file = 'HH.sav'.

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
  /title = "Case present in child file but not in household file"
  /variables = HH1 HH2 LN.

* open a new, blank data file.
new file.

*erase the working file.
erase file = 'tmp.sav'.
erase file = 'check.sav'.

** CHECK CHILDREN'S FILE AGAINST THE HOUSEHOLD LISTING FILE **.

* open the household file.
get file = 'HL.sav'.

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
  /title = "Case present in child file but not in household listing file"
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
  /title = "Case present in birth history file but not in household file"
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
  /title = "Case present in birth history file but not women file"
  /variables = HH1 HH2 LN BHLN.

* open a new, blank data file.
new file.

*erase the working file.
erase file = 'tmp.sav'.
erase file = 'check.sav'.