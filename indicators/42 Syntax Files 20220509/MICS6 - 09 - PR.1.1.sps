* Encoding: windows-1252.
***.

* v02 - 2019-08-27. Last modified to reflect tab plan changes as of 25 July 2019.
* v03 - 2020-04-21. A new note B inserted. Labels in French and Spanish have been removed.

include "surveyname.sps".

get file = 'ch.sav'.

weight by chweight.

select if (UF17 = 1) .

* children whose birth certificate was seen by the interviewer (BR1=1).
compute certificateSeen = 0.
if (BR1 = 1) certificateSeen = 100.
variable labels certificateSeen "Seen".

* children reported to have a birth certificate that was not seen by the interviewer (BR1=2).
compute certificateNotSeen = 0.
if (BR1 = 2) certificateNotSeen = 100.
variable labels certificateNotSeen "Not seen".

* children who do not have a birth certificate but are reported to have been registered with civil authorities (BR2=1). 
compute noCertificate = 0.
if (BR1 <> 1 and BR1 <> 2 and BR2 = 1) noCertificate = 100.
variable labels noCertificate "No birth certificate".

compute birthRegistrated = 0.
if (BR1 = 1 or BR1 = 2 or BR2 = 1) birthRegistrated = 100.
variable labels birthRegistrated "Total registered [1]".

* The denominator for children whose mothers/caretakers know how to register birth (BR3=1) 
* includes children who are not registered (BR1=3 and BR2=2) as well as children whose registration status is unknown.
do if (birthRegistrated = 0).
+ compute knowHow = 0.
+ if (BR3 = 1) knowHow = 100.
end if.
variable labels knowHow "Percent of children whose mothers/ caretakers know how to register births".

if (birthRegistrated = 0) numWithout = 1.
variable labels numWithout "".
value labels numWithout 1 "Number of children without birth registration".

compute layerRegistrated = 1.
variable labels layerRegistrated "".
value labels layerRegistrated 1 "Children whose births are registered with civil authorities".

compute layerCertificate = 0.
variable labels layerCertificate "".
value labels layerCertificate 0 "Has birth certificate".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

compute numChildren = 1.
variable labels numChildren "".
value labels numChildren 1 "Number of children".

variable labels cdisability "Child's functional difficulties (age 2-4 years) [A]".
variable labels caretakerdis "Mother's functional difficulties [B]".

* Ctables command in English.
ctables
  /vlabels variables = layerRegistrated layerCertificate numWithout numChildren
           display = none
  /table  total [c]
         + hl4 [c]
         + hh6 [c]
         + hh7 [c]
         + cage_11 [c]
         + melevel [c] 
         + cdisability [c]
         + caretakerdis [c]
         + ethnicity [c]
         + windex5 [c]
   by
         layerRegistrated [c] > (
            layerCertificate[c] > (
                 certificateSeen [s] [mean '' f5.1]
                + certificateNotSeen [s] [mean '' f5.1] )
            + noCertificate [s] [mean '' f5.1]
            + birthRegistrated [s] [mean '' f5.1] )
         + numChildren [c] [count '' f5.0]
         + knowHow[s] [mean '' f5.1]
         + numWithout [c] [count '' f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible=no
  /titles title=
     "Table PR.1.1: Birth registration"
     "Percentage of children under age 5 by whether birth is registered and percentage of children not registered whose mothers/caretakers know how to register births, " + surveyname
   caption=
     "[1] MICS indicator PR.1 - Birth registration; SDG indicator 16.9.1"
     "[A] Children age 0-1 years are excluded, as functional difficulties are only collected for age 2-4 years."
     "[B] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."	
  .	

new file .
