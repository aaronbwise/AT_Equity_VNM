* v3 - 2014-08-19 .

*	SPSS syntax files for calculating and appending background variables to SPSS MICS data files
	This program should be run after the data sets have been exported from CSPro, and structural checks have been completed
	Usually, several runs of this program will be needed before the creation of background variables are finalized and merged to the data sets for good
	The data processing expert should check the frequency distribution of created variables
	With every run of the program, background variables will be replaced with the new values of the variables
	Added variables are: EDUCATION,  ETHNICITY/LANGUAGE/RELIGION and AGE AT THE BEGINING OF SCHOOL YEAR.




*  CREATE BACKGROUND CHARACTERISTICS TEMPORARY FILES .

* Open the household data file.
get file = 'hh.sav'.

* Delete variable if previously created.
delete variables ethnicity.

* Sort the cases by cluster number and household number.
sort cases by HH1 HH2.

* Customize the household head ethnicity/language/religion categories.
* Make sure to change HC1C variable below to reflect one background characteristic that will be used in your survey. 
recode HC1C (1 = 1) (2, 3 = 2) (4 =3) (8,9 = 9) into ethnicity.
variable labels ethnicity "Religion/Language/Ethnicity of household head".
value labels ethnicity
  1 "Group 1"
  2 "Group 2"
  3 "Group 3"
  9 "Missing/DK".
formats ethnicity (f1.0).

* Check if variables are properly recoded, by cross tabulating recoded and original variable.
crosstabs HC1C by ethnicity.

* Save data file of household heads with IDs and ethnicity as only variables.
save outfile = 'tmpEthnicity.sav'
  /keep HH1 HH2 ethnicity.
  
* ..also save the hh data file with ethinicity.
save outfile = 'hh.sav' .  

* Open the household listing data file.
get file = 'hl.sav'.

* Delete variables if previously created.
delete variables helevel melevel felevel.

* Sort the cases by cluster number, household number and line number.
sort cases by HH1 HH2 HL1.

* Customize the household head education level categories.
recode ED4A (1 = 2) (2 = 3) (3 = 4) (8,9 = 9) (else = 1) into helevel.
variable labels helevel "Education of household head".
value labels helevel
  1 "None"
  2 "Primary"
  3 "Secondary"
  4 "Higher"
  9 "Missing/DK".
formats helevel (f1.0).

* Check if variables are properly recoded, by cross tabulating recoded and original variable.
crosstabs ED4A by helevel.

* Filter household heads only.
compute headFilter = (HL3 = 1).
filter by headFilter .

* Save a data file of household heads with IDs and education as only vars.
save outfile = 'tmphelevel.sav'
  /unselected = delete
  /keep HH1 HH2 helevel.

filter off.
  
* Melevel: create mother education level tmp file.
* allow for code 5 - cases when mother is not in household.
recode ED4A (1 = 2) (2 = 3) (3 = 4) (8,9 = 9) (else = 1) into melevel.
variable labels melevel "Mother's education".
value labels melevel
  1 "None"
  2 "Primary"
  3 "Secondary"
  4 "Higher"
  5 "Cannot be determined"
  9 "Missing/DK".
formats melevel (f1.0).

* Check if variables are properly recoded, by cross tabulating recoded and original variable.
crosstabs ED4A by melevel.

* Save a mother's education file.
save outfile = 'tmpmelevel.sav'
  /keep HH1 HH2 HL1 melevel
  /rename HL1 = mline.
  
* felevel: create father's education level tmp file .
* same as in the case of mothers education allow for code 5 - cases when father is not in the household.
recode ED4A  (1 = 2) (2 = 3) (3 = 4) (8,9 = 9) (else = 1) into felevel.
variable labels felevel "Father's education".
value labels felevel
  1 "None"
  2 "Primary"
  3 "Secondary"
  4 "Higher"
  5 "Father not in household"
  9 "Missing/DK".
formats felevel (f1.0).

* Check if variables are properly recoded, by cross tabulating recoded and original variable.
crosstabs ED4A by felevel.

* Save a father's education file.
save outfile = 'tmpfelevel.sav'
  /keep HH1 HH2 HL1 felevel
  /rename HL1 = fline.
  
   
* MERGE BACGROUND VARIABLES FROM TMP FILES .


* Open the household data file.
get file = 'hh.sav'.

* ethinicity already created .
delete variables helevel .

* Merge the household head education file onto the household file.
match files
  /file = *
  /table = 'tmphelevel.sav'
  /by HH1 HH2 .

* Save the hh data file with ethinicity and education of hh head.
save outfile = 'hh.sav' .

new file.

* Open the household members data file.
get file = 'hl.sav'.

* Sort the cases by cluster number, household number and line number.
sort cases by HH1 HH2 HL1.

* delete variables if already existing.
delete variables ethnicity helevel melevel felevel schage.

* Merge the household head ethnicity file onto the household listing file.
match files
  /file = *
  /table = 'tmpEthnicity.sav'
  /by HH1 HH2 .
  
* Merge the household head education file onto the household listing file.
match files
  /file = *
  /table = 'tmphelevel.sav'
  /by HH1 HH2 .

* Sort the cases by cluster number, household number and mother's line number.
sort cases by HH1 HH2 mline.

* Merge the mother's education file onto the household listing file.
match files
  /file = *
  /table = 'tmpmelevel.sav'
  /by HH1 HH2 mline.

* Recode mother's education level to deal with mothers who live elsewhere or are dead.
if (mline = 0) melevel = 5.

* Sort the cases by cluster number, household number and father's line number.
sort cases by HH1 HH2 fline.

* Merge the father's education file onto the household listing file.
match files
  /file = *
  /table = 'tmpfelevel.sav'
  /by HH1 HH2 fline.

* Recode father's education level to deal with fathers who live elsewhere or are dead.
if (fline = 0) felevel = 5.

* Set the month and year of the beginning of the school year in your country.
compute monthSc =  9.
compute yearSc =  2013.
variable labels monthSc "Month of beginning of the school year".
variable labels yearSc "Year of beginning of the school year".

compute schage = 998.
* if month and year of birth are valid.
if (HL5M < 98   and HL5Y < 9998) schage = trunck ( (yearSc - HL5Y)  + (monthSc - HL5M) / 12).
* if only year of birth is valid and survey is conducted half a year or later than the beginning of the school year.
if ((HL5M >= 98 and HL5Y < 9998) and ((HH5Y - yearSc) *12 + (HH5M - monthSc) >= 6)) schage =  (yearSc - HL5Y)  - 1.
* if only year of birth is valid and survey is conducted half a year or later than the beginning of the school year.
if ((HL5M >= 98 and HL5Y < 9998) and ((HH5Y - yearSc) *12 + (HH5M - monthSc) < 6)) schage =  (yearSc - HL5Y).
* if only years of member are known and survey was conducted half a year or later than the beginning of the school year.
if HL5Y >= 9998 and HL6 < 95 and ((HH5Y - yearSc) *12 + (HH5M - monthSc) >= 6) schage = HL6 - 1.
* if only years of member are known and survey was conducted 0 - 5 months before than the beginning of the school year.
if HL5Y >= 9998 and HL6 < 95 and ((HH5Y - yearSc) *12 + (HH5M - monthSc) < 6) schage = HL6.
* if a child is born after beginning of school year set value to 995.
if (schage < 0) schage = 995.

formats schage (f3.0).
variable labels schage "Age at beginning of school year".
value labels schage
995 "Child  born after beginning of school year"
998 "DK/Missing".
execute.

* Delete working variables.
delete variables  monthSc.
delete variables  yearSc.

* Sort the cases by cluster number, household number and line number.
sort cases by HH1 HH2 HL1 .

* Save the household listing data file.
save outfile = 'hl.sav'.

new file .
  

  
* Open the women file.
get file ="wm.sav".

* welevel: calculate woman's education level.

delete variables welevel ethnicity.

recode WB4 (1 = 2) (2 = 3) (3 = 4) (8,9 = 9) (else = 1) into welevel.
variable labels welevel "Education".
value labels welevel
  1 "None"
  2 "Primary"
  3 "Secondary"
  4 "Higher"
  9 "Missing/DK".
format welevel (f1.0).

* Reset variables for incomplete interviews.
if (WM7 ~= 1) welevel = $SYSMIS .

* Sort by cluster number and household number.
sort cases by HH1 HH2 LN.

* Add ethnicity variable to women file.
match files
  /file = *
  /table = 'tmpEthnicity.sav'
  /by HH1 HH2.

* Save the women's file.
save outfile = 'wm.sav'.

* Save a data file of women with IDs and education as only vars.
save outfile = 'tmpwelevel.sav'
  /keep HH1 HH2 LN welevel.

new file.

* Open the men file.
get file ="mn.sav".

* mwelevel: calculate man's education level.
delete variables mwelevel ethnicity.

recode MWB4 (1 = 2) (2 = 3) (3 = 4) (8,9 = 9) (else = 1) into mwelevel.
variable labels mwelevel "Education".
value labels mwelevel
  1 "None"
  2 "Primary"
  3 "Secondary"
  4 "Higher"
  9 "Missing/DK".
format mwelevel (f1.0).

* Reset variables for incomplete interviews.
if (MWM7 ~= 1) mwelevel = $SYSMIS .

* Sort by cluster number and household number.
sort cases by HH1 HH2 LN.

* Add ethnicity variable to men file.
match files
  /file = *
  /table = 'tmpEthnicity.sav'
  /by HH1 HH2.

* Save the men's file.
save outfile = 'mn.sav'.

new file .
  
  
*** Open the children file.
get file ="ch.sav".

* melevel: calculate education level of mother.
delete variables melevel ethnicity.

* mother education from ED4A that was mergend during the export .
recode ED4A (1 = 2) (2 = 3) (3 = 4) (8,9 = 9) (else = 1) into melevel.
variable labels melevel "Mother's education".
value labels melevel
  1 "None"
  2 "Primary"
  3 "Secondary"
  4 "Higher"
  9 "Missing/DK".
formats melevel (f1.0).

* Sort by cluster number and household number, and line number.
sort cases by HH1 HH2 LN.

* add ethnicity variable to children file.
match files
  /file = *
  /table = 'tmpEthnicity.sav'
  /by HH1 HH2.

* Save the children's file.
save outfile = 'ch.sav'.

new file .


* Open the ITN data file.
get file = 'tn.sav'.

delete variables helevel ethnicity.

* Sort the cases by cluster number and household number.
sort cases by HH1 HH2.

* Merge the household head education.
match files
  /file = *
  /table = 'tmphelevel.sav'
  /by HH1 HH2 .

* Merge the household head ethnicity.
match files
  /file = *
  /table = 'tmpEthnicity.sav'
  /by HH1 HH2 .

* Save household data, which now contains the education of household head.
save outfile = 'tn.sav'.




* Open the female genital cutting data file.
get file = 'fg.sav'.

delete variables welevel ethnicity.

* Sort the cases by cluster number and household number.
sort cases by HH1 HH2 LN.

* Merge the household head ethnicity.
match files
  /file = *
  /table = 'tmpEthnicity.sav'
  /by HH1 HH2.

* Merge the women's education.
match files
  /file = *
  /table = 'tmpwelevel.sav'
  /by HH1 HH2 LN.

* Save fg data.
save outfile = 'fg.sav'.

new file .


* Open the birth history data file.
get file = 'bh.sav'.

delete variables welevel ethnicity brthord magebrt birthint.
* Sort the cases by cluster number and household number.
sort cases by HH1 HH2 LN BHLN.

* Merge the household head ethnicity.
match files
  /file = *
  /table = 'tmpEthnicity.sav'
  /by HH1 HH2 .

* Merge the mother's education.
match files
  /file = *
  /table = 'tmpwelevel.sav'
  /by HH1 HH2 LN.

* Create birth order, birth interval and mother's age at birth variables.
sort cases by HH1 HH2 LN BHLN.

recode BHLN (1 = 1) (2,3 = 2) (4,5,6 = 3) (else = 4) into brthord.
compute magebrt = BH4C - WDOB.
recode magebrt (lo thru 239 = 1) (240 thru 419 = 2) (420 thru hi = 3).

* Not twin and not first.
if (BH4C <> lag(BH4C) and BHLN > 1) birthint = BH4C - lag(BH4C).
* Twin and not first.
if (BH4C = lag(BH4C) and BH4C <> lag(BH4C,2) and BHLN > 2) birthint = BH4C - lag(BH4C,2).
* Triplet and not first.
if (BH4C = lag(BH4C) and BH4C = lag(BH4C,2) and BH4C <> lag(BH4C,3) and BHLN > 3) birthint = BH4C - lag(BH4C,3).
recode birthint (sysmis=0) (lo thru 23=1) (24 thru 35=2) (36 thru 47=3) (48 thru hi=4).

variable labels 
  brthord 'Birth order'
 /magebrt "Mother's age at birth"
 /birthint "Previous birth interval".
value labels
  brthord 1 '1' 2 '2-3' 3 '4-6' 4 '7+'
 /magebrt 1 '<20' 2 '20-34' 3 '35+'
 /birthint 0 'First birth' 1 '<2 years' 2 '2 years' 3 '3 years' 4 '4+ years'.

* Save bh data, which now contains new variables .
save outfile = 'bh.sav'.



* Open the maternal mortality data file.
get file = 'mm.sav'.

delete variables welevel ethnicity.

* Sort the cases by cluster number and household number.
sort cases by HH1 HH2 LN.

* Merge the household head ethnicity.
match files
  /file = *
  /table = 'tmpEthnicity.sav'
  /by HH1 HH2.

* Merge the women's education.
match files
  /file = *
  /table = 'tmpwelevel.sav'
  /by HH1 HH2 LN.

* Save maternal mortality data.
save outfile = 'mm.sav'.

new file .


*erase the working files.
erase file = 'tmphelevel.sav'.
erase file = 'tmpEthnicity.sav'.
erase file = 'tmpmelevel.sav'.
erase file = 'tmpfelevel.sav'.
erase file = 'tmpwelevel.sav'.

new file.

