* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

select if (HH9 = 1).

weight by hhweight.

compute total = 1.
variable labels  total "".
value labels total 1 "Number of households".

compute observed = 0.
if (HW1 = 1) observed = 100.
variable labels  observed "Percentage of households where place for handwashing was observed".

do if (observed = 100).
+ compute totalo = 1.
+ compute watsoap = 9.
+ if (HW2 = 1 and (HW3A = "A" or HW3B = "B" or HW3C = "C" or HW3D = "D")) watsoap = 1.
+ if (HW2 = 1 and (HW3Y= "Y")) watsoap = 2.
+ if (HW2 <> 1 and (HW3A = "A" or HW3B = "B" or HW3C = "C" or HW3D = "D")) watsoap = 3.
+ if (HW2 <> 1 and (HW3Y= "Y")) watsoap = 4.
end if.

* If place for handwashing was not observed.
do if (observed <> 100).
+ compute resno = 9.
+ if (HW1 = 2) resno = 1.
+ if (HW1 = 3) resno = 2.
+ if (HW1 = 6) resno = 3.
end if.

variable labels  resno "Percentage of households where place for handwashing was not observed".
value labels resno
  1 "Not in dwelling/plot/yard"
  2 "No permission to see"
  3 "Other reasons"
  9 "Missing".

variable labels  watsoap "Percent distribution of households where place for handwashing was observed, and:".
value labels watsoap
  1 "Water and soap are available [1]"
  2 "Water is available, soap is not available"
  3 "Water is not available, soap is available"
  4 "Water and soap are not available"
  9 "Missing".

variable labels totalo "".
value labels totalo 1 "Number of households where place for handwashing was observed".

compute tot = 1.
variable labels tot "".
value labels tot 1 "Total".

compute tot1 = 100.
variable labels tot1 "Total".
value labels tot1 100 "".

ctables
  /vlabels variables =  total tot totalo
         display = none
  /table hh7 [c] + hh6 [c] + helevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
   	observed [s] [mean,'',f5.1] + resno [c] [rowpct.totaln,'',f5.1] + tot1 [s] [mean,'',f5.1] +  total [c] [count,'',f5.0] + 
                  watsoap [c] [rowpct.validn,'',f5.1] + tot1 [s] [mean,'',f5.1] + totalo [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
   "Table WS.9: Water and soap at place for handwashing"
	      "Percentage of households where place for handwashing was observed and percent distribution of households by availability " +
                        "of water and soap at place for handwashing," + surveyname
  caption=
   "[1] MICS indicator 4.5".

* French table missing.										

new file.
