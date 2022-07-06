* v1 - 2014-04-06.
* v2 - 2015-04-21: subtitle and column order updated.

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

*Households with at least one LLIN: TN5=11-18 for any net in the household.
compute longtreat = 0.
if (TN5 >=11 and TN5 <= 18) longtreat = 1.
variable labels  longtreat "Long-lasting insecticidal treated net (LLIN)".


* Insecticide treated nets (ITN) are.
*Mosquito nets not in any of these categories are considered untreated.
compute itn = 0.
* (a) long lasting treated nets (TN5=11-18).
if (TN5 >=11 and TN5 <= 18) itn = 1.
* b) pretreated nets obtained within the past 12 months (TN5=21-28 and TN6<12).
if (TN5 >=21 and TN5 <= 28 and TN6 <12) itn = 1.
* (c) Other net (TN5=36 or 98) obtained in the previous 12 months (TN6<12) which was pretreated (TN8=1),.
if ((TN5 = 36 or TN5 = 98) and TN6 <12 and TN8 = 1) itn = 1.
* (d) Other net or pre-treated net (TN5=21-98) treated in the previous 12 months (TN9=1 and TN10<12). 
if (TN5 >= 21 and TN5 <= 98 and TN9 = 1 and TN10 < 12) itn = 1.
variable labels  itn "Insecticide treated mosquito net (ITN) [1]".

aggregate outfile = "tmp.sav"
  /break=HH1 HH2
  /longtreat=max(longtreat)
  /longtreatN=sum(longtreat)
  /itn=max(itn)
  /itnN=sum(itn).

get file = 'hh.sav'.

sort cases by HH1 HH2.

match files 
  /file=*
  /table='tmp.sav'
  /by hh1 hh2.

select if (HH9 = 1).

weight by hhweight.

compute total = 1.
value labels total  1 "Number of households".
variable labels  total "".

compute anynet = 0.
if (TN1 = 1) anynet = 100.
variable labels  anynet "Any mosquito net".

recode longtreat (0, sysmis = 0) (1 = 100) .
recode itn (0, sysmis = 0) (1 = 100).

* The numerators are based on number of usual (de jure) household members 
* and does not take into account whether household members stayed in the household last night. 
* at least one net for every two persons.
compute anynet2 = 0.
recode TN2 (sysmis = 0) (else = copy).
if (TN2 * 2 >= HH11) anynet2 = 100.
variable labels  anynet2 "Any mosquito net".

* at least one long  lasting net for every two persons.
compute longtreat2 = 0.
if (longtreatN * 2 >= HH11) longtreat2 = 100.
variable labels  longtreat2 "Long-lasting insecticidal treated net (LLIN)".

* at least one lITN for every two persons.
compute itn2 = 0.
if (itnN * 2 >= HH11) itn2 = 100.
variable labels  itn2 "Insecticide treated mosquito net (ITN) [2]".
	
*Households that received IRS during the last 12 months: IR1=1 and IR2=A, B, and/or C.			
compute irs = 0.
if (IR1 = 1 and (IR2A = "A" or IR2B = "B" or IR2C = "C")) irs = 100.
variable labels irs "Percentage of households with IRS in the past 12 months".

compute itnirs = 0.
if (itn = 100 or irs = 100) itnirs = 100.
variable labels  itnirs "Percentage of households with at least one ITN and/or IRS during the last 12 months [3]".

compute itnLeast2 = 0.
if (itn2 = 100 or irs = 100) itnLeast2 = 100.
variable labels itnLeast2 "Percentage of households with at least one ITN for every 2 persons and/or received IRS during the last 12 months [4]".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

compute layer1 = 0.
variable labels layer1 " ".
value labels layer1 0 "Percentage of households with at least one mosquito net:".

compute layer2 = 0.
variable labels layer2 " ".
value labels layer2 0 "Percentage of households with at least one net for every two persons [a]".


* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables =  total tot layer1 layer2
         display = none
  /table tot [c] + hh7 [c] + hh6 [c] + helevel [c] + windex5 [c] + ethnicity [c] by 
   	layer1 [c] > (anynet [s] [mean,'',f5.1] + itn [s] [mean,'',f5.1] + longtreat [s] [mean,'',f5.1])+
	layer2 [c] > (anynet2 [s] [mean,'',f5.1] + itn2 [s] [mean,'',f5.1] + longtreat2 [s] [mean,'',f5.1])
	 +  irs [s] [mean,'',f5.1] + itnirs [s] [mean,'',f5.1] + itnLeast2 [s] [mean,'',f5.1] + total [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
	"Table CH.14: Household availability of insecticide treated nets and protection by a vector control method "											
 "Percentage of households with at least one mosquito net, one insecticide treated net (ITN), and one long-lasting treated net, "
 "percentage of households with at least one mosquito net, one insecticide treated net (ITN) per two people, "
 "and one long-lasting treated net, percentage of households with at least one ITN and/or indoor residual spraying (IRS) in the last 12 months, "
 "and percentage of households with at least one ITN per two people and/or with indoor residual spraying (IRS) in the last 12 months, "
                                    + surveyname
  caption =
  "[1] MICS indicator 3.16a - Household availability of insecticide-treated nets (ITNs) - One+"
  "[2] MICS indicator 3.16b - Household availability of insecticide-treated nets (ITNs) - One+ per 2 people"											
  "[3] MICS indicator 3.17a - Households covered  by vector control - One+ ITNs"											
  "[4] MICS indicator 3.17b - Households covered  by vector control - One+ ITNs per 2 people"
  "[a] The numerators are based on number of usual (de jure) household members and does not take into account "
        "whether household members stayed in the household last night. MICS does not collect information on visitors to the household.".										

new file.

* erase working file.
erase file = "tmp.sav".