* v1 2014-04-06.
* v2 2014-04-21.
* The background characteristic of “Mother’s education” has been replaced with “Education of household head”.
* The comments to the table have been updated.
* v03 2014-08-19.
* lines: select if (HH6A = 1). changed to select if (HL6A = 1).
* v04 2015-04-21.
* A note has been inserted on age group 0-4 years.

* TN12 in the Insecticide Treated Nets module is used to determine if a household member has slept under any of the nets in the household. 
* The first denominator of the table includes all household members who have stayed in the household the previous night (HL6A=1).
* For definitions of mosquito nets and insecticide treated nets (ITNs) as well as IRS, see footnotes to Table CH.18.

*.....


* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

sort cases by HH1 HH2.

* create tmp file with IRS information.
save outfile = "tmp.sav"
  /keep HH1 HH2 IR1 IR2A IR2B IR2C.

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
  /itnh = max (itnh).

get file = 'hl.sav'.

recode HL6 (0 thru 4 = 1) (5 thru 14 = 2) (15 thru 34 = 3) (35 thru 49 = 4) (50 thru 96 = 5) (97 thru hi = 9) into memage.
variable labels memage "Age".
value labels memage
	1 "0-4 [a]"
	2 "5-14"
	3 "15-34"
	4 "35-49"
	5 "50+"
	9 "Missing/DK".

sort cases by HH1 HH2 HL1.

match files 
  /file=*
  /table='tmp.sav'
  /by hh1 hh2.

match files 
  /file=*
  /table='tmp1.sav'
  /by hh1 hh2.

weight by hhweight.

select if (HL6A = 1).

compute total = 1.
value labels total  1 "Number of household members who spent the previous night in the interviewed households".
variable labels  total "".

* Any mosquito net.
compute netpresent = 0.
if (TN11 = 1) netpresent = 100.

*Insecticide treated nets (ITN) are (a) long lasting treated nets (TN5=11-18)
 (b) pretreated nets obtained within the past 12 months (TN5=21-28 and TN6<12), 
 (c) Other net (TN5=31 or 98) obtained in the previous 12 months (TN6<12) which was pretreated (TN8=1),
 (d) Other net or pre-treated net (TN5=21-98) treated in the previous 12 months (TN9=1 and TN10<12). 
*Mosquito nets not in any of these categories are considered untreated.
compute itn = 0.
if (TN5 >=11 and TN5 <= 18) itn = 100.
if (TN5 >=21 and TN5 <= 28 and TN6 <12) itn = 100.
if ((TN5 = 36 or TN5 = 98) and TN6 <12 and TN8 = 1) itn = 100.
if (TN5 >= 21 and TN5 <= 98 and TN9 = 1 and TN10 < 12) itn = 100.

*A Long-lasting insecticidal treated net (LLIN).
* Households with at least one LLIN: TN5=11-18 for any net in the household.
compute longtreat = 0.
if (TN5 >= 11 and TN5 <= 18) longtreat = 100.

*Households that received IRS during the last 12 months: IR1=1 and IR2=A, B, and/or C.
compute irs = 0.
if (IR1 = 1 and (IR2A = "A" or IR2B = "B" or IR2C = "C")) irs = 100.

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of household members who the previous night slept under:".

variable labels  netpresent "Any mosquito net".
variable labels  itn "An insecticide treated net (ITN) [1]".
variable labels  longtreat "A Long-lasting insecticidal treated net (LLIN)".
variable labels irs "An ITN or in a dwelling sprayed with IRS in the past 12 months".	

do if (itnh > 0).

+ compute itnsl = 0.
+ if (itn = 100) itnsl = 100.

+ compute itnhtot = 1.
+ variable labels  itnhtot "".

end if.

variable labels  itnsl "Percentage who the previous night slept under an ITN".
value labels itnhtot 1 "Number of household members in households with at least one ITN".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".


* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables =  total tot itnhtot layer
         display = none
  /table tot [c] + hl4 [c] + hh7 [c] + hh6 [c] + memage [c] + helevel [c] + windex5 [c] + ethnicity [c] by 
                  layer [c] > (netpresent [s] [mean,'',f5.1] +  itn [s] [mean,'',f5.1] + longtreat [s] [mean,'',f5.1] + irs [s] [mean,'',f5.1]) +  total [c] [count,'',f5.0] +
                  itnsl [s] [mean,'',f5.1] + itnhtot [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
   "Table CH.19: Use of mosquito nets by the household population"
	"Percentage of household members who slept under a mosquito net last night, by type of net, " + surveyname
  caption=
   "[1] MICS indicator 3.19 - Population that slept under an ITN"
   "[a] The results of the age group 0-4 years do not match those in Table CH.18, which is based on completed under-5 interviews only. "
   "The two tables are computed with different sample weights".
												
new file.

* erase working file.
erase file = "tmp.sav".
erase file = "tmp1.sav".