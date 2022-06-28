* Encoding: UTF-8.
* v02 - 2020-04-26. Updated label of the variable selftestkit. Labels in French and Spanish removed.
* v03. 2020-05-06: lines:
* compute none = 0.
* if (HA8A <> 1 and HA8B <> 1 and HA8C <> 1) none = 100.
* variable labels none "Do not know any of the specific means of HIV transmission from mother to child".
* changed to:
* compute none = 0.
 * if (HA1 = 2 or ((HA8A = 2 or HA8A = 8) and (HA8B = 2 or HA8B = 8) and (HA8C = 2 or HA8C = 8))) none = 100.
 * variable labels none "Do not know any of the specific means of HIV transmission from mother to child".
* v04. 2021-10-26. Removed unnecessery lines 147-149:
*mrsets 
  /mcgroup name=$deliveryPlace label='Place of delivery' variables=place1 place2
.

compute contraceptiveMethod = 99.
if (CP4X = "X") contraceptiveMethod = 14.
if (CP4M = "M") contraceptiveMethod = 13.
if (CP4L = "L") contraceptiveMethod = 12.
if (CP4K = "K") contraceptiveMethod = 11.
if (CP4I = "I" or CP4J = "J") contraceptiveMethod = 9.
if (CP4H = "H") contraceptiveMethod = 8.
if (CP4G = "G") contraceptiveMethod = 7.
if (CP4F = "F") contraceptiveMethod = 6.
if (CP4E = "E") contraceptiveMethod = 5.
if (CP4D = "D") contraceptiveMethod = 4.
if (CP4C = "C") contraceptiveMethod = 3.
if (CP4B = "B") contraceptiveMethod = 2.
if (CP4A = "A") contraceptiveMethod = 1.

* If pregnant or state they are not using, set method to 0.
if (CP1 = 1 or CP2 = 2 or CP2 = 9) contraceptiveMethod = 0.

value labels contraceptiveMethod
   0 "No method"
   1 "Female sterilization"
   2 "Male sterilization"
   3 "IUD"
   4 "Injectables"
   5 "Implants"
   6 "Pill"
   7 "Male condom"
   8 "Female condom"
   9 "Diaphragm/foam/jelly"
  11 "Lactational amenorrhoea method (LAM)"
  12 "Periodic abstinence/Rhythm"
  13 "Withdrawal"
  14 "Other"
   99 "Missing".


***.

compute anc = 0.
if (MN3A = "A") anc = 11.
if (anc = 0 and MN3B = "B") anc = 12.
if (anc = 0 and MN3C = "C") anc = 13.
if (anc = 0 and MN3F = "F") anc = 21.
if (anc = 0 and MN3G = "G") anc = 22.
if (anc = 0 and (MN3X = "X" or MN3NR = "?")) anc = 97.
if (anc = 0) anc = 98.
variable labels anc "Person providing antenatal care".
value labels anc
  11 "Medical doctor"
  12 "Nurse / Midwife"
  13 "Other qualified"
  21 "Traditional birth attendant"
  22 "Community health worker"
  97 "Other/Missing"
  98 "No antenatal care".

compute skilledPersonnel = 0.
if (any(anc, 11, 12, 13)) skilledPersonnel = 100.
variable labels skilledPersonnel "Skilled health personnel".

***.

compute personAtDelivery = 0.
if (MN19A = "A") personAtDelivery = 11.
if (personAtDelivery = 0 and MN19B = "B") personAtDelivery = 12.
if (personAtDelivery = 0 and MN19C = "C") personAtDelivery = 13.
if (personAtDelivery = 0 and MN19F = "F") personAtDelivery = 14.
if (personAtDelivery = 0 and MN19G = "G") personAtDelivery = 15.
if (personAtDelivery = 0 and MN19H = "H") personAtDelivery = 16.
if (personAtDelivery = 0 and (MN19X = "X" or MN19NR = "?")) personAtDelivery = 97.
if (personAtDelivery = 0 and MN19Y = "Y") personAtDelivery = 98.
*SL.
recode personAtDelivery (0=98)(else = copy).
variable labels personAtDelivery "Person assisting at delivery".
value labels personAtDelivery
  11 "Skilled attendant: Medical doctor"
  12 "Skilled attendant: Nurse / Midwife"
  13 "Skilled attendant: Other qualified"
  14 "Other: Traditional birth attendant"
  15 "Other: Community / village health worker"
  16 "Other: Relative / Friend"
  97 "Other/Missing"
  98 "No attendant".	

recode personAtDelivery (11 thru 13 = 1) (14 = 2) (15 thru 98 = 3) into personAtDelivery1.
variable labels personAtDelivery1 "Assistance at delivery".
value labels personAtDelivery1
  1 "Skilled attendant"
  2 "Traditional birth attendant"
  3 "Other/No attendant/Missing".

compute skilledAttendant = 0.
if any(personAtDelivery, 11, 12, 13) skilledAttendant = 100.
variable labels skilledAttendant "Delivery assisted by any skilled attendant".
***.

compute agebrth = (wdoblc - wdob)/12.
variable labels agebrth "Age at birth".

compute ageAtBirth = 9.
if (agebrth < 20) ageAtBirth = 1.
if (agebrth >= 20 and agebrth < 35) ageAtBirth = 2.
if (agebrth >= 35 and agebrth <= 49) ageAtBirth = 3.
variable labels ageAtBirth "Age at most recent live birth".
value labels ageAtBirth
  1 "Less than 20"
  2 "20-34"
  3 "35-49"
  9 "Missing".

***.

compute deliveryPlace = 0.
if (MN20 >= 21 and MN20 <= 26) deliveryPlace = 11.
if (MN20 >= 31 and MN20 <= 36) deliveryPlace = 12.
if (MN20 = 11 or MN20 = 12) deliveryPlace = 13.
if (MN20 = 96) deliveryPlace = 96.
if (MN20 = 76 or MN20 = 98 or MN20 = 99) deliveryPlace = 98.
variable labels deliveryPlace "Place of delivery".
value labels deliveryPlace
  11 "Public sector health facility"
  12 "Private sector health facility"
  13 "Home"
  96 "Other"
  98 "DK/Missing".
  
recode deliveryPlace (13=1) (11,12=2) (96,98=5) into place1 .
recode deliveryPlace (11=3) (12=4) into place2 .
value labels place1 place2
  1 'Home'
  2 'Health facility'
  3 '   Public'
  4 '   Private'
  5 'Other/DK/Missing' .

***.

compute noVisits = 0.
if (MN5 >= 1 and MN5 <= 3) noVisits = 1.
if (MN5 >= 4) noVisits = 2.
if (MN5 = 98 or MN5 = 99) noVisits = 9.
variable labels noVisits "Percent of women who had:".
value labels noVisits
  0 "None"
  1 "1-3 visits"
  2 "4+ visits"
  9 "DK/Missing".

compute noVisitsAux1 = 0.
if (MN5 >= 1 and MN5 <= 3) noVisitsAux1 = 0.1.
if (MN5 >= 4) noVisitsAux1 = 1.
if (MN5 = 98 or MN5 = 99) noVisitsAux1 = 9.
variable labels noVisitsAux1 "Percent of women who had:".
value labels noVisitsAux1
  0 "No visits"
  0.1 "1-3 visits to any provider"
  1 "4 or more visits to any provider [1]"
  2 "8 or more visits to any provider [2]"
  9 "DK/Missing".

if (MN5 >= 8 and MN5 < 98) noVisitsAux2 = 2.
variable labels noVisitsAux2 "Percent of women who had 8+ visits".

***.

recode MN21 (1=2) (else=1) into deliveryType.
variable labels deliveryType "Type of delivery".
value labels deliveryType
  1 "Vaginal birth"
  2 "C-section" .

***.

compute sexact=2.
if (SB2U = 1 and SB2N <= 30) sexact=1.
if (SB2U = 2 and SB2N <= 4) sexact=1.
if (SB2U = 3 and SB2N = 1) sexact=1.
variable labels sexact "Sexually active in last 30 days".
value labels sexact 1 "Yes" 2 "No".
formats sexact (f1.0).


***.


* Person checking health: excluding relative / friend and other.
compute pncmedC = 0.
if (PN14A = "A" or PN14B = "B" or PN14C = "C" or PN14F = "F" or PN14G = "G") pncmedC = 1.
variable labels pncmedC "Person checking health".

compute pncVisitC = 9.
* PN6><1 or PN10><1 or PN11><1 or PN14><A through G.
if (PN6 <> 1 or PN10 <>  1 or PN11 <> 1 or pncmedC = 0) pncVisitC = 6.
* same day.
if (PN13U = 1 and pncmedC = 1) pncVisitC = 1.
* 1 day.
if (PN13U = 2 and PN13N  = 1 and pncmedC = 1) pncVisitC = 2.
* 2 days.
if (PN13U = 2 and PN13N  = 2 and pncmedC = 1) pncVisitC = 3.
* 3-6 days.
if (PN13U = 2 and PN13N >= 3 and PN13N <= 6 and pncmedC = 1) pncVisitC = 4.
* After 1 week or more.
if (PN13U = 2 and PN13N > 6 and PN13N < 98 and pncmedC = 1) pncVisitC = 5.
if (PN13U = 3 and pncmedC = 1) pncVisitC = 5.
variable labels pncVisitC "PNC visit".
value labels pncVisitC
  1 "Same day"
  2 "1 day following birth"
  3 "2 days following birth"
  4 "3-6 days following birth"
  5 "After the first week following birth"
  6 "No post-natal care visit"
  9 "DK/Missing".



compute pncmedM = 0.
if (PN23A = "A" or PN23B = "B" or PN23C = "C" or PN23F = "F" or PN23G = "G") pncmedM = 1.
variable labels pncmedM "Person checking health".

compute pncVisitM = 9.
* No PNC visit: PN17><1 or PN19><1 or PN20><1 or PN23><A through G.
if (PN17 <> 1 or PN19 <> 1 or PN20 <> 1 or pncmedM = 0) pncVisitM = 6.
* same day.
if (PN22U = 1 and pncmedM = 1) pncVisitM = 1.
* 1 day.
if (PN22U = 2 and PN22N  = 1 and pncmedM = 1) pncVisitM = 2.
* 2 days.
if (PN22U = 2 and PN22N  = 2 and pncmedM = 1) pncVisitM = 3.
* 3-6 days.
if (PN22U = 2 and PN22N >= 3 and PN22N <= 6 and pncmedM = 1) pncVisitM = 4.
* After 1 week or more.
if (PN22U = 2 and PN22N > 6 and PN22N < 98 and pncmedM = 1) pncVisitM = 5.
if (PN22U = 3 and pncmedM = 1) pncVisitM = 5.
variable labels pncVisitM "PNC visit".
value labels  pncVisitM
  1 "Same day"
  2 "1 day following birth"
  3 "2 days following birth"
  4 "3-6 days following birth"
  5 "After the first week following birth"
  6 "No post-natal care visit"
  9 "Missing/DK".

***.


recode HA1 (1 = 100) (else = 0) into heardOfAIDS.
variable labels heardOfAIDS "Percentage who have heard of AIDS".

recode HA2 (1 = 100) (else = 0) into onePartner.
variable labels onePartner "Having only one faithful uninfected sex partner".

recode HA4 (1 = 100) (else = 0) into condomUse.
variable labels condomUse "Using a condom every time".

count twoWays = onePartner condomUse (100).
recode twoWays (2 = 100) (else = 0) into knowBoth.
variable labels knowBoth "Both".

recode HA7 (1 = 100) (else = 0) into healthy.
variable labels healthy "Percentage who know that a healthy-looking person can be HIV-positive".

recode HA3 (2 = 100) (else = 0) into mosquito.
variable labels mosquito "Mosquito bites".

recode HA6 (2 = 100) (else = 0) into supernatural.
variable labels supernatural "Supernatural means".

recode HA5 (2 = 100) (else = 0) into sharingFood.
variable labels sharingFood "Sharing food with someone with HIV".

compute ways = 0 .

*-----.

define twoMostCommon(vars = !CHAREND ('/')).
!let !varsTot = ""
!let !agg = ""

* generate the list of variables to aggregate, e.g. for one it is like /indTot = mean(ind) .
!do !var !IN (!vars)
!let !varTot = !concat(!var, "Tot")
!let !varsTot = !concat(!varsTot, !varTot, ", ")
!let !agg = !concat(!agg  , "/", !varTot, "= mean(", !var, ")")
!doend

aggregate !agg .

* adding 300 to the end so that the last ',' is not making parse error .
!let !varsTot = !concat(!varsTot, "300")

* finding the minimum value, as it is the most common misconception .
compute low = min(!varsTot) .
!do !var !in (!vars)
!let !varTot = !concat(!var, "Tot").
* if we haven't found two, and it is the one, increase the value, so in next round it will not be the same .
do if (ways <= 2 and !varTot = low) .
+ compute !varTot = low + 200 .
+ if (!var = 100) ways = ways + 1 .
end if.
!doend

* repeat all for the next most common .
compute low = min(!varsTot) .
!do !var !in (!vars)
!let !varTot = !concat(!var, "Tot").
do if (ways <= 2 and !varTot = low) .
+ compute !varTot = low + 200 .
+ if (!var = 100) ways = ways + 1 .
end if.
!doend

!enddefine.	


* customize by adding the new country specific misconceptions on the list .
twoMostCommon vars =  mosquito supernatural sharingFood .

*-----.

* and healthy person counts also .
if (healthy=100) ways = ways + 1 .

recode ways (3 = 100) (else = 0) into knowThree.
variable labels knowThree "Percentage who reject the two most common misconceptions and know that a healthy looking person can be HIV-positive".

compute comprehensiveKnowledge = 0.
if (knowBoth = 100 and knowThree = 100) comprehensiveKnowledge = 100.
variable labels comprehensiveKnowledge "Percentage with comprehensive knowledge [1]".


*********************.

compute knowForTransmision = 0.
if (HA8A = 1 or HA8B = 1 or HA8C = 1) knowForTransmision = 100.
variable labels knowForTransmision "Percentage who know HIV can be transmitted from mother to child".

recode HA8A (1 = 100) (else = 0) into duringPregnancy.
variable labels duringPregnancy "During pregnancy".

recode HA8B (1 = 100) (else = 0) into duringDelivery.
variable labels duringDelivery "During delivery".

recode HA8C (1 = 100) (else = 0) into byBreastfeeding.
variable labels byBreastfeeding "By breastfeeding".

compute atLeastOne = 0.
if (HA8A = 1 or HA8B = 1 or HA8C = 1) atLeastOne = 100.
variable labels atLeastOne "By at least one of the three means".

compute allThree = 0.
if (HA8A = 1 and HA8B = 1 and HA8C = 1) allThree = 100.
variable labels allThree "By all three means [1]".

compute none = 0.
if (HA1 = 2 or ((HA8A = 2 or HA8A = 8) and (HA8B = 2 or HA8B = 8) and (HA8C = 2 or HA8C = 8))) none = 100.
variable labels none "Do not know any of the specific means of HIV transmission from mother to child".


*************.

recode HA30 (2 = 100) (else = 0) into food.
variable labels food "Would not buy fresh vegetables from a shopkeeper or vendor who is HIV-positive".

recode HA31 (2 = 100) (else = 0) into school.
variable labels school "Think children living with HIV should not be allowed to attend school with children who do not have HIV".

recode HA32 (1 = 100) (else = 0) into hesitate.
variable labels hesitate "Hesitate to take an HIV test because they are afraid of how other people will react if the test result is positive for HIV".

recode HA33 (1 = 100) (else = 0) into talkbadly.
variable labels talkbadly "Talk badly about people living with HIV, or who are thought to be living with HIV".

recode HA34 (1 = 100) (else = 0) into respect.
variable labels respect "Living with HIV, or thought to be living with HIV, lose the respect of other people".

recode HA35 (1 = 100) (else = 0) into ashamed.
variable labels ashamed "Would be ashamed if someone from family had HIV".

recode HA36 (1 = 100) (else = 0) into fear.
variable labels fear "Fear getting HIV if coming into contact with the saliva of a person living with HIV [B]".
*** .	
	
	
* Women who have ever been tested includes HA14=1 or HA19=1 or HA22=1 or HA24=1.
compute beenTested = 0.
if (HA14 = 1 or HA19 = 1 or HA22 = 1 or HA24 = 1) beenTested = 100.
variable labels beenTested "Have ever been tested".

* Women who know of a place to get tested for HIV includes those who have already been tested (HA14=1 or HA19=1 or HA22=1 or HA24=1). 
* and those who report that they know of a place to get tested (HA27=1).
compute knowPlace = 0.
if (beenTested = 100 or HA27 = 1)  knowPlace = 100.
variable labels knowPlace "Know a place to get tested [1]".

* Women who have ever been tested includes HA16=1 or HA20=1 or HA22=1 or HA24=1; 
* those who know the result of the most recent test are (a) HA22=2 and (HA17=1 or HA21=1) or (b) HA26=1.
compute toldResult = 0.
if (beenTested = 100 and ((HA22 = 2 and (HA15=1 or HA20=1)) or HA26=1)) toldResult = 100.
variable labels toldResult "Have ever been tested and know the result of the most recent test".

* Women who have been tested for HIV during the last 12 months includes HA23=1 or HA25=1.
compute tested12 = 0.
if (HA23 = 1 or HA25 = 1) tested12 = 100.
variable labels tested12 "Have been tested in the last 12 months".

* ..and those who know the results are (a) HA23=1 and (HA17=1 or HA21=1) or (b) HA25=1 and HA26=1.
compute toldResult12 = 0.
if ((HA23 = 1 and (HA15 = 1 or HA20 = 1)) or (HA25 = 1 and HA26 = 1)) toldResult12 = 100.
variable labels toldResult12 "Have been tested in the last 12 months and know the result [2], [3]".

*Those who have heard of test kits are those responding 'yes' to HA28;.
compute testkit = 0.
if (HA28=1) testkit = 100.
variable labels testkit "Have heard of test kits people can use to test themselves for HIV [A]".

* Those who have used are HA29=1.
compute selftestkit = 0.
if (HA29=1) selftestkit = 100.
variable labels selftestkit "Have tested themselves for HIV using a self-test kit [A]".



*** TM 10.1W.

compute sexEver = 0.
if (SB1 <> 0) sexEver = 100.
variable labels sexEver "Ever had sex".

compute sex12 = 0.
if (SB1 <> 0 and SB2U >= 1 and SB2U <= 3) sex12 = 100.
variable labels sex12 "Had sex in the last 12 months".

compute morePartners = 0.
if (sex12 = 100 and SB7 = 1) morePartners = 100.
variable labels morePartners "Had sex with more than one partner in last 12 months [1]".

do if (morePartners = 100).
+ compute numWomenMorePartners = 1.
+ compute usedCondom = 0.
+ if (SB3 = 1) usedCondom = 100.
end if.

variable labels usedCondom "Percentage of women who had more than one sexual partner in the last 12 months reporting that a condom was used the last time they had sex [2]".
value labels numWomenMorePartners 1 "Number of women who had more than one sexual partner in the last 12 months".

