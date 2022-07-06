* v1 - 2014-04-06.

* Insecticide treated nets (ITN) are 
(a) long lasting treated nets (TN5=11-18) 
(b) pretreated nets obtained within the past 12 months (TN5=21-28 and TN6<12),
(c) Other net (TN5=31 or 98) obtained in the previous 12 months (TN6<12) which was pretreated (TN8=1), 
(d) Other net or pre-treated net (TN5=21-98) treated in the previous 12 months (TN9=1 and TN10<12).

*The percentage with access to an ITN is calculated through an intermediate variable at the household level by multiplying the 
number of ITNs in the household by two and then dividing by the number of household members (HH11). 
*If this number is greater than 1 (in the event that a household has more than one ITN for every two people), 
the variable value is set to 1. 
*Through this process, each household is assigned a value between 0 and 1. The value for the household is then assigned to each member of the household.

****.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open nets data file.
get file = "tn.sav".

sort cases by HH1 HH2.

* Long-lasting treated nets
	Brand A		11
	Brand B		12
	Brand C		13
	Other (specify)	16
	DK brand		18
* Pre-treated nets
	Brand D		21
	Brand E		22
	Brand F		23
	Other (specify)	26
	DK brand		28
* Other net			36
* DK brand / type		98.

* Insecticide treated nets (ITN) are 
*(a) long lasting treated nets (TN5=11-18) 
(b) pretreated nets obtained within the past 12 months (TN5=21-28 and TN6<12), 
(c) Other net (TN5=36 or 98) obtained in the previous 12 months (TN6<12) which was pretreated (TN8=1), 
(d) Other net or pre-treated net (TN5=21-98) treated in the previous 12 months (TN9=1 and TN10<12). 
*Mosquito nets not in any of these categories are considered untreated.
compute itn = 0.
if (TN5 >=11 and TN5 <= 18) itn = 1.
if (TN5 >=21 and TN5 <= 28 and TN6 <12) itn = 1.
if ((TN5 = 36 or TN5 = 98) and TN6 <12 and TN8 = 1) itn = 1.
if (TN5 >= 21 and TN5 <= 98 and TN9 = 1 and TN10 < 12) itn = 1.
variable labels  itn "Insecticide treated mosquito net (ITN) [1]".

aggregate outfile = "tmp.sav"
  /break=HH1 HH2
  /itn=max(itn)
  /itnN=sum(itn).

get file = 'hh.sav'.

sort cases by HH1 HH2.

match files 
  /file=*
  /table='tmp.sav'
  /by hh1 hh2.

select if (HH9 = 1).

compute hhweight1 = hhweight*hh11.
weight by hhweight1.

recode itn (sysmis = 0) (else = 100).

recode itnN (sysmis = 0) (else = copy).

*The percentage with access to an ITN.
compute inter = itnN * 2 / HH11.
compute withAccess = 0.
if (inter > 1) withAccess = 100.
variable labels withAccess "Percentage with access to an ITN [a]".

compute total = 1.
variable labels total "".
value labels total 1 "Number of household members [b]".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".


* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables =  tot total
         display = none
  /table tot [c] + hh7 [c] + hh6 [c] + windex5 [c] + ethnicity [c] by 
   	withAccess [s][mean,'',f5.1] + total [c][count,''f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
	"Table CH.16: Access to an insecticide treated net (ITN) - background characteristics "	
	"Percentage of household population with access to an ITN in the household, "								
                                    + surveyname
  caption =
	"[a] Percentage of household population who could sleep under an ITN if each ITN in the household were used by up to two people"												
	"[b] The denominator is number of usual (de jure) household members and does not take into account whether household members stayed"
	       "in the household last night. MICS does not collect information on visitors to the household.".								

new file.

* erase working file.
erase file = "tmp.sav".