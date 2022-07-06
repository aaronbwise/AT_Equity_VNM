* MICS5 HA-08 .

* v01 - 2014-03-17.

* Some columns in this table are presenting disaggregated information for women age 15-24 years that is already described in the respective tables
  for women age 15-49 years.
* Please refer to these tables for detailed information on calculations:
    Ever had sex: HA.6
    More than one partner in last 12 months: HA.6
    Condom use during last sex for women with multiple sex partners: HA.6 .

* Had sex before age 15:
    Calculated based on responses to SB1 (SB1<>0 AND SB1<15). 
*   If the response is that the first time she had sex was when she started living with her first husband or partner (SB1=95), then her age 
    at first sex is calculated from the date of first marriage/union or age at first marriage/union given in MA8 and MA9 
    (SB1=95 and ((MA8-WB1)<15 OR MA9<15)). 
*   These calculations are performed with Century Month Codes (CMC).

* Never had sex:
    This indicator is calculated only for women who have never been married (MA5=3).
*   Never had sex: SB1=00.

* Sex with a man 10 or more years older:
    This is based only on women (not included in Table HA.8M) who had sex in the 12 months preceding the survey (SB1<>00 and SB3<>401).
*   The age difference between the respondent and her partner is calculated by using information on the age(s) of partner(s) during the last 
    12 months (SB7 and SB12).
*   If the last sexual partner during this period is a husband or cohabiting partner, then the partner's age information is obtained from MA2
    if the respondent is currently married or living with a man (MA1=1 or 2). 
*   If the respondent is not currently married, then information in SB7 is used. 
*   If the respondent had more than one partner in the 12 months preceding the survey, the age of the previous partner is obtained from SB12,
    with the exception of those respondents who are currently married or living with a man and have been married/lived with a man only once. 

* Sex with a non-marital, non-cohabiting partner:
    Women who had more than one partner in the last 12 months (SB3<401 and SB8=1).

* Condom use during last sex for women with a non-marital, non-cohabiting partner:
    Using the above as denominator, the numerator is: SB4=1 .


***.


include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

select if (wage = 1 or wage = 2) .

* include HA . 
include 'define\MICS5 - 10 - HA.sps' .

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
+ if ((SB5 = 1 or SB5 = 2 or SB10 = 1 or SB10 = 2) and MA2 <= 96 and MA2-WB2 >= 10) partner10YearsOlder = 100.
+ if (SB5  <> 1 and SB5  <> 2 and SB7  <= 96 and SB7  - WB2 >= 10) partner10YearsOlder = 100.
+ if (SB10 <> 1 and SB10 <> 2 and SB12 <= 96 and SB12 - WB2 >= 10) partner10YearsOlder = 100.
+ compute numWomenSex12 = 1 .
end if.
variable labels partner10YearsOlder "A man 10 or more years older [3]" .
variable labels numWomenSex12 "Number of women age 15-24 years who had sex in the last 12 months" .

compute neverMarried = 0 .
* if (mstatus = 3) neverMarried = 1 .
if (MA1 = 3 and MA5 = 3) neverMarried = 1 .
variable labels neverMarried "Number of never-married women age 15-24 years" .

compute womenNonMaritalPartner = 0.
compute numWomenNonMaritalPartner = 0.
if (SB5 > 2 or SB10 > 2) womenNonMaritalPartner = 100.
if (SB5 > 2 or SB10 > 2) numWomenNonMaritalPartner = 1.

variable labels womenNonMaritalPartner "A non-marital, non-cohabiting partner [4]" .
variable labels numWomenNonMaritalPartner "Number of women age 15-24 years who had sex with a non-marital, non-cohabiting partner in last 12 months" .

do if (numWomenNonMaritalPartner <> 0) .
+ compute usedCondomNonMarital = 0 .
+ if ((SB4 = 1 and SB5 > 2) or
      (SB9 = 1 and SB10 > 2)   ) usedCondomNonMarital = 100 .
end if .

variable labels usedCondomNonMarital "Percentage reporting the use of a condom during the last sexual intercourse with a non-marital, non-cohabiting partner in the last 12 months [5]" .

recode mstatus (1,2 = 1) (3 = 2).
variable labels mstatus "Marital status" .
add value labels mstatus
  1 "Ever married/in union"
  2 "Never married/in union" .

recode wage (1 = 1) (2 = 4) into wageAux1 .
recode WB2
 (15 thru 17 = 2)
 (18 thru 19 = 3)
 (20 thru 22 = 5)
 (23 thru 24 = 6) into wageAux2 .

variable labels wageAux1 "Age".
value labels wageAux1
1 "15-19"
2 "    15-17"
3 "    18-19"
4 "20-24"
5 "    20-22"
6 "    23-24" .

mrsets
  /mcgroup name=$wage
   label='Age'
   variables= wageAux1 wageAux2 .

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


* ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = total layerWho layerHad numWomen
           display = none
  /table   total [c]
         + hh7 [c]
         + hh6 [c]
         + $wage [c]
         + mstatus [c]
         + welevel [c]
         + windex5 [c]
         + ethnicity [c]
   by
           layerWho [c]  > (
             sexBefore15 [s] [mean,'',f5.1]
           + sexEver [s] [mean,'',f5.1]
           + morePartners [s] [mean,'',f5.1] )
         + numWomen [c] [count,'',f5.0]
         + neverHadSex [s] [mean,'',f5.1]
         + neverMarried [s] [sum,'',f5.0]
         + layerHad [c]  > (
             partner10YearsOlder [s] [mean,'',f5.1]
           + womenNonMaritalPartner [s] [mean,'',f5.1] )
         + numWomenSex12 [s] [sum,'',f5.0]
         + usedCondomNonMarital [s] [mean,'',f5.1]
         + numWomenNonMaritalPartner [s] [sum,'',f5.0]
         + usedCondom [s] [mean,'',f5.1]
         + numWomenMorePartners [s] [sum,'',f5.0] 
  /categories var = all empty = exclude missing = exclude
  /slabels visible = no
  /title title=
    "Table HA.8: Key sexual behaviour indicators (young women)"
    "Percentage of women age 15-24 years by key sexual behaviour indicators, " + surveyname
   caption=
    "[1] MICS indicator 9.10 - Sex before age 15 among young women"
    "[2] MICS indicator 9.9 - Young women who have never had sex"
    "[3] MICS indicator 9.11 - Age-mixing among sexual partners"
    "[4] MICS indicator 9.14 - Sex with non-regular partners"
    "[5] MICS indicator 9.15 - Condom use with non-regular partners"
  .

new file.
