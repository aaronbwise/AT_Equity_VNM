* Encoding: UTF-8.

***.
*v02 - 2020-04-27: Several changes related to the latest tab plan. Labels in French and Spanish have been removed.
*v03 - 2020-09-10: added “No vaccinations” column for the children 23-45 months.
***.

 * Please refer to description for Table TC.1.1 for similar customisation instructions.

 * In this table, the calculation is the same as the "Either" column of Table TC.1.1, i.e. the child’s age at vaccination is not taken into account. Children who were vaccinated 
   at any time before the survey are included in the numerator.

 * "Full" (fully vaccinated) needs to be determined at the country level, in accordance with the existing vaccination schedule. Vaccinations included in the table should be 
    revised/adapted accordingly. The note (A) should be customized and list all included vaccinations.

 * If the survey included the Questionnaire Form for Vaccination Records at Health Facility, the column heading "Vaccination records" should be changed to "Vaccination 
    records at home or health facility records" and the appropriate tabulation syntax used to produce the table.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

include file = "MICS6 - 07 - TC - RECODE.sps".


select if (UF17 = 1).

weight by chweight.

do if (cage >= 12 and cage <= 23).

+ recode bcg (1,2 = 100) (else = 0) into bcg_r.

+ recode polio0 (1,2 = 100) (else = 0) into polio0_r.
+ recode polio1 (1,2 = 100) (else = 0) into polio1_r.
+ recode polio2 (1,2 = 100) (else = 0) into polio2_r.
+ recode polio3 (1,2 = 100) (else = 0) into polio3_r.
+ recode polio3ipv (1,2 = 100) (else = 0) into polio3ipv_r.

+ recode hepB0 (1,2 = 100) (else = 0) into hepB0_r.

+ recode penta1 (1,2 = 100) (else = 0) into penta1_r.
+ recode penta2 (1,2 = 100) (else = 0) into penta2_r.
+ recode penta3 (1,2 = 100) (else = 0) into penta3_r.

+ recode pneumo1 (1,2 = 100) (else = 0) into pneumo1_r.
+ recode pneumo2 (1,2 = 100) (else = 0) into pneumo2_r.
+ recode pneumo3 (1,2 = 100) (else = 0) into pneumo3_r.

+ recode rota1 (1,2 = 100) (else = 0) into rota1_r.
+ recode rota2 (1,2 = 100) (else = 0) into rota2_r.
+ recode rota3 (1,2 = 100) (else = 0) into rota3_r.

+ recode measles1 (1,2 = 100) (else = 0) into measles1_r.

+ recode basicvacc (1,2 = 100) (else = 0) into basic_r.

+ recode novacc (1,2 = 100) (else = 0) into no_r.

+ recode hasvcard (1 = 100) (2 = 0) into card_r.

+ recode hasC (1 = 100) (2 = 0) into hasC_r1.

end if.

variable labels bcg_r "".
variable labels polio0_r "".
variable labels polio1_r "".
variable labels polio2_r "".
variable labels polio3_r "".
variable labels polio3ipv_r "".
variable labels HepB0_r "".
variable labels penta1_r "".
variable labels penta2_r "".
variable labels penta3_r "".
variable labels measles1_r "".
variable labels pneumo1_r "".
variable labels pneumo2_r "".
variable labels pneumo3_r "".
variable labels rota1_r "".
variable labels rota2_r "".
variable labels rota3_r "".
variable labels no_r "".
variable labels basic_r "".
variable labels card_r "".
variable labels hasC_r1"".

compute layer1 = 0.
variable labels layer1 "".
value labels layer1 0 "Percentage of children age 12-23 months who received:".

do if (cage >= 24 and cage <= 35).

+ recode measles2 (1,2 = 100) (else = 0) into measles2_r.

+ recode yf (1,2 = 100) (else = 0) into yf_r.

+ recode td (1,2 = 100) (else = 0) into td_r.

+ recode hasvcard (1 = 100) (2 = 0) into card_r2.

+ recode hasC (1 = 100) (2 = 0) into hasC_r2.

+ recode basicvacc (1,2 = 100) (else = 0) into basic_r2.

+ recode allvacc (1,2 = 100) (else = 0) into all_r2.

+ recode novacc (1,2 = 100) (else = 0) into no_r2.

end if.

variable labels measles2_r "".
variable labels yf_r "".
variable labels td_r "".
variable labels card_r2 "".
variable labels hasC_r2 "".
variable labels basic_r2 "".
variable labels all_r2 "".
variable labels no_r2 "".

compute layer2 = 0.
variable labels layer2 "".
value labels layer2 0 "Percentage of children age 24-35 months who received:".

compute tot = 1.
variable labels tot "".
value labels tot 1 "Total".

compute layer3 = 0.
variable labels layer3 "".
value labels layer3 0 "Polio".

compute layer4 = 0.
variable labels layer4 "".
value labels layer4 0 "DTP-HepB-Hib".

compute layer5 = 0.
variable labels layer5 "".
value labels layer5 0 "PCV".

compute layer6 = 0.
variable labels layer6 "".
value labels layer6 0 "Rotavirus".

compute layer7 = 0.
variable labels layer7 "".
value labels layer7 0 "Percentage with:".

compute layer8 = 0.
variable labels layer8 "".
value labels layer8 0 "Full vaccination".

* Ctables command in English.
ctables
   /vlabels variables = tot bcg_r polio0_r polio1_r polio2_r polio3_r polio3ipv_r hepB0_r penta1_r penta2_r penta3_r td_r yf_r measles1_r measles2_r pneumo1_r pneumo2_r pneumo3_r rota1_r rota2_r rota3_r no_r basic_r basic_r2 all_r2 no_r2
       card_r card_r2 hasC_r1 hasC_r2 layer1 layer2  layer3 layer4 layer5 layer6 layer7 layer8
         display = none
  /table  tot [c] + hl4 [c] +  hh6 [c] + hh7 [c] + melevel [c] + ethnicity [c] + windex5 [c]  by
   layer1 [c] >
   (bcg_r [s] [mean,'BCG [1]',f5.1] + 
    layer3 [c]>( polio0_r [s] [mean,'At birth [A]',f5.1] + polio1_r [s] [mean,'OPV 1',f5.1] + polio2_r [s] [mean,'OPV 2',f5.1] + polio3_r [s] [mean,'OPV 3',f5.1] + polio3ipv_r [s] [mean,'OPV 3 or IPV [2]',f5.1]) +
    hepB0_r [s] [mean,'HepB at birth [B] ',f5.1] +
    layer4 [c]>(penta1_r [s] [mean,'1',f5.1] + penta2_r [s] [mean,'2',f5.1] + penta3_r [s] [mean,'3 [3] [4] [5]',f5.1])+
    layer5 [c]>(pneumo1_r [s] [mean,'1',f5.1] + pneumo2_r [s] [mean,'2',f5.1] + pneumo3_r [s] [mean,'3 [6]',f5.1]) + 
    layer6 [c]>( rota1_r [s] [mean,'1',f5.1] +  rota2_r [s] [mean,'2',f5.1] + rota3_r [s] [mean,'3 [7]',f5.1]) +
    measles1_r [s] [mean,'Measles-Rubella 1  [8]',f5.1] +  basic_r [s] [mean,'Basic [9] [C]',f5.1] + no_r [s][mean,'No vaccinations',f5.1]) +
    layer7 [c] > (hasC_r1 [s]   [mean,'Vaccination records  [D]',f5.1] + card_r [s] [mean,'Vaccination records seen [E]',f5.1])+ card_r [s] [validn,"Number of children age 12-23 months",f5.0]+
    layer2 [c] > (measles2_r [s] [mean,'Measles-Rubella 2  [10]',f5.1] + yf_r [s] [mean,'Yellow fever [11]',f5.1] + td_r [s] [mean,'Td Booster 1',f5.1] +
    layer8 [c] > (basic_r2 [s] [mean,'Basic antigens [C]',f5.1] + all_r2 [s] [mean,'All antigens [12],[F]',f5.1])  + no_r2 [s] [mean,'No vaccinations',f5.1]) +
    layer7 [c] > (hasC_r2 [s]  [mean,'Vaccination records  [D]',f5.1] + card_r2 [s] [mean,'Vaccination records seen [E]',f5.1]) + card_r2 [s] [validn,"Number of children age 24-35 months",f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column 
  /titles title=
    "Table TC.1.2: Vaccinations by background characteristics"																																						
       "Percentage of children age 12-23 months and 24-35 months currently vaccinated against vaccine preventable childhood diseases (Crude coverage),  " + surveyname
   caption =
    "[1] MICS indicator TC.1 - Tuberculosis immunization coverage"																																		
    "[2] MICS indicator TC.2 - Polio immunization coverage"																																	
    "[3] MICS indicator TC.3 - Diphtheria, tetanus and pertussis (DTP) immunization coverage; SDG indicator 3.b.1 & 3.8.1"																																		
    "[4] MICS indicator TC.4 - Hepatitis B immunization coverage"																														
    "[5] MICS indicator TC.5 - Haemophilus influenzae type B (Hib) immunization coverage"																																		
    "[6] MICS indicator TC.6 - Pneumococcal (Conjugate) immunization coverage; SDG indicator 3.b.1"																																		
    "[7] MICS indicator TC.7 - Rotavirus immunization coverage"																																	
    "[8] MICS indicator TC.8 - Rubella immunization coverage"																																		
    "[9] MICS indicator TC.11a - Full immunization coverage (basic antigens)"																																		
    "[10] MICS indicator TC.10 - Measles immunization coverage; SDG indicator 3.b.1"																																	
    "[11] MICS indicator TC.9 - Yellow fever immunization coverage"																																		
    "[12] MICS indicator TC.11b - Full immunization coverage (all antigens)"																																	
    "[A] For children with vaccination records, any record of Polio at birth is accepted. For children relying on mother's report, Polio at birth is a dose received within the first 2 weeks after birth."																																		
    "[B] Any record or report of a Hepatitis B birth dose is accepted regardless of timing"																																	
    "[C] Basic antigens include: BCG, Polio3, DTP3, Measles 1"																																		
    "[D] Vaccination card or other documents where the vaccinations are written down"																																		
    "[E] Includes children for whom vaccination cards or other documents were observed with at least one vaccination dose recorded (Card availability)"																																	
    "[F] All antigens include: BCG, Polio3/IPV, DTP3, HepB3, Hib3, PCV3, Rota3, Rubella, YF, DT Booster 1 and Measles 2 as per the vaccination schedule in Country"																																																													
.
									
new file.