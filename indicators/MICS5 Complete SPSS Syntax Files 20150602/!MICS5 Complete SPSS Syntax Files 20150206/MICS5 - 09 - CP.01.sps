* MICS5 CP-01.

* v01 - 2013-03-17.
* v02 - 2014-08-19.
* value labels numWithout changed to 1 "Number of children under age 5 without birth registration".
* value labels numChildren changed to 1 "Number of children under age 5".

* Children age 0-59 months whose birth is registered includes:
  - children whose birth certificate was seen by the interviewer
      (BR1=1),
  - children reported to have a birth certificate that was not seen by the interviewer
      (BR1=2), and
  - children who do not have a birth certificate but are reported to have been registered with civil authorities
      (BR2=1) .

* The denominator for children whose mothers/caretakers know how to register birth
     (BR3=1)
  includes children who are not registered
     (BR1=3 and BR2=2)
  as well as children whose registration status is unknown .

***.


include "surveyname.sps".

get file = 'ch.sav'.

weight by chweight.

select if (UF9 = 1) .

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
variable labels knowHow "Percent of children whose mother/caretaker knows how to register birth".

if (birthRegistrated = 0) numWithout = 1.
variable labels numWithout "".
value labels numWithout 1 "Number of children under age 5 without birth registration".

compute layerRegistrated = 1.
variable labels layerRegistrated "".
value labels layerRegistrated 1 "Children under age 5 whose birth is registered with civil authorities".

compute layerCertificate = 0.
variable labels layerCertificate "".
value labels layerCertificate 0 "Has birth certificate".

compute layerNotRegistrated = 0.
variable labels layerNotRegistrated "".
value labels layerNotRegistrated 0 "Children under age 5 whose birth is not registered".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

compute numChildren = 1.
variable labels numChildren "".
value labels numChildren 1 "Number of children under age 5".


* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = layerRegistrated layerNotRegistrated layerCertificate numWithout numChildren
           display = none
  /table  total [c]
        + hl4 [c]
        + hh7 [c]
        + hh6 [c]
        + cage_11 [c]
        + melevel [c]
        + windex5 [c]
        + ethnicity [c]
   by
          layerRegistrated [c] > (
            layerCertificate[c] > (
              certificateSeen [s] [mean,'',f5.1]
            + certificateNotSeen [s] [mean,'',f5.1] )
          + noCertificate [s] [mean,'',f5.1]
          + birthRegistrated [s] [mean,'',f5.1] )
        + numChildren [c] [count,'',f5.0]
        + layerNotRegistrated [c] > (
            knowHow[s] [mean,'',f5.1]
         + numWithout [c] [count,'',f5.0] )
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible=no
  /title title=
     "Table CP.1: Birth registration"
     "Percentage of children under age 5 by whether birth is registered and percentage "+
     "of children not registered whose mothers/caretakers know how to register birth, " + surveyname
   caption=
     "[1] MICS indicator 8.1 - Birth registration"
  .

new file .
