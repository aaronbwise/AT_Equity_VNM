* Encoding: UTF-8.
* v-2018-11-26 .
* v-2020-07-14: Several changes made in line with the new version of tab plan. 
*                      Re-structuring of the file, most of the recoding statements has been moved to MICS6 - 00 - 01 Make - RECODE.sps.
*v-2021-04-09: line 433 corrected to:if (FS17 ~= 1) fsinsurance = $SYSMIS .
*v-2021-11-18: sYear = HL5Y corrected in line: createSchage bMonth = HL5M bYear = HL5Y age = HL6 sMonth = HH5M sYear = HH5Y.

********************************************************************************************************************************************************************************************************.
********************************************************************************************************************************************************************************************************.
********************************************************************************************************************************************************************************************************.

*	SPSS syntax files for calculating and appending background variables to SPSS MICS data files
	This program should be run after the data sets have been exported from CSPro, and structural checks have been completed
	Usually, several runs of this program will be needed before the creation of background variables are finalized and merged to the data sets for good
	The data processing expert should check the frequency distribution of created variables
	With every run of the program, background variables will be replaced with the new values of the variables

*                 Following background characteristics are produced:
*                                    Ethnicity of household head ETHNICITY: added to all analysis files
                                     Note: Additionally, a socio-cultural background characteristic can be developed, 
                                     if appropriate, from a combination of questions HC1A, HC1B and HC2 that best describes the main socio-cultural or ethnic groups in the country

*                                    Education of household head HELEVEL: added to hh.sav, hl.sav and tn.sav
                                     Education of individual women WELEVEL (added to wm.sav bh.sav,fg.sav, and mm.sav), men MWELEVEL (added to mn.sav) and FSELEVEL children 5-17 (added to fs.sav).
*                                    Education of mother/caretaker MELEVEL (added to hl.sav, fs.sav and ch.sav).
*                                    Education of natural father FELEVEL (added to hl.sav).

*                                    Age at the beginning of school year SCHAGE: added to hl.sav and fs.sav

*                                    Health insurance of individual women INSURANCE (added to wm.sav bh.sav,fg.sav, and mm.sav), 
                                     men MINSURANCE (added to mn.sav), children under 5 CINSURANCE (added to ch.sav), and children 5-17 FSINSURANCE (added to fs.sav).

*                                    Disability of individual women (18-49) DISABILITY (added to wm.sav bh.sav,fg.sav, and mm.sav), men (18-49) MDISABILITY (added to mn.sav), 
                                     children 2-4 years CDISABILITY (added to ch.sav), and children 5-17 FSDISABILITY (added to fs.sav).

*                                    Disability of mother/caretaker CARETAKERDIS (added to hl.sav, ch.sav and fs.sav)

*                                    Birth order BRTHORD: added to bh.sav

*                                    Mother’s age at birth MAGEBRT: added to bh.sav

*                                    Birth interval BIRTHINT: added to bh.sav



* Call macro for creation of recoded categories. 
insert file = "MICS6 - 00 - 01 Make - RECODE.sps".

*  CREATE BACKGROUND CHARACTERISTICS TEMPORARY FILES.

********************************************************************************************************************************************************************************************************.
***
*   tmpEthnicity.sav: stores unique identifiers and recoded ethnicity variable.
***

* Open the household data file.
get file = 'hh.sav'.

sort cases by HH1 HH2.

* Delete previously created variables.
delete variables ethnicity.

recodeEthnicity inputEthnicity = HC2 outputEthnicity = ethnicity.

save outfile = tmpEthnicity.sav 
  /keep HH1 HH2 ethnicity.

new file.

***
* tmphelevel.sav: stores unique identifiers and education of household head.
* tmpmelevel.sav: stores unique identifiers and mother's/caretakers education.
* tmpfelevel.sav: stores unique identifiers and education of natural father.
***

* Open the household listing data file.
get file = 'hl.sav'.

* Sort the cases by cluster number, household number and line number.
sort cases by HH1 HH2 HL1.

* Delete previously created variables.
delete variables helevel melevel felevel.

* Recode education.
recodeEdu inputEdu = ED5A outputEdu = helevel.
variable labels helevel "Education of household head".

* Check if variables are properly recoded, by cross tabulating recoded and original variable.
crosstabs ED5A by helevel.

* Filter household heads only.
compute headFilter = (HL3 = 1).
filter by headFilter .

* Save a data file of household heads with IDs and education as only vars.
save outfile = 'tmphelevel.sav'
  /unselected = delete
  /keep HH1 HH2 helevel.

filter off.
  
* Melevel: create mother education level tmp file.
recodeEdu inputEdu = ED5A outputEdu = melevel.
variable labels melevel "Mother’s education".

* Check if variables are properly recoded, by cross tabulating recoded and original variable.
crosstabs ED5A by melevel.

* Save a mother's education file.
save outfile = 'tmpmelevel.sav'
  /keep HH1 HH2 HL1 melevel
  /rename HL1 = mline.
  
* felevel: create father's education level tmp file .
recodeEdu inputEdu = ED5A outputEdu = felevel.
variable labels felevel "Father's education".

* Check if variables are properly recoded, by cross tabulating recoded and original variable.
crosstabs ED5A by felevel.

* Save a father's education file.
save outfile = 'tmpfelevel.sav'
  /keep HH1 HH2 HL1 felevel
  /rename HL1 = fline.

new file.


***
*   tmpCaretakerDis.sav: stores unique identifiers and information on mother's/caretaker's functional difficulties.
***.

* Calculate functional difficulties from women file.
get file = "wm.sav".

* Delete previously created variables.
delete variables disability.

calcDisabilityWomen outputDisability = disability.
if (WM17 ~= 1) disability = $SYSMIS .

* save unique identifiers and functional difficulties from women.
save outfile = "tmpWMDis.sav" /keep HH1 HH2 LN disability /rename disability = caretakerdis.

new file.


* Calculate functional difficulties from men file.
get file = "mn.sav".

* Delete previously created variables.
delete variables mdisability.

calcDisabilityMen outputDisability = mdisability.
if (MWM17 ~= 1) mdisability = $SYSMIS .

* save unique identifiers and functional difficulties from women.
save outfile = "tmpMNDis.sav" /keep HH1 HH2 LN mdisability /rename mdisability = caretakerdis.

new file.

* create one file from women and men related information.
get file =  "tmpWMDis.sav".
add files 
/file=*
/file="tmpMNDis.sav" .

sort cases by HH1 HH2 LN.

* create copies of LN variables for easier merge to HL.sav, CH.sav and FS.sav.
compute MLINE = LN.
compute UF4 = LN.
compute FS4 = LN.

save outfile = "tmpCaretakerDis.sav".



  
*  ADD BACKGROUND CHARACTERISTICS TO ANALYSIS FILES, BY MERGING THEM FROM THE TMP FILES OR CALLING RECODE MACROS.

********************************************************************************************************************************************************************************************************.
***.
********************************************************************************       HH.sav      *****************************************************************************************************.

* Open the household data file.
get file = 'hh.sav'.

sort cases by hh1 hh2.

* Delete previously created variables.
delete variables ethnicity helevel.

* Merge ethnicity of the household head onto the household file.
match files
  /file = *
  /table = 'tmpEthnicity.sav'
  /by HH1 HH2 .

* Merge the household head education file onto the household file.
match files
  /file = *
  /table = 'tmphelevel.sav'
  /by HH1 HH2 .

* Save the hh data file with ethinicity and education of hh head.
save outfile = 'hh.sav' .

new file.

********************************************************************************       HL.sav      *****************************************************************************************************.

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

* Merge the caretakers functional difficulty onto the household listing file.
match files
  /file = *
  /table = 'tmpCaretakerDis.sav'
  /by HH1 HH2 mline.

* delete unnecessery variables UF4 and FS4 added through the merge with tmpCaretakerDis.sav.
execute.
delete variables UF4 FS4.

* Sort the cases by cluster number, household number and father's line number.
sort cases by HH1 HH2 fline.

* Merge the father's education file onto the household listing file.
match files
  /file = *
  /table = 'tmpfelevel.sav'
  /by HH1 HH2 fline.

* Add category for cases when biological father is not in the household.
if (FLINE = 0) felevel = 5.
add value labels felevel 5 "Biological father not in the household".

* create age at the begining of school year.
createSchage bMonth = HL5M bYear = HL5Y age = HL6 sMonth = HH5M sYear = HH5Y.

* Sort the cases by cluster number, household number and line number.
sort cases by HH1 HH2 HL1 .

* Save the household listing data file.
save outfile = 'hl.sav'.

new file .

********************************************************************************       WM.sav      *****************************************************************************************************.

* Open the women file.
get file ="wm.sav".

* delete variables if already existing.
delete variables ethnicity welevel insurance disability.

* welevel: calculate woman's education level.
recodeEdu inputEdu = WB6A outputEdu = welevel.
variable labels welevel "Education".

* insurance: indicator if woman has health insurance.
calcInsurance inputInsurance = WB18 outputInsurance = insurance.

* disability: calculate woman's functional difficulties.
calcDisabilityWomen outputDisability = disability.

* Reset variables for incomplete interviews.
if (WM17 ~= 1) welevel = $SYSMIS .
if (WM17 ~= 1) disability = $SYSMIS .
if (WM17 ~= 1) insurance = $SYSMIS .

* Sort by cluster number and household number.
sort cases by HH1 HH2 LN.
* add ethnicity of household head to woman's file.
match files
  /file = *
  /table = 'tmpEthnicity.sav'
  /by HH1 HH2.

* Save the women's file.
save outfile = 'wm.sav'.

* Save a data file of women with IDs and background variables, so that they can be added to bh.sav, fg.sav and mm.sav.
save outfile = 'tmpWomenBck.sav'
  /keep HH1 HH2 LN welevel insurance disability.

new file.


********************************************************************************       MN.sav      *****************************************************************************************************.

* Open the men file.
get file ="mn.sav".

* delete variables if already existing.
delete variables ethnicity mwelevel minsurance mdisability.

* mwelevel: calculate man's education level.
recodeEdu inputEdu = MWB6A outputEdu = mwelevel.
variable labels mwelevel "Education".

* insurance: indicator if man has health insurance.
calcInsurance inputInsurance = MWB18 outputInsurance = minsurance.

* disability: calculate woman's functional difficulties.
calcDisabilityMen outputDisability = mdisability.

* Reset variables for incomplete interviews.
if (MWM17 ~= 1) mwelevel = $SYSMIS .
if (MWM17 ~= 1) mdisability = $SYSMIS .
if (MWM17 ~= 1) minsurance = $SYSMIS .

* Sort by cluster number and household number.
sort cases by HH1 HH2 LN.
* add ethnicity variable to man file.
match files
  /file = *
  /table = 'tmpEthnicity.sav'
  /by HH1 HH2.

* Save the men's file.
save outfile = 'mn.sav'.

new file .
  
********************************************************************************       CH.sav      *****************************************************************************************************.

*** Open the children file.
get file ="ch.sav".

* delete variables if already existing.
delete variables ethnicity melevel cinsurance cdisability caretakerdis.

* melevel: mother education level is calculated using variable ED5A that was added to the ch.sav during export.
recodeEdu inputEdu = ED5A outputEdu = melevel.
variable labels melevel "Mother's education".

* insurance: indicator if chid has health insurance.
calcInsurance inputInsurance = UB9 outputInsurance = cinsurance.

* disability: calculate under 5's functional difficulties.
calcDisabilityU5 outputDisability = cdisability.

* Reset variables for incomplete interviews.
if (UF17 ~= 1) cdisability = $SYSMIS .
if (UF17 ~= 1) cinsurance = $SYSMIS .

* Sort by cluster number and household number, and line number.
sort cases by HH1 HH2 LN.
* add ethnicity variable to children file.
match files
  /file = *
  /table = 'tmpEthnicity.sav'
  /by HH1 HH2.

* Merge the caretakers functional difficulty onto the ch.sav file.
sort cases by HH1 HH2 UF4.
match files
  /file = *
  /table = 'tmpCaretakerDis.sav'
  /by HH1 HH2 UF4.

* delete unnecessery variables MLINE and FS4 added through the merge with tmpCaretakerDis.sav.
execute.
delete variables MLINE FS4.

sort cases by HH1 HH2 LN.

* Save the children's file.
save outfile = 'ch.sav'.

new file .

********************************************************************************       FS.sav      *****************************************************************************************************.
  
*** Open the 5-17 file.
get file ="fs.sav".

* delete variables if already existing.
delete variables ethnicity fselevel schage fsinsurance fsdisability melevel caretakerdis.

* melevel: mother education level is calculated using variable ED5A that was added to the ch.sav during export.
recodeEdu inputEdu = ED5A outputEdu = melevel.
* Latest updated of tab plan (for children who are considered emancipated, there should be no information on mother's education).
if FS4 = 90 melevel = $SYSMIS.
variable labels melevel "Mother's education".

* fselevel: calculate education level of  5-17 year old.
recodeEdu inputEdu = CB5A outputEdu = fselevel.
variable labels fselevel "Child's education".

* create age at the begining of school year.
createSchage bMonth = CB2M bYear = CB2Y age = CB3 sMonth = FS7M sYear = FS7Y.

* insurance: indicator if  5-17 year old has health insurance.
calcInsurance inputInsurance = CB11 outputInsurance = fsinsurance.

* disability: calculate 5-17's functional difficulties.
calcDisability517 outputDisability = fsdisability.

* Reset variables for incomplete interviews.
if (FS17 ~= 1) fselevel = $SYSMIS .
if (FS17 ~= 1) fsdisability = $SYSMIS .
if (FS17 ~= 1) fsinsurance = $SYSMIS .

* Sort by cluster number and household number, and line number.
sort cases by HH1 HH2 LN.
* add ethnicity variable to children file.
match files
  /file = *
  /table = 'tmpEthnicity.sav'
  /by HH1 HH2.

* Merge the caretakers functional difficulty onto the ch.sav file.
sort cases by HH1 HH2 FS4.
match files
  /file = *
  /table = 'tmpCaretakerDis.sav'
  /by HH1 HH2 FS4.

* delete unnecessery variables MLINE and UF4 added through the merge with tmpCaretakerDis.sav.
execute.
delete variables MLINE UF4.

sort cases by HH1 HH2 LN.

* Save the children's file.
save outfile = 'fs.sav'.

new file .

********************************************************************************       TN.sav      *****************************************************************************************************.

* Open the ITN data file.
get file = 'tn.sav'.

* delete variables if already existing.
delete variables ethnicity helevel.

* Sort the cases by cluster number and household number.
sort cases by HH1 HH2.

* Merge the household head ethnicity.
match files
  /file = *
  /table = 'tmpEthnicity.sav'
  /by HH1 HH2 .

* Merge the household head education.
match files
  /file = *
  /table = 'tmphelevel.sav'
  /by HH1 HH2 .

* Save household data, which now contains the education of household head.
save outfile = 'tn.sav'.


********************************************************************************       BH.sav      *****************************************************************************************************.

* Open the birth history data file.
get file = 'bh.sav'.

* delete variables if already existing.
delete variables BHLN ethnicity welevel insurance disability brthord magebrt birthint.

* Create variable BHLN.
compute BHLN=BH0.
apply dictionary from *
 /source variables=BH0
 /target variables=BHLN.

* Sort the cases by cluster number and household number.
sort cases by HH1 HH2 LN BHLN.

* Merge the household head ethnicity.
match files
  /file = *
  /table = 'tmpEthnicity.sav'
  /by HH1 HH2 .

* Merge the mother's background characteristics.
match files
  /file = *
  /table = 'tmpWomenBck.sav'
  /by HH1 HH2 LN.

* Create birth order, birth interval and mother's age at birth variables.
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

new file.

********************************************************************************       FG.sav      *****************************************************************************************************.

* Open the female genital cutting data file.
get file = 'fg.sav'.

* delete variables if already existing.
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

********************************************************************************       MM.sav      *****************************************************************************************************.

* Open the maternal mortaility data file.
get file = 'mm.sav'.

* delete variables if already existing.
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

* Save mm data.
save outfile = 'mm.sav'.

new file .

*******************************************************************************************************************************************************************************************************.


*erase the working files.
erase file = 'tmpEthnicity.sav'.
erase file = 'tmpmelevel.sav'.
erase file = 'tmpfelevel.sav'.
erase file = 'tmphelevel.sav'.
erase file = 'tmpWomenBck.sav'.
erase file = "tmpWMDis.sav".
erase file = "tmpMNDis.sav".
erase file = "tmpCaretakerDis.sav".
