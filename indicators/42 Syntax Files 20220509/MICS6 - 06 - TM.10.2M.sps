* Encoding: windows-1252.
 * Some columns in this table are presenting disaggregated information for men age 15-24 years that is already described in the respective tables for men age 15-49 years. Please refer to these tables 
  for detailed information on calculations:

 * Ever had sex: TM.10.1M
More than one partner in last 12 months: TM.10.1M
Condom use during last sex for women with multiple sex partners: TM.10.1M

 * Had sex before age 15:
 Calculated based on responses to MSB1 (MSB1<>0 AND MSB1<15). If the response is that the first time he had sex was when he started living with his first wife or partner (MSB1=95), then his age 
 at first sex is calculated from the date of first marriage/union or age at first marriage/union given in MMA8A/B and MMA11A/B (MSB1=95 and ((MMA8A/B-MWB3)<15 OR MMA11A/B<15)). These calculations 
 are performed with Century Month Codes (CMC).

 * Never had sex:
 This indicator is calculated only for men who have never been married (MMA5=3). Never had sex: MSB1=00.

 * Sex with a non-marital, non-cohabiting partner:
 Men who had more than one partner in the last 12 months (MSB2<401 and MSB7=1).

 * Condom use during last sex for men with a non-marital, non-cohabiting partner:
 Using the above as denominator, the numerator is: MSB3=1.

***.

* v02 - 2020-04-14. Labels in French and Spanish have been removed.

include "surveyname.sps".

get file = 'mn.sav'.

include "CommonVarsMN.sps".

select if (MWM17 = 1).

weight by mnweight.

select if (mwage = 1 or mwage = 2) .

* include TM.M . 
include 'define\MICS6 - 06 - TM.M.sps' .

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

do if (sex12 <> 0).
+ compute menNonMaritalPartner = 0.
+ compute numMenNonMaritalPartner = 0.
+ if (MSB4 > 2 or MSB9 > 2) menNonMaritalPartner = 100.
+ if (MSB4 > 2 or MSB9 > 2) numMenNonMaritalPartner = 1.
end if.

variable labels menNonMaritalPartner "Percentage who in the last 12 months had sex with a non-marital, non-cohabiting partner [3]" .
variable labels numMenNonMaritalPartner "Number of men age 15-24 years who had sex with a non-marital, non-cohabiting partner in last 12 months" .

do if (numMenNonMaritalPartner <> 0) .
+ compute usedCondomNonMarital = 0 .
+ if ((MSB3 = 1 and MSB4 > 2) or
      (MSB8 = 1 and MSB9 > 2)   ) usedCondomNonMarital = 100 .
end if .

variable labels usedCondomNonMarital "Percentage reporting the use of a condom during the last sexual intercourse with a non-marital, non-cohabiting partner in the last 12 months [4]" .

compute total = 1.
variable labels total "".
value labels total 1 "Total".

compute layerWho = 0.
variable labels layerWho "".
value labels layerWho 0 "Percentage of men age 15-24 years who:".

compute numMen = 1.
variable labels numMen "".
value labels numMen 1 "Number of men age 15-24 years".

* ctables command in English.
ctables
  /format empty = "na" missing = "na"    
  /vlabels variables = total layerWho numMen
           display = none
  /table   total [c]
         + HH6 [c]
         + HH7 [c]
         + $mwagex [c]
         + mwelevel [c]
         + mmstatus2 [c]
         + mdisability [c]
         + ethnicity [c]
         + windex5 [c]
   by
          layerWho [c]  > (
            sexEver  [s] [mean '' f5.1]
         + sexBefore15 [s] [mean '' f5.1]
         + morePartners [s] [mean '' f5.1] )
         + numMen [c] [count '' f5.0]
         + neverHadSex [s] [mean '' f5.1]
         + neverMarried [s] [sum '' f5.0]
         + menNonMaritalPartner [s] [mean '' f5.1]
         + numMenSex12 [s] [sum '' f5.0]
         + usedCondomNonMarital [s] [mean '' f5.1]
         + numMenNonMaritalPartner [s] [sum '' f5.0]
         + usedCondom [s] [mean '' f5.1]
         + numMenMorePartners [s] [sum '' f5.0] 
  /categories variables = all empty = exclude missing = exclude
  /slabels visible = no
  /titles title=
    "Table TM.10.2M: Key sexual behaviour indicators (young men)"
    "Percentage of men age 15-24 years by key sexual behaviour indicators, " + surveyname
   caption=
   "[1] MICS indicator TM.24 - Sex before age 15 among young people"
   "[2] MICS indicator TM.25 - Young people who have never had sex" 
   "[3] MICS indicator TM.27 - Sex with non-regular partners" 
   "[4] MICS indicator TM.28 - Condom use with non-regular partners"
 "na: not applicable"   
.

new file.
