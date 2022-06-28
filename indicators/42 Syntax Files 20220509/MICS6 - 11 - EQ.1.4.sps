* Encoding: UTF-8.

***.
* v02 - 2020-04-11 A note has been inserted on the disaggregate of Mother’s functional difficulties. Labels in French and Spanish have been removed.
* v03 - 2021-04-09 removed duplicate lines:
                chweight = hweight.

***.
* Children with functional difficulty in at least one domain are presented for the age groups of age 2-4 and 5-17 years. The two results are weighted together in the final indicator column.

* Please refer to tables EQ.1.1 and 1.2 for algorithms.
									
*******.
include "surveyname.sps".

get file = "fs.sav".

select if (FS17 = 1).

weight by fsweight.
 	 	
*Seeing (FCF6A/B=3 or 4),.
if (any(FCF6, 3, 4)) seeing=100.
* Hearing (FCF8A/B=3 or 4),.
if (any(FCF8, 3, 4)) hearing=100.
 * Walking Walking (FCF10=3 or 4 OR FCF11=3 or 4 OR FCF14=3 or 4 OR FCF15=3 or 4).
if ((any(FCF10, 3, 4)) or (any(FCF11, 3, 4)) or (any(FCF14, 3, 4)) or (any(FCF15, 3, 4))) walking=100.
 * Self-care (FCF16=3 or 4),.
if (any(FCF16, 3, 4)) selfcare=100.
 * Communication a) Being understood inside household (FCF17=3 or 4) or b) Being understood outside household (FCF18=3 or 4), .
if ((any(FCF17, 3, 4)) or (any(FCF18, 3, 4))) communication=100.
 * Learning (FCF19=3 or 4),.
if (any(FCF19, 3, 4)) learning=100.
 * Remembering (FCF20=3 or 4), .
if (any(FCF20, 3, 4)) remembering=100.
*Concentrating ((FCF21=3 or 4).     . 
compute concentrating=0.
if (any(FCF21, 3, 4)) concentrating=100.
 * Accepting change (FCF22=3 or 4),.
compute accepting=0.
if (any(FCF22, 3, 4)) accepting=100.
*Controlling behaviour (FCF23=3 or 4), .
if (any(FCF23, 3, 4)) behaviour=100.
*Making friends (FCF24=3 or 4), . 
if (any(FCF24, 3, 4)) makingfriends=100.
*Anxiety (FCF25=1),. 
if FCF25=1 anxiety=100.
*Depression (FCF26=1).
if FCF26=1 depression=100.

compute anyfuncdifficulty=0.
if (seeing=100 or hearing=100 or walking=100 or selfcare=100 or communication=100 or learning=100 or remembering=100 or 
    concentrating=100 or accepting=100 or behaviour=100 or makingfriends=100 or anxiety=100 or depression=100) anyfuncdifficulty=100.
variable labels anyfuncdifficulty "Percentage of children age 5-17 years with functional difficulty in at least one domain".

sort cases hh1 hh2 ln.

rename variables 
FS17 = result
fsdisability = disability
fsweight = hweight
CB7 = attendance
CB3 = age
.

save outfile = "tmpfs.sav"/keep  HH1 HH2 LN anyfuncdifficulty caretakerdis hweight melevel attendance
                                               disability ethnicity wscore windex5 windex10 wscoreu windex5u windex10u wscorer windex5r windex10r age hh6 hh7 hl4 result.

new file. 

get file = "ch.sav".

*Seeing (UCF7A/B=3 or 4),.
if (any(UCF7, 3, 4)) seeing=100.
* Hearing (UCF9A/B=3 or 4),.
if (any(UCF9, 3, 4)) hearing=100.
 * Walking (UCF11=3 or 4 OR UCF12=3 or 4 OR UCF13=3 or 4),.
if ((any(UCF11, 3, 4)) or (any(UCF12, 3, 4)) or (any(UCF13, 3, 4))) walking=100.
 * Fine motor (UCF14=3 or 4),. 
if (any(UCF14, 3, 4)) finemotor=100.
 * Communication  a) Understanding (UCF15=3 or 4) or b) Being understood (UCF16=3 or 4),.
if ((any(UCF15, 3, 4)) or (any(UCF16, 3, 4))) communication=100.
 * Learning (UCF17=3 or 4), .
if (any(UCF17, 3, 4)) learning=100.
 * Playing (UCF18=3 or 4), .
if (any(UCF18, 3, 4)) playing=100.
 * Controlling behaviour (UCF19=5).
if (UCF19 =5) behaviour=100.

compute anyfuncdifficulty=0.
if (seeing=100 or hearing=100 or walking=100 or finemotor=100 or communication=100 or learning=100 or playing=100 or behaviour=100) anyfuncdifficulty=100.
variable labels anyfuncdifficulty "Percentage of children age 2-4 years with functional difficulty in at least one domain".

sort cases by hh1 hh2 ln.

rename variables 
UF17 = result
chweight = hweight
cdisability = disability
UB8 = attendance
UB2 = age.

save outfile = "tmpch.sav"/keep HH1 HH2 LN anyfuncdifficulty caretakerdis hweight melevel attendance
                                               disability ethnicity wscore windex5 windex10 wscoreu windex5u windex10u wscorer windex5r windex10r age hh6 hh7 hl4 result.
new file. 

get file = "tmpch.sav".

add files file = * /file = "tmpfs.sav".

select if (result = 1).

select if (age >=2 and age <=17).

weight by hweight.

recode age (2 thru 4 = 1) (5 thru 9 = 2) (10 thru 14 = 3) (15 thru 17 = 4) into ageGroup .
variable labels ageGroup "Age" .
value labels ageGroup
  1 "2-4"
  2 "5-9"
  3 "10-14"
  4 "15-17" .

do if ageGroup=1.
+ compute numCH = 1.
+ compute anyfuncdifficultyCH=anyfuncdifficulty.
end if.
value labels numCH 1 "Number of children age 2-4 years".
variable labels anyfuncdifficultyCH "Percentage of children age 2-4 years with functional difficulty in at least one domain".

do if ageGroup>=2.
+ compute numFS = 1.
+ compute anyfuncdifficultyFS=anyfuncdifficulty.
end if.
value labels numFS 1 "Number of children age 5-17 years".
variable labels anyfuncdifficultyFS "Percentage of children age 5-17 years with functional difficulty in at least one domain".

variable labels anyfuncdifficulty "Percentage of children age 2-17 years with functional difficulty in at least one domain [1]".

compute numChildren = 1.
value labels numChildren 1 "Number of children age 2-17 years".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

variable labels melevel "Mother's education [A]".
variable labels caretakerdis "Mother's functional difficulties [B]".

* Ctables command in English.
ctables
   /vlabels variables = numCH numFS numChildren 
            display = none
   /table  total [c]
         + hl4 [c] 
         + hh6 [c] 
         + hh7 [c] 
         + melevel [c] 
         + caretakerdis [c]
         + ethnicity [c]
         + windex5 [c] 
    by 
           anyfuncdifficultyCH [s][mean '' f5.1]
           + numCH [c] [count '' f5.0] 
           + anyfuncdifficultyFS [s][mean '' f5.1]
           + numFS [c] [count '' f5.0] 
           + anyfuncdifficulty [s][mean '' f5.1]
           + numChildren [c] [count '' f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table EQ.1.4: Child functioning (children age 2-17 years)"
    "Percentage of children age 2-4, 5-17 and 2-17 years with functional difficulty, " + surveyname 
 caption = "[1] MICS indicator EQ.1 - Children with functional difficulty"
                "[A] The disaggregate of Mother's education is not available for children age 15-17 years identified as emancipated."									
               "[B] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households.".	
 
new file.

erase file = "tmpch.sav".
erase file = "tmpfs.sav".

