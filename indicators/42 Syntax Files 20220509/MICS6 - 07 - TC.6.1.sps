* Encoding: windows-1252.
 * Households with at least one mosquito net: TN1=1

 * Insecticide-treated nets (ITN) are long lasting insecticidal treated nets (TN5=11-18).		

* v03 - 2020-04-14. Labels in French and Spanish have been removed.								

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
* Other net			36
* DK brand / type		98.

* Insecticide treated nets (ITN) are.
compute itn = 0.
if (TN5 >=11 and TN5 <= 18) itn = 1.
variable labels  itn "Insecticide treated mosquito net (ITN) [1]".

compute any=1.

aggregate outfile = "tmp.sav"
  /break=HH1 HH2
  /itn=max(itn)
  /itnN=sum(itn)
  /anyN=sum(any).

get file = 'hh.sav'.

sort cases HH1 HH2.

match files 
  /file=*
  /table='tmp.sav'
  /by hh1 hh2.

select if (HH46  = 1).

weight by hhweight.

compute total = 1.
value labels total  1 "Number of households".
variable labels  total "".

compute anynet = 0.
if (TN1 = 1) anynet = 100.
variable labels  anynet "Any mosquito net".

compute numitn=itnN .
compute numanynet=anyN.
variable labels numitn "Insecticide-treated mosquito net (ITN)".
variable labels numanynet "Any mosquito net".  

recode itn (0, sysmis = 0) (1 = 100).

* The numerators are based on number of usual (de jure) household members 
* and does not take into account whether household members stayed in the household last night. 
* at least one net for every two persons.
compute anynet2 = 0.
recode TN2 (sysmis = 0) (else = copy).
if (TN2 * 2 >= HH48) anynet2 = 100.
variable labels  anynet2 "Any mosquito net".

* at least one lITN for every two persons.
compute itn2 = 0.
if (itnN * 2 >= HH48) itn2 = 100.
variable labels  itn2 "Insecticide treated mosquito net (ITN) [2]".
	
compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

compute layer1 = 0.
variable labels layer1 " ".
value labels layer1 0 "Percentage of households with at least one mosquito net:".

compute layer2 = 0.
variable labels layer2 " ".
value labels layer2 0 "Average number of nets per household:".

compute layer3 = 0.
variable labels layer3 " ".
value labels layer3 0 "Percentage of households with at least one net for every two persons [B]".

* Ctables command in English.
ctables
  /vlabels variables =  total tot layer1 layer2 layer3
         display = none
  /table tot [c]
         + HH6 [c]
         + HH7 [c]
         + helevel [c]
         + ethnicity [c]
         + windex5 [c] by 
   	layer1 [c] > (anynet [s] [mean '' f5.1] + itn [s] [mean '' f5.1])+
	layer2 [c] > (numanynet [s] [mean '' f5.1] + numitn [s] [mean '' f5.1]) +
	layer3 [c] > (anynet2 [s] [mean '' f5.1] +  itn2 [s] [mean '' f5.1])
	+ total [c] [count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
	"Table TC.6.1: Household possession of mosquito nets"											
 "Percentage of households with at least one mosquito net and insecticide-treated net (ITN) [A], average number of any mosquito net and ITN per household, "+
 "percentage of households with at least one mosquito net and ITN per two people, "  + surveyname
  caption =
  "[1] MICS indicator TC.21a - Household availability of insecticide-treated nets (ITNs) (at least one ITN)"
  "[2] MICS indicator TC.21b - Household availability of insecticide-treated nets (ITNs) (at least one ITN for every two people)"
  "[A] An insecticide-treated net (ITN) is a net treated at factory that does not require any further treatment. In previous surveys, this was known as a long-lasting insecticidal net (LLIN)."
  "[B] The numerators are based on number of usual (de jure) household members and does not take into account whether household members stayed in the household last night. MICS does not collect information on visitors to the household.".										
									
new file.

* erase working file.
erase file = "tmp.sav".