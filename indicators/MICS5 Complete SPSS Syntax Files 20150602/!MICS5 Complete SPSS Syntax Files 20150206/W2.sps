* EXAMINE FREQUENCIES, RECODE AND DESCRIBE VARIABLES.


* Frequencies of selected variables by national, urban and rural.
varpdist hh11 hc2 hc3 hc4 hc5 hc6
	hc8a hc8b hc8c hc8d hc8e hc8f  
	hc9a hc9b hc9c hc9d hc9e hc9f hc9g hc9h
	hc10
	hc11 hc12 hc13 hc14a hc14b hc14c hc14d hc14e hc14f hc14g
	hc15
	ws1 ws3 ws4 
	ws8 ws9 ws10 ws11
	hw1 hw2 hw3a hw4
	servant abroad @.


* Construct variables for wealth index.

*	Persons per sleeping room.
do if (hc2 < 98).
compute persroom = hh11 / hc2.
else.
compute persroom = 99.
end if.
missing values persroom (99).
variable labels persroom "Persons per sleeping room".
execute.

*	Type of floor.
dichotomize hc3 (11) (98 thru hi) hc3@11	"Earth/sand floor".
dichotomize hc3 (12) (98 thru hi) hc3@12	"Dung floor".
dichotomize hc3 (21) (98 thru hi) hc3@21	"Wood planks floor".
dichotomize hc3 (22) (98 thru hi) hc3@22	"Palm/bamboo floor".
Dichotomize hc3 (31) (98 thru hi) hc3@31	"Parquet/polished wood floor".
dichotomize hc3 (32) (98 thru hi) hc3@32	"Vinyl/asphalt strip floor".
dichotomize hc3 (33) (98 thru hi) hc3@33	"Ceramic tiles floor".
dichotomize hc3 (34) (98 thru hi) hc3@34	"Cement floor".
dichotomize hc3 (35) (98 thru hi) hc3@35	"Carpet floor".

*	Type of roof.
dichotomize hc4 (11) (98 thru hi) hc4@11	"No roof".
dichotomize hc4 (12) (98 thru hi) hc4@12	"Thatch/palm leaf roof".
dichotomize hc4 (13) (98 thru hi) hc4@13	"Sod roof".
dichotomize hc4 (21) (98 thru hi) hc4@21	"Rustic mat roof".
dichotomize hc4 (22) (98 thru hi) hc4@22	"Palm/bamboo roof".
dichotomize hc4 (23) (98 thru hi) hc4@23	"Wood planks roof".
dichotomize hc4 (24) (98 thru hi) hc4@24	"Cardboard roof".
dichotomize hc4 (31) (98 thru hi) hc4@31	"Metal/tin roof".
dichotomize hc4 (32) (98 thru hi) hc4@32	"Wood roof".
dichotomize hc4 (33) (98 thru hi) hc4@33	"Calamine/cement fibre roof".
dichotomize hc4 (34) (98 thru hi) hc4@34	"Ceramic tiles roof".
dichotomize hc4 (35) (98 thru hi) hc4@35	"Cement roof".
dichotomize hc4 (36) (98 thru hi) hc4@36	"Roofing shingles roof".

*	Type of wall.
dichotomize hc5 (11) (98 thru hi) hc5@11	"No walls".
dichotomize hc5 (12) (98 thru hi) hc5@12	"Cane/palm/trunks walls".
dichotomize hc5 (13) (98 thru hi) hc5@13	"Dirt walls".
dichotomize hc5 (21) (98 thru hi) hc5@21	"Bamboo with mud wall".
dichotomize hc5 (22) (98 thru hi) hc5@22	"Stone with mud walls".
dichotomize hc5 (23) (98 thru hi) hc5@23	"Uncovered adobe walls".
dichotomize hc5 (24) (98 thru hi) hc5@24	"Plywood walls".
dichotomize hc5 (25) (98 thru hi) hc5@25	"Cardboard walls".
dichotomize hc5 (26) (98 thru hi) hc5@26	"Reused wood walls".
dichotomize hc5 (31) (98 thru hi) hc5@31	"Cement walls".
dichotomize hc5 (32) (98 thru hi) hc5@32	"Stone with lime/cement walls".
dichotomize hc5 (33) (98 thru hi) hc5@33	"Brick walls".
dichotomize hc5 (34) (98 thru hi) hc5@34	"Cement blocks walls".
dichotomize hc5 (35) (98 thru hi) hc5@35	"Covered adobe walls".
dichotomize hc5 (36) (98 thru hi) hc5@36	"Wood planks/shingles walls".

*	Type of household fuel.
dichotomize hc6 (01) (98 thru hi) hc6@01	"Electricity fuel".
dichotomize hc6 (02) (98 thru hi) hc6@02	"LPG fuel".
dichotomize hc6 (03) (98 thru hi) hc6@03	"Natural gas fuel".
dichotomize hc6 (04) (98 thru hi) hc6@04	"Biogas fuel".
dichotomize hc6 (05) (98 thru hi) hc6@05	"Kerosene fuel".
dichotomize hc6 (06) (98 thru hi) hc6@06	"Coal/lignite fuel".
dichotomize hc6 (07) (98 thru hi) hc6@07	"Charcoal fuel".
dichotomize hc6 (08) (98 thru hi) hc6@08	"Wood fuel".
dichotomize hc6 (09) (98 thru hi) hc6@09	"Straw/shrub/grass fuel".
dichotomize hc6 (10) (98 thru hi) hc6@10	"Animal dung fuel".
dichotomize hc6 (11) (98 thru hi) hc6@11	"Agrciultural crop residue fuel".
dichotomize hc6 (95) (98 thru hi) hc6@95	"No food cooked".

*	Household assets.
dichotomize hc8a (1) (9) hc8a@1 	"Electricity".
dichotomize hc8b (1) (9) hc8b@1	"Radio".
dichotomize hc8c (1) (9) hc8c@1	"Television".
dichotomize hc8d (1) (9) hc8d@1	"Non-mobile telephone".
dichotomize hc8e (1) (9) hc8e@1	"Refrigetaror".
dichotomize hc8f (1) (9) hc8f@1	"Country specific item".

*	Household members assets.
dichotomize hc9a (1) (9) hc9a@1	"Watch".
dichotomize hc9b (1) (9) hc9b@1	"Mobile telephone".
dichotomize hc9c (1) (9) hc9c@1	"Bicycle".
dichotomize hc9d (1) (9) hc9d@1	"Motorcycle/scooter".
dichotomize hc9e (1) (9) hc9e@1	"Animal drawn cart".
dichotomize hc9f (1) (9) hc9f@1	"Car/truck".
dichotomize hc9g (1) (9) hc9g@1	"Boat with motor".
dichotomize hc9h (1) (9) hc9h@1	"Country specific item".

*	Ownership of dwelling.
dichotomize hc10 (1) (9) hc10@1 "Owns dwelling".
dichotomize hc10 (2) (9) hc10@2	"Rents dwelling".
dichotomize hc10 (6) (9) hc10@6	"Other dwelling arrangement".

*	Bank account.
dichotomize hc15 (1) (9) hc15@1 "Household owns bank account".

* Land ownership.
recode hc12 (0=1) (996 thru hi=999) (else=copy) into hc12r.
if (hc11=2) hc12r=0.
missing values hc12r (999).
variable labels hc12r "Land area".

* Ownership of livestock.
recode hc14a hc14b hc14c hc14d hc14e hc14f (sysmis=0).

lanimal hc14a   cattle0   cattle1   cattle5   cattle10.
lanimal hc14b   horse0    horse1    horse5    horse10.
sanimal hc14c   goat0     goat1     goat10    goat30.
sanimal hc14d   sheep0    sheep1    sheep10   sheep30.
sanimal hc14e   chicken0  chicken1  chicken10 chicken30.
lanimal hc14f   pig0      pig1      pig5      pig10.

* 	Source of drinking water.
dichotomize ws1 (11) (98 thru hi) ws1@11 	"Water piped into dwelling".
dichotomize ws1 (12) (98 thru hi) ws1@12 	"Water piped into yard/plot".
dichotomize ws1 (13) (98 thru hi) ws1@13 	"Water piped to neighbor".
dichotomize ws1 (14) (98 thru hi) ws1@14 	"Public tap/standpipe for water".
dichotomize ws1 (21) (98 thru hi) ws1@21 	"Tubewell/borehole for water".
dichotomize ws1 (31) (98 thru hi) ws1@31 	"Protected well for water".
dichotomize ws1 (32) (98 thru hi) ws1@32	"Unprotected well for water".
dichotomize ws1 (41) (98 thru hi) ws1@41	"Protected spring for water".
dichotomize ws1 (42) (98 thru hi) ws1@42	"Unprotected spring for water".
dichotomize ws1 (51) (98 thru hi) ws1@51	"Rainwater for water".
dichotomize ws1 (61) (98 thru hi) ws1@61	"Tanker truck for water".
dichotomize ws1 (71) (98 thru hi) ws1@71	"Cart with small tank for water".
dichotomize ws1 (81) (98 thru hi) ws1@81	"Surface water".
dichotomize ws1 (91) (98 thru hi) ws1@91	"Bottled water".

* 	Location of water source.
recode ws3 (sysmis=1) (1,2,3=copy) (else=9) into watloc.
if (watloc=3 and ws4 ge 30 and ws4 le 995) watloc=4.
dichotomize watloc (1) (9) watloc@1	"Water in own dwelling".
dichotomize watloc (2) (9) watloc@2	"Water in own yard or plot".
dichotomize watloc (3) (9) watloc@3	"Water less than 30 minutes away".
dichotomize watloc (4) (9) watloc@4	"Water more than 30 minutes away".

* Sharing sanitation facilities.
dichotomize ws9 (1) (9) latshare		"Shares toilet with other households or uses public toilets".
dichotomize ws11 (2 thru 9) (98, 99) lathh1	"Shares toilet with less than 10 households".
dichotomize ws11 (10) (98, 99) lathh2	"Shares toilet with 10+ households or uses public toilets".
if (ws10 = 2) lathh2 = 1.

*	Type of sanitation facility.
dichotomize ws8 (11) (98 thru hi) ws8@11	"Flush to piped sewer system toilet".
dichotomize ws8 (12) (98 thru hi) ws8@12	"Flush to septic system toilet".
dichotomize ws8 (13) (98 thru hi) ws8@13	"Flush to pit latrine toilet".
dichotomize ws8 (14) (98 thru hi) ws8@14	"Flush to somewhere else toilet".
dichotomize ws8 (15) (98 thru hi) ws8@15	"Flush to unknown place toilet".
dichotomize ws8 (21) (98 thru hi) ws8@21	"Vent improved pit latrine toilet".
dichotomize ws8 (22) (98 thru hi) ws8@22	"Pit latrine with slab toilet".
dichotomize ws8 (23) (98 thru hi) ws8@23	"Pit latrine without slab toilet".
dichotomize ws8 (31) (98 thru hi) ws8@31	"Composting toilet".
dichotomize ws8 (41) (98 thru hi) ws8@41	"Bucket toilet".
dichotomize ws8 (51) (98 thru hi) ws8@51	"Hanging toilet".
dichotomize ws8 (95) (98 thru hi) ws8@95	"Bush/field/no toilet".

*	Separate out shared toilets and non-shared (private) toilets.
sharedfac ws8@11 ws8@11s	"Flush to piped sewer system toilet - shared".
sharedfac ws8@12 ws8@12s	"Flush to septic system toilet - shared".
sharedfac ws8@13 ws8@13s	"Flush to pit latrine toilet - shared".	
sharedfac ws8@14 ws8@14s	"Flush to somewhere else toilet - shared".
sharedfac ws8@15 ws8@15s	"Flush to unknown place toilet - shared".	
sharedfac ws8@21 ws8@21s	"Vent improved pit latrine toilet - shared".
sharedfac ws8@22 ws8@22s	"Pit latrine with slab toilet - shared".
sharedfac ws8@23 ws8@23s	"Pit latrine without slab toilet - shared".
sharedfac ws8@31 ws8@31s	"Composting toilet - shared".
sharedfac ws8@41 ws8@41s	"Bucket toilet - shared".
sharedfac ws8@51 ws8@51s	"Hanging toilet - shared".	

* 	Availability of water at place for handwashing.
dichotomize hw2 (1) (9) hw2@1		"Water present at handwashing place in the dwelling".
* To account for those cases where place for handwashing is not in the dwelling.
if (hw1=2) hw2@1=0.

* 	Availability of soap.
compute soap = 9.
if (hw3a = 1 or hw4= 1) soap = 1.
if (hw3a = 2 and hw4 = 2) soap = 0.
dichotomize soap (1) (9) soap@1 		"Has soap in household".

* Summary statistics.
varmeans 	((persroom)).
varmeans 	((hc3@11 + hc3@12 + hc3@21 + hc3@22 + hc3@31 + hc3@32 + hc3@33 + hc3@34 + hc3@35)).
varmeans 	((hc4@11 + hc4@12 + hc4@13 + hc4@21 + hc4@22 + hc4@23 + hc4@24 + hc4@31 + hc4@32 + 
		hc4@33 + hc4@34 + hc4@35 + hc4@36)).
varmeans 	((hc5@11 + hc5@12 + hc5@13 + hc5@21 + hc5@22 + hc5@23 + hc5@24 + hc5@25 + hc5@26 +
		hc5@31 + hc5@32 + hc5@33 + hc5@34 + hc5@35 + hc5@36)).
varmeans  	((hc6@01 + hc6@02 + hc6@03 + hc6@04 + hc6@05 + hc6@06 + hc6@07 + hc6@08 + hc6@09 + 
		hc6@10 + hc6@11 + hc6@95)).
varmeans  	((hc8a@1 + hc8b@1 + hc8c@1 + hc8d@1 + hc8e@1 + hc8f@1)).
varmeans  	((hc9a@1 + hc9b@1 + hc9c@1 + hc9d@1 + hc9e@1 + hc9f@1 + hc9g@1 + hc9h@1)).
varmeans 	((hc10@1 + hc10@2 + hc10@6)).
varmeans	((hc12r@0)).
varmeans 	((cattle0 + cattle1 + cattle5 + cattle10)).
varmeans  	((horse0 + horse1 + horse5 + horse10)).
varmeans  	((goat0 + goat1 + goat10 + goat30)). 
varmeans  	((sheep0 + sheep1 + sheep10 + sheep30)). 
varmeans  	((chicken0 + chicken1 + chicken10 + chicken30)). 
varmeans  	(( pig0 + pig1 + pig5 + pig10)). 
varmeans	((hc15@1)).
varmeans  	((ws1@11 + ws1@12 + ws1@13 + ws1@14 + ws1@21 + ws1@31 + ws1@32 + 
		ws1@41 + ws1@42 + ws1@51 + ws1@61 + ws1@71 + ws1@81 + ws1@91)).
varmeans  	((watloc@1 + watloc@2 + watloc@3 + watloc@4)).
varmeans	((latshare + lathh1 + lathh2)).
varmeans  	((ws8@11 + ws8@12 + ws8@13 + ws8@14 + ws8@15 + ws8@21 + ws8@22 + ws8@23 + 
		ws8@31 + ws8@41 + ws8@51 + ws8@95)).
varmeans 	((hw2@1 + soap@1)).
varmeans	((servant + abroad)).



* 	Create the SPSS output.
output save outfile = "w2.spv".

*	Close the output.
output close *.