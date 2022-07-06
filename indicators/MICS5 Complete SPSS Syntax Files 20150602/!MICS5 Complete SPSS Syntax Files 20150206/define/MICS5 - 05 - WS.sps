* Drinking water sources.
* Improved sources of drinking water WS1=11, 12, 13, 14, 21, 31, 41, 51 or (WS1=91 and WS2=11, 12, 13, 14, 21, 31, 41, 51) 
* DK and Missing are treated as "unimproved".

do if any(WS1, 11, 12, 13, 14, 21, 31, 41, 51) .
+ compute drinkingWater = 1 .
else if (WS1 = 91 and any(WS2, 11, 12, 13, 14, 21, 31, 41, 51)) .
+ compute drinkingWater = 1 .
else .
+ compute drinkingWater = 2 .
end if.

variable labels drinkingWater "Main source of drinking water".
value labels drinkingWater
  1 "Improved sources"
  2 "Unimproved sources".

* Sanitation facilities.
* Improved sanitation facilities are: WS8=11, 12, 13, 15, 21, 22, and 31.
* DK and Missing are treated as "unimproved".

recode WS8
  (11, 12, 13, 15, 21, 22, 31 = 1)
  (95 = 3)
  (else = 2) into toiletType.
variable labels  toiletType "Type of toilet facility used by household".
value labels toiletType
    1 "Improved sanitation facility"
    2 "Unimproved sanitation facility"
    3 "Open defecation (no facility, bush field)" .

* Shared facilities.

recode WS11
  (1 thru 5 = 2)
  (97, 98, 99 = 9)
  (sysmis = 0)
  (else = 3) into sharedToilet.

if (WS10 = 2) sharedToilet = 1.

variable labels sharedToilet " ".
value labels sharedToilet
  0 "Not shared"
  1 "Public facility"
  2 "5 households or less"
  3 "More than 5 households"
  9 "Missing/DK".
