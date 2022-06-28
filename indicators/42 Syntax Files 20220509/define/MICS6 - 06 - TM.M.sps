* Encoding: UTF-8.
* v02 - 2020-04-26. Updated label of the variable selftestkit.
* v03. 2020-05-06: lines:
*compute none = 0.
* if (MHA8A <> 1 and MHA8B <> 1 and MHA8C <> 1) none = 100.
* variable labels none "Do not know any of the specific means of HIV transmission from mother to child".
* changed to:
 * compute none = 0.
 * if (MHA1 = 2 or ((MHA8A = 2 or MHA8A = 8) and (MHA8B = 2 or MHA8B = 8) and (MHA8C = 2 or MHA8C = 8))) none = 100.
 * variable labels none "Do not know any of the specific means of HIV transmission from mother to child".

***  .

recode MHA1 (1 = 100) (else = 0) into heardOfAIDS.
variable labels heardOfAIDS "Percentage who have heard of AIDS".

recode MHA2 (1 = 100) (else = 0) into onePartner.
variable labels onePartner "Having only one faithful uninfected sex partner".

recode MHA4 (1 = 100) (else = 0) into condomUse.
variable labels condomUse "Using a condom every time".

count twoWays = onePartner condomUse (100).
recode twoWays (2 = 100) (else = 0) into knowBoth.
variable labels knowBoth "Both".

recode MHA7 (1 = 100) (else = 0) into healthy.
variable labels healthy "Percentage who know that a healthy-looking person can be HIV-positive".

recode MHA3 (2 = 100) (else = 0) into mosquito.
variable labels mosquito "Mosquito bites".

recode MHA6 (2 = 100) (else = 0) into supernatural.
variable labels supernatural "Supernatural means".

recode MHA5 (2 = 100) (else = 0) into sharingFood.
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
* if we haven't found two, and it is the one, increase the value, so in next round it will not be the same.
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


***  .

compute knowForTransmision = 0.
if (MHA8A = 1 or MHA8B = 1 or MHA8C = 1) knowForTransmision = 100.
variable labels knowForTransmision "Percentage who know HIV can be transmitted from mother to child".

recode MHA8A (1 = 100) (else = 0) into duringPregnancy.
variable labels duringPregnancy "During pregnancy".

recode MHA8B (1 = 100) (else = 0) into duringDelivery.
variable labels duringDelivery "During delivery".

recode MHA8C (1 = 100) (else = 0) into byBreastfeeding.
variable labels byBreastfeeding "By breastfeeding".

compute atLeastOne = 0.
if (MHA8A = 1 or MHA8B = 1 or MHA8C = 1) atLeastOne = 100.
variable labels atLeastOne "By at least one of the three means".

compute allThree = 0.
if (MHA8A = 1 and MHA8B = 1 and MHA8C = 1) allThree = 100.
variable labels allThree "By all three means [1]".

compute none = 0.
if (MHA1 = 2 or ((MHA8A = 2 or MHA8A = 8) and (MHA8B = 2 or MHA8B = 8) and (MHA8C = 2 or MHA8C = 8))) none = 100.
variable labels none "Do not know any of the specific means of HIV transmission from mother to child".




***  .

recode MHA30 (2 = 100) (else = 0) into food.
variable labels food "Would not buy fresh vegetables from a shopkeeper or vendor who is HIV-positive" .

recode MHA31 (2 = 100) (else = 0) into school.
variable labels school "Think children living with HIV should not be allowed to attend school with children who do not have HIV".

recode MHA32 (1 = 100) (else = 0) into hesitate.
variable labels hesitate "Hesitate to take an HIV test because they are afraid of how other people will react if the test result is positive for HIV".

recode MHA33 (1 = 100) (else = 0) into talkbadly.
variable labels talkbadly "Talk badly about people living with HIV, or who are thought to be living with HIV".

recode MHA34 (1 = 100) (else = 0) into respect.
variable labels respect "Living with HIV, or thought to be living with HIV, lose the respect of other people".

recode MHA35 (1 = 100) (else = 0) into ashamed.
variable labels ashamed "Would be ashamed if someone from family had HIV".

recode MHA36 (1 = 100) (else = 0) into fear.
variable labels fear "Fear getting HIV if coming into contact with the saliva of a person living with HIV [B]".


***  .

*Men who have ever been tested: MHA24=1. 
compute beenTested = 0.
if (MHA24 = 1) beenTested = 100.
variable labels beenTested "Have ever been tested".

*Men who know of a place to get tested for HIV includes those who have already been tested (MHA24=1) and those who report that they know of a place to get tested (MHA27=1).
compute knowPlace = 0.
if (beenTested = 100 or MHA27 = 1)  knowPlace = 100.
variable labels knowPlace "Know a place to get tested [1]".

*..those who know the result are MHA26=1.
compute toldResult= 0.
if (beenTested = 100 and MHA26 = 1) toldResult = 100.
variable labels toldResult "Have ever been tested and know the result of the most recent test".

* Men who have been tested for HIV during the last 12 months includes MHA25=1.
compute tested12 = 0.
if (MHA25 = 1) tested12 = 100.
variable labels tested12 "Have been tested in the last 12 months".

*.. those who know the results are MHA26=1.
compute toldResult12 = 0.
if (tested12 = 100 and MHA26 = 1) toldResult12 = 100.
variable labels toldResult12 "Have been tested in the last 12 months and know the result [2] [3]".

*Those who have heard of test kits are those responding 'yes' to MHA28;.
compute testkit = 0.
if (MHA28=1) testkit = 100.
variable labels testkit "Have heard of test kits people can use to test themselves for HIV [A]".

* Those who have used are MHA29=1.
compute selftestkit = 0.
if (MHA29=1) selftestkit = 100.
variable labels selftestkit "Have tested themselves for HIV using a self-test kit [A]".


*** .
compute sexEver = 0.
if (MSB1 <> 0) sexEver = 100.
variable labels sexEver "Ever had sex".

compute sex12 = 0.
if (MSB1 <> 0 and MSB2U >= 1 and MSB2U <= 3) sex12 = 100.
variable labels sex12 "Had sex in the last 12 months".

compute morePartners = 0.
if (sex12 = 100 and MSB7= 1) morePartners = 100.
variable labels morePartners "Had sex with more than one partner in last 12 months [1]".

do if (morePartners = 100).
+ compute numMenMorePartners = 1.
+ compute usedCondom = 0.
+ if (MSB3 = 1) usedCondom = 100.
end if.

variable labels usedCondom "Percentage of men who had more than one sexual partner in the last 12 months reporting that a condom was used the last time they had sex [2]".
value labels numMenMorePartners 1 "Number of men who had more than one sexual partner in the last 12 months".

