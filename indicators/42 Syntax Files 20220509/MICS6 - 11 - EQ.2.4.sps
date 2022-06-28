* Encoding: windows-1252.
 * Households who are aware of economic assistance programme: ST2A=1 or ST2B=1 or ST2C=1 or ST2D=1 or ST2X=1.

 * Households who are aware and have ever received assistance: (ST2A=1 or ST2B=1 or ST2C=1 or ST2D=1 or ST2X=1) and (ST3A=1 or ST3B=1 or ST2C=1 or ST3D=1 or ST3X=1).
***.

* v02 - 2019-08-28. Last modified to reflect tab plan changes as of 25 July 2019.
* v03 - 2020-04-21  A layer header has been added. Headers of results columns edited. Labels in French and Spanish have been removed.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file= 'hl.sav'.

compute orphan=0.
if (HL12=2 or HL16=2) orphan=1.

aggregate outfile = 'orphan.sav'
  /break   = HH1 HH2
  /nOrphan  = sum(orphan).

new file.

get file = 'hh.sav'.

include "CommonVarsHH.sps".

select if (HH46  = 1).

match files
  /file = *
  /table = 'orphan.sav'
  /by HH1 HH2.

recode nOrphan (0=2) (else=1) into orphan.
variable labels orphan "Household with orphans".
value labels orphan 1 "With at least one orphan" 2 "With no orphans".

weight by hhweight.

compute nhh = 1.
variable labels  nhh "Number of households".
value labels nhh 1 " ".

compute awareEAP=0.
if (ST2$1=1 or ST2$2=1 or ST2$3=1 or ST2$4=1 or ST2$5=1) awareEAP=100.
variable labels awareEAP "are aware of economic assistance programmes".

compute receivedEAP=0.
if (awareEAP=100 and (ST3$1=1 or ST3$2=1 or ST3$3=1 or ST3$4=1 or ST3$5=1)) receivedEAP=100.
variable labels receivedEAP "are aware of and report household having ever received assistance/ external economic support".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of household questionnaire respondents who:".

compute total = 1.
variable labels  total "Total".
value labels total 1 " ".

* Ctables command in English.
ctables
  /vlabels variables = layer display = none 
  /table   total [c]
         + HHSEX [c]
         + HH6 [c]
         + HH7 [c]
         + HHAGEx [c]
         + orphan [c]
         + ethnicity [c]
         + windex5 [c]
   by 
         layer [c] > (awareEAP [s] [mean '' f5.1] 
         + receivedEAP [s] [mean '' f5.1])
         + nhh [s] [count '' f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title = 
    "Table EQ.2.4: Awareness and ever use of external economic support "
    "Percentage of household questionnaire respondents who are aware of and report having received external economic support, " + surveyname
.
                         
new file.

erase file "orphan.sav".
