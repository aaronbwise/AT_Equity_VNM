* Encoding: UTF-8.

***.
* v02 - 2020-04-14. Labels in French and Spanish have been removed.
*                           Latest chages related to new version of the questionnaire and tab plan included.
* v03 - 2021-04-09. Line 59 changed from 
+ if ((sysmis(FL7) and FL7>=21) and (sysmis(FL9) or FL9>=20)) readingbook=100.  to 
+ if ((sysmis(FL7) and FL7>=21) and (sysmis(FL9) or FL9>=21)) readingbook=100. 

 * The percent distribution of results of the FL module is based on FL28.

 * The percentage for whom the reading book was not available in appropriate language is FL7>=21 and FL9>=21 or blank. 
 * Note the categories accepted for FL9 and FL7 are those for which no reading book was available. This must be customised in syntax.

 * The percentage with insufficient number recognition skill for testing, are those children who did not recognise 2 of the first 3 numbers in FL23 (FL23A=2).

 * The percentage who did not complete reading and comprehension practise are children age 7-9 years old who failed to read every word in the practise 
sentence correctly or did not answer the comprehension questions correctly (FL14=2 or FL15>1 or FL17>1) and (FL21D=95 or FL21H=2 or FL21I>1 or FL21K>1).

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'fs.sav'.
include "CommonVarsFS.sps".

select if (FS17 = 1).

select if (CB3 >= 7 and CB3 <=14).

weight by fshweight.

compute total714 = 1.
variable labels total714  " ".
value labels total714 1 "Number of selected children age 7-14 years".

compute completedLA=0. 
if FL28=1 completedLA=100. 
variable labels completedLA "Completed foundational learning skills (FL) module".

compute incompmother=0. 
if FL28 =3 incompmother=100. 
variable labels incompmother "Mother refused".

compute incompchild=0. 
if FL28 =4 incompchild=100. 
variable labels incompchild "Child refused".

compute incompchildnotathome=0. 
if FL28 =2 incompchildnotathome=100. 
variable labels incompchildnotathome "Child not available".

compute incompOTHER=0. 
if FL28>=5  incompOTHER=100. 
variable labels incompOTHER "Other".

*The percentage for whom the reading book was not available in appropriate language is FL7>=21 and FL9>=21 or blank. 
*Note the categories accepted for FL9 and FL7 are those for which no reading book was available. This must be customised in syntax.
do if FL28=1.
+ compute total714comp = 1.
+ compute readingbook=0. 
+ if ((sysmis(FL7) and FL7>=21) and (sysmis(FL9) or FL9>=21)) readingbook=100. 
+ recode FL23A FL23B FL23C (2=1) (else=0). 
+ compute FL23x=FL23A+FL23B+FL23C.
+ compute numberrecognition =0. 
+ if FL23x>1  numberrecognition=100. 
end if.

variable labels total714comp  " ".
value labels total714comp 1 "Number of children age 7-14 years with completed FL module".

variable labels readingbook "For whom the reading book was not available in appropriate language".
variable labels numberrecognition "With insufficient number recognition skill for testing".

* The percentage who did not complete reading and comprehension practise are children age 7-9 years old who failed to read every word in the practise 
sentence correctly or did not answer the comprehension questions correctly (FL14=2 or FL15>1 or FL17>1) and (FL21D=95 or FL21H=2 or FL21I>1 or FL21K>1).
do if CB3>=7 and CB3<=9 and FL28=1.
+ compute total79comp = 1.
+ compute completedreading=0. 
+ if (FL14=2 or FL15>1 or FL17>1) and (FL21D=95 or FL21H=2 or FL21I>1 or FL21K>1) completedreading=100. 
end if.
variable labels total79comp  " ".
value labels total79comp 1 "Number of children age 7-9 years with completed FL module".

variable labels completedreading "Percentage of children who did not complete reading and comprehension practise".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

compute tot = 100.
variable labels tot "Total".
value labels tot 100 " ".

variable labels CB3 "Age".

compute layer1 = 0.
variable labels layer1 "".
value labels layer1 0 "Percent distribution of children with:".

compute layer2 = 0.
variable labels layer2 "".
value labels layer2 0 "Incomplete FL modules, by reason:".

compute layer3 = 0.
variable labels layer3 "".
value labels layer3 0 "Percent of children:".

* Ctables command in English.
ctables
  /format missing = "na" 
  /vlabels variables =  total714 total714comp total79comp layer1 layer2 layer3
         display = none
  /table total [c] + HH6 [c] + HH7 [c] + CB3 [c]  by 
	layer1 [c] > ( completedLA [s] [mean,f5.1] + layer2 [c] > ( incompmother [s] [mean,f5.1] + incompchild [s] [mean,f5.1] + incompchildnotathome [s] [mean,f5.1] + incompOTHER [s] [mean,f5.1] )) 
                  + tot [s][mean,f5.1] + total714 [c] [count,f5.0]
                  +  layer3 [c] >(readingbook [s] [mean,f5.1] + numberrecognition [s] [mean,f5.1]) + total714comp  [c] [count,f5.0]   
                  + completedreading [s] [mean,f5.1] + total79comp  [c] [count,f5.0]  
  /slabels position = column visible = no
  /titles title=
   "Table DQ.3.8: Completeness of information for foundational learning skills indicators"
   "Percent distribution of selected children age 7-14 years by completion of the foundational learning skills (FL) module, " +
   "percentage for whom the reading book was unavailable in appropriate language and those with insufficient number recognition skills for testing, " +
   "and percentage children age 7-9 years who did not complete the reading and comprehension practise," + surveyname
    caption=
    "na: not applicable".

new file.
