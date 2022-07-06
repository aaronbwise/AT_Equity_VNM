* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

include file = "MICS5 - 04 - CH.01 RECODE.SPS".

* if HF records were collected use RECODE syntax below.
* MICS5 - 04 - CH.01 RECODE  vHF.sps.

select if (UF9 = 1).

weight by chweight.

do if (cage >= 12 and cage <= 23).

+ recode bcg (1,2 = 100) (3 = 0) into bcg_r.

+ recode polio0 (1,2 = 100) (3 = 0) into polio0_r.
+ recode polio1 (1,2 = 100) (3 = 0) into polio1_r.
+ recode polio2 (1,2 = 100) (3 = 0) into polio2_r.
+ recode polio3 (1,2 = 100) (3 = 0) into polio3_r.

+ recode dpt1 (1,2 = 100) (3 = 0) into dpt1_r.
+ recode dpt2 (1,2 = 100) (3 = 0) into dpt2_r.
+ recode dpt3 (1,2 = 100) (3 = 0) into dpt3_r.

+ recode hepb0 (1,2 = 100) (3 = 0) into hepb0_r.
+ recode hepb1 (1,2 = 100) (3 = 0) into hepb1_r.
+ recode hepb2 (1,2 = 100) (3 = 0) into hepb2_r.
+ recode hepb3 (1,2 = 100) (3 = 0) into hepb3_r.

+ recode hib1 (1,2 = 100) (3 = 0) into hib1_r.
+ recode hib2 (1,2 = 100) (3 = 0) into hib2_r.
+ recode hib3 (1,2 = 100) (3 = 0) into hib3_r.

+ recode measles (1,2 = 100) (3 = 0) into measles_r.

+ recode yf (1,2 = 100) (3 = 0) into yf_r.

+ recode basicvacc (1,2 = 100) (3 = 0) into all_r.

+ recode novacc (1,2 = 100) (3 = 0) into no_r.

+ recode hasvcard (1 = 100) (2 = 0) into card_r.

end if.


variable labels bcg_r "".
variable labels polio0_r "".
variable labels polio1_r "".
variable labels polio2_r "".
variable labels polio3_r "".
variable labels dpt1_r "".
variable labels dpt2_r "".
variable labels dpt3_r "".
variable labels measles_r "".
variable labels hepb0_r "".
variable labels hepb1_r "".
variable labels hepb2_r "".
variable labels hepb3_r "".
variable labels hib1_r "".
variable labels hib2_r "".
variable labels hib3_r "".
variable labels yf_r "".
variable labels measles_r "".
variable labels no_r "".
variable labels all_r "".
variable labels card_r "".

compute layer1 = 0.
variable labels layer1 "".
value labels layer1 0 "Percentage of children age 12-23 months who received:".

compute tot = 1.
variable labels tot "".
value labels tot 1 "Total".

* Ctables command in English (currently active, comment it out if using different language).
ctables
   /vlabels variables = tot bcg_r polio0_r polio1_r polio2_r polio3_r dpt1_r dpt2_r dpt3_r yf_r measles_r hepb0_r hepb1_r hepb2_r hepb3_r hib1_r hib2_r hib3_r no_r all_r card_r layer1 
         display = none
  /table  tot [c] + hl4 [c] + hh7 [c] + hh6 [c] + melevel [c]  + windex5 [c] + ethnicity [c] by
  layer1 [c] >
   (bcg_r [s] [mean,'BCG',f5.1] + 
   polio0_r [s] [mean,'Polio at birth',f5.1] + polio1_r [s] [mean,'Polio 1',f5.1] + polio2_r [s] [mean,'Polio 2',f5.1] + polio3_r [s] [mean,'Polio 3',f5.1] +
   dpt1_r [s] [mean,'DPT 1',f5.1] + dpt2_r [s] [mean,'DPT 2',f5.1] + dpt3_r [s] [mean,'DPT 3',f5.1]+
   hepb0_r [s] [mean,'HepB 0',f5.1] + hepb1_r [s] [mean,'HepB 1',f5.1] + hepb2_r [s] [mean,'HepB 2',f5.1] + hepb3_r [s] [mean,'HepB 3',f5.1] + 
   hib1_r [s] [mean,'Hib 1',f5.1] + hib2_r [s] [mean,'Hib 2',f5.1] + hib3_r [s] [mean,'Hib 3',f5.1] + 
   yf_r [s] [mean,'Yellow fever',f5.1] + measles_r [s] [mean,'Measles',f5.1] +  all_r [s] [mean,'Full [a]',f5.1] + no_r [s] [mean,'None',f5.1]) +
   card_r [s] [mean,'Percentage with vaccination card seen',f5.1,validn,'Number of children age 12-23 months',f5.0] 
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /titles title=
    "Table CH.2: Vaccinations by background characteristics"
		"Percentage of children age 12-23 months currently vaccinated against vaccine preventable childhood diseases, " + surveyname
   caption =
	"[a]  Includes: BCG, Polio3, DPT3, HepB3, Hib3, and Measles (MCV1) as per the vaccination schedule in Country".
															
new file.