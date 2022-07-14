CD "C:\MICS4\SPSS".

* --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------.
* --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------.
* ---------------------	Program to calculate and append wealth index variables to SPSS data files.
* --------------------- This program should be run after household weights have been finalized, and structural checks have been completed.
* ---------------------	Only hh.sav data file is used to calculate the wealth index and two new variables are created: wscore and windex5.
* ---------------------	Usually, several runs of this program will be needed before the wealth index is finalized and merged to the data sets for good.
* ---------------------	The data processing expert should work with an expert with expertise in wealth index calculation to finalize this program.
* --------------------- Do not run the program all at once - run parts of the program, ensure that everything is in order, then proceed to the next part.
* --------------------- Ensure that the variables "windex5" and "wscore" do not exist in the data files already.
* --------------------- If they do, then the program will fail to replace them with the new values of the variables.
* --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------.
* --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------.


* ------------------------------------------ Get household file and select only households where interviews were completed.
get file = 'hh.sav'.
select if (hh9 = 1).


* ------------------------------------------ Check frequency distribution of variables, look for missing values.
* ------------------------------------------ First run the command below before proceeding to the following commands. 
Fre vars=
	ws1 ws8
	hc2 hc3 hc4 hc5 hc6
	hc8a hc8b hc8c hc8d hc8e 
	hc9a hc9b hc9c hc9d hc9e hc9f hc9g
	hc10
	hc11
	hc12 hc13 hc14a hc14b hc14c hc14d hc14e hc14f hc15
           	/statistics=stddev mean
	/order=analysis .


* ------------------------------------------ Begin recoding variables, as dichotomous variables or continuous variables.

* ------------------------------------------ Source of drinking water (WS1).
* ------------------------------------------ Dichotomize for each response category of source of drinking water - you should have as many variables as the response codes.
recode ws1 (11 = 1) (98 thru hi = 9) (else = 0) into watpdw.
variable label watpdw 'Has water piped into dwelling'.
value label watpdw 0 'Not water piped into dwelling' 1 'Has water piped into dwelling' 9 'Missing'.
missing values watpdw (9).

recode ws1 (12 = 1) (98 thru hi = 9) (else = 0) into watpyd.
variable label watpyd 'Has water piped into yard/plot'.
value label watpyd 0 'Not water piped into yard/plot' 1 'Has water piped into yard/plot' 9 'Missing'.
missing values watpyd (9).

recode ws1 (13 = 1) (98 thru hi = 9) (else = 0) into watnei.
variable label watnei 'Has water piped to neighbor'.
value label watnei 0 'Not water piped to neighbor' 1 'Has water piped to neighbor' 9 'Missing'.
missing values watnei (9).

recode ws1 (14 = 1) (98 thru hi = 9) (else = 0) into watptap.
variable label watptap 'Has public tap/standpipe for water'.
value label watptap 0 'Not public tap/standpipe for water' 1 'Has public tap/standpipe for water' 9 'Missing'.
missing values watptap (9).

recode ws1 (21 = 1) (98 thru hi = 9) (else = 0) into watbore.
variable label watbore 'Has tubewell/borehole for water'.
value label watbore 0 'Not tubewell/borehole for water' 1 'Has tubewell/borehole for water' 9 'Missing'.
missing values watbore (9).

recode ws1 (31 = 1) (98 thru hi = 9) (else = 0) into watpwell.
variable label watpwell 'Has protected well for water'.
value label watpwell 0 'Not protected well for water' 1 'Has protected well for water' 9 'Missing'.
missing values watpwell (9).

recode ws1 (32 = 1) (98 thru hi = 9) (else = 0) into watuwell.
variable label watuwell 'Has unprotected well for water'.
value label watuwell 0 'Not unprotected well for water' 1 'Has unprotected well for water' 9 'Missing'.
missing values watuwell (9).

recode ws1 (41 = 1) (98 thru hi = 9) (else = 0) into watpsprg.
variable label watpsprg 'Has protected spring for water'.
value label watpsprg 0 'Not protected spring for water' 1 'Has protected spring for water' 9 'Missing'.
missing values watpsprg (9).

recode ws1 (42 = 1) (98 thru hi = 9) (else = 0) into watusprg.
variable label watusprg 'Has unprotected spring for water'.
value label watusprg 0 'Not unprotected spring for water' 1 'Has unprotected spring for water' 9 'Missing'.
missing values watusprg (9).

recode ws1 (51 = 1) (98 thru hi = 9) (else = 0) into watrain.
variable label watrain 'Has rainwater for water'.
value label watrain 0 'Not rainwater for water' 1 'Has rainwater for water' 9 'Missing'.
missing values watrain (9).

recode ws1 (61 = 1) (98 thru hi = 9) (else = 0) into wattank.
variable label wattank 'Has tanker truck for water'.
value label wattank 0 'Not tanker truck for water' 1 'Has tanker truck for water' 9 'Missing'.
missing values wattank (9).

recode ws1 (71 = 1) (98 thru hi = 9) (else = 0) into watcart.
variable label watcart 'Has cart with small tank for water'.
value label watcart 0 'Not cart with small tank for water' 1 'Has cart with small tank for water' 9 'Missing'.
missing values watcart (9).

recode ws1 (81 = 1) (98 thru hi = 9) (else = 0) into watsurf.
variable label watsurf 'Has surface water'.
value label watsurf 0 'Not surface water' 1 'Has surface water' 9 'Missing'.
missing values watsurf (9).

recode ws1 (91 = 1) (98 thru hi = 9) (else = 0) into watbott.
variable label watbott 'Has bottled water'.
value label watbott 0 'Not bottled water' 1 'Has bottled water' 9 'Missing'.
missing values watbott (9).



* ------------------------------------------ Type of sanitation facility (WS8).
recode ws8 (11 = 1) (98 thru hi = 9) (else = 0) into sanfsew.
variable label sanfsew 'Has flush to piped sewer system toilet'.
value label sanfsew 0 'Not flush to piped sewer system toilet' 1 'Has flush to piped sewer system toilet' 9 'Missing'.
missing values sanfsew (9).

recode ws8 (12 = 1) (98 thru hi = 9) (else = 0) into sanfsep.
variable label sanfsep 'Has flush to septic system toilet'.
value label sanfsep 0 'Not flush to septic system toilet' 1 'Has flush to septic system toilet' 9 'Missing'.
missing values sanfsep (9).

recode ws8 (13 = 1) (98 thru hi = 9) (else = 0) into sanfpit.
variable label sanfpit 'Has flush to pit latrine toilet'.
value label sanfpit 0 'Not flush to pit latrine toilet' 1 'Has flush to pit latrine toilet' 9 'Missing'.
missing values sanfpit (9).

recode ws8 (14 = 1) (98 thru hi = 9) (else = 0) into sanfelse.
variable label sanfelse 'Has flush to somewhere else toilet'.
value label sanfelse 0 'Not flush to somewhere else toilet' 1 'Has flush to somewhere else toilet' 9 'Missing'.
missing values sanfelse (9).

recode ws8 (15 = 1) (98 thru hi = 9) (else = 0) into sanfdk.
variable label sanfdk 'Has flush to unknown place toilet'.
value label sanfdk 0 'Not flush to unknown place toilet' 1 'Has flush to unknown place toilet' 9 'Missing'.
missing values sanfdk (9).

recode ws8 (21 = 1) (98 thru hi = 9) (else = 0) into sanvip.
variable label sanvip 'Has vent improved pit latrine toilet'.
value label sanvip 0 'Not vent improved pit latrine toilet' 1 'Has vent improved pit latrine toilet' 9 'Missing'.
missing values sanvip (9).

recode ws8 (22 = 1) (98 thru hi = 9) (else = 0) into sanpitsl.
variable label sanpitsl 'Has pit latrine with slab toilet'.
value label sanpitsl 0 'Not pit latrine with slab toilet' 1 'Has pit latrine with slab toilet' 9 'Missing'.
missing values sanpitsl (9).

recode ws8 (23 = 1) (98 thru hi = 9) (else = 0) into sanpit.
variable label sanpit 'Has pit latrine without slab toilet'.
value label sanpit 0 'Not pit latrine without slab toilet' 1 'Has pit latrine without slab toilet' 9 'Missing'.
missing values sanpit (9).

recode ws8 (31 = 1) (98 thru hi = 9) (else = 0) into sancomp.
variable label sancomp 'Has composting toilet'.
value label sancomp 0 'Not composting toilet' 1 'Has composting toilet' 9 'Missing'.
missing values sancomp (9).

recode ws8 (41 = 1) (98 thru hi = 9) (else = 0) into sanbuck.
variable label sanbuck 'Has bucket toilet'.
value label sanbuck 0 'Not bucket toilet' 1 'Has bucket toilet' 9 'Missing'.
missing values sanbuck (9).

recode ws8 (51 = 1) (98 thru hi = 9) (else = 0) into sanhang.
variable label sanhang 'Has hanging toilet'.
value label sanhang 0 'Not hanging toilet' 1 'Has hanging toilet' 9 'Missing'.
missing values sanhang (9).

recode ws8 (95 = 1) (98 thru hi = 9) (else = 0) into sannone.
variable label sannone 'Has bush/field/none toilet'.
value label sannone 0 'Not bush/field/none toilet' 1 'Has bush/field/none toilet' 9 'Missing'.
missing values sannone (9).



* ------------------------------------------ Persons per sleeping room.
* ------------------------------------------ Normally, values should be greater than 0, but hc2>0 included to be on the safe side.
compute persroom = 99.
if (hc2>0 and hc2 < 98) persroom = hh11/hc2.
variable label persroom 'Persons per sleeping rooms'.
missing values persroom (99).



* ------------------------------------------ Type of floor (HC3).
recode hc3 (11 = 1) (98 thru hi = 9) (else = 0) into flres.
variable label flres 'Has earth/sand floor'.
value label flres 0 'Not earth/sand floor' 1 'Has earth/sand floor' 9 'Missing'.
missing values flres (9).

recode hc3 (12 = 1) (98 thru hi = 9) (else = 0) into flrdng.
variable label flrdng 'Has dung floor'.
value label flrdng 0 'Not dung floor' 1 'Has dung floor' 9 'Missing'.
missing values flrdng (9).

recode hc3 (21 = 1) (98 thru hi = 9) (else = 0) into flrwd.
variable label flrwd 'Has wood floor'.
value label flrwd 0 'Not wood floor' 1 'Has wood floor' 9 'Missing'.
missing values flrwd (9).

recode hc3 (22 = 1) (98 thru hi = 9) (else = 0) into flrbam.
variable label flrbam 'Has palm/bamboo floor'.
value label flrbam 0 'Not palm/bamboo floor' 1 'Has palm/bamboo floor' 9 'Missing'.
missing values flrbam (9).

recode hc3 (31 = 1) (98 thru hi = 9) (else = 0) into flrpq.
variable label flrpq 'Has parquet/polished wood floor'.
value label flrpq 0 'Not parquet/polished wood floor' 1 'Has parquet/polished wood floor' 9 'Missing'.
missing values flrpq (9).

recode hc3 (32 = 1) (98 thru hi = 9) (else = 0) into flrvl.
variable label flrvl 'Has vinyl/asphalt strip floor'.
value label flrvl 0 'Not vinyl/asphalt strip floor' 1 'Has vinyl/asphalt strip floor' 9 'Missing'.
missing values flrvl (9).

recode hc3 (33 = 1) (98 thru hi = 9) (else = 0) into flrcer.
variable label flrcer 'Has ceramic tile floor'.
value label flrcer 0 'Not ceramic tile floor' 1 'Has ceramic tile floor' 9 'Missing'.
missing values flrcer (9).

recode hc3 (34 = 1) (98 thru hi = 9) (else = 0) into flrcem.
variable label flrcem 'Has cement floor'.
value label flrcem 0 'Not cement floor' 1 'Has cement floor' 9 'Missing'.
missing values flrcem (9).

recode hc3 (35 = 1) (98 thru hi = 9) (else = 0) into flrcpt.
variable label flrcpt 'Has carpet floor'.
value label flrcpt 0 'Not carpet floor' 1 'Has carpet floor' 9 'Missing'.
missing values flrcpt (9).


* ------------------------------------------ Type of roof (HC4).
recode hc4 (11 = 1) (98 thru hi = 9) (else = 0) into roofno.
variable label roofno 'Has no roof'.
value label roofno 0 'Has roof' 1 'Has no roof' 9 'Missing'.
missing values roofno (9).

recode hc4 (12 = 1) (98 thru hi = 9) (else = 0) into rooflf.
variable label rooflf 'Has thatch/palm leaf roof'.
value label rooflf 0 'Not thatch/palm leaf roof' 1 'Has thatch/palm leaf roof' 9 'Missing'.
missing values rooflf (9).

recode hc4 (13 = 1) (98 thru hi = 9) (else = 0) into roofsod.
variable label roofsod 'Has sod roof'.
value label roofsod 0 'Not sod roof' 1 'Has sod roof' 9 'Missing'.
missing values roofsod (9).

recode hc4 (21 = 1) (98 thru hi = 9) (else = 0) into roofmat.
variable label roofmat 'Has rustic mat roof'.
value label roofmat 0 'Not rustic mat roof' 1 'Has rustic mat roof' 9 'Missing'.
missing values roofmat (9).

recode hc4 (22 = 1) (98 thru hi = 9) (else = 0) into roofbam.
variable label roofbam 'Has palm/bamboo roof'.
value label roofbam 0 'Not palm/bamboo roof' 1 'Has palm/bamboo roof' 9 'Missing'.
missing values roofbam (9).

recode hc4 (23 = 1) (98 thru hi = 9) (else = 0) into roofplnk.
variable label roofplnk 'Has wood plank roof'.
value label roofplnk 0 'Not wood plank roof' 1 'Has wood plank roof' 9 'Missing'.
missing values roofplnk (9).

recode hc4 (24 = 1) (98 thru hi = 9) (else = 0) into roofcard.
variable label roofcard 'Has cardboard roof'.
value label roofcard 0 'Not cardboard roof' 1 'Has cardboard roof' 9 'Missing'.
missing values roofcard (9).

recode hc4 (31 = 1) (98 thru hi = 9) (else = 0) into roofmetl.
variable label roofmetl 'Has metal roof'.
value label roofmetl 0 'Not metal roof' 1 'Has metal roof' 9 'Missing'.
missing values roofmetl (9).

recode hc4 (32 = 1) (98 thru hi = 9) (else = 0) into roofwood.
variable label roofwood 'Has wood roof'.
value label roofwood 0 'Not wood roof' 1 'Has wood roof' 9 'Missing'.
missing values roofwood (9).

recode hc4 (33 = 1) (98 thru hi = 9) (else = 0) into rooffibr.
variable label rooffibr 'Has calamine/cement fibre roof'.
value label rooffibr 0 'Not calamine/cement fibre roof' 1 'Has calamine/cement fibre roof' 9 'Missing'.
missing values rooffibr (9).

recode hc4 (34 = 1) (98 thru hi = 9) (else = 0) into roofcer.
variable label roofcer 'Has ceramic tile roof'.
value label roofcer 0 'Not ceramic tile roof' 1 'Has ceramic tile roof' 9 'Missing'.
missing values roofcer (9).

recode hc4 (35 = 1) (98 thru hi = 9) (else = 0) into roofcem.
variable label roofcem 'Has cement roof'.
value label roofcem 0 'Not cement roof' 1 'Has cement roof' 9 'Missing'.
missing values roofcem (9).

recode hc4 (36 = 1) (98 thru hi = 9) (else = 0) into roofshng.
variable label roofshng 'Has shingle roof'.
value label roofshng 0 'Not shingle roof' 1 'Has shingle roof' 9 'Missing'.
missing values roofshng (9).


* ------------------------------------------ Type of wall (HC5).
recode hc5 (11 = 1) (98 thru hi = 9) (else = 0)  into wallno.
variable label wallno 'Has no wall'.
value label wallno 0 'Has wall' 1 'Has no wall' 9 'Missing'.
missing values wallno (9).

recode hc5 (12 = 1) (98 thru hi = 9) (else = 0)  into wallcane.
variable label wallcane 'Has cane/palm/trunk wall'.
value label wallcane 0 'Not cane/palm/trunk wall' 1 'Has cane/palm/trunk wall' 9 'Missing'.
missing values wallcane (9).

recode hc5 (13 = 1) (98 thru hi = 9) (else = 0)  into walldirt.
variable label walldirt 'Has dirt wall'.
value label walldirt 0 'Not dirt wall' 1 'Has dirt wall' 9 'Missing'.
missing values walldirt (9).

recode hc5 (21 = 1) (98 thru hi = 9) (else = 0)  into wallbam.
variable label wallbam 'Has bamboo with mud wall'.
value label wallbam 0 'Not bamboo with mud wall' 1 'Has bamboo with mud wall' 9 'Missing'.
missing values wallbam (9).

recode hc5 (22 = 1) (98 thru hi = 9) (else = 0)  into wallmud.
variable label wallmud 'Has stone with mud wall'.
value label wallmud 0 'Not stone with mud wall' 1 'Has stone with mud wall' 9 'Missing'.
missing values wallmud (9).

recode hc5 (23 = 1) (98 thru hi = 9) (else = 0)  into wallunad.
variable label wallunad 'Has uncovered adobe wall'.
value label wallunad 0 'Not uncovered adobe wall' 1 'Has uncovered adobe wall' 9 'Missing'.
missing values wallunad (9).

recode hc5 (24 = 1) (98 thru hi = 9) (else = 0)  into wallply.
variable label wallply 'Has plywood wall'.
value label wallply 0 'Not plywood wall' 1 'Has plywood wall' 9 'Missing'.
missing values wallply (9).

recode hc5 (25 = 1) (98 thru hi = 9) (else = 0)  into wallcard.
variable label wallcard 'Has cardboard wall'.
value label wallcard 0 'Not cardboard wall' 1 'Has cardboard wall' 9 'Missing'.
missing values wallcard (9).

recode hc5 (26 = 1) (98 thru hi = 9) (else = 0)  into wallre.
variable label wallre 'Has reused wood wall'.
value label wallre 0 'Not reused wood wall' 1 'Has reused wood wall' 9 'Missing'.
missing values wallre (9).

recode hc5 (31 = 1) (98 thru hi = 9) (else = 0)  into wallcem.
variable label wallcem 'Has cement wall'.
value label wallcem 0 'Not cement wall' 1 'Has cement wall' 9 'Missing'.
missing values wallcem (9).

recode hc5 (32 = 1) (98 thru hi = 9) (else = 0)  into wallstn.
variable label wallstn 'Has stone with lime/cement wall'.
value label wallstn 0 'Not stone with lime/cement wall' 1 'Has stone with lime/cement wall' 9 'Missing'.
missing values wallstn (9).

recode hc5 (33 = 1) (98 thru hi = 9) (else = 0)  into wallbrk.
variable label wallbrk 'Has brick wall'.
value label wallbrk 0 'Not brick wall' 1 'Has brick wall' 9 'Missing'.
missing values wallbrk (9).

recode hc5 (34 = 1) (98 thru hi = 9) (else = 0)  into wallblk.
variable label wallblk 'Has cement block wall'.
value label wallblk 0 'Not cement block wall' 1 'Has cement block wall' 9 'Missing'.
missing values wallblk (9).

recode hc5 (35 = 1) (98 thru hi = 9) (else = 0)  into walladob.
variable label walladob 'Has covered adobe wall'.
value label walladob 0 'Not covered adobe wall' 1 'Has covered adobe wall' 9 'Missing'.
missing values walladob (9).

recode hc5 (36 = 1) (98 thru hi = 9) (else = 0)  into wallplnk.
variable label wallplnk 'Has wood plank/shingle wall'.
value label wallplnk 0 'Not wood plank/shingle wall' 1 'Has wood plank/shingle wall' 9 'Missing'.
missing values wallplnk (9).


* ------------------------------------------ Type of cooking fuel (HC6).
recode hc6 (1 = 1) (98 thru hi = 9) (else = 0) into fuelelec.
variable label fuelelec 'Household fuel type: electricity'.
value label fuelelec 0 'No' 1 'Yes' 9 'Missing'.
missing values fuelelec (9).

recode hc6 (2 = 1) (98 thru hi = 9) (else = 0) into fuellpg.
variable label fuellpg 'Household fuel type: LPG'.
value label fuellpg 0 'No' 1 'Yes' 9 'Missing'.
missing values fuellpg (9).

recode hc6 (3 = 1) (98 thru hi = 9) (else = 0) into fuelgas.
variable label fuelgas 'Household fuel type: natural gas'.
value label fuelgas 0 'No' 1 'Yes' 9 'Missing'.
missing values fuelgas (9).

recode hc6 (4 = 1) (98 thru hi = 9) (else = 0) into fuelbio.
variable label fuelbio 'Household fuel type: biogas'.
value label fuelbio 0 'No' 1 'Yes' 9 'Missing'.
missing values fuelbio (9).

recode hc6 (5 = 1) (98 thru hi = 9) (else = 0) into fuelker.
variable label fuelker 'Household fuel type: kerosene'.
value label fuelker 0 'No' 1 'Yes' 9 'Missing'.
missing values fuelker (9).

recode hc6 (6 = 1) (98 thru hi = 9) (else = 0) into fuelcoal.
variable label fuelcoal 'Household fuel type: coal/lignite'.
value label fuelcoal 0 'No' 1 'Yes' 9 'Missing'.
missing values fuelcoal (9).

recode hc6 (7 = 1) (98 thru hi = 9) (else = 0) into fuelchar.
variable label fuelchar 'Household fuel type: charcoal'.
value label fuelchar 0 'No' 1 'Yes' 9 'Missing'.
missing values fuelchar (9).

recode hc6 (8 = 1) (98 thru hi = 9) (else = 0) into fuelwood.
variable label fuelwood 'Household fuel type: wood'.
value label fuelwood 0 'No' 1 'Yes' 9 'Missing'.
missing values fuelwood (9).

recode hc6 (9 = 1) (98 thru hi = 9) (else = 0) into fuelstrw.
variable label fuelstrw 'Household fuel type: straw/shrub/grass'.
value label fuelstrw 0 'No' 1 'Yes' 9 'Missing'.
missing values fuelstrw (9).

recode hc6 (10 = 1) (98 thru hi = 9) (else = 0) into fueldung.
variable label fueldung 'Household fuel type: animal dung'.
value label fueldung 0 'No' 1 'Yes' 9 'Missing'.
missing values fueldung (9).

recode hc6 (11 = 1) (98 thru hi = 9) (else = 0) into fuelagre.
variable label fuelagre 'Household fuel type: agrciultural crop residue'.
value label fuelagre 0 'No' 1 'Yes' 9 'Missing'.
missing values fuelagre (9).

recode hc6 (95 = 1) (98 thru hi = 9) (else = 0) into fuelnone.
variable label fuelnone 'Household fuel type: no food cooked'.
value label fuelnone 0 'No' 1 'Yes' 9 'Missing'.
missing values fuelnone (9).


* ------------------------------------------ Household assets (HC8A to HC8E).
recode hc8a (1 = 1) (9 = 9) (else = 0) into elec.
variable label elec 'Household has: electricity'.
value label elec 0 'No' 1 'Yes' 9 'Missing'.
missing values elec (9).

recode hc8b (1 = 1) (9 = 9) (else = 0) into radio.
variable label radio 'Household has: radio'.
value label radio 0 'No' 1 'Yes' 9 'Missing'.
missing values radio (9).

recode hc8c (1 = 1) (9 = 9) (else = 0) into tv.
variable label tv 'Household has: television'.
value label tv 0 'No' 1 'Yes' 9 'Missing'.
missing values tv (9).

recode hc8d (1 = 1) (9 = 9) (else = 0) into phone.
variable label phone 'Household has: non-mobile telephone'.
value label phone 0 'No' 1 'Yes' 9 'Missing'.
missing values phone (9).

recode hc8e (1 = 1) (9 = 9) (else = 0) into fridge.
variable label fridge 'Household has: refrigerator'.
value label fridge 0 'No' 1 'Yes' 9 'Missing'.
missing values fridge (9).


* ------------------------------------------ Household members assets (HC9A to HC9F).
recode hc9a (1 = 1) (9 = 9) (else = 0) into watch.
variable label watch 'Household member owns: watch'.
value label watch 0 'No' 1 'Yes' 9 'Missing'.
missing values watch (9).

recode hc9b (1 = 1) (9 = 9) (else = 0) into mobile.
variable label mobile 'Household member owns: mobile phone'.
value label mobile 0 'No' 1 'Yes' 9 'Missing'.
missing values mobile (9).

recode hc9c (1 = 1) (9 = 9) (else = 0) into bike.
variable label bike 'Household member owns: bicycle'.
value label bike 0 'No' 1 'Yes' 9 'Missing'.
missing values bike (9).

recode hc9d (1 = 1) (9 = 9) (else = 0) into moto.
variable label moto 'Household member owns: motorcycle/scooter'.
value label moto 0 'No' 1 'Yes' 9 'Missing'.
missing values moto (9).

recode hc9e (1 = 1) (9 = 9) (else = 0) into cart.
variable label cart 'Household member owns: animal drawn cart'.
value label cart 0 'No' 1 'Yes' 9 'Missing'.
missing values cart (9).

recode hc9f (1 = 1) (9 = 9) (else = 0) into car.
variable label car 'Household member owns: car/truck'.
value label car 0 'No' 1 'Yes' 9 'Missing'.
missing values car (9).

recode hc9g (1 = 1) (9 = 9) (else = 0) into boat.
variable label boat 'Household member owns: boat with motor'.
value label boat 0 'No' 1 'Yes' 9 'Missing'.
missing values boat (9).


* ------------------------------------------ Ownership of dwelling (HC10).
recode hc10 (1 = 1) (9 = 9) (else = 0) into own.
variable label own 'Household owns dwelling'.
value label own 0 'Not own dwelling' 1 'Owns dwelling' 9 'Missing'.
missing values own (9).

recode hc10 (2 = 1) (9 = 9) (else = 0) into rent.
variable label rent 'Household rents dwelling'.
value label rent 0 'Not rent dwelling' 1 'Rents dwelling' 9 'Missing'.
missing values rent (9).


* ------------------------------------------ Ownership of agricultural land (HC11).
recode hc11 (1 = 1) (9 = 9) (else = 0) into agland.
variable label agland 'Household owns agricultural land'.
value label agland 0 'Not own agricultural land' 1 'Owns agricultural land' 9 'Missing'.
missing values agland (9).


* ------------------------------------------ Ownership of livestock (HC14A to HC14F).
recode hc14a (1 thru 97 = 1) (98 thru hi = 9) (else = 0) into cattle.
variable label cattle 'Household owns cattle milk cows or bulls'.
value label cattle 0 'Not own cattle' 1 'Owns cattle' 9 'Missing'.
missing values cattle (9).

recode hc14b (1 thru 97 = 1) (98 thru hi = 9) (else = 0) into horses.
variable label horses 'Household owns horses donkeys mules'.
value label horses 0 'Not own horses' 1 'Owns horses donkeys mules' 9 'Missing'.
missing values horses (9).

recode hc14c (1 thru 97 = 1) (98 thru hi = 9) (else = 0) into goats.
variable label goats 'Household owns goats'.
value label goats 0 'Not own goats' 1 'Owns goats' 9 'Missing'.
missing values goats (9).

recode hc14d (1 thru 97 = 1) (98 thru hi = 9) (else = 0) into sheep.
variable label sheep 'Household owns sheep'.
value label sheep 0 'Not own sheep' 1 'Owns sheep' 9 'Missing'.
missing values sheep (9).

recode hc14e (1 thru 97 = 1) (98 thru hi = 9) (else = 0) into chickens.
variable label chickens 'Household owns chickens'.
value label chickens 0 'Not own chickens' 1 'Owns chickens' 9 'Missing'.
missing values chickens (9).

recode hc14f (1 thru 97 = 1) (98 thru hi = 9) (else = 0) into pigs.
variable label pigs 'Household owns pigs'.
value label pigs 0 'Not own pigs' 1 'Owns pigs' 9 'Missing'.
missing values pigs (9).


* ------------------------------------------ Ownership of bank account (HC15).
recode hc15 (1 = 1) (9 = 9) (else = 0) into bank.
variable label bank 'Household owns bank account'.
value label bank 0 'Not own bank account' 1 'Owns bank account' 9 'Missing'.
missing values bank (9).


* ---------------------	Run means for all variables created for inclusion in factor analysis.
* ---------------------	If any variable has a mean of 0.0000 or a very low value indicating that there are less than 2 cases 
			with the characteristic, delete that variable from the factor analysis command below.
desc vars=
	watpdw watpyd watnei watptap watbore watpwell watuwell watpsprg watusprg watrain wattank watcart watsurf watbott
	sanfsew sanfsep sanfpit sanfelse sanfdk sanvip sanpitsl sanpit sancomp sanbuck sanhang sannone
	persroom
	flres flrdng flrwd flrbam flrpq flrvl flrcer flrcem flrcpt
	roofno rooflf roofsod roofmat roofbam roofplnk roofcard roofmetl roofwood rooffibr roofcer roofcem roofshng
	wallno wallcane walldirt wallbam wallmud wallunad wallply wallcard wallre wallcem wallstn wallbrk wallblk walladob wallplnk
	fuelelec fuellpg fuelgas fuelbio fuelker fuelcoal fuelchar fuelwood fuelstrw fueldung fuelagre fuelnone
	elec radio tv phone fridge
	watch mobile bike moto cart car boat 
	own rent 
	agland 
	cattle horses goats sheep chickens pigs
                  bank
  	/statistics = mean.


* -------------------- Note that although we recoded variables on ownership of dwelling, agricultural land and livestock, we are not using these in factor analysis.
* -------------------- Methodological work is in progress on these.

* ---------------------	Run factor analysis.
factor
  /variables
	watpdw watpyd watnei watptap watbore watpwell watuwell watpsprg watusprg watrain wattank watcart watsurf watbott
	sanfsew sanfsep sanfpit sanfelse sanfdk sanvip sanpitsl sanpit sancomp sanbuck sanhang sannone
	persroom
	flres flrdng flrwd flrbam flrpq flrvl flrcer flrcem flrcpt
	roofno rooflf roofsod roofmat roofbam roofplnk roofcard roofmetl roofwood rooffibr roofcer roofcem roofshng
	wallno wallcane walldirt wallbam wallmud wallunad wallply wallcard wallre wallcem wallstn wallbrk wallblk walladob wallplnk
	fuelelec fuellpg fuelgas fuelbio fuelker fuelcoal fuelchar fuelwood fuelstrw fueldung fuelagre fuelnone
	elec radio tv phone fridge
	watch mobile bike moto cart car boat 
                  bank
  /missing meansub
  /analysis
	watpdw watpyd watnei watptap watbore watpwell watuwell watpsprg watusprg watrain wattank watcart watsurf watbott
	sanfsew sanfsep sanfpit sanfelse sanfdk sanvip sanpitsl sanpit sancomp sanbuck sanhang sannone
	persroom
	flres flrdng flrwd flrbam flrpq flrvl flrcer flrcem flrcpt
	roofno rooflf roofsod roofmat roofbam roofplnk roofcard roofmetl roofwood rooffibr roofcer roofcem roofshng
	wallno wallcane walldirt wallbam wallmud wallunad wallply wallcard wallre wallcem wallstn wallbrk wallblk walladob wallplnk
	fuelelec fuellpg fuelgas fuelbio fuelker fuelcoal fuelchar fuelwood fuelstrw fueldung fuelagre fuelnone
	elec radio tv phone fridge
	watch mobile bike moto cart car boat 
                  bank
  /print univariate initial extraction fscore
  /criteria factors(1) iterate(25)
  /extraction pc
  /rotation norotate
  /save reg(all)
  /method=correlation.

compute hhmemwt = hh11*hhweight.
weight by hhmemwt.
variable labels hhmemwt 'HH members weight for Index'.

rank
  variables=fac1_1  (A)
  /ntiles (5)
  /print=yes
  /ties=mean.

variable label fac1_1 'Wealth index score'.
format fac1_1 (f9.5).
variable label nfac1_1 'Wealth index quintiles'.
value label nfac1_1
	1 'Poorest'
	2 'Second'
	3 'Middle'
	4 'Fourth'
	5 'Richest'.
format nfac1_1 (f1.0).

frequencies
  variables=fac1_1
  /ntiles= 5
  /statistics=stddev minimum maximum mean median
  /order=analysis.

weight off.

crosstabs
  /tables=HH6 HH7  by nfac1_1
  /format= avalue tables
  /cells= count row
  /count round cell.

delete var wscore windex5.

sort cases by hh1 hh2.

save outfile="wealth.sav"
 /rename (fac1_1 = wscore) (nfac1_1 = windex5)
 /keep HH1 HH2 wscore windex5.


* ---------------------	Merging wealth index values to data files.

* ---------------------	Add wealth index values to household file.
get file = 'hh.sav'.

delete var windex5 wscore.

sort cases by HH1 HH2.

match files
  /file = *
  /table = 'wealth.sav'
  /by HH1 HH2.

*set wealth index for incomplete households equal to 0.
if (HH9 <> 1) windex5 = 0.
if (HH9 <> 1) wscore = 0.

save outfile = 'hh.sav'.

* ---------------------	Add wealth index values to household listing file.
get file = 'hl.sav'.

delete var windex5 wscore.

sort cases by HH1 HH2.

match files
  /file = *
  /table = 'wealth.sav'
  /by HH1 HH2.

save outfile = 'hl.sav'.

* ---------------------	Add wealth index values to women's file.
get file = 'wm.sav'.

delete var windex5 wscore.

sort cases by HH1 HH2.

match files
  /file = *
  /table = 'wealth.sav'
  /by HH1 HH2.

*set wealth index for incomplete womens interviews equal to 0.
if (WM7 <> 1) windex5 = 0.
if (WM7 <> 1) wscore = 0.
save outfile = 'wm.sav'.

* ---------------------	Add wealth index values to children's file.
get file = 'ch.sav'.

delete var windex5 wscore.

sort cases by HH1 HH2.

match files
  /file = *
  /table = 'wealth.sav'
  /by HH1 HH2.

*set wealth index for incomplete child interviews equal to 0.
if (UF9 <> 1) windex5 = 0.
if (UF9 <> 1) wscore = 0.

save outfile = 'ch.sav'.

* ---------------------	Add wealth index values to the nets file.
get file = 'tn.sav'.

delete var windex5 wscore.

sort cases by HH1 HH2.

match files
  /file = *
  /table = 'wealth.sav'
  /by HH1 HH2.

save outfile = 'tn.sav'.


* ---------------------	Add wealth index values to fgm file.
get file = 'fg.sav'.

delete var windex5 wscore.

sort cases by HH1 HH2.

match files
  /file = *
  /table = 'wealth.sav'
  /by HH1 HH2.

save outfile = 'fg.sav'.


* ---------------------	Add wealth index values to birth history file.
** ! REMOVE THE COMMENTS IF BH IS USED IN THE COUNTRY.
* get file = 'bh.sav'.

* delete var windex5 wscore.

* sort cases by HH1 HH2.

* match files
  /file = *
  /table = 'wealth.sav'
  /by HH1 HH2.

* save outfile = 'bh.sav'.


* ---------------------	Delete the wealth sav file.
erase file 'wealth.sav'.

new file.