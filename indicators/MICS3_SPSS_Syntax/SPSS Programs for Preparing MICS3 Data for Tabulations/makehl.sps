*open the household listing data file.
get file = 'hl.sav'.

* create a variable that will reflect mother's line number.
compute mline = hl1.

* create what will be mother's education level.
recode ED3A (1 = 2) (2,3 = 3) (6 = 4) (8,9 = 9) (else = 1) into melevel.
variable label melevel "Mother's education".
value label melevel
  1 "None"
  2 "Primary"
  3 "Secondary +"
  4 "Non-standard curriculum"
  5 "Mother not in household"
  9 "Missing/DK".
format melevel (f1.0).

* sort the cases by cluster number, household number and mother's line number.
sort cases by HH1 HH2 mline.

* save a mother's education file.
save outfile = 'tmpme.sav'
  /keep HH1 HH2 mline melevel.

* create a variable that will reflect father's line number.
compute fline = hl1.

* create what will be father's education level.
recode ED3A (1 = 2) (2,3 = 3) (6 = 4) (8,9 = 9) (else = 1) into felevel.
variable label felevel "Father's education".
value label felevel
  1 "None"
  2 "Primary"
  3 "Secondary +"
  4 "Non-standard curriculum"
  5 "Father not in household"
  9 "Missing/DK".
format felevel (f1.0).

* sort the cases by cluster number, household number and father's line number.
sort cases by HH1 HH2 fline.

* save a father's education file.
save outfile = 'tmpfe.sav'
  /keep HH1 HH2 fline felevel.

* keep heads of household only.
select if (hl3 = 1).

* create head of household's education level.
recode ED3A (1 = 2) (2,3 = 3) (6 = 4) (8,9 = 9) (else = 1) into helevel.
variable label helevel "Education of household head".
value label helevel
  1 "None"
  2 "Primary"
  3 "Secondary +"
  4 "Non-standard curriculum"
  9 "Missing/DK".
format helevel (f1.0).

* sort the cases by cluster number, household number and head's line number.
sort cases by HH1 HH2 HL1.

* save a household head's education file.
save outfile = 'tmphhe.sav'
  /keep HH1 HH2 HL1 helevel.

* open the household listing data file.
get file = 'hl.sav'.

* compute mother's line number for household members aged 17 or younger.
if (HL7 <> 0) mline = HL7.
if (HL8 <> 0) mline = HL8.
if (hl5 < 18 and sysmis(mline)) mline = 0.
* use mother's line number if mother/caretaker from HL7 & HL8 is not available.
if (mline=0 and not sysmis(HL10) and HL10 <> 0) mline = HL10.
variable label mline "Mother's line number".
format mline (f2.0).

* sort the cases by cluster number, household number and mother's line number.
sort cases by HH1 HH2 mline.

* merge the mother's education file onto the household listing file.
match files
  /file = *
  /table = 'tmpme.sav'
  /by HH1 HH2 mline.

* recode mother's education level to deal with mothers who live elsewhere or are dead.
if (mline = 0) melevel = 5.

* compute father's line number for household members aged 17 or younger.
compute fline = HL12.
if (hl5 < 18 and sysmis(fline)) fline = 0.
variable label fline "Father's line number".
format fline (f2.0).

* sort the cases by cluster number, household number and father's line number.
sort cases by HH1 HH2 fline.

* merge the father's education file onto the household listing file.
match files
  /file = *
  /table = 'tmpfe.sav'
  /by HH1 HH2 fline.

* recode father's education level to deal with fathers who live elsewhere or are dead.
if (fline = 0) felevel = 5.

* sort the cases by cluster number and household number.
sort cases by HH1 HH2.

* merge the household head file onto the household listing file.
match files
  /file = *
  /table = 'tmphhe.sav'
  /by HH1 HH2 .

* sort the cases by cluster number, household number and line number.
sort cases by HH1 HH2 HL1 .

* save the household listing data file.
save outfile = 'hl.sav'.

* erase the working files.
erase file = 'tmpme.sav'.
erase file = 'tmpfe.sav'.
erase file = 'tmphhe.sav'.
