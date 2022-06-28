* Encoding: windows-1252.
***.
* v02 - 2020-04-14. – A note has been inserted on the disaggregate of Mother’s functional difficulties. Labels in French and Spanish have been removed.
***.

 * "Functional difficulty in the individual domains are calculated as follows:
     Seeing (UCF7A/B=3 or 4), Hearing (UCF9A/B=3 or 4), Walking (UCF11=3 or 4 OR UCF12=3 or 4 OR UCF13=3 or 4), Fine motor (UCF14=3 or 4), Communication 
     a) Understanding (UCF15=3 or 4) or b) Being understood (UCF16=3 or 4), Learning (UCF17=3 or 4), Playing (UCF18=3 or 4), Controlling behaviour (UCF19=5).

 * The percentage of children age 2-4 years with functional difficulty in at least one domain is presented in the last column."										

include "surveyname.sps".

get file = 'ch.sav'.

select if (UF17 = 1).

weight by chweight.

select if (UB2 >=2).
 	 	
*Seeing (UCF7A/B=3 or 4),.
compute seeing=0.
if (any(UCF7, 3, 4)) seeing=100.
variable labels seeing "Seeing".

* Hearing (UCF9A/B=3 or 4),.
compute hearing=0.
if (any(UCF9, 3, 4)) hearing=100.
variable labels hearing "Hearing".

 * Walking (UCF11=3 or 4 OR UCF12=3 or 4 OR UCF13=3 or 4),.
compute walking=0.
if ((any(UCF11, 3, 4)) or (any(UCF12, 3, 4)) or (any(UCF13, 3, 4))) walking=100.
variable labels walking "Walking".

 * Fine motor (UCF14=3 or 4),. 
compute finemotor=0.
if (any(UCF14, 3, 4)) finemotor=100.
variable labels finemotor "Fine motor".

 * Communication  a) Understanding (UCF15=3 or 4) or b) Being understood (UCF16=3 or 4),.
compute communication=0.
if ((any(UCF15, 3, 4)) or (any(UCF16, 3, 4))) communication=100.
variable labels communication "Communication".

 * Learning (UCF17=3 or 4), .
compute learning=0.
if (any(UCF17, 3, 4)) learning=100.
variable labels learning "Learning".

 * Playing (UCF18=3 or 4), .
compute playing=0.
if (any(UCF18, 3, 4)) playing=100.
variable labels playing "Playing".

 * Controlling behaviour (UCF19=5).
compute behaviour=0.
if (UCF19 =5) behaviour=100.
variable labels behaviour "Controlling behaviour".

compute anyfuncdifficulty=0.
if (seeing=100 or hearing=100 or walking=100 or finemotor=100 or communication=100 or learning=100 or playing=100 or behaviour=100) anyfuncdifficulty=100.
variable labels anyfuncdifficulty "Percentage of children age 2-4 years with functional difficulty in at least one domain".

do if (UB2 >= 3).
recode UB8 (1 = 1) (9 = 8) (else = 2). 				 
variable labels UB8 "Early childhood education attendance [B]".
value labels UB8
  1 "Attending"
  2 "Not attending "
  8 "Missing".
end if.

compute numChildren = 1.
value labels numChildren 1 "Number of children age 2-4 years".

compute layer = 1.
value labels layer 1 "Percentage of children aged 2-4 years with functional difficulty [A] in the domain of:" .

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

variable labels UB2 "Age".
add value labels UB2 2 "2" 3 "3" 4 "4".

variable labels caretakerdis "Mother's functional difficulties [C]".

* Ctables command in English.
ctables
   /vlabels variables = total layer numChildren
            display = none
   /table  total [c]
         + HL4 [c] 
         + hh6 [c] 
         + hh7 [c] 
         + UB2 [c] 
         + ub8 [c] 
         + melevel [c]
         + caretakerdis [c]
         + ethnicity [c]
         + windex5 [c] 
    by 
           layer [c] > (seeing[s][mean '' f5.1] +  hearing[s][mean '' f5.1] + walking[s][mean '' f5.1] 
      +  finemotor[s][mean '' f5.1] +  communication[s][mean '' f5.1] +   learning[s][mean '' f5.1] 
      +  playing[s][mean '' f5.1] + behaviour [s][mean '' f5.1])   + anyfuncdifficulty[s][mean '' f5.1]
      + numChildren [c] [count '' f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table EQ.1.1: Child functioning (children age 2-4 years)"
    "Percentage of children age 2-4 years who have functional difficulty, by domain, " + surveyname
   caption =
     "[A] Functional difficulty for children age 2-4 years are defined as having responded 'A lot of difficulty' or 'Cannot at all' to questions within all listed domains, " 
     "except the last domain of controlling behaviour, for which the response category 'A lot more' is considered a functional difficulty."										
     "[B] Children age 2 are excluded, as early childhood education attendance is only collected for age 3-4 years."
     "[C] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households.".
	 	 
new file. 
