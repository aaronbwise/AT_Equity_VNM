* MICS5 WS-06.

* v01 - 2014-03-03.

* Improved sanitation facilities are:
    WS8=11, 12, 13, 15, 21, 22, and 31.

* Not shared:      WS9=2.
* Public facility: WS10=2.
* Number of households sharing toilet facilities is based on responses to WS11.

* Denominators are obtained by weighting the number of households by the number of household members (HH11).

* The distribution of users of between types of improved and unimproved sanitation facilities are as shown in Table WS_5.

***.


include "surveyname.sps".

get file = 'hh.sav'.

select if (HH9 = 1).

compute hhweightHH11 = HH11*hhweight.

weight by hhweightHH11.

* include definition of drinking  water and sanitation facilities.
include "define/MICS5 - 05 - WS.sps" .

do if (toiletType = 1).
+ compute shared1 = sharedToilet.
end if.
variable labels shared1 "Users of improved sanitation facilities".
value labels shared1
  0 "Not shared [1]"
  1 "Public facility"
  2 "Shared by: 5 households or less"
  3 "Shared by: More than 5 households"
  9 "Missing/DK".

do if (toiletType = 2).
+ compute shared2 = sharedToilet.
end if.
variable labels shared2 "Users of unimproved sanitation facilities".
value labels shared2
  0 "Not shared"
  1 "Public facility"
  2 "Shared by: 5 households or less"
  3 "Shared by: More than 5 households"
  9 "Missing/DK".

do if (toiletType = 3).
+ compute shared3 = 1.
end if.
variable labels  shared3 "".
value labels shared3 1 "Open defecation (no facility, bush field)".

compute nhhmem = 1.
variable labels  nhhmem "Number of household members".
value labels nhhmem 1 " ".

compute total = 1.
variable labels  total "Total".
value labels total 1 " ".

compute total100 = 100.
variable labels  total100 "Total".
value labels total100 100 " ".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = shared3
           display = none
  /table   total [c]
         + hh7 [c]
         + hh6[c]
         + helevel [c]
         + windex5 [c]
         + ethnicity [c]
   by
           shared1 [c] [rowpct.totaln,'',f5.1]
         + shared2 [c] [rowpct.totaln,'',f5.1]
         + shared3 [c] [rowpct.totaln,'',f5.1]
         + total100 [s] [mean,'',f5.1]
         + nhhmem[s][sum,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table WS.6: Use and sharing of sanitation facilities"
    "Percent distribution of household population by use of private and public sanitation facilities "+
    "and use of shared facilities, by users of improved and unimproved sanitation facilities, " + surveyname
   caption =
     "[1] MICS indicator 4.3; MDG indicator 7.9 - Use of improved sanitation".

new file.

