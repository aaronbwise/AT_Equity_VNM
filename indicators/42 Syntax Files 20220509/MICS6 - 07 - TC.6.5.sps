* Encoding: windows-1252.
 * TN15 in the Insecticide Treated Nets module is used to determine if a household member has slept under any of the nets in the household. 

 * The first denominator of the table includes all household members who have stayed in the household the previous night (HL7=1).

 * Insecticide treated nets (ITN) are long lasting insecticidal treated nets (TN5=11-18).		

* v03 - 2020-04-14. Labels in French and Spanish have been removed.	


* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = "tn.sav".

sort cases by HH1 HH2.

compute itnh = 0.
if (TN5 >=11 and TN5 <= 18) itnh = 1.
variable labels  itnh "Percentage of households with at least one ITN".

aggregate outfile = "tmp1.sav"
  /break=HH1 HH2
  /itnh = max (itnh).

get file = 'hl.sav'.

recode HL6 (0 thru 4 = 1) (5 thru 14 = 2) (15 thru 34 = 3) (35 thru 49 = 4) (50 thru 96 = 5) (97 thru hi = 9) into memage.
variable labels memage "Age".
value labels memage
	1 "0-4"
	2 "5-14"
	3 "15-34"
	4 "35-49"
	5 "50+"
	9 "DK/Missing".

sort cases by HH1 HH2 HL1.

match files 
  /file=*
  /table='tmp1.sav'
  /by hh1 hh2.

weight by hhweight.

select if (HL7 = 1).

compute total = 1.
value labels total  1 "Number of household members who spent the previous night in the interviewed households".
variable labels  total "".

* Any mosquito net.
compute netpresent = 0.
if (TN13 = 1) netpresent = 100.

*Insecticide treated nets (ITN) are long lasting treated nets (TN5=11-18).
compute itn = 0.
if (TN5 >=11 and TN5 <= 18) itn = 100.

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of household members who the previous night slept under:".

variable labels  netpresent "Any mosquito net".
variable labels  itn "An insecticide treated net (ITN) [1] [A]".

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
	
* Ctables command in English.
ctables
  /vlabels variables =  total tot itnhtot layer
         display = none
  /table tot [c]
         + hl4 [c]
         + HH6 [c]
         + HH7 [c]
         + memage [c]
         + helevel [c]
         + ethnicity [c]
         + windex5 [c] by 
                  layer [c] > (netpresent [s] [mean '' f5.1] +  itn [s] [mean '' f5.1] ) +  total [c] [count '' f5.0] +
                  itnsl [s] [mean '' f5.1] + itnhtot [c] [count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
   "Table TC.6.5: Use of mosquito nets by the household population"
	"Percentage of household members who slept under a mosquito net last night, by type of net, " + surveyname
  caption=
   "[1] MICS indicator TC.22 - Population that slept under an ITN; SDG indicator 3.8.1"
   "[A] An insecticide-treated net (ITN) is a net treated at factory that does not require any further treatment. In previous surveys, this was known as a long-lasting insecticidal net (LLIN).".
						
new file.

* erase working file.
erase file = "tmp1.sav".