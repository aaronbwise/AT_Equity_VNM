* Encoding: windows-1252.
 * Insecticide treated nets (ITN) are long lasting insecticidal treated nets (TN5=11-18). 

 * The percentage with access to an ITN is calculated through an intermediate variable at the household level by multiplying 
   the number of ITNs in the household by two and then dividing by the number of household members (HH48). If this number is 
  greater than 1 (in the event that a household has more than one ITN for every two people), the variable value is set to 1. Through this process, e
 ach household is assigned a value between 0 and 1. The value for the household is then assigned to each member of the household.	

****.
* v03 - 2020-04-14. Labels in French and Spanish have been removed.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open nets data file.
get file = "tn.sav".

sort cases by HH1 HH2.

compute itn = 0.
if (TN5 >=11 and TN5 <= 18) itn = 1.
variable labels itn "Insecticide treated mosquito net (ITN)".

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

select if (HH46  = 1).

compute hhweight1 = hhweight*hh48.

weight by hhweight1.

recode itn (sysmis = 0) (else = 100).

recode itnN (sysmis = 0) (else = copy).

*The percentage with access to an ITN.
compute withAccess = itnN * 2 * 100 / HH48.
if (withAccess > 100) withAccess = 100.
variable labels withAccess "Percentage with access to an ITN [A]".

compute total = 1.
variable labels total "".
value labels total 1 "Number of household members [B]".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

* Ctables command in English.
ctables
  /vlabels variables =  tot total
         display = none
  /table tot [c]
         + HH6 [c]
         + HH7 [c]
         + helevel [c]          
         + ethnicity [c]
         + windex5 [c] 
        by  
        withAccess [s][mean '' f5.1] + total [c][count,''f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
	"Table TC.6.4: Access to an insecticide-treated net (ITN) - background characteristics"	
	"Percentage of household population with access to an ITN in the household, "								
                                    + surveyname
  caption =
	"[A] Percentage of household population who could sleep under an ITN if each ITN in the household were used by up to two people"
                  "[B] The denominator is number of usual (de jure) household members and does not take into account whether household members stayed in the household last night." 
                        "MICS does not collect information on visitors to the household.".														

new file.

* erase working file.
erase file = "tmp.sav".