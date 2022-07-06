* v1 - 2014-04-06.

****.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open nets data file.
get file = "tn.sav".

weight by hhweight.

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
variable labels  itn "ITNs".

*ITNs in use last night is: TN11=1.
do if (itn = 1).
+ compute usedLastNight = 0.
+ if (TN11 = 1) usedLastNight = 100.
+ compute itnN = 1.
end if.

variable labels usedLastNight "Percentage of ITNs used last night".
variable labels  itnN "".
value labels itnN 1 "Number of ITNs".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

ctables
  /vlabels variables =  tot itnN
         display = none
  /table tot [c] + hh7 [c] + hh6 [c] + windex5 [c]  + ethnicity [c]  by 
   	usedLastNight [s][mean,'',f5.1] + itnN [c][count,''f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
	"Table CH.17: Use of ITNs"
	"Percentage of insecticide treated nets (ITNs) that were "	
	"used by anyone last night, "									
                                    + surveyname.
							
new file.
