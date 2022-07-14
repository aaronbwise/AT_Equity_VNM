* open the household listing data file.
get file = 'hl.sav'.

* keep heads of household only.
select if (HL3 = 1).

* sort the cases by cluster number, household number and line number.
sort cases by HH1 HH2 HL1.

* education level.
recode ED3A (1 = 2) (2,3 = 3) (6 = 4) (8,9 = 9) (else = 1) into helevel.
variable label helevel "Education of household head".
value label helevel
  1 "None"
  2 "Primary"
  3 "Secondary +"
  4 "Non-standard curriculum"
  9 "Missing/DK".
format helevel (f1.0).

* sex of household head.
recode HL4 (1,2 = copy) (else = 9) into hhsex.
variable label hhsex "Sex of household head".
value label hhsex
  1 "Male"
  2 "Female"
  9 "Missing/DK".
format hhsex (f1.0).

* save a data file of household heads with IDs and education as only vars.
save outfile = 'tmp1.sav'
  /keep HH1 HH2 helevel hhsex.

* open the household data file.
get file = 'hh.sav'.

* sort the cases by cluster number and household number.
sort cases by HH1 HH2.

* merge the household head file onto the household file.
match files
  /file = *
  /table = 'tmp1.sav'
  /by HH1 HH2 .

* resort the cases by cluster number and household number.
sort cases by HH1 HH2.

* save household data, which now contains the education of household head.
save outfile = 'hh.sav'.

* erase the working file.
erase file = 'tmp1.sav'.
