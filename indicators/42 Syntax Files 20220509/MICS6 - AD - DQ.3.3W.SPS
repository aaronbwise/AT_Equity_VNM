* Encoding: windows-1252.

***.
* v02 - 2020-04-14. Labels in French and Spanish have been removed.

get file = 'wm.sav'.

select if (WM17 = 1).

weight by wmweight.

do if (sysmis(MA5) or MA5 <> 3).

compute layer1 = 0.
variable labels layer1 "".
value labels layer1 0 "Ever married (age 15-49 years)".

+ compute mmfm = 0.
+ compute mwmfm   = 0.
+ compute mwyfm = 0.
+ if (MA8M >= 97 and MA8Y < 9997) mwmfm = 100.  
+ if (MA8M >= 97 and MA8Y >= 9997) mwyfm = 100.  
+ if (MA8M >= 97 or MA8Y >= 9997) mmfm = 100.
+ recode MA11 (97,98,99 = 100) (else = 0) into agefm.

end if.

variable labels mmfm "Date of first marriage/union missing".
variable labels mwmfm "Only month missing".
variable labels mwyfm "Both month and year missing".
variable labels agefm "Age at first marriage/union missing".

do if (WB4 >= 15 and WB4 <= 49 and SB1 <> 0).

compute layer2 = 0.
variable labels layer2 "".
value labels layer2 0 "Ever had sex (age 15-49 years)".

+ compute agefi = 0.
+ compute timesli = 0.
+ recode SB1 (97,98,99 = 100) (else = 0) into agefi.  
+ if (SB1 = 95 and MA11 >= 97) agefi = 100.
+ recode SB2N (97,98,99 = 100) (sysmis = copy) (else = 0) into timesli.  

end if.

variable labels agefi "Age at first intercourse missing".
variable labels timesli "Time since last intercourse missing".

do if (WB4 >= 15 and WB4 <= 24 and SB1 <> 0).

compute layer3 = 0.
variable labels layer3 "".
value labels layer3 0 "Ever had sex (age 15-24 years)".

+ compute Yagefi = 0.
+ compute Ytimesli = 0.
+ recode SB1 (97,98,99 = 100) (else = 0) into Yagefi.  
+ if (SB1 = 95 and MA11 >= 97) Yagefi = 100.
+ recode SB2N (97,98,99 = 100) (sysmis = copy) (else = 0) into Ytimesli.  

end if.

variable labels Yagefi "Age at first intercourse missing".
variable labels Ytimesli "Time since last intercourse missing".

* Ctables command in English.
ctables
  /vlabels variables = layer1 layer2 layer3 display = none
  /table 
  layer1 [c] > 
  (mmfm[s][mean ,'Percent with missing/ incomplete information[A]',F5.1,validn ,'Number of women',F5.0]+
  mwmfm[s][mean ,'Percent with missing/ incomplete information[A]',F5.1,validn ,'Number of women',F5.0]+
  mwyfm[s][mean ,'Percent with missing/ incomplete information[A]',F5.1,validn ,'Number of women',F5.0])+
  agefm[s][mean ,'Percent with missing/ incomplete information[A]',F5.1,validn ,'Number of women',F5.0]+
  layer2 [c] > 
  (agefi[s][mean ,'Percent with missing/ incomplete information[A]',F5.1,validn ,'Number of women',F5.0]+
  timesli[s][mean ,'Percent with missing/ incomplete information[A]',F5.1,validn ,'Number of women',F5.0])+
 layer3 [c] > 
  (Yagefi[s][mean ,'Percent with missing/ incomplete information[A]',F5.1,validn ,'Number of women',F5.0]+
  Ytimesli[s][mean ,'Percent with missing/ incomplete information[A]',F5.1,validn ,'Number of women',F5.0])
  /titles title=
   "Table DQ.3.3W: Completeness of information on dates of marriage/union and sexual intercourse (women)"
   "Percentage of women age 15-49 years with missing or incomplete information on date of and age at first marriage/union and age at first intercourse and time since last intercourse, " + surveyname
  caption = "[A] Includes Dont know responses".

new file.
