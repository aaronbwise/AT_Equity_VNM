include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

compute total = 1.
variable label total "".
value label total 1 "Number of women age 15-49 years".

* Maternity status.
do if (CP1 = 1).
+ compute matstat = 1.
else if (UN11G = "G").
+ compute matstat = 2.
else.
+ compute matstat = 3.
end if.
variable label matstat "Maternity status".
value label matstat
	1 "Pregnant"
	2 "Breastfeeding (not pregnant)"
	3 "Neither".

compute nevsmoke = 0.
if ((TA1 = 2 or TA2=00) and TA6=2 and TA10=2) nevsmoke = 100.
variable label nevsmoke "Never smoked cigarettes or used other tobacco products".

* Ever users.
compute evercig = 0.
if (TA2 > 00 and TA2 < 97)  evercig = 100.
variable label evercig "Ever users: Cigarettes".

compute etabprod = 0.
if (TA6 = 1)  etabprod = 100.
variable label etabprod "Ever users: Smoked tobacco products".

compute esmokless = 0.
if (TA10 = 1)  esmokless = 100.
variable label esmokless "Ever users: Smokeless tobacco products:".

* Only cigarettes.
compute eonlycig = 0.
if (evercig = 100 and etabprod <> 100 and esmokless <> 100) eonlycig = 100.
variable label eonlycig "Only cigarettes".

* Cigarettes and other tobacco products.
compute ecigoth = 0.
if (evercig = 100 and (etabprod = 100 or esmokless = 100)) ecigoth = 100.
variable label ecigoth "Cigarettes and other tobacco products".

*Only other tobacco products.
compute eother = 0.
if (evercig = 0 and (etabprod = 100 or esmokless = 100)) eother = 100.
variable label eother "Only other tobacco products".

*Any tobacco product.
compute eany = 0.
if (evercig = 100 or etabprod = 100 or esmokless = 100) eany = 100.
variable label eany "Any tobacco product".

* Used tobacco products on one or more days during the last one month.
compute uevercig = 0.
if (TA5 > 00 and TA5 < 98)  uevercig = 100.
variable label uevercig "Used tobacco products on one or more days during the last one month: Cigarettes".

compute usetabprod = 0.
if (TA9 > 00 and TA9 < 98)  usetabprod = 100.
variable label usetabprod "Used tobacco products on one or more days during the last one month: Smoked tobacco products".

compute usmokless = 0.
if (TA13 > 00 and TA13 < 98)  usmokless = 100.
variable label usmokless "Used tobacco products on one or more days during the last one month: Smokeless tobacco products:".

* Only cigarettes.
compute uonlycig = 0.
if (uevercig = 100 and usetabprod <> 100 and usmokless <> 100) uonlycig = 100.
variable label uonlycig "Only cigarettes".

* Cigarettes and other tobacco products.
compute ucigoth = 0.
if (uevercig = 100 and (usetabprod = 100 or usmokless = 100)) ucigoth = 100.
variable label ucigoth "Cigarettes and other tobacco products".

*Only other tobacco products.
compute uother = 0.
if (uevercig = 0 and (usetabprod = 100 or usmokless = 100)) uother = 100.
variable label uother "Only other tobacco products".

*Any tobacco product.
compute uany = 0.
if (uevercig = 100 or usetabprod = 100 or usmokless = 100) uany = 100.
variable label uany "Any tobacco product".

compute layer0 = 0.
variable label layer0 "".
value label layer0 0 "Ever users".

compute layer1 = 0.
variable label layer1 "".
value label layer1 0 "Used tobacco products on one or more days during the last one month".

compute tot = 1.
variable label tot "".
value label tot 1 "Total".

ctables
  /vlabels variables =  total layer0 layer1 tot
         display = none
  /table wage [c] + hh7 [c] + hh6 [c] + welevel [c] + matstat [c] + windex5 [c] + ethnicity [c] + tot [c] by
	 nevsmoke [s] [mean,'',f5.1]+
                   layer0 [c] > (eonlycig [s] [mean,'',f5.1] + ecigoth [s] [mean,'',f5.1] + eother [s] [mean,'',f5.1] + eany[s] [mean,'',f5.1] ) +
                   layer1 [c] > (uonlycig [s] [mean,'',f5.1] + ucigoth [s] [mean,'',f5.1] + uother [s] [mean,'',f5.1] + uany[s] [mean,'',f5.1] ) +
                   total[c][count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
	"Table TA.1: Current and ever use of tobacco"						
	"Percentage distribution of women age 15-49 years by pattern of use of tobacco, " + surveyname						
 caption = 
     	"[1] MICS indicator TA.1".										
							
new file.
