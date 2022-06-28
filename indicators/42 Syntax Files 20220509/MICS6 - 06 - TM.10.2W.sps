* Encoding: windows-1252.
 * Some columns in this table are presenting disaggregated information for women age 15-24 years that is already described in the respective tables for women age 15-49 years. Please refer to these 
   tables for detailed information on calculations:

 * Ever had sex: TM.10.1W
More than one partner in last 12 months: TM.10.1W
Condom use during last sex for women with multiple sex partners: TM.10.1W

 * Had sex before age 15:
  Calculated based on responses to SB1 (SB1<>0 AND SB1<15). If the response is that the first time she had sex was when she started living with her first husband or partner (SB1=95), then 
  her age at first sex is calculated from the date of first marriage/union or age at first marriage/union given in MA8A/B and MA11A/B (SB1=95 and ((MA8A/B-WB3)<15 OR MA11A/B<15)). These 
  calculations are performed with Century Month Codes (CMC).

 * Never had sex:
This indicator is calculated only for women who have never been married (MA5=3). Never had sex: SB1=00.

 * Sex with a man 10 or more years older:
This is based only on women (not included in Table HA.8M) who had sex in the 12 months preceding the survey (SB1<>00 and SB2<>401). The age difference between the respondent and her partner
  is calculated by using information on the age(s) of partner(s) during the last 12 months (SB6 and SB12). If the last sexual partner during this period is a husband or cohabiting partner, then the partner's 
 age information is obtained from MA2 if the respondent is currently married or living with a man (MA1=1 or 2). If the respondent is not currently married, then information in SB6 is used. If the respondent 
 had more than one partner in the 12 months preceding the survey, the age of the previous partner is obtained from SB12, with the exception of those respondents who are currently married or living with a man 
 and have been married/lived with a man only once. 

 * Sex with a non-marital, non-cohabiting partner:
Women who had more than one partner in the last 12 months (SB2<401 and SB7=1).

 * Condom use during last sex for women with a non-marital, non-cohabiting partner:
Using the above as denominator, the numerator is: SB3=1.


***.

* v02 - 2020-04-14. Labels in French and Spanish have been removed.


include "surveyname.sps".

get file = 'wm.sav'.

include "CommonVarsWM.sps".

select if (WM17 = 1).

weight by wmweight.

select if (wage = 1 or wage = 2) .

include 'define\MICS6 - 06 - TM.sps' .

variable labels morePartners "Had sex with more than one partner in last 12 months" .
variable labels usedCondom "Percentage reporting that a condom was used the last time they had sex" .
variable labels numWomenMorePartners "Number of women age 15-24 years who had sex with more than one partner in the last 12 months".

compute sexBefore15 = 0 .
if (sexEver <> 0 and SB1 < 15) sexBefore15 = 100 .
if (SB1 = 95 and wagem < 15) sexBefore15 = 100 .
variable labels sexBefore15 "Had sex before age 15 [1]" .

if (MA5 = 3) neverHadSex = 0 .
if (MA5 = 3 and SB1 = 0) neverHadSex = 100 . 
variable labels neverHadSex "Percentage of women who never had sex [2]" .


do if (sex12 <> 0) .
+ compute partner10YearsOlder = 0 .
+ if ((SB4 = 1 or SB4 = 2 or SB9 = 1 or SB9 = 2) and MA2 <= 96 and MA2-WB4 >= 10) partner10YearsOlder = 100.
+ if (SB4  <> 1 and SB4  <> 2 and SB6  <= 96 and SB6  - WB4 >= 10) partner10YearsOlder = 100.
+ if (SB9 <> 1 and SB9 <> 2 and SB12 <= 96 and SB12 - WB4 >= 10) partner10YearsOlder = 100.
+ compute numWomenSex12 = 1 .
end if.
variable labels partner10YearsOlder "A man 10 or more years older [3]" .
variable labels numWomenSex12 "Number of women age 15-24 years who had sex in the last 12 months" .

compute neverMarried = 0 .
if (MA1 = 3 and MA5 = 3) neverMarried = 1 .
variable labels neverMarried "Number of never-married women age 15-24 years" .

do if (sex12 <> 0) .
+ compute womenNonMaritalPartner = 0.
+ compute numWomenNonMaritalPartner = 0.
+ if (SB4 > 2 or SB9 > 2) womenNonMaritalPartner = 100.
+ if (SB4 > 2 or SB9 > 2) numWomenNonMaritalPartner = 1.
end if.

variable labels womenNonMaritalPartner "A non-marital, non-cohabiting partner [4]" .
variable labels numWomenNonMaritalPartner "Number of women age 15-24 years who had sex with a non-marital, non-cohabiting partner in last 12 months" .

do if (numWomenNonMaritalPartner <> 0) .
+ compute usedCondomNonMarital = 0 .
+ if ((SB3 = 1 and SB4 > 2) or
      (SB8 = 1 and SB9 > 2)   ) usedCondomNonMarital = 100 .
end if .

variable labels usedCondomNonMarital "Percentage reporting the use of a condom during the last sexual intercourse with a non-marital, non-cohabiting partner in the last 12 months [5]" .

compute total = 1.
variable labels total "".
value labels total 1 "Total".

compute layerWho = 0.
variable labels layerWho "".
value labels layerWho 0 "Percentage of women age 15-24 years who:".

compute layerHad = 0.
variable labels layerHad "".
value labels layerHad 0 "Percentage of women age 15-24 years who in the last 12 months had sex with:".

compute numWomen = 1.
variable labels numWomen "".
value labels numWomen 1 "Number of women age 15-24 years".

* ctables command in English.
ctables
  /format empty = "na" missing = "na"    
  /vlabels variables = total layerWho layerHad numWomen
           display = none
  /table   total [c]
         + HH6 [c]
         + HH7 [c]
         + $wagex [c]
         + welevel [c]
         + mstatus2 [c]
         + disability [c]
         + ethnicity [c]
         + windex5 [c]
   by
           layerWho [c]  > (
           sexEver [s] [mean '' f5.1]
           + sexBefore15 [s] [mean '' f5.1]
           + morePartners [s] [mean '' f5.1] )
         + numWomen [c] [count '' f5.0]
         + neverHadSex [s] [mean '' f5.1]
         + neverMarried [s] [sum '' f5.0]
         + layerHad [c]  > (
             partner10YearsOlder [s] [mean '' f5.1]
           + womenNonMaritalPartner [s] [mean '' f5.1] )
         + numWomenSex12 [s] [sum '' f5.0]
         + usedCondomNonMarital [s] [mean '' f5.1]
         + numWomenNonMaritalPartner [s] [sum '' f5.0]
         + usedCondom [s] [mean '' f5.1]
         + numWomenMorePartners [s] [sum '' f5.0] 
  /categories variables = all empty = exclude missing = exclude
  /slabels visible = no
  /titles title=
    "Table TM.10.2W: Key sexual behaviour indicators (young women)"
    "Percentage of women age 15-24 years by key sexual behaviour indicators, " + surveyname
   caption=
 "[1] MICS indicator TM.24 - Sex before age 15 among young people"
 "[2] MICS indicator TM.25 - Young people who have never had sex"
 "[3] MICS indicator TM.26 - Age-mixing among sexual partners"
 "[4] MICS indicator TM.27 - Sex with non-regular partners"
 "[5] MICS indicator TM.28 - Condom use with non-regular partners"
 "na: not applicable"
.

new file.
