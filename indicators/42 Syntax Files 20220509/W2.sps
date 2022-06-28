* Encoding: windows-1252.
* EXAMINE FREQUENCIES, RECODE AND DESCRIBE VARIABLES.

* Frequencies of selected variables by national, urban and rural.
varpdist HH48 
            HC3 HC4 HC5 HC6
            HC7A HC7B HC7C
            HC8  
            HC9A HC9B HC9C
            HC10A HC10B HC10C HC10D HC10E HC10F HC10G
            HC11 HC12 HC13 
            HC15 HC16
            HC17 HC18A HC18B HC18C HC18D HC18E HC18F HC18G HC18H
            HC19
            EU1 EU2 EU3 
            EU4 EU5 
            EU6 EU7
            EU8 EU9 
            WS1 WS3 WS4 
            WS7 
            WS11 WS14 WS15 WS16 WS17
            HW1 HW2 HW3 HW4 
            servant @.

* Construct variables for wealth index.

*	Persons per sleeping room.
do if (HC3 < 98).
compute persroom = HH48 / HC3.
else.
compute persroom = 99.
end if.
missing values persroom (99).
variable labels persroom "Persons per sleeping room".
execute.

*	Type of floor.
dichotomize HC4 (11) (98 thru hi) hc4@11	"Earth/sand floor".
dichotomize HC4 (12) (98 thru hi) hc4@12	"Dung floor".
dichotomize HC4 (21) (98 thru hi) hc4@21	"Wood planks floor".
dichotomize HC4 (22) (98 thru hi) hc4@22	"Palm/bamboo floor".
dichotomize HC4 (31) (98 thru hi) hc4@31	"Parquet/polished wood floor".
dichotomize HC4 (32) (98 thru hi) hc4@32	"Vinyl/asphalt strip floor".
dichotomize HC4 (33) (98 thru hi) hc4@33	"Ceramic tiles floor".
dichotomize HC4 (34) (98 thru hi) hc4@34	"Cement floor".
dichotomize HC4 (35) (98 thru hi) hc4@35	"Carpet floor".

*	Type of roof.
dichotomize HC5 (11) (98 thru hi) hc5@11	"No roof".
dichotomize HC5 (12) (98 thru hi) hc5@12	"Thatch/palm leaf roof".
dichotomize HC5 (13) (98 thru hi) hc5@13	"Sod roof".
dichotomize HC5 (21) (98 thru hi) hc5@21	"Rustic mat roof".
dichotomize HC5 (22) (98 thru hi) hc5@22	"Palm/bamboo roof".
dichotomize HC5 (23) (98 thru hi) hc5@23	"Wood planks roof".
dichotomize HC5 (24) (98 thru hi) hc5@24	"Cardboard roof".
dichotomize HC5 (31) (98 thru hi) hc5@31	"Metal/tin roof".
dichotomize HC5 (32) (98 thru hi) hc5@32	"Wood roof".
dichotomize HC5 (33) (98 thru hi) hc5@33	"Calamine/cement fibre roof".
dichotomize HC5 (34) (98 thru hi) hc5@34	"Ceramic tiles roof".
dichotomize HC5 (35) (98 thru hi) hc5@35	"Cement roof".
dichotomize HC5 (36) (98 thru hi) hc5@36	"Roofing shingles roof".

*	Type of wall.
dichotomize HC6 (11) (98 thru hi) hc6@11	"No walls".
dichotomize HC6 (12) (98 thru hi) hc6@12	"Cane/palm/trunks walls".
dichotomize HC6 (13) (98 thru hi) hc6@13	"Dirt walls".
dichotomize HC6 (21) (98 thru hi) hc6@21	"Bamboo with mud wall".
dichotomize HC6 (22) (98 thru hi) hc6@22	"Stone with mud walls".
dichotomize HC6 (23) (98 thru hi) hc6@23	"Uncovered adobe walls".
dichotomize HC6 (24) (98 thru hi) hc6@24	"Plywood walls".
dichotomize HC6 (25) (98 thru hi) hc6@25	"Cardboard walls".
dichotomize HC6 (26) (98 thru hi) hc6@26	"Reused wood walls".
dichotomize HC6 (31) (98 thru hi) hc6@31	"Cement walls".
dichotomize HC6 (32) (98 thru hi) hc6@32	"Stone with lime/cement walls".
dichotomize HC6 (33) (98 thru hi) hc6@33	"Brick walls".
dichotomize HC6 (34) (98 thru hi) hc6@34	"Cement blocks walls".
dichotomize HC6 (35) (98 thru hi) hc6@35	"Covered adobe walls".
dichotomize HC6 (36) (98 thru hi) hc6@36	"Wood planks/shingles walls".

*	Household assets - 1.
dichotomize HC7A (1) (9) hc7a@1	"Fixed telephone line".
dichotomize HC7B (1) (9) hc7b@1	"Radio".
dichotomize HC7C (1) (9) hc7c@1	"Country-specific item".

*	Electricity.
dichotomize HC8 (1) (9) hc8@1    "Yes, interconnected grid".
dichotomize HC8 (2) (9) hc8@2    "Yes, off-grid (generator/isolated system)".
dichotomize HC8 (3) (9) hc8@3    "No electricity".


*	Household assets - 2.
dichotomize HC9A (1) (9) hc9a@1 	"Television".
dichotomize HC9B (1) (9) hc9b@1	"Refrigerator".
dichotomize HC9C (1) (9) hc9c@1	"Country-specific item".

*	Household members assets.
dichotomize HC10A (1) (9) hc10a@1	"Wristwatch".
dichotomize HC10B (1) (9) hc10b@1	"Bicycle".
dichotomize HC10C (1) (9) hc10c@1	"Motorcycle/scooter".
dichotomize HC10D (1) (9) hc10d@1	"Animal drawn cart".
dichotomize HC10E (1) (9) hc10e@1	"Car/truck/van".
dichotomize HC10F (1) (9) hc10f@1	"Boat with motor".
dichotomize HC10G (1) (9) hc10g@1	"Country-specific item".

*	Computer / Mobile / Internet.
dichotomize HC11 (1) (9) hc11@1	"Computer/tablet".
dichotomize HC12 (1) (9) hc12@1	"Mobile telephone".
dichotomize HC13 (1) (9) hc13@1	"Internet at home".

* Land ownership.
recode HC16 (0=1) (96 thru hi=99) (else=copy) into hc16r.
if (HC15=2) hc16r=0.
missing values hc16r (99).
variable labels hc16r "Land area".

* Ownership of livestock.
recode HC18A HC18B HC18C HC18D HC18E HC18F HC18G HC18H (sysmis=0).

lanimal HC18A    cow0  cow1  cow5  cow10.
lanimal HC18B    othercattle0  othercattle1  othercattle5  othercattle10.
lanimal HC18C    horse0  horse1  horse5  horse10.
sanimal HC18D    goat0  goat1  goat10  goat30.
sanimal HC18E   sheep0  sheep1  sheep10  sheep30.
sanimal HC18F   chicken0  chicken1  chicken10  chicken30.
lanimal HC18G   pig0  pig1  pig5  pig10.
sanimal HC18H    otheranimal0  otheranimal1  otheranimal10  otheranimal30.

*	Bank account.
dichotomize HC19 (1) (9) hc19@1 "Household owns bank account".

*	Type of  cookstove.
dichotomize EU1 (01) (98 thru hi) eu1@01	"Electric stove".
dichotomize EU1 (02) (98 thru hi) eu1@02	"Solar cooker".
dichotomize EU1 (03) (98 thru hi) eu1@03	"Liquefied petroleum gas (lpg)/ cooking gas stove".
dichotomize EU1 (04) (98 thru hi) eu1@04	"Piped natural gas stove".
dichotomize EU1 (05) (98 thru hi) eu1@05	"Biogas stove".
dichotomize EU1 (06) (98 thru hi) eu1@06	"Liquid fuel stove".
dichotomize EU1 (09) (98 thru hi) eu1@09	"Three stone stove / open fire".
dichotomize EU1 (97) (98 thru hi) eu1@97	"No food cooked".

dichotomize EU1 (07) (98 thru hi) eu1@07	"Manufactured solid fuel stove".
dichotomize EU1 (08) (98 thru hi) eu1@08	"Traditional solid fuel stove".

compute eu1@070101=0.
compute eu1@070102=0.
compute eu1@070108=0.
compute eu1@070201=0.
compute eu1@070202=0.
compute eu1@070208=0.
compute eu1@070801=0.
compute eu1@070802=0.
compute eu1@070808=0.
if (EU1=7 and EU2=1 and EU3=1) eu1@070101=1.	
if (EU1=7 and EU2=1 and EU3=2) eu1@070102=1. 	
if (EU1=7 and EU2=1 and EU3=8) eu1@070108=1.	
if (EU1=7 and EU2=2 and EU3=1) eu1@070201=1.	
if (EU1=7 and EU2=2 and EU3=2) eu1@070202=1.	
if (EU1=7 and EU2=2 and EU3=8) eu1@070208=1.
if (EU1=7 and EU2=8 and EU3=1) eu1@070801=1.	
if (EU1=7 and EU2=8 and EU3=2) eu1@070802=1.
if (EU1=7 and EU2=8 and EU3=8) eu1@070808=1.	
variable labels eu1@070101 "Manufactured solid fuel stove - has chimney has fan".
variable labels eu1@070102 "Manufactured solid fuel stove - has chimney NO fan".
variable labels eu1@070108 "Manufactured solid fuel stove - has chimney DK fan".
variable labels eu1@070201 "Manufactured solid fuel stove - NO chimney has fan".
variable labels eu1@070202 "Manufactured solid fuel stove - NO chimney NO fan".
variable labels eu1@070208 "Manufactured solid fuel stove - NO chimney DK fan".
variable labels eu1@070801 "Manufactured solid fuel stove - DK chimney has fan".
variable labels eu1@070802 "Manufactured solid fuel stove - DK chimney NO fan".
variable labels eu1@070808 "Manufactured solid fuel stove - DK chimney DK fan".
compute eu1@080101=0.
compute eu1@080102=0.
compute eu1@080108=0.
compute eu1@080201=0.
compute eu1@080202=0.
compute eu1@080208=0.
compute eu1@080801=0.
compute eu1@080802=0.
compute eu1@080808=0.
if (EU1=8 and EU2=1 and EU3=1) eu1@080101=1.	
if (EU1=8 and EU2=1 and EU3=2) eu1@080102=1. 	
if (EU1=8 and EU2=1 and EU3=8) eu1@080108=1.	
if (EU1=8 and EU2=2 and EU3=1) eu1@080201=1.	
if (EU1=8 and EU2=2 and EU3=2) eu1@080202=1.	
if (EU1=8 and EU2=2 and EU3=8) eu1@080208=1.
if (EU1=8 and EU2=8 and EU3=1) eu1@080801=1.	
if (EU1=8 and EU2=8 and EU3=2) eu1@080802=1.
if (EU1=8 and EU2=8 and EU3=8) eu1@080808=1.	
variable labels eu1@080101 "Traditional solid fuel stove - has chimney has fan".
variable labels eu1@080102 "Traditional solid fuel stove - has chimney NO fan".
variable labels eu1@080108 "Traditional solid fuel stove - has chimney DK fan".
variable labels eu1@080201 "Traditional solid fuel stove - NO chimney has fan".
variable labels eu1@080202 "Traditional solid fuel stove - NO chimney NO fan".
variable labels eu1@080208 "Traditional solid fuel stove - NO chimney DK fan".
variable labels eu1@080801 "Traditional solid fuel stove - DK chimney has fan".
variable labels eu1@080802 "Traditional solid fuel stove - DK chimney NO fan".
variable labels eu1@080808 "Traditional solid fuel stove - DK chimney DK fan".

*	Type of energy used at cookstove.
dichotomize EU4 (01) (98 thru hi) eu4@01	"Alcohol/ethanol".
dichotomize EU4 (02) (98 thru hi) eu4@02	"Gasoline/diesel".
dichotomize EU4 (03) (98 thru hi) eu4@03	"Kerosene/paraffin".
dichotomize EU4 (04) (98 thru hi) eu4@04	"Coal/lignite".
dichotomize EU4 (05) (98 thru hi) eu4@05	"Charcoal".
dichotomize EU4 (06) (98 thru hi) eu4@06	"Wood".
dichotomize EU4 (07) (98 thru hi) eu4@07	"Crop residue/grass/straw/shrubs".
dichotomize EU4 (08) (98 thru hi) eu4@08	"Animal dung/waste".
dichotomize EU4 (09) (98 thru hi) eu4@09	"Processed biomass (pellets) or woodchips".
dichotomize EU4 (10) (98 thru hi) eu4@10	"Garbage/plastic".
dichotomize EU4 (11) (98 thru hi) eu4@11	"Sawdust".

*	Type of household fuel.
dichotomize EU5 (1) (98 thru hi) eu5@1	"In main house - no separate room".
dichotomize EU5 (2) (98 thru hi) eu5@2	"In main house - in a separate room".
dichotomize EU5 (3) (98 thru hi) eu5@3	"In a separate building".
dichotomize EU5 (4) (98 thru hi) eu5@4	"Outdoors - open air".
dichotomize EU5 (5) (98 thru hi) eu5@5	"Outdoors - on veranda or covered porch".

*	Type of space heating.
dichotomize EU6 (01) (98 thru hi) eu6@01	"Central heating".
dichotomize EU6 (06) (98 thru hi) eu6@06	"Three stone stove / open fire".
dichotomize EU6 (97) (98 thru hi) eu6@97	"No space heating in the household".

dichotomize EU6 (02) (98 thru hi) eu6@02	"Manufactured space heater".
dichotomize EU6 (03) (98 thru hi) eu6@03	"Traditional space heater".
dichotomize EU6 (04) (98 thru hi) eu6@04	"Manufactured cookstove".
dichotomize EU6 (05) (98 thru hi) eu6@05	"Traditional cookstove".

compute eu6@0201=0.
compute eu6@0202=0.
compute eu6@0208=0.
compute eu6@0301=0.
compute eu6@0302=0.
compute eu6@0308=0.
compute eu6@0401=0.
compute eu6@0402=0.
compute eu6@0408=0.
compute eu6@0501=0.
compute eu6@0502=0.
compute eu6@0508=0.
if (EU6=2 and EU7=1) eu6@0201=1.
if (EU6=2 and EU7=2) eu6@0202=1.
if (EU6=2 and EU7=8) eu6@0208=1.
if (EU6=3 and EU7=1) eu6@0301=1.
if (EU6=3 and EU7=2) eu6@0302=1.
if (EU6=3 and EU7=8) eu6@0308=1.
if (EU6=4 and EU7=1) eu6@0401=1.
if (EU6=4 and EU7=2) eu6@0402=1.
if (EU6=4 and EU7=8) eu6@0408=1.
if (EU6=5 and EU7=1) eu6@0501=1.
if (EU6=5 and EU7=2) eu6@0502=1.
if (EU6=5 and EU7=8) eu6@0508=1.
variable labels eu6@0201 "Manufactured space heater - has chimney".
variable labels eu6@0202 "Manufactured space heater - NO chimney".
variable labels eu6@0208 "Manufactured space heater - DK chimney".
variable labels eu6@0301 "Traditional space heater - has chimney".
variable labels eu6@0302 "Traditional space heater - NO chimney".
variable labels eu6@0308 "Traditional space heater - DK chimney".
variable labels eu6@0401 "Manufactured cookstove - has chimney".
variable labels eu6@0402 "Manufactured cookstove - NO chimney".
variable labels eu6@0408 "Manufactured cookstove - DK chimney".
variable labels eu6@0501 "Traditional cookstove - has chimney".
variable labels eu6@0502 "Traditional cookstove - NO chimney".
variable labels eu6@0508 "Traditional cookstove - DK chimney".

*	Type of household fuel.
dichotomize EU8 (01) (98 thru hi) eu8@01	"Solar air heater".
dichotomize EU8 (02) (98 thru hi) eu8@02	"Electricity".
dichotomize EU8 (03) (98 thru hi) eu8@03	"Piped natural gas".
dichotomize EU8 (04) (98 thru hi) eu8@04	"Liquefied petroleum gas (lpg)/cooking gas".
dichotomize EU8 (05) (98 thru hi) eu8@05	"Biogas".
dichotomize EU8 (06) (98 thru hi) eu8@06	"Alcohol/ethanol".
dichotomize EU8 (07) (98 thru hi) eu8@07	"Gasoline / diesel".
dichotomize EU8 (08) (98 thru hi) eu8@08	"Kerosene / paraffin".
dichotomize EU8 (09) (98 thru hi) eu8@09	"Coal / lignite".
dichotomize EU8 (10) (98 thru hi) eu8@10	"Charcoal".
dichotomize EU8 (11) (98 thru hi) eu8@11	"Wood".
dichotomize EU8 (12) (98 thru hi) eu8@12	"Crop residue / grass /straw / shrubs".
dichotomize EU8 (13) (98 thru hi) eu8@13	"Animal dung / waste".
dichotomize EU8 (14) (98 thru hi) eu8@14	"Processed biomass (pellets) or woodchips".
dichotomize EU8 (15) (98 thru hi) eu8@15	"Garbage / plastic".
dichotomize EU8 (16) (98 thru hi) eu8@16	"Sawdust".

*	Source of light.
dichotomize EU9 (01) (98 thru hi) eu9@01	"Electricity".
dichotomize EU9 (02) (98 thru hi) eu9@02	"Solar lantern".
dichotomize EU9 (03) (98 thru hi) eu9@03	"Rechargeable flashlight, torch or lantern".
dichotomize EU9 (04) (98 thru hi) eu9@04	"Battery powered flashlight, torch or lantern".
dichotomize EU9 (05) (98 thru hi) eu9@05	"Biogas lamp".
dichotomize EU9 (06) (98 thru hi) eu9@06	"Gasoline lamp".
dichotomize EU9 (07) (98 thru hi) eu9@07	"Kerosene or paraffin lamp".
dichotomize EU9 (08) (98 thru hi) eu9@08	"Charcoal".
dichotomize EU9 (09) (98 thru hi) eu9@09	"Wood".
dichotomize EU9 (10) (98 thru hi) eu9@10	"Crop residue/grass/straw/shrubs".
dichotomize EU9 (11) (98 thru hi) eu9@11	"Animal dung/waste".
dichotomize EU9 (12) (98 thru hi) eu9@12	"Oil lamp".
dichotomize EU9 (13) (98 thru hi) eu9@13	"Candle".
dichotomize EU9 (97) (98 thru hi) eu9@97	"No lighting".

* 	Source of drinking water.
dichotomize WS1 (11) (98 thru hi) ws1@11 	"Water piped into dwelling".
dichotomize WS1 (12) (98 thru hi) ws1@12 	"Water piped into yard/plot".
dichotomize WS1 (13) (98 thru hi) ws1@13 	"Water piped to neighbor".
dichotomize WS1 (14) (98 thru hi) ws1@14 	"Public tap/standpipe for water".
dichotomize WS1 (21) (98 thru hi) ws1@21 	"Tubewell/borehole for water".
dichotomize WS1 (31) (98 thru hi) ws1@31 	"Protected well for water".
dichotomize WS1 (32) (98 thru hi) ws1@32	"Unprotected well for water".
dichotomize WS1 (41) (98 thru hi) ws1@41	"Protected spring for water".
dichotomize WS1 (42) (98 thru hi) ws1@42	"Unprotected spring for water".
dichotomize WS1 (51) (98 thru hi) ws1@51	"Rainwater for water".
dichotomize WS1 (61) (98 thru hi) ws1@61	"Tanker truck for water".
dichotomize WS1 (71) (98 thru hi) ws1@71	"Cart with small tank for water".
dichotomize WS1 (72) (98 thru hi) ws1@72	"Water kiosk".
dichotomize WS1 (81) (98 thru hi) ws1@81	"Surface water".
dichotomize WS1 (91) (98 thru hi) ws1@91	"Bottled water".
dichotomize WS1 (92) (98 thru hi) ws1@92	"Sachet water".


* 	Location of water source.
recode WS3 (sysmis=1) (1,2,3=copy) (else=9) into watloc.
if (watloc=3 and WS4 ge 30 and ws4 le 995) watloc=4.
if (WS4=0) watloc=5.

dichotomize watloc (1) (9) watloc@1	"Water in own dwelling".
dichotomize watloc (2) (9) watloc@2	"Water in own yard or plot".
dichotomize watloc (3) (9) watloc@3	"Water less than 30 minutes away".
dichotomize watloc (4) (9) watloc@4	"Water more than 30 minutes away".
dichotomize watloc (5) (9) watloc@5	"Water not collected by household member".

*	Sufficient water.
dichotomize WS7 (1) (9 thru hi) ws7@1	"Water was not sufficient last month - At least once".
dichotomize WS7 (2) (9 thru hi) ws7@2	"Water was not sufficient last month - Always sufficient".

*	Type of sanitation facility.
dichotomize WS11 (11) (98 thru hi) ws11@11	"Flush to piped sewer system toilet".
dichotomize WS11 (12) (98 thru hi) ws11@12	"Flush to septic system toilet".
dichotomize WS11 (13) (98 thru hi) ws11@13	"Flush to pit latrine toilet".
dichotomize WS11 (14) (98 thru hi) ws11@14	"Flush to open drain toilet".
dichotomize WS11 (18) (98 thru hi) ws11@18	"Flush to unknown place toilet".
dichotomize WS11 (21) (98 thru hi) ws11@21	"Ventilated improved pit latrine toilet".
dichotomize WS11 (22) (98 thru hi) ws11@22	"Pit latrine with slab toilet".
dichotomize WS11 (23) (98 thru hi) ws11@23	"Pit latrine without slab/open pit toilet".
dichotomize WS11 (31) (98 thru hi) ws11@31	"Composting toilet".
dichotomize WS11 (41) (98 thru hi) ws11@41	"Bucket toilet".
dichotomize WS11 (51) (98 thru hi) ws11@51	"Hanging toilet/hanging latrine".
dichotomize WS11 (95) (98 thru hi) ws11@95	"No facility/bush/field".


* 	Location of sanitation facility.
dichotomize WS14 (1) (98 thru hi) ws14@1 	"Toilet facility in the dwelling".
dichotomize WS14 (2) (98 thru hi) ws14@2 	"Toilet facility in the yard/plot".
dichotomize WS14 (3) (98 thru hi) ws14@3 	"Toilet facility elsewhere".


* Sharing sanitation facilities.
dichotomize WS15 (1) (9) latshare		"Shares toilet with other households or uses public toilets".
dichotomize WS17 (2 thru 9) (98, 99) lathh1	"Shares toilet with less than 10 households".
dichotomize WS17 (10) (98, 99) lathh2	"Shares toilet with 10+ households or uses public toilets".
if (WS16 = 2) lathh2 = 1.



*	Separate out shared toilets and non-shared (private) toilets.
 * sharedfac WS11@11 ws11@11s	"Flush to piped sewer system toilet - shared".
 * sharedfac WS11@12 ws11@12s	"Flush to septic system toilet - shared".
 * sharedfac WS11@13 ws11@13s	"Flush to pit latrine toilet - shared".	
 * sharedfac WS11@14 ws11@14s	"Flush to open drain toilet - shared".
 * sharedfac WS11@18 ws11@18s	"Flush to unknown place toilet - shared".	
 * sharedfac WS11@21 ws11@21s	"Ventilated improved pit latrine toilet - shared".
 * sharedfac WS11@22 ws11@22s	"Pit latrine with slab toilet - shared".
 * sharedfac WS11@23 ws11@23s	"Pit latrine without slab/open pit toilet - shared".
 * sharedfac WS11@31 ws11@31s	"Composting toilet - shared".
 * sharedfac WS11@41 ws11@41s	"Bucket toilet - shared".
 * sharedfac WS11@51 ws11@51s	"Hanging toilet - shared".


 * HW1 HW2 HW3 HW4. 

* 	Availability of water at place for handwashing.
dichotomize HW2 (1) (9) hw2@1		"Water present at handwashing place in the dwelling".
* To account for those cases where place for handwashing is not in the dwelling.
if (HW1=4) hw2@1=0.

* 	Availability of soap.
compute soap = 9.
if (HW3 = 1 or HW5= 1) soap = 1.
if (HW3 = 2 and HW5 = 2) soap = 0.
dichotomize soap (1) (9) soap@1 		"Has soap in household".



* Summary statistics.
varmeans 	((persroom)).
varmeans 	((hc4@11 + hc4@12 + hc4@21 + hc4@22 + hc4@31 + hc4@32 + hc4@33 + hc4@34 + hc4@35)).
varmeans 	((hc5@11 + hc5@12 + hc5@13 +hc5@21+ hc5@22 + hc5@23 + hc5@24 + hc5@31 + hc5@32 + 
		hc5@33 + hc5@34 + hc5@35 + hc5@36)).
varmeans 	((hc6@11 + hc6@12 + hc6@13 + hc6@21 + hc6@22 +  hc6@23+ hc6@24 + hc6@25 + hc6@26 + 
		hc6@31 + hc6@32 + hc6@33 + hc6@34 + hc6@35 + hc6@36)).
varmeans 	((hc7a@1 + hc7b@1 + hc7c@1)).
varmeans 	((hc8@1 + hc8@2 + hc8@3)).
varmeans 	((hc9a@1 + hc9b@1 + hc9c@1)).
varmeans 	((hc10a@1 + hc10b@1 + hc10c@1 + hc10d@1 + hc10e@1 + hc10f@1 + hc10g@1)).
varmeans 	((hc11@1 + hc12@1 + hc13@1)).
varmeans 	((hc16r)).
varmeans 	((cow0 + cow1 + cow5 + cow10)).
varmeans 	((othercattle0 + othercattle1 + othercattle5 + othercattle10)).
varmeans 	((horse0+  horse1 + horse5+  horse10)).
varmeans 	((goat0 + goat1 + goat10 + goat30)). 
varmeans 	((sheep0 + sheep1 + sheep10 + sheep30)). 
varmeans 	((chicken0 + chicken1 + chicken10 + chicken30)). 
varmeans 	((pig0 + pig1 + pig5 + pig10)). 
varmeans 	((otheranimal0 + otheranimal1 + otheranimal10 + otheranimal30)).
varmeans 	((hc19@1)).
varmeans 	((eu1@01 + eu1@02 + eu1@03 + eu1@04 + eu1@05 + eu1@06 + eu1@07 + eu1@08 + eu1@09 + eu1@97)).
varmeans 	((eu1@070101 + eu1@070102 + eu1@070108 + eu1@070201 + eu1@070202 + eu1@070208 + eu1@070801 + eu1@070802 + eu1@070808)).
varmeans 	((eu1@080101 + eu1@080102 + eu1@080108 + eu1@080201 + eu1@080202 + eu1@080208 + eu1@080801 + eu1@080802 + eu1@080808)).
varmeans 	((eu4@01 + eu4@02 + eu4@03 + eu4@04 + eu4@05 + eu4@06 + eu4@07 + eu4@08 + eu4@09 + 
		eu4@10 + eu4@11)).
varmeans 	((eu5@1 + eu5@2 + eu5@3 + eu5@4 + eu5@5)).
varmeans 	((eu6@01 + eu6@02 + eu6@03 + eu6@04 + eu6@05 + eu6@06 + eu6@97)).
varmeans 	((eu6@0201+ eu6@0202 + eu6@0208 + eu6@0301+ eu6@0302 + eu6@0308 +eu6@0401+ eu6@0402 + eu6@0408 + 
                                    eu6@0501+ eu6@0502 + eu6@0508)).
varmeans 	(( eu8@01 + eu8@02 + eu8@03 + eu8@04 + eu8@05 + eu8@06 + eu8@07 + eu8@08 + eu8@09 + 
		eu8@10 + eu8@11 + eu8@12 + eu8@13 + eu8@14 + eu8@15 + eu8@16)).
varmeans 	((eu9@01 + eu9@02 + eu9@03 + eu9@04 + eu9@05 + eu9@06 + eu9@07 + eu9@08 + eu9@09 + 
		eu9@10 + eu9@11 + eu9@12 + eu9@13 + eu9@97)).
varmeans 	((ws1@11 + ws1@12 + ws1@13 + ws1@14 + ws1@21 + ws1@31 + ws1@32 + 
		ws1@41 + ws1@42 + ws1@51 + ws1@61 + ws1@71 + ws1@72 + ws1@81 + ws1@91 + ws1@92)).
varmeans 	((watloc@1 + watloc@2 + watloc@3 + watloc@4 + watloc@5)).
varmeans 	((ws7@1 + ws7@2)).	
varmeans 	((ws11@11 + ws11@12 + ws11@13 + ws11@14 + ws11@18 + ws11@21 + ws11@22 + ws11@23 + 
		ws11@31 + ws11@41 + ws11@51 + ws11@95)).
varmeans 	((ws14@1 + ws14@2 + ws14@3)).	
varmeans 	((latshare + lathh1 + lathh2)).		
varmeans 	((hw2@1 + soap@1)).
varmeans 	((servant)).


* 	Create the SPSS output.
output save outfile = "w2.spv".

*	Close the output.
output close *.
