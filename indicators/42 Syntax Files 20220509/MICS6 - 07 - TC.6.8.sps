* Encoding: UTF-8.
 * TN15 in the Insecticide Treated Nets module is used to determine if a pregnant woman living in the household has slept under any of the nets in the household. 

 * The denominator of the table includes women age 15-49 years (HL6=15-49) listed in the List of Household Members who stayed in the household the previous night (HL7=1)

 * Households with at least one mosquito net: TN1=1

 * Households with at least one ITN: TN5=11-18.

 * Insecticide treated nets (ITN) are long lasting insecticidal treated nets (TN5=11-18).		

**********************************************************************************************************************************************
* v04 - 2021-10-26
Line 22: removed TN7 and TN9 from the statement below:
  /keep HH1 HH2 HL1 HL7 TNLN TN3 TN4 TN5 TN7 TN9 TN10 TN12 TN13 TN15_1 TN15_2 TN15_3 TN15_4.			

get file = 'hl.sav'.

sort cases by HH1 HH2 HL1.

save outfile = "tmp.sav"
  /keep HH1 HH2 HL1 HL7 TNLN TN3 TN4 TN5 TN10 TN12 TN13 TN15_1 TN15_2 TN15_3 TN15_4
  /rename HL1 = LN.

get file = "tmp.sav".

sort cases by HH1 HH2 LN.

compute itnh = 0.
if (TN5 >=11 and TN5 <= 18) itnh = 1.
variable labels  itnh "Percentage of households with at least one ITN".

aggregate outfile = "tmp1.sav"
  /break=HH1 HH2
  /itnh=max (itnh) .

get file = "wm.sav".

include "CommonVarsWM.sps".

sort cases by HH1 HH2 LN.

match files 
  /file=*
  /table='tmp.sav'
  /by hh1 hh2 ln.

match files 
  /file=*
  /table='tmp1.sav'
  /by hh1 hh2.

select if (WM17 = 1 and CP1=1).

weight by wmweight.

compute total = 1.
value labels total  1 "Number of pregnant women".
variable labels  total "".

compute sleep = 0.
if (HL7 = 1) sleep = 100.
variable labels  sleep "Percentage of pregnant women who spent last night in the interviewed households".

do if (sleep = 100).

+ compute netpresent = 0.
+ if (TN13 = 1) netpresent = 100.

+ compute itn = 0.
+ if (TN5 >=11 and TN5 <= 18) itn = 100.

+ compute stotal = 1.
+ variable labels  stotal "".

end if.

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of pregnant women who the previous night slept under:".

variable labels  netpresent "Any mosquito net".
variable labels  itn "An insecticide treated net (ITN) [1] [A]".
value labels stotal 1 "Number of pregnant women who spent last night in the interviewed households".

do if (itnh > 0 and sleep = 100).

+ compute itnsl = 0.
+ if (itn = 100) itnsl = 100.

+ compute itnhtot = 1.
+ variable labels  itnhtot "".

end if.

variable labels  itnsl "Percentage of pregnant women who slept under an ITN last night in households with at least one ITN".
value labels itnhtot 1 "Number of pregnant women living in households with at least one ITN".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

* Ctables command in English.
ctables
  /vlabels variables =  total tot stotal itnhtot layer
         display = none
  /table tot [c] 
         + HH6 [c]
         + HH7 [c]
         + wageu [c]
         + welevel [c]
         + ethnicity [c]
         + windex5 [c]
        by 
   	sleep [s] [mean '' f5.1] +  total [c] [count '' f5.0] +
                  layer [c] > ( netpresent [s] [mean '' f5.1] +  itn [s] [mean '' f5.1] ) + stotal [c] [count '' f5.0] +
                  itnsl [s] [mean '' f5.1] + itnhtot [c] [count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table TC.6.8: Use of mosquito nets by pregnant women"								
   "Percentage of pregnant women age 15-49 years who slept under a mosquito net last night, by type of net, "+ surveyname
  caption=
   "[1] MICS indicator TC.24 - Pregnant women who slept under an insecticide-treated net (ITN)"
   "[A] An insecticide-treated net (ITN) is a net treated at factory that does not require any further treatment. In previous surveys, this was known as a long-lasting insecticidal net (LLIN).".

new file.

* erase working file.
erase file = "tmp.sav".
erase file = "tmp1.sav".