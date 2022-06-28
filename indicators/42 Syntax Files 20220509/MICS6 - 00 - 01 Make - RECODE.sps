* Encoding: UTF-8.
***.

* 'recodeEthnicity': macro for recoding ethicity (language/religion) variables.

define recodeEthnicity ( inputEthnicity = !tokens(1) / outputEthnicity = !tokens(1)).

* !CUSTOMIZATION REQUIRED!.
recode !inputEthnicity (1=1) (2=2) (3=3) (96=7) (else = 9) into !outputEthnicity.
variable labels !outputEthnicity "Ethnicity of household head".
value labels !outputEthnicity
    1 "Group 1" 
    2 "Group 2" 
    3 "Group 3" 
    6 "Other ethnicity"  
    9 "Missing/DK".
formats  !outputEthnicity (f1.0).

* Reset variables for incomplete interviews.
if (HH46 ~= 1) !outputEthnicity = $SYSMIS .

* Check if variables are properly recoded, by cross tabulating recoded and original variable.
crosstabs !inputEthnicity by !outputEthnicity.

!enddefine.

*   'recodeEdu': macro for recoding education variables.

define recodeEdu ( inputEdu = !tokens(1) / outputEdu = !tokens(1)).

* Customize the education level categories. If different customization is required accorss different files, make sure to include separate recode statements for each separate scenario.
* !CUSTOMIZATION REQUIRED!.
recode !inputEdu (1 = 1) (2, 3, 4, 5 = 2) (8, 9 = 9) (else = 0) into !outputEdu.
variable labels !outputEdu "Education".
value labels !outputEdu
  0 "Pre-primary or none"
  1 "Primary"
  2 "Secondary + "
  9 "Missing/DK".
formats  !outputEdu (f1.0).

* Check if variables are properly recoded, by cross tabulating recoded and original variable.
crosstabs !inputEdu by !outputEdu.

!enddefine.

***.
*   'createSchage': macro for creating age at the begining of school year.

define createSchage (bMonth = !tokens(1) / bYear = !tokens(1) / age = !tokens(1) / sMonth = !tokens(1) / sYear = !tokens(1) ).

* !CUSTOMIZATION REQUIRED!.
* Set the month and year of the beginning of the school year in your country.
compute monthSc =  9.
compute yearSc =  2018.
variable labels monthSc "Month of beginning of the school year".
variable labels yearSc "Year of beginning of the school year".

compute schage = 998.
* if month and year of birth are valid.
if (!bMonth < 97  and !bYear < 9997) schage =  trunck ( (yearSc - !bYear)  + (monthSc - !bMonth) / 12).
* if month or year of birth infomration is missing, and survey was conducted half a year or later than the beginning of the school year.
if (!bMonth >= 97 or !bYear >= 9997) and !age < 95 and ((!sYear - yearSc) *12 + (!sMonth - monthSc) >= 6) schage = !age - 1.
* if month or year of birth infomration is missing, and survey was conducted 0 - 5 months before than the beginning of the school year.
if (!bMonth >= 97 or !bYear >= 9997) and !age < 95 and ((!sYear - yearSc) *12 + (!sMonth - monthSc) < 6) schage = !age.
* if a child is born after beginning of school year set value to 995.
if ( ((!bMonth < 97  and !bYear < 9997) and (yearSc - !bYear)  + (monthSc - !bMonth) / 12 < 0) or schage < 0) schage = 995.

formats schage (f3.0).
variable labels schage "Age at beginning of school year".
value labels schage
995 "Child  born after beginning of school year"
998 "DK/Missing".
execute.

* Delete working variables.
delete variables  monthSc.
delete variables  yearSc.

!enddefine.

*   'calcInsurance': macro for calculating insurance variable.

define calcInsurance ( inputInsurance = !tokens(1) / outputInsurance = !tokens(1)).

* !CUSTOMIZATION MAY BE REQUIRED!.
compute !outputInsurance = !inputInsurance.
variable labels !outputInsurance "Health insurance".
value labels !outputInsurance
 1 "With insurance"
 2 "Without insurance" 
 9 "Missing/DK".
formats  !outputInsurance (f1.0).
variable labels !outputInsurance "Health insurance".

* Check if variables are properly recoded, by cross tabulating recoded and original variable.
crosstabs !inputInsurance by !outputInsurance.

!enddefine.

*   'calcDisabilityWomen': macro for calculating functional difficulties for women. 

define calcDisabilityWomen (outputDisability = !tokens(1)).

* !CUSTOMIZATION MAY BE REQUIRED!.
* (AF6A/B=3 or 4 OR AF8A/B=3 or 4 OR AF9=3 or 4 OR AF10=3 or 4 OR AF11=3 or 4 OR AF12=3 or 4).
do if (WB4 >= 18).
compute !outputDisability = 2.
if (AF6 = 3 or AF6 = 4) !outputDisability = 1.
if (AF8 = 3 or AF8 = 4) !outputDisability = 1.
if (AF9 = 3 or AF9 = 4) !outputDisability = 1.
if (AF10 = 3 or AF10 = 4) !outputDisability = 1.
if (AF11 = 3 or AF11 = 4) !outputDisability = 1.
if (AF12 = 3 or AF12 = 4) !outputDisability = 1.
end if.
variable labels !outputDisability "Functional difficulties (age 18-49 years)".
value labels !outputDisability
 1 "Has functional difficulty"
 2 "Has no functional difficulty".
formats  !outputDisability (f1.0).

!enddefine.

*   'calcDisabilityMen': macro for calculating functional difficulties for men. 

define calcDisabilityMen (outputDisability = !tokens(1)).

* !CUSTOMIZATION MAY BE REQUIRED!.
do if (MWB4 >= 18).
compute !outputDisability = 2.
if (MAF6 = 3 or MAF6 = 4) !outputDisability = 1.
if (MAF8 = 3 or MAF8 = 4) !outputDisability = 1.
if (MAF9 = 3 or MAF9 = 4) !outputDisability = 1.
if (MAF10 = 3 or MAF10 = 4) !outputDisability = 1.
if (MAF11 = 3 or MAF11 = 4) !outputDisability = 1.
if (MAF12 = 3 or MAF12 = 4) !outputDisability = 1.
end if.
variable labels !outputDisability "Functional difficulties (age 18-49 years)".
value labels !outputDisability
 1 "Has functional difficulty"
 2 "Has no functional difficulty".
formats  !outputDisability (f1.0).

!enddefine.

*   'calcDisabilityU5': macro for calculating functional difficulties for children under 5. 

define calcDisabilityU5 (outputDisability = !tokens(1)).

* !CUSTOMIZATION MAY BE REQUIRED!.
*Seeing (UCF7A/B=3 or 4), Hearing (UCF9A/B=3 or 4).
*Walking (UCF11=3 or 4 OR UCF12=3 or 4 OR UCF13=3 or 4).
*Fine motor (UCF14=3 or 4), Communication.
*a) Understanding (UCF15=3 or 4) or b) Being understood (UCF16=3 or 4), Learning (UCF17=3 or 4), Playing (UCF18=3 or 4), Controlling behaviour (UCF19=5).

do if (UB2 >= 2).
compute !outputDisability = 2.
if (UCF7 = 3 or UCF7 = 4) !outputDisability = 1.
if (UCF9 = 3 or UCF9 = 4) !outputDisability = 1.
if (UCF11 = 3 or UCF11 = 4) !outputDisability = 1.
if (UCF12 = 3 or UCF12 = 4) !outputDisability = 1.
if (UCF13 = 3 or UCF13 = 4) !outputDisability = 1.
if (UCF14 = 3 or UCF14 = 4) !outputDisability = 1.
if (UCF15 = 3 or UCF15 = 4) !outputDisability = 1.
if (UCF16 = 3 or UCF16 = 4) !outputDisability = 1.
if (UCF17 = 3 or UCF17 = 4) !outputDisability = 1.
if (UCF18 = 3 or UCF18 = 4) !outputDisability = 1.
if (UCF19 = 5) !outputDisability = 1.
end if.
variable labels !outputDisability "Child's functional difficulties (age 2-4 years)".
value labels !outputDisability
 1 "Has functional difficulty"
 2 "Has no functional difficulty".
formats  !outputDisability (f1.0).

!enddefine.

*   'calcDisability517': macro for calculating functional difficulties for children age 5-17.

define calcDisability517 (outputDisability = !tokens(1)).

* !CUSTOMIZATION MAY BE REQUIRED!.
compute !outputDisability = 2.
if (FCF6 = 3 or FCF6 = 4) !outputDisability = 1.
if (FCF8 = 3 or FCF8 = 4) !outputDisability = 1.
if (FCF10 = 3 or FCF10 = 4) !outputDisability = 1.
if (FCF11 = 3 or FCF11 = 4) !outputDisability = 1.
*if (FCF12 = 3 or FCF12 = 4) !outputDisability = 1.
*if (FCF13 = 3 or FCF13 = 4) !outputDisability = 1.
if (FCF14 = 3 or FCF14 = 4) !outputDisability = 1.
if (FCF15 = 3 or FCF15 = 4) !outputDisability = 1.
if (FCF16 = 3 or FCF16 = 4) !outputDisability = 1.
if (FCF17 = 3 or FCF17 = 4) !outputDisability = 1.
if (FCF18 = 3 or FCF18 = 4) !outputDisability = 1.
if (FCF19 = 3 or FCF19 = 4) !outputDisability = 1.
if (FCF20 = 3 or FCF20 = 4) !outputDisability = 1.
if (FCF21 = 3 or FCF21 = 4) !outputDisability = 1.
if (FCF22 = 3 or FCF22 = 4) !outputDisability = 1.
if (FCF23 = 3 or FCF23 = 4) !outputDisability = 1.
if (FCF24 = 3 or FCF24 = 4) !outputDisability = 1.
if (FCF25 = 1) !outputDisability = 1.
if (FCF26 = 1) !outputDisability = 1.
variable labels !outputDisability "Child's functional difficulties (age 5-17years)".
value labels !outputDisability
 1 "Has functional difficulty"
 2 "Has no functional difficulty".
formats  !outputDisability (f1.0).

!enddefine.


