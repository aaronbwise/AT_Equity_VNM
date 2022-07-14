include "surveyname.sps".

* open household members file.
get files="hl.sav".

*weight by household weight.
weight by hhweight.

*select children 2-9 years of age.
select if (HL6 >= 2 and HL6 <= 9).

recode HL6 (2 thru 4 = 1) (5 thru 6 = 2) (7 thru 9 = 3) into agegrp.
variable labels  agegrp "Age of child".
value labels agegrp 
	1 "2-4" 
	2 "5-6"
	3 "7-9".

compute compl = 0.
if (DA9 = 1) compl = 100.
variable labels  compl "Percentage of Questionnaire Forms for Child Disability completed".

compute tot29 = 1.
value labels tot29 1 "Total number of children age 2-9 years in interviewed households".

do if (compl = 100).

compute delay = 0.
if (DA13 = 1) delay = 100.
variable labels  delay "Delay in sitting standing or walking".

compute seeing = 0.
if (DA14 = 1) seeing = 100.
variable labels  seeing "Difficulty seeing, either in the daytime or at night".

compute hearing = 0.
if (DA15 = 1) hearing = 100.
variable labels  hearing "Appears to have difficulty hearing".

compute nounders = 0.
if (DA16 = 2) nounders = 100.
variable labels  nounders "No understanding of instructions".

compute dwalk = 0.
if (DA17 = 1) dwalk = 100.
variable labels  dwalk "Difficulty in walking, moving arms, weakness or stiffness".

compute hfits = 0.
if (DA18 = 1) hfits = 100.
variable labels  hfits "Have fits, become rigid, lose conciousness".

compute nlearn = 0.
if (DA19 = 2) nlearn = 100.
variable labels  nlearn "Not learning to do things like other children his / her age".

compute nospeak = 0.
if (DA20 = 2) nospeak = 100.
variable labels  nospeak "No speak-ing / cannot be under-stood in words".

compute mentally = 0.
if (DA24 = 1) mentally = 100.
variable labels  mentally "Appears mentally backward, dull, or slow".

compute disabil = 0.
if (delay = 100 or seeing = 100 or hearing  = 100 or nounders = 100 or 
  dwalk = 100 or hfits = 100 or nlearn = 100 or nospeak = 100 or 
	mentally = 100) disabil = 100. 
variable labels  disabil "Percentage of children age 2-9 years with at least one reported impairment [1]".

compute total = 1.
value labels total 1 "Number of children age 2-9 years".

end if.

do if (HL6 >= 3 and HL6 <= 9 and compl = 100).
+ compute speech = 0.
+ if (DA22 = 1) speech = 100.
+ if (speech = 100) disabil = 100.
+ compute total39 = 1.
end if.

variable labels  speech "Speech is not normal".
variable labels  total39 "Number of children age 3-9 years".
value labels total39 1 "Number of children age 3-9 years".

do if (HL6 = 2 and compl = 100).
+ compute cname = 0.
+ if (DA23 = 2) cname = 100.
+ if (cname = 100) disabil = 100.
+ compute total2 = 1.
end if.

variable labels  cname "Cannot name at least one object".
variable labels  total2 "Number of children aged 2 years".
value labels total2 1 "Number of children aged 2 years".

compute layer = 0.
variable labels  layer "".
value labels layer 0 "Percentage of children age 2-9 reported to have specified impairments or activity limitations".

compute tot = 1.
variable labels  tot "Total".
value labels tot 1 " ".

ctables
  /vlabels variables = layer tot29 total total2 total39
         display = none
  /table hh7 [c] + region [c] + hh6 [c] + agegrp [c] + melevel [c] + windex5 [c]  + tot [c] by 
             compl [s] [mean,'',f5.1] + tot29  [c] [count,'',f5.0] +
             layer [c] > (delay [s] [mean,'',f5.1] + seeing  [s] [mean,'',f5.1] + hearing  [s] [mean,'',f5.1] + nounders  [s] [mean,'',f5.1] + dwalk  [s] [mean,'',f5.1] + hfits  [s] [mean,'',f5.1] +
                 nlearn  [s] [mean,'',f5.1] + nospeak  [s] [mean,'',f5.1] + mentally [s] [mean,'',f5.1]) + total  [c] [count,'',f5.0] +
                 cname  [s] [mean,'',f5.1] + total2 [c] [count,'',f5.0] + speech  [s] [mean,'',f5.1] + total39  [c] [count,'',f5.0] + disabil [s] [mean,'',f5.1] + total  [c] [count,'',f5.0]
 /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
   "Table CH.17: Children at increased risk of disability"
   "Percentage of children age 2-9 years reported by mothers/caretakers to have impairments or activity limitations, by background characteristics, " + surveyname.sps
  caption =
    "[1] MICS indicator 3.21".
															
new file.






















