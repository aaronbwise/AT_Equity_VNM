* Encoding: windows-1252.
 * "Source of net: TN10 (1-3) and TN12

 * Insecticide-treated nets (ITN) are long lasting insecticidal treated nets (TN5=11-18)."														
										
* v02 - 2020-04-14. Table sub-title changed based on the latest tab plan. Labels in French and Spanish have been removed.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open nets data file.
get file = "tn.sav".

sort cases by HH1 HH2.

weight by hhweight.

compute nettype=2.
if (TN5 >=11 and TN5 <= 18) nettype = 1.
variable labels nettype "Type of net".
value labels nettype 1 "ITN [A]" 2 "Other/Missing".

compute source =99.
if TN12>=1 source=TN12+3.
if TN10 <=3 source=TN10.
if TN12=96 source=96.
if TN12>=98 source=99.

variable labels source "Percent distribution of source of mosquito nets".
value labels source 1"Mass distribution campaign" 2"Antenatal Care visit" 3 "Immunization visit" 4"Health facility-Government" 5 "Health facility-Private"  
                               6 "Pharmacy" 7 "Shop/ Market/ Street" 8 "Community health worker" 9 "Religious institution" 10 "School" 96 "Other" 99 "DK/Missing".

compute numnets = 1.
value labels numnets  1 "Number of mosquito nets".
variable labels  numnets "".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".
							   
* Ctables command in English.
ctables
  /vlabels variables =  numnets tot 
         display = none
  /table tot [c]
         + HH6 [c]
         + HH7 [c]
         + nettype [c]
         + helevel [c]
         + ethnicity [c]
         + windex5 [c] by 
             source [c] [rowpct.totaln '' f5.1] 	
         + numnets [c] [count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=source total=yes position= after label= "Total"
  /slabels position=column visible = no
  /titles title=
	"Table TC.6.2: Source of mosquito nets"
                  "Percent distribution of mosquito nets by source of net, "  + surveyname
  caption =
   "[A] An insecticide-treated net (ITN) is a net treated at factory that does not require any further treatment. In previous surveys, this was known as a long-lasting insecticidal net (LLIN). An 'other' net is any net that is not an ITN.".		
.																

new file.