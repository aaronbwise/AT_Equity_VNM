*v1. 2014-04-07.

*....



include "surveyname.sps".

get file = 'ch.sav'.

*children age 0-59 months with fever in the last two weeks.
select if (UF9 = 1 and CA6AA = 1).

weight by chweight.

compute total = 1.
variable labels  total "".
value labels total 1 "Number of children age 0-59 months with fever in the last two weeks".

compute layer = 0.
variable labels layer " ".
value labels layer 0 "Percentage of children who:".

* Children who had a finger or heel stick: CA6B=1.
compute heelstick = 0.
if (CA6BB = 1) heelstick = 100.
variable labels  heelstick "Had blood taken from a finger or heel for testing [1]".

*  Children given Artemisinin-based Combination Therapy (ACT) are: CA13=E.
compute ACT = 0.
if (CA13E = "E") ACT = 100.
variable labels ACT "Were given: Artemisinin-combination Treatment (ACT)".

*  Were given: ACT the same or next day.
* The percentage who took the anti-malarial drug same or next day are CA13E=0 or 1.	
compute ACTsameday = 0.
if (CA13E = "E" and (CA13EE = 0 or CA13EE = 1)) ACTsameday = 100.
variable labels ACTsameday "Were given: ACT the same or next day".

*  Were given: Any antimalarial drugs.
compute antiMalarial  = 0.
if (CA13A = "A" or CA13B = "B" or CA13C = "C" or CA13D = "D" or CA13E = "E" or CA13H = "H") antiMalarial = 100.
variable labels  antiMalarial "Were given: Any antimalarial drugs [2]".

* Were given: Any antimalarial drugs same or next day.
compute MALsameday = 0.
if (antiMalarial = 100 and (CA13EE = 0 or CA13EE = 1)) MALsameday = 100.
variable labels MALsameday "Were given: Any antimalarial drugs same or next day".


* Treatment with Artemisinin-based Combination Therapy (ACT) among children who received anti-malarial treatment.
do if (antiMalarial = 100).
+ compute ACTtreat = 0.
+ if (ACT = 100) ACTtreat = 100.
+ compute  antiMalarialN = 1.
end if.

variable labels ACTtreat "Treatment with Artemisinin-based Combination Therapy (ACT) among children who received anti-malarial treatment [3]".
value labels antiMalarialN 1 "Number of children age 0-59 months with fever in the last two weeks who were given any antimalarial drugs".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables =  total tot layer antiMalarialN
         display = none
  /table  tot [c] + hl4 [c] + hh7 [c] + hh6 [c] + cage_11 [c] + melevel [c] + windex5 [c] + ethnicity [c] by 
                layer [c] > (heelstick [s] [mean,'',f5.1] + ACT  [s] [mean,'',f5.1] + ACTsameday  [s] [mean,'',f5.1] + antiMalarial  [s] [mean,'',f5.1] +  MALsameday [s] [mean,'',f5.1]) +
		total [c] [count,'',f5.0] +
		ACTtreat [s] [mean,'',f5.1]  + antiMalarialN [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table CH.22: Diagnostics and anti-malarial treatment of children"
  	"Percentage of children age 0-59 months who had a fever in the last two weeks who had a finger or heel stick for malaria testing, " +
	"who were given Artemisinin-combination Treatment (ACT) and any anti-malarial drugs, and percentage who were given ACT among those " +
	"who were given anti-malarial drugs, " + surveyname
  caption=
	"[1] MICS indicator 3.21 - Malaria diagnostics usage"
	"[2] MICS indicator 3.22; MDG indicator 6.8 - Anti-malarial treatment of children under age 5"								
	"[3] MICS indicator 3.23 - Treatment with Artemisinin-based Combination Therapy (ACT) among children who received anti-malarial treatment".								
								
new file.
