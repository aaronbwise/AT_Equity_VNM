
* --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------.
* --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------.
* ---------------------	Program to calculate and append background variables to SPSS data files.
* --------------------- This program should be run after the data sets have been exported from CSPro, and structural checks have been completed.
* --------------------- Usually, several runs of this program will be needed before the creation of background variables are finalized and merged to the data sets for good.
* --------------------- The data processing expert should check the frequency distribution of created variables.
* --------------------- With every run of the program, background variables will be replaced with the new values of the variables.
* --------------------- Added variables are: EDUCATION,  ETHNICITY/LANGUAGE/RELIGION and AGE AT THE BEGINING OF SCHOOL YEAR.
* --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------.
* --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------.

* Create background characteristics for household file: hh.sav.

* Open the household members data file.
get file = 'hl.sav'.

* delete variables  if already existing.
delete variables felevel.

* Keep household heads only.
select if (HL3 = 1).

* Sort the cases by cluster number, household number and line number.
sort cases by HH1 HH2 HL1.

* Customize the household head education level categories.
recode ED4A (1 = 2) (2,3 = 3) (8,9 = 9) (else = 1) into helevel.
variable label helevel "Education of household head".
value label helevel
  1 "None"
  2 "Primary"
  3 "Secondary +"
  9 "Missing/DK".
format helevel (f1.0).

* Save a data file of household heads with IDs and education as only vars.
save outfile = 'tmphe.sav'
  /keep HH1 HH2 helevel .

* Open the household data file.
get file = 'hh.sav'.

delete variables helevel ethnicity.

* Sort the cases by cluster number and household number.
sort cases by HH1 HH2.

* Customize the household head ethnicity/language/religion categories.
recode HC1C (1 = 1) (2, 3 = 2) (4 =3) (8,9 = 9) into ethnicity.
variable label ethnicity "Ethnicity of household head".
value label ethnicity
  1 "Ethnic group 1"
  2 "Ethnic group 2"
  3 "Ethnic group 3"
  9 "Missing/DK".
format ethnicity (f1.0).

* Merge the household head education file onto the household file.
match files
  /file = *
  /table = 'tmphe.sav'
  /by HH1 HH2 .

* Resort the cases by cluster number and household number.
sort cases by HH1 HH2.

*  Save household data, which now contains the education of household head.
save outfile = 'hh.sav'.

* Create a file for adding ethnicity/language/religion variable to other files.
get file = "hh.sav".

* Sort the cases by cluster number and household number.
sort cases by HH1 HH2.

save outfile = 'tmpetn.sav'
  /keep HH1 HH2 ethnicity.

* Create background characteristics for household member file: hl.sav.

* Open the household member data file.
get file = 'hl.sav'.

*Delete variable if already in the file.
delete variables schage.

* Set the month and year of the beginning of the school year in your country.
compute monthsc =  9.
compute yearsc =  2008.
variable label monthsc "Month of beginning of the school year".
variable label yearsc "Year of beginning of the school year".

compute schage = 998.
* if month and year of birth are valid.
if (HL5M < 98 and HL5Y < 9998) schage = trunck ( (yearsc - HL5Y)  + (monthsc - HL5M) / 12).
* if only year of birth is valid and survey is conducted half a year or later than the beginning of the school year.
if ((HL5M >= 98 and HL5Y < 9998) and ((HH5Y - yearsc) *12 + (HH5M - monthsc) >= 6)) schage =  (yearsc - HL5Y)  - 1.
* if only year of birth is valid and survey is conducted half a year or later than the beginning of the school year.
if ((HL5M >= 98 and HL5Y < 9998) and ((HH5Y - yearsc) *12 + (HH5M - monthsc) < 6)) schage =  (yearsc - HL5Y).
* if only years of member are known and survey was conducted half a year or later than the beginning of the school year.
if HL5Y >= 9998 and HL6 < 95 and ((HH5Y - yearsc) *12 + (HH5M - monthsc) >= 6) schage = HL6 - 1.
* if only years of member are known and survey was conducted 0 - 5 months before than the beginning of the school year.
if HL5Y >= 9998 and HL6 < 95 and ((HH5Y - yearsc) *12 + (HH5M - monthsc) < 6) schage = HL6.
* if a child is born after beginning of school year set value to 995.
if (schage < 0) schage = 995.

format schage (f3.0).
variable label schage "Age at beginning of school year".
value labels schage
995 "Child  born after beginning of school year"
998 "DK/Missing".
execute.

* Delete working variables.
delete variables  monthsc.
delete variables  yearsc.

*  Save household member data, which now contains the age at the beginning of school year.
save outfile = "hl.sav".

* Open the household member data file.
get file "hl.sav".

* melevel: create mother's education level. Delete the variable if already in the file.

delete variables melevel.

recode ED4A (1 = 2) (2,3 = 3) (8,9 = 9) (else = 1) into melevel.
variable label melevel "Mother's education".
value label melevel
  1 "None"
  2 "Primary"
  3 "Secondary +"
  5 "Mother not in household"
  9 "Missing/DK".
format melevel (f1.0).

*  Sort the cases by cluster number, household number and mother's line number.
sort cases by HH1 HH2 HL1.

* Save a mother's education file.
save outfile = 'tmpme.sav'
  /keep HH1 HH2 HL1 melevel
  /rename HL1 = mline.

* Open the household member data file.
get file "hl.sav".

* felevel: create father's education level. Delete the variable if already in the file.

delete variables felevel.

recode ED4A (1 = 2) (2,3 = 3) (8,9 = 9) (else = 1) into felevel.
variable label felevel "Father's education".
value label felevel
  1 "None"
  2 "Primary"
  3 "Secondary +"
  5 "Father not in household"
  9 "Missing/DK".
format felevel (f1.0).

* Sort the cases by cluster number, household number and father's line number.
sort cases by HH1 HH2 HL1.

* Save a father's education file.
save outfile = 'tmpfe.sav'
  /keep HH1 HH2 HL1 felevel
  /rename HL1 = fline.

* Open the household member data file.
get file = 'hl.sav'.


match files
  /file = *
  /table = 'tmpetn.sav'
  /by HH1 HH2.

save outfile = "hl.sav".

* Open the household member data file.
get file "hl.sav".

delete variables ethnicity.

* Sort the cases by cluster number, household number and mother's line number.
sort cases by HH1 HH2 mline.

* Merge the mother's education file onto the household listing file.
match files
  /file = *
  /table = 'tmpme.sav'
  /by HH1 HH2 mline.

* Recode mother's education level to deal with mothers who live elsewhere or are dead.
if (mline = 0) melevel = 5.

* Sort the cases by cluster number, household number and father's line number.
sort cases by HH1 HH2 fline.

* Merge the father's education file onto the household listing file.
match files
  /file = *
  /table = 'tmpfe.sav'
  /by HH1 HH2 fline.

* Recode father's education level to deal with fathers who live elsewhere or are dead.
if (fline = 0) felevel = 5.

* Sort the cases by cluster number and household number.
sort cases by HH1 HH2.

* Merge the household head file onto the household listing file.

match files
  /file = *
  /table = 'tmphe.sav'
  /by HH1 HH2.

* Sort the cases by cluster number, household number and line number.
sort cases by HH1 HH2 HL1 .

* Save the household listing data file.
save outfile = 'hl.sav'.


* Create background characteristics for women file: wm.sav.

* Open the women file.
get file ="wm.sav".

* melevel: calculate woman's education level.

delete variables welevel ethnicity.

recode WB4 (1 = 2) (2,3 = 3) (8,9 = 9) (else = 1) into welevel.
variable label welevel "Education".
value label welevel
  1 "None"
  2 "Primary"
  3 "Secondary +"
  9 "Missing/DK".
format welevel (f1.0).

* Reset variables for incomplete interviews.
do if (WM7 ~= 1).
+ recode welevel (lo thru hi=sysmis).
end if.

* Sort by cluster number and household number.
sort cases by HH1 HH2.

* Add ethnicity variable to women file.
match files
  /file = *
  /table = 'tmpetn.sav'
  /by HH1 HH2.

* Save the women's file.
save outfile = 'wm.sav'.

* Create temporary file with women education level.
get file "wm.sav".

sort cases by HH1 HH2 LN.

* Save a data file of women with IDs and education as only vars.
save outfile = 'tmpwe.sav'
  /keep HH1 HH2 LN welevel.

* Create background characteristics for children file: ch.sav.

* Open the children file.
get file ="ch.sav".

* melevel: calculate education level of mother.

delete variables melevel ethnicity.

recode ED4A (1 = 2) (2,3 = 3) (8,9 = 9) (else = 1) into melevel.
variable label melevel "Mother's education".
value label melevel
  1 "None"
  2 "Primary"
  3 "Secondary"
  9 "Missing/DK".
format melevel (f1.0).

* Sort by cluster number and household number.
sort cases by HH1 HH2.

* add ethnicity variable to children file.
match files
  /file = *
  /table = 'tmpetn.sav'
  /by HH1 HH2.

* Save the children's file.
save outfile = 'ch.sav'.

* Create background characteristics for ITN file: tn.sav.


* Open the ITN data file.
get file = 'tn.sav'.

delete variables helevel ethnicity.

* Sort the cases by cluster number and household number.
sort cases by HH1 HH2.

* Merge the household head education.
match files
  /file = *
  /table = 'tmphe.sav'
  /by HH1 HH2 .

* Merge the household head ethnicity.
match files
  /file = *
  /table = 'tmpetn.sav'
  /by HH1 HH2 .

* Save household data, which now contains the education of household head.
save outfile = 'tn.sav'.

* Create background characteristics for fgm file: fg.sav.

* Open the female genital cutting data file.
get file = 'fg.sav'.

delete variables welevel ethnicity.

* Sort the cases by cluster number and household number.
sort cases by HH1 HH2.

* Merge the household head ethnicity.
match files
  /file = *
  /table = 'tmpetn.sav'
  /by HH1 HH2.

* Resort cases.
sort cases by HH1 HH2 LN.

* Merge the women's education.
match files
  /file = *
  /table = 'tmpwe.sav'
  /by HH1 HH2 LN.

* Save fg data.
save outfile = 'fg.sav'.

* Create background characteristics for bh file: bn.sav.

* Open the birth history data file.
 * get file = 'bh.sav'.

* Sort the cases by cluster number and household number.
 * sort cases by HH1 HH2.

* Merge the household head ethnicity.
 * match files
  /file = *
  /table = 'tmpetn.sav'
  /by HH1 HH2 .

* Resort cases.
 * sort cases by HH1 HH2 LN.

* Merge the mother's education.
*match files
  /file = *
  /table = 'tmpwe.sav'
  /by HH1 HH2 LN.

* Save bh data, which now contains the education of household head.
 * save outfile = 'bh.sav'.

*erase the working files.
 erase file = 'tmphe.sav'.
 erase file = 'tmpetn.sav'.
 erase file = 'tmpme.sav'.
 erase file = 'tmpfe.sav'.
 erase file = 'tmpwe.sav'.

new file.

