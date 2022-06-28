* Encoding: windows-1252.


*********** calculating number of completed individuals.

* Open women file.
get file = "wm.sav".

* Commented out as variable HH49 is created in CSPro.
*compute HH49 = 1.
*variable labels HH49 "Number of women 15 - 49 years".
compute HH53 = 0.
if (WM17 = 1) HH53 = 1.
variable labels HH53 "Number of woman' questionnaires completed".

aggregate outfile = "women.sav"
 /break = HH1 HH2
 /HH53 = sum(HH53).

new file.

* Open men file.
get file = "mn.sav".

* Commented out as variable HH50 is created in CSPro.
*compute HH50 = 1.
*variable labels HH50 "Number of men 15 - 49 years [If household is selected for Questionnaire for Men]".

compute HH54 = 0.
if (MWM17 = 1) HH54 = 1.
variable labels HH54 "Number of man' questionnaires completed [If household is selected for Questionnaire for Men]".

aggregate outfile = "men.sav"
 /break = HH1 HH2
 /HH54 = sum(HH54).

new file.

* Open household listing file.
get file = "hl.sav".

* Add number of men in all interviewed households, regardless if household was selected for Questionnaire for Men. This variable is required for sample weights calculations.
compute HH50A = 0.
if (HL4 = 1 and HL6 >= 15 and HL6 <= 49) HH50A = 1.
variable labels HH50A "Number of men 15 - 49 years in interviewed households".

aggregate outfile = "menall.sav"
 /break = HH1 HH2
 /HH50A = sum(HH50A).

new file.

* Open u5 file.
get file = "ch.sav".

* Commented out as variable HH51 is created in CSPro.
*compute HH51 = 1.
*variable labels HH51 "Number of children under age 5".
compute HH55 = 0.
if (UF17 = 1) HH55 = 1.
variable labels HH55 "Number of under - 5 questionnaires completed".

aggregate outfile = "u5.sav"
 /break = HH1 HH2
 /HH55 = sum(HH55).

new file.

* Open children file.
get file = "fs.sav".

* Commented out as variable HH52 is created in CSPro, and it calculates total number of all children 5-17 in the households, not number of selected children.
* variable labels HH52 "Number of children age 5-17".
compute HH56 = 0.
if (FS17 = 1) HH56 = 1.
variable labels HH56 "Number of CF questionnaires completed (age 5-17)".

aggregate outfile = "children.sav"
 /break = HH1 HH2
 /HH56 = sum(HH56).

new file.

* Merge with household data file.

* Open the household data file.
get file = 'hh.sav'.

* Delete variable if previously created (for total number of men in all households, as well as number of completed questionnaires).
delete variables HH50A HH53 HH54 HH55 HH56.

sort cases by HH1 HH2.

match files
  /file = *
  /table = "women.sav"
  /table = "men.sav"
  /table = "menall.sav"
  /table = "u5.sav"
  /table = "children.sav"
  /by HH1 HH2.

do if (HH46 = 1).
do if (sysmis(HH50A)).
compute HH50A = 0.
end if.
do if (sysmis(HH53)).
compute HH53 = 0.
end if.
do if (sysmis(HH54)).
compute HH54 = 0.
end if.
do if (sysmis(HH55)).
compute HH55 = 0.
end if.
do if (sysmis(HH56)).
compute HH56 = 0.
end if.
end if.
variable labels HH50A "Number of men 15 - 49 years in interviewed households".
variable labels HH53 "Number of woman' questionnaires completed".
variable labels HH54 "Number of man' questionnaires completed [If household is selected for Questionnaire for Men]".
variable labels HH55 "Number of under - 5 questionnaires completed".
variable labels HH56 "Number of CF questionnaires completed (age 5-17)".
formats HH49
HH50A
HH53
HH54
HH55
HH56 (f2.0). 

save outfile = 'hh.sav' .  

new file.

*erase the working files.
erase file 'women.sav'.
erase file 'men.sav'.
erase file 'menall.sav'.
erase file 'u5.sav'.
erase file 'children.sav'.

new file.