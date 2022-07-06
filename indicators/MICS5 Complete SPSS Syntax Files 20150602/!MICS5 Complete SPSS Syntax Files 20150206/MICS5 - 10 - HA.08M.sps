* MICS5 HA-08M .

* v01 - 2014-03-14.

* Some columns in this table are presenting disaggregated information for women age 15-24 years that is already described in the respective tables
  for women age 15-49 years.
* Please refer to these tables for detailed information on calculations:
    Ever had sex: HA.6M
    More than one partner in last 12 months: HA.6M
    Condom use during last sex for women with multiple sex partners: HA.6M .

* Had sex before age 15:
    Calculated based on responses to MSB1 (MSB1<>0 AND MSB1<15). 
*   If the response is that the first time she had sex was when she started living with his first husband or partner (MSB1=95), then his age 
    at first sex is calculated from the date of first marriage/union or age at first marriage/union given in MA8 and MA9 
    (MSB1=95 and ((MMA8-MWB1)<15 OR MMA9<15)). 
*   These calculations are performed with Century Month Codes (CMC).

* Never had sex:
    This indicator is calculated only for women who have never been married (MA5=3).
*   Never had sex: MSB1=00.

* Sex with a man 10 or more years older:
    This is based only on women (not included in Table HA.8M) who had sex in the 12 months preceding the survey (MSB1<>00 and MSB3<>401).
*   The age difference between the respondent and his partner is calculated by using information on the age(s) of partner(s) during the last 
    12 months (MSB7 and MSB12).
*   If the last sexual partner during this period is a husband or cohabiting partner, then the partner's age information is obtained from MA2
    if the respondent is currently married or living with a man (MA1=1 or 2). 
*   If the respondent is not currently married, then information in MSB7 is used. 
*   If the respondent had more than one partner in the 12 months preceding the survey, the age of the previous partner is obtained from MSB12,
    with the exception of those respondents who are currently married or living with a man and have been married/lived with a man only once. 

* Sex with a non-marital, non-cohabiting partner:
    Women who had more than one partner in the last 12 months (MSB3<401 and MSB8=1).

* Condom use during last sex for women with a non-marital, non-cohabiting partner:
    Using the above as denominator, the numerator is: MSB4=1 .

***.


include "surveyname.sps".

get file = 'mn.sav'.

select if (MWM7 = 1).

weight by mnweight.

select if (mwage = 1 or mwage = 2) .

* include HA . 
include 'define\MICS5 - 10 - HA.M.sps' .

variable labels morePartners "Had sex with more than one partner in last 12 months" .
variable labels usedCondom "Percentage reporting that a condom was used the last time they had sex" .
variable labels numMenMorePartners "Number of men age 15-24 years who had sex with more than one partner in the last 12 months".

compute sexBefore15 = 0 .
if (sexEver<>0 and MSB1 < 15) sexBefore15 = 100 .
if (MSB1 = 95 and mwagem < 15) sexBefore15 = 100 .
variable labels sexBefore15 "Had sex before age 15 [1]" .

if (MMA5 = 3) neverHadSex = 0 .
if (MMA5 = 3 and MSB1 = 0) neverHadSex = 100 . 
variable labels neverHadSex "Percentage of men who never had sex [2]" .

if (sex12 <> 0) numMenSex12 = 1 .

variable labels numMenSex12 "Number of men age 15-24 years who had sex in the last 12 months" .

compute neverMarried = 0 .
* if (mmstatus = 3) neverMarried = 1 .
if (MMA1 = 3 and MMA5 = 3) neverMarried = 1 .
variable labels neverMarried "Number of never-married men age 15-24 years" .

compute menNonMaritalPartner = 0.
compute numMenNonMaritalPartner = 0.
if (MSB5 > 2 or MSB10 > 2) menNonMaritalPartner = 100.
if (MSB5 > 2 or MSB10 > 2) numMenNonMaritalPartner = 1.

variable labels menNonMaritalPartner "Percentage who in the last 12 months had sex with a non-marital, non-cohabiting partner [3]" .
variable labels numMenNonMaritalPartner "Number of men age 15-24 years who had sex with a non-marital, non-cohabiting partner in last 12 months" .

do if (numMenNonMaritalPartner <> 0) .
+ compute usedCondomNonMarital = 0 .
+ if ((MSB4 = 1 and MSB5 > 2) or
      (MSB9 = 1 and MSB10 > 2)   ) usedCondomNonMarital = 100 .
end if .

variable labels usedCondomNonMarital "Percentage reporting the use of a condom during the last sexual intercourse with a non-marital, non-cohabiting partner in the last 12 months [4]" .

recode mmstatus (1,2 = 1) (3 = 2).
variable labels mmstatus "Marital status" .
add value labels mmstatus
  1 "Ever married/in union"
  2 "Never married/in union" .

recode mwage (1 = 1) (2 = 4) into mwageAux1 .
recode MWB2
 (15 thru 17 = 2)
 (18 thru 19 = 3)
 (20 thru 22 = 5)
 (23 thru 24 = 6) into mwageAux2 .

variable labels mwageAux1 "Age".
value labels mwageAux1
1 "15-19"
2 "    15-17"
3 "    18-19"
4 "20-24"
5 "    20-22"
6 "    23-24" .

mrsets
  /mcgroup name=$mwage
   label='Age'
   variables= mwageAux1 mwageAux2 .

compute total = 1.
variable labels total "".
value labels total 1 "Total".

compute layerWho = 0.
variable labels layerWho "".
value labels layerWho 0 "Percentage of men age 15-24 years who:".

compute numMen = 1.
variable labels numMen "".
value labels numMen 1 "Number of men age 15-24 years".

* ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = total layerWho numMen
           display = none
  /table   total [c]
         + hh7 [c]
         + hh6 [c]
         + $mwage [c]
         + mmstatus [c]
         + mwelevel [c]
         + windex5 [c]
         + ethnicity [c]
   by
           layerWho [c]  > (
             sexBefore15 [s] [mean,'',f5.1]
           + sexEver [s] [mean,'',f5.1]
           + morePartners [s] [mean,'',f5.1] )
         + numMen [c] [count,'',f5.0]
         + neverHadSex [s] [mean,'',f5.1]
         + neverMarried [s] [sum,'',f5.0]
         + menNonMaritalPartner [s] [mean,'',f5.1]
         + numMenSex12 [s] [sum,'',f5.0]
         + usedCondomNonMarital [s] [mean,'',f5.1]
         + numMenNonMaritalPartner [s] [sum,'',f5.0]
         + usedCondom [s] [mean,'',f5.1]
         + numMenMorePartners [s] [sum,'',f5.0] 
  /categories var = all empty = exclude missing = exclude
  /slabels visible = no
  /title title=
    "Table HA.8M: Key sexual behaviour indicators (young men)"
    "Percentage of men age 15-24 years by key sexual behaviour indicators, " + surveyname
   caption=
    "[1] MICS indicator 9.10 - Sex before age 15 among young men [M]"
    "[2] MICS indicator 9.9 - Young men who have never had sex [M]"
    "[3] MICS indicator 9.14 - Sex with non-regular partners [M]"
    "[4] MICS indicator 9.15 - Condom use with non-regular partners [M]"
  .

new file.
