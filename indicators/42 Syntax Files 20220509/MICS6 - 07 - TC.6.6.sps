* Encoding: windows-1252.
 * "Insecticide treated nets (ITN) are long lasting insecticidal treated nets (TN5=11-18). 

 * ITNs in use last night is: TN13=1"		

****.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open nets data file.
get file = "tn.sav".

sort cases by HH1 HH2.

weight by hhweight.

compute itn = 0.
if (TN5 >=11 and TN5 <= 18) itn = 1.
variable labels  itn "Insecticide treated mosquito net (ITN)".

*ITNs in use last night is: TN13=1.
do if (itn = 1).
+ compute usedLastNight = 0.
+ if (TN13 = 1) usedLastNight = 100.
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
  /table tot [c] 
         + HH6 [c]
         + HH7 [c]
         + helevel [c]
         + ethnicity [c]
         + windex5 [c] 
       by 
         usedLastNight [s][mean '' f5.1] + itnN [c][count,''f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
	"Table TC.6.6: Use of existing ITNs"
                  "Percentage of insecticide-treated nets (ITNs) that were used by anyone last night, " + surveyname.
					
new file.