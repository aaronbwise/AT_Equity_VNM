* Encoding: UTF-8.

* v02 - 2020-04-11 A note has been inserted on the disaggregate of Mother’s functional difficulties. Labels in French and Spanish have been removed.
* v03 - 2021-04-09 removed duplicate lines:
                chweight = hweight.

* "The percent of children age 2-4 years who use the three different assistive devices are those for whom the response to UCF2, UCF3 and UCF4, respectively, is yes. For children 
    age 5-17, the same questions are FCF1, FCF2 and FCF3.

* Those with difficulties are those responding ""A lot of difficulty"" or ""Cannot do at all"" to questions for:
- age 2-4: UCF7A, (seeing using glasses), UCF9A (with using hearing aid) and UCF12 (walking using equipment or assistance) 
- age 5-17: FCF6A (seeing using glasses), FCF8A (hearing using hearing aid) and FCF12 or FCF13 (walking using equipment or assistance)
									
*******.
include "surveyname.sps".

get file = "fs.sav".

sort cases hh1 hh2 ln.

rename variables 
FS17 = result
FCF1 = seeing
FCF2 = hearing
FCF3 = walking
FCF6=dseeing
FCF8=dhearing
FCF12=dwalking1
FCF13=dwalking2
fsdisability = disability
fsweight = hweight
CB7 = attendance
CB3 = age
.

save outfile = "tmpfs.sav"/keep  HH1 HH2 LN seeing hearing walking dseeing dhearing dwalking1 dwalking2 caretakerdis hweight melevel attendance
                                               disability ethnicity wscore windex5 windex10 wscoreu windex5u windex10u wscorer windex5r windex10r age hh6 hh7 hl4 result.

get file = "ch.sav".

sort cases by hh1 hh2 ln.

compute dwalking2=$sysmis.

rename variables 
UF17 = result
UCF2 = seeing
UCF3 = hearing
UCF4 = walking
UCF7 = dseeing
UCF9 = dhearing
UCF12 = dwalking1
chweight = hweight
cdisability = disability
UB8 = attendance
UB2 = age.

save outfile = "tmpch.sav"
/keep HH1 HH2 LN seeing hearing walking dseeing dhearing dwalking1 dwalking2 caretakerdis hweight melevel attendance
                                               disability ethnicity wscore windex5 windex10 wscoreu windex5u windex10u wscorer windex5r windex10r age hh6 hh7 hl4 result .

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

compute glasses=0.
if seeing=1 glasses=100.
variable labels glasses "Wear glasses".

compute hearingaid=0.
if hearing=1 hearingaid=100.
variable labels hearingaid "Use hearing aid".

compute walkingequipment=0.
if walking=1 walkingequipment=100.
variable labels walkingequipment  "Use equipment or receive assistance for walking".

do if glasses=100.
+ compute numglasses = 1.
+ compute diffglasses=0.
+ if (any(dseeing, 3, 4)) diffglasses=100.
end if.
value labels numglasses 1 "Number of children age 2-17 years who wear glasses".
variable labels diffglasses "Percentage of children with difficulties seeing when wearing glasses".

do if hearingaid=100.
+ compute numhearingaid = 1.
+ compute diffhearingaid=0.
+ if (any(dhearing, 3, 4)) diffhearingaid=100.
end if.
value labels numhearingaid 1 "Number of children age 2-17 years who use hearing aid	".
variable labels diffhearingaid "Percentage of children with difficulties hearing when using hearing aid".

do if walkingequipment=100.
+ compute numwalkingequipment = 1.
+ compute diffwalkingequipment=0.
+ if ((any(dwalking1, 3, 4)) or (any(dwalking2, 3, 4))) diffwalkingequipment=100.
end if.
value labels numwalkingequipment 1 "Number of children age 2-17 years who use equipment or receive assistance for walking ".
variable labels diffwalkingequipment "Percentage of children with difficulties walking when using equipment or receiving assistance".

compute numChildren = 1.
value labels numChildren 1 "Number of children age 2-17 years".

compute layer = 1.
value labels layer 1 "Percentage of children age 2-17 years who:" .

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

variable labels melevel "Mother's education [A]".
variable labels caretakerdis "Mother's functional difficulties [B]".

* Ctables command in English.
ctables
   /vlabels variables = layer numchildren numglasses numhearingaid numwalkingequipment
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
           layer [c] > (
             glasses [s][mean '' f5.1]
           + hearingaid [s][mean '' f5.1]
           + walkingequipment [s][mean '' f5.1] )
           + numchildren [c] [count '' f5.0] 
           + diffglasses [s][mean '' f5.1] 
           + numglasses [c] [count '' f5.0] 
           + diffhearingaid  [s][mean '' f5.1] 
           + numhearingaid  [c] [count '' f5.0] 
           + diffwalkingequipment [s][mean '' f5.1] 
           + numwalkingequipment [c] [count '' f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table EQ.1.3: Use of assistive devices (children age 2-17 years)"
    "Percentage of children age 2-17 years who use assistive devices and have functional difficulty within domain of assistive devices, " + surveyname 
  caption =
    "[A] The disaggregate of Mother's education is not available for children age 15-17 years identified as emancipated."									
    "[B] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."								
.

new file.

erase file = "tmpch.sav".
erase file = "tmpfs.sav".

