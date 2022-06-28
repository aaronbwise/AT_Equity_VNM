* Encoding: windows-1252.

* Generating age groups.
recode UB2 (0 thru 1 = 1) (2 thru 4 = 2) into ageGr.
variable labels ageGr 'Age'.
value labels ageGr 1 '0-1' 2 '2-4'.

* there is childAge6 that we could use? .
recode cage (lo thru 5 = 1) (6 thru 11 = 2) (12 thru 23 = 3) into ageCat.
variable labels ageCat "Age (in months)".
value labels ageCat 1 "0-5" 2 "6-11" 3 "12-23".

* Auxilary table variables .
recode cage (6, 7, 8 = 1) (9, 10, 11 = 2) (12 thru 17 = 3) (else = 4) into ageCatz.
variable labels ageCatz "Age (in months)".
value labels ageCatz 1 "6-8" 2 "9-11" 3 "12-17" 4 "18-23".
