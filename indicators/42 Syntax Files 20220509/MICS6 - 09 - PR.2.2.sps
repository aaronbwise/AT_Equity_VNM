* Encoding: UTF-8.

***.
* 2018.08.29: the FCD3 variable is replaced by FCD5 and CD3 variable replaced by CD5 due to the change at the question numbers at the questionnaires.
* v03 - 2020-04-21. The disaggregate of Mother’s functional difficulties has been edited and a new note C has been inserted. Labels in French and Spanish have been removed.
***.

include "surveyname.sps".

get file = "hl.sav".

sort cases by hh1 hh2 hl1.

save outfile = "tmpHL.sav"/keep hh1 hh2 hl1 hl4 hl6/rename hl1 = mline.

get file = "fs.sav".

sort cases hh1 hh2 ln.

rename variables 
FS17 = result
FS4 = mline
FCD5 = CD5
fshweight = hweight
fsdisability = cdisability.

save outfile = "tmpfs.sav"/keep HH1 HH2 LN mline CD5 hweight melevel cdisability caretakerdis ethnicity wscore windex5 windex10 wscoreu windex5u windex10u wscorer windex5r windex10r 
 hh6 hh7 result.

get file = "ch.sav".

sort cases by hh1 hh2 ln.

rename variables 
UF17 = result
UF4 = mline 
UCD5 = CD5
chweight = hweight
.

save outfile = "tmpch.sav"/keep HH1 HH2 LN mline CD5 hweight melevel cdisability caretakerdis ethnicity wscore windex5 windex10 wscoreu windex5u windex10u wscorer 
windex5r windex10r hh6 hh7 result.

get file = "tmpch.sav".

add files file = */file = "tmpfs.sav".

select if (result = 1).
select if not sysmis (CD5).

weight by hweight.

* add tmpHL file in order to determine respondents education age.
sort cases by HH1 HH2 mline.
match files
  /file = *
  /table = "tmpHL.sav"
  /by HH1 HH2 mline  .

recode HL6
  (lo thru 24 = 1)
  (25 thru 34 = 2)
  (35 thru 49 = 3)
  (50 thru 96 = 4)
  (97 thru hi = 9) into ageGroup .
variable labels ageGroup "Age" .
value labels ageGroup
  1 "<25"
  2 "25-34"
  3 "35-49"
  4 "50+" 
  9 "Missing\DK".

* Respondent believes that a child needs to be physically punished: CD4=1.
compute belivePunishment = 0 .
if (CD5 = 1) belivePunishment = 100 .
variable labels belivePunishment "Percentage of mothers/caretakers who believe that a child needs to be physically punished" .

compute numRespondents = 1.
value labels numRespondents 1 "Number of mothers/ caretakers responding to a child discipline module".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

variable labels melevel "Education".
variable labels caretakerdis "Functional difficulties [A]".

* Ctables command in English.
ctables
   /vlabels variables = numRespondents
            display = none
   /table  total [c]
         + hl4 [c] 
         + hh6 [c] 
         + hh7 [c] 
         + ageGroup [c] 
         + melevel [c] 
         + caretakerdis [c]
         + ethnicity [c]
         + windex5 [c] 
    by
           belivePunishment [s][mean '' f5.1]
         + numRespondents [c] [count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table PR.2.2: Attitudes toward physical punishment"
    "Percentage of mothers/caretakers of children age 1-14 years who believe that physical punishment is needed to bring up, raise, or educate a child properly, " + surveyname
   caption =
    "[A] The disaggregate of Functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."	
.

new file.

erase file = "tmpCH.sav" .
erase file = "tmpFS.sav" .
erase file = "tmpHL.sav" .
