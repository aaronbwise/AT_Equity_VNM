* Encoding: UTF-8.
***.
* v02. 2019-03-14.
* v03 - 2020-04-14. Labels in French and Spanish have been removed.
***.

include "surveyname.sps".

get file = 'wm.sav'.

include "CommonVarsWM.sps".

select if (WM17 = 1).

weight by wmweight.

*select women that gave birth in two years preceeding the survey.
select if (CM17 = 1).

* definitions of anc, ageAtBirth .
include 'define\MICS6 - 06 - TM.sps' .

select if (deliveryPlace<>11 and deliveryPlace<>12).

variable labels MN28 "Instrument used to cut the cord".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of children whose cord was cut with:".

* The percentage of children whose cord was cut with a boiled or sterilised instrument are those responding 'yes' to MN29, 
while the percentage cut with a clean instrument are those cut with a new blade (or a used blade or scissors that was boiled or sterilised before use (MN28=1 or (MN28= 2 or 3 AND MN29=1)).
compute sterilInst = 0.
if (MN29 = 1) sterilInst = 100.
variable labels sterilInst "Boiled or sterilised instruments".

compute cleanInst = 0.
if (MN28=1 or ((MN28= 2 or MN28= 3) AND MN29=1)) cleanInst = 100.
variable labels cleanInst "A clean instrument [1] [A]".

* Nothing: MN30=2.
* Chlorhexidine or other antiseptic: MN31=A and/or B.
* Other non-harmful substance: Should be deleted in surveys where no non-harmful substance is included. The MICS standard questionnaire does not include such.
* Harmful substances: MN31=C, D and/or E.
* Percentage with nothing harmful applied to the cord: MN30=2 or MN31<>C, D, E, X or Z.

compute nothing = 0.
if (MN30 = 2) nothing = 100.
variable labels nothing "Nothing".

compute antiseptic = 0.
if (MN31A ="A" or MN31B = "B") antiseptic = 100.
variable labels antiseptic "Chlorhexidine or other antiseptic".

compute Harm = 0.
if (MN31C = "C" or MN31D = "D" or MN31E = "E" or MN31X = "X") Harm = 100.
variable labels Harm "Harmful substance".

compute nonHarm = 0.
if (nothing = 100 or antiseptic = 100) nonHarm = 100.
variable labels nonHarm "Percentage with nothing harmful applied to the cord [2]".

compute layer1 = 0.
variable labels layer1 "".
value labels layer1 0 "Substances [B] applied to the cord".

compute numChildren = 1.
variable labels numChildren "Number of women with a live birth in the last 2 years who delivered the most recent live birth outside a facility".
value labels  numChildren 1 "".

compute total = 1.
variable labels total "Total".
value labels  total 1 " ".

variable labels welevel "Education".
variable labels ageAtBirth "Age at most recent live birth".
variable labels disability "Functional difficulties (age 18-49 years)". 
variable labels bh3_last "Sex of newborn".
	 
* Ctables command in English.
ctables
  /vlabels variables = layer layer1 display = none
  /table   total [c]
         + bh3_last [c]
         + hh6 [c]
         + hh7 [c]
         + welevel [c]
         + ageAtBirth [c]
         + $deliveryPlace [c]
         + personAtDelivery1 [c]
         + disability [c]
         + ethnicity[c]
         + windex5 [c]   
     by
          MN28[c] [rowpct.validn '' f5.1] +   
          layer [c] > 
          (sterilInst [s] [mean '' f5.1] + cleanInst [s] [mean '' f5.1]) + 
          layer1 [c] > 
          (nothing [s] [mean '' f5.1] + antiseptic [s] [mean '' f5.1] + Harm [s] [mean '' f5.1]) + 
         nonHarm [s] [mean '' f5.1] + 
         numChildren[s] [count '' f5.0]
  /categories variables=all empty=exclude
  /categories variables=MN28 total=yes position = after label = "Total"
  /slabels position=column visible=no
  /titles title="Table TM.8.5: Cord cutting and care"
	"Percent distribution of women age 15-49 years with a live birth in the last 2 years who delivered the most recent live birth outside a facility by what instrument was used to cut the umbilical cord and percentage of cord cut " 
                  " with clean instruments and what substance was applied to the cord,  " +  surveyname
   caption=
      "[1] MICS indicator TM.17 - Cord cut with clean instrument"  															
      "[2] MICS indicator TM.18 - Nothing harmful applied to cord"														
      "[A] Clean instruments are all new blades and boiled or sterilised used blades or scissors"														
      "[B] Substances include: Chlorhexidine, other antiseptic (such as alcohol, spirit, gentian violet), mustard oil, ash, animal dung and others. Mustard oil, ash and animal dung are considered harmful".						
	  
new file.
