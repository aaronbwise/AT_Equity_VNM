* v 2014-04-06.

*.....


* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hl.sav'.

sort cases by HH1 HH2 HL1.

* create tmp file to check if child slept in the hh last night.
save outfile = "tmp.sav"
  /keep HH1 HH2 HL1 HL6A
  /rename HL1 = LN.

get file = "tn.sav".

sort cases by HH1 HH2.

* Insecticide treated nets (ITN) are 
*(a) long lasting treated nets (TN5=11-18) 
(b) pretreated nets obtained within the past 12 months (TN5=21-28 and TN6<12), 
(c) Other net (TN5=36 or 98) obtained in the previous 12 months (TN6<12) which was pretreated (TN8=1), 
(d) Other net or pre-treated net (TN5=21-98) treated in the previous 12 months (TN9=1 and TN10<12). 
*Mosquito nets not in any of these categories are considered untreated.
compute itnh = 0.
if (TN5 >=11 and TN5 <= 18) itnh = 1.
if (TN5 >=21 and TN5 <= 28 and TN6 <12) itnh = 1.
if ((TN5 = 36 or TN5 = 98) and TN6 <12 and TN8 = 1) itnh = 1.
if (TN5 >= 21 and TN5 <= 98 and TN9 = 1 and TN10 < 12) itnh = 1.
variable labels  itnh "Percentage of households with at least one ITN".

aggregate outfile = "tmp1.sav"
  /break=HH1 HH2
  /itnh = max(itnh).

get file = 'hh.sav'.

sort cases by HH1 HH2.

* create tmp file with IRS information.
save outfile = "tmp2.sav"
  /keep HH1 HH2 IR1 IR2A IR2B IR2C.

get file = "ch.sav".

sort cases by HH1 HH2 LN.

match files 
  /file=*
  /table='tmp.sav'
  /by hh1 hh2 ln.

match files 
  /file=*
  /table='tmp1.sav'
  /by hh1 hh2.

match files 
  /file=*
  /table='tmp2.sav'
  /by hh1 hh2.

select if (UF9 = 1).

weight by chweight.

compute total = 1.
value labels total  1 "Number of children age 0-59 months".
variable labels  total "".

*The denominator of the table includes children under age 5 (HL6=00-04) 
listed in the List of Household Members who stayed in the household the previous night (HL6A=1).
compute sleep = 0.
if (HL6A = 1) sleep = 100.
variable labels  sleep "Percentage of children age 0-59 who spent last night in the interviewed households".

do if (sleep = 100).

* Any mosquito net.
+ compute netpresent = 0.
+ if (TN11 = 1) netpresent = 100.

*Insecticide treated nets (ITN) are (a) long lasting treated nets (TN5=11-18)
 (b) pretreated nets obtained within the past 12 months (TN5=21-28 and TN6<12), 
 (c) Other net (TN5=31 or 98) obtained in the previous 12 months (TN6<12) which was pretreated (TN8=1),
 (d) Other net or pre-treated net (TN5=21-98) treated in the previous 12 months (TN9=1 and TN10<12). 
*Mosquito nets not in any of these categories are considered untreated.
+ compute itn = 0.
+ if (TN5 >=11 and TN5 <= 18) itn = 100.
+ if (TN5 >=21 and TN5 <= 28 and TN6 <12) itn = 100.
+ if ((TN5 = 36 or TN5 = 98) and TN6 <12 and TN8 = 1) itn = 100.
+ if (TN5 >= 21 and TN5 <= 98 and TN9 = 1 and TN10 < 12) itn = 100.

*A Long-lasting insecticidal treated net (LLIN).
* Households with at least one LLIN: TN5=11-18 for any net in the household.
+ compute longtreat = 0.
+ if (TN5 >=11 and TN5 <= 18) longtreat = 100.

*Households that received IRS during the last 12 months: IR1=1 and IR2=A, B, and/or C.
+ compute irs = 0.
+ if (IR1 = 1 and (IR2A = "A" or IR2B = "B" or IR2C = "C")) irs = 100.

+ compute stotal = 1.
+ variable labels  stotal "".

end if.

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of children under age five who the previous night slept under:".

variable labels  netpresent "Any mosquito net".
variable labels  itn "An insecticide treated net (ITN) [1]".
variable labels  longtreat "A Long-lasting insecticidal treated net (LLIN)".
variable labels irs "An ITN or in a dwelling sprayed with IRS in the past 12 months".	

value labels stotal 1 "Number of children age 0-59 months who spent last night in the interviewed households".

do if (itnh > 0 and sleep = 100).

+ compute itnsl = 0.
+ if (itn = 100) itnsl = 100.

+ compute itnhtot = 1.
+ variable labels  itnhtot "".

end if.

variable labels  itnsl "Percentage of children who slept under an ITN last night in households with at least one ITN".
value labels itnhtot 1 "Number of children age 0-59 living in households with at least one ITN".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables =  total tot stotal itnhtot layer
         display = none
  /table tot [c] + hl4 [c] + hh7 [c] + hh6 [c] + cage_11 [c] + melevel [c] + windex5 [c] + ethnicity [c] by 
   	sleep [s] [mean,'',f5.1] +  total [c] [count,'',f5.0] +
                  layer [c] > (netpresent [s] [mean,'',f5.1] +  itn [s] [mean,'',f5.1] + longtreat [s] [mean,'',f5.1] + irs [s] [mean,'',f5.1]) +  stotal [c] [count,'',f5.0] +
                  itnsl [s] [mean,'',f5.1] + itnhtot [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
   "Table CH.18: Children sleeping under mosquito nets"
		"Percentage of children age 0-59 months who slept under a mosquito net last night, by type of net, " + surveyname
  caption=
   "[1] MICS indicator 3.18; MDG indicator 6.7 - Children under age 5 sleeping under insecticide-treated nets (ITNs)".
												
new file.

* erase working file.
erase file = "tmp.sav".
erase file = "tmp1.sav".
erase file = "tmp2.sav".