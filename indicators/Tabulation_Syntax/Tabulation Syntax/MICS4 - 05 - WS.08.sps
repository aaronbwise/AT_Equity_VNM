include "surveyname.sps".

get file = 'hh.sav'.

select if (HH9 = 1).

compute hhweight1 = HH11*hhweight.

weight by hhweight1.

compute total  = 1.
value labels total 1 "".
variable labels total "Number of household members".

compute tot = 1.
value labels tot 1 " ".
variable labels tot "Total".

compute improved = 0.
value labels improved 0 "Improved drinking water [1]".

compute imprtype1 = 0.
if (WS1 = 11 or  WS1 = 12) imprtype1 = 100.
if ((WS2 = 11 or WS2 = 12)  and WS1 = 91) imprtype1 = 100.
variable labels imprtype1 "Piped into dwelling, plot or yard".

compute imprtype2 = 0.
if (WS1 = 13 or WS1 = 14 or WS1 = 21 or WS1 = 31 or WS1 = 41 or WS1 = 51) imprtype2 = 100.
if ((WS2 = 13 or WS2 = 14 or WS2 = 21 or WS2 = 31 or WS2 = 41 or  WS2 = 51) and WS1 = 91) imprtype2 = 100.
variable labels imprtype2 "Other improved".

compute unimproved = 100.
if (WS1 = 11 or  WS1 = 12 or WS1 = 13 or WS1 = 14 or WS1 = 21 or WS1 = 31 or WS1 = 41 or WS1 = 51) unimproved = 0.
if ((WS2 = 11 or WS2 = 12 or WS2 = 13 or WS2 = 14 or WS2 = 21 or WS2 = 31 or WS2 = 41 or WS2 = 51) and WS1 = 91) unimproved = 0.
variable labels unimproved "Unimproved drinking water".

recode WS8 (11,12,13,15,21,22,31,16 = 1) (95 = 3) (else = 2) into type.
variable labels  type "Type of toilet facility used by household".
value labels type 
	1 "Improved sanitation facility" 
	2 "Unimproved sanitation facility"
                  3 "Open defecation (no facility, bush, field)".

recode WS11 (1 thru 5 = 2) (97,99 = 9) (sysmis = 0) (else = 3) into shared.
if (WS10 = 2) shared = 1.
variable labels shared " ".
value labels shared
  0 "Not shared"
  1 "Public facility"
  2 "5 households or less"
  3 "More than 5 households"
  9 "Missing/DK".

compute imprsan = 0.
if (type = 1 and shared = 0) imprsan = 100.
variable labels imprsan "Improved sanitation [2]".

do if (imprsan = 0).
+ compute unsan = 0.
+ if (type = 1 and shared <> 0) unsan = 1.
+ if (type = 2) unsan = 2.
+ if (type = 3) unsan = 3.
end if.

variable labels unsan "Unimproved sanitation".
value labels unsan
 1 "Shared improved facilities"
 2 "Unimproved facilities"
 3 "Open defecation".

compute imwims = 0.
if (unimproved = 0 and imprsan = 100) imwims = 100.
variable labels imwims "Improved drinking water sources and improved sanitation".

compute layer = 100.
variable labels layer "".
value labels layer 100 "Percentage of household population using:".

compute tot1 = 100.
variable labels tot1 "Total".
value labels tot1 100 " ".

ctables
 /vlabels variable = layer improved
           display = none
 /table hh7 [c] + hh6 [c] + helevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
          layer[c] > (improved [c] > (imprtype1 [s] [mean,'',f5.1] + imprtype2 [s] [mean,'',f5.1] ) + unimproved [s] [mean,'',f5.1] +
                         tot1 [s] [mean,'',f5.1] + imprsan [s] [mean,'',f5.1] + unsan [c] [rowpct.totaln,'',f5.1]+tot1 [s] [mean,'',f5.1] + 
                         imwims [s] [mean,'',f5.1] ) + total [s] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table WS.8: Drinking water and sanitation ladders"
  	"Percentage of household population by drinking water and sanitation ladders, " + surveyname
  caption = "[1] MICS indicator 4.1; MDG indicator 7.8" 			
                 "[2] MICS indicator 4.3; MDG indicator 7.9".

* Necessary to add French.
											
new file.
