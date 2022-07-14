get file = 'hh.sav'.

select if (hh9 = 1).

* check frequency distribution of variables, look for missing values.

frequencies
  variables=hc2 hc3 hc4 hc5 hc6
		hc9a hc9b hc9c hc9d hc9e hc9f
		hc10a hc10b hc10c hc10d hc10e hc10f
		hc11 hc12 hc13 hc14a hc14b hc14c hc14d hc14e hc14f
                        ws1 ws2 ws7
  /statistics=stddev mean
  /order=analysis .

* begin recoding, dichotomous variables or continuous variables.

* persons per sleeping room.

compute persroom = 99.
if (hc2 < 98) persroom = hh11/hc2.
variable label persroom 'Persons per sleeping rooms'.
missing values persroom (99).

* type of floor.

compute flres = 0.
if (hc3 = 11) flres = 1.
if (hc3 >= 98) flres = 9.
variable label flres 'Has earth/sand floor'.
value label flres 0 'Not earth/sand floor' 1 'Has earth/sand floor' 9 'Missing'.
missing values flres (9).

compute flrdng = 0.
if (hc3 = 12) flrdng = 1.
if (hc3 >= 98) flrdng = 9.
variable label flrdng 'Has dung floor'.
value label flrdng 0 'Not dung floor' 1 'Has dung floor' 9 'Missing'.
missing values flrdng (9).

compute flrwd = 0.
if (hc3 = 21) flrwd = 1.
if (hc3 >= 98) flrwd = 9.
variable label flrwd 'Has wood floor'.
value label flrwd 0 'Not wood floor' 1 'Has wood floor' 9 'Missing'.
missing values flrwd (9).

compute flrbam = 0.
if (hc3 = 22) flrbam = 1.
if (hc3 >= 98) flrbam = 9.
variable label flrbam 'Has palm/bamboo floor'.
value label flrbam 0 'Not palm/bamboo floor' 1 'Has palm/bamboo floor' 9 'Missing'.
missing values flrbam (9).

compute flrpq = 0.
if (hc3 = 31) flrpq = 1.
if (hc3 >= 98) flrpq = 9.
variable label flrpq 'Has parquet/polished wood floor'.
value label flrpq 0 'Not parquet/polished wood floor' 1 'Has parquet/polished wood floor' 9 'Missing'.
missing values flrpq (9).

compute flrvl = 0.
if (hc3 = 32) flrvl = 1.
if (hc3 >= 98) flrvl = 9.
variable label flrvl 'Has vinyl/asphalt strip floor'.
value label flrvl 0 'Not vinyl/asphalt strip floor' 1 'Has vinyl/asphalt strip floor' 9 'Missing'.
missing values flrvl (9).

compute flrcer = 0.
if (hc3 = 33) flrcer = 1.
if (hc3 >= 98) flrcer = 9.
variable label flrcer 'Has ceramic tile floor'.
value label flrcer 0 'Not ceramic tile floor' 1 'Has ceramic tile floor' 9 'Missing'.
missing values flrcer (9).

compute flrcem = 0.
if (hc3 = 34) flrcem = 1.
if (hc3 >= 98) flrcem = 9.
variable label flrcem 'Has cement floor'.
value label flrcem 0 'Not cement floor' 1 'Has cement floor' 9 'Missing'.
missing values flrcem (9).

compute flrcpt = 0.
if (hc3 = 35) flrcpt = 1.
if (hc3 >= 98) flrcpt = 9.
variable label flrcpt 'Has carpet floor'.
value label flrcpt 0 'Not carpet floor' 1 'Has carpet floor' 9 'Missing'.
missing values flrcpt (9).

* type of roof.

compute roofno = 0.
if (hc4 = 11) roofno = 1.
if (hc4 >= 98) roofno = 9.
variable label roofno 'Has no roof'.
value label roofno 0 'Has roof' 1 'Has no roof' 9 'Missing'.
missing values roofno (9).

compute rooflf = 0.
if (hc4 = 12) rooflf = 1.
if (hc4 >= 98) rooflf = 9.
variable label rooflf 'Has thatch/palm leaf roof'.
value label rooflf 0 'Not thatch/palm leaf roof' 1 'Has thatch/palm leaf roof' 9 'Missing'.
missing values rooflf (9).

compute roofsod = 0.
if (hc4 = 13) roofsod = 1.
if (hc4 >= 98) roofsod = 9.
variable label roofsod 'Has sod roof'.
value label roofsod 0 'Not sod roof' 1 'Has sod roof' 9 'Missing'.
missing values roofsod (9).

compute roofmat = 0.
if (hc4 = 21) roofmat = 1.
if (hc4 >= 98) roofmat = 9.
variable label roofmat 'Has rustic mat roof'.
value label roofmat 0 'Not rustic mat roof' 1 'Has rustic mat roof' 9 'Missing'.
missing values roofmat (9).

compute roofbam = 0.
if (hc4 = 22) roofbam = 1.
if (hc4 >= 98) roofbam = 9.
variable label roofbam 'Has palm/bamboo roof'.
value label roofbam 0 'Not palm/bamboo roof' 1 'Has palm/bamboo roof' 9 'Missing'.
missing values roofbam (9).

compute roofplnk = 0.
if (hc4 = 23) roofplnk = 1.
if (hc4 >= 98) roofplnk = 9.
variable label roofplnk 'Has wood plank roof'.
value label roofplnk 0 'Not wood plank roof' 1 'Has wood plank roof' 9 'Missing'.
missing values roofplnk (9).

compute roofmetl = 0.
if (hc4 = 31) roofmetl = 1.
if (hc4 >= 98) roofmetl = 9.
variable label roofmetl 'Has metal roof'.
value label roofmetl 0 'Not metal roof' 1 'Has metal roof' 9 'Missing'.
missing values roofmetl (9).

compute roofwood = 0.
if (hc4 = 32) roofwood = 1.
if (hc4 >= 98) roofwood = 9.
variable label roofwood 'Has wood roof'.
value label roofwood 0 'Not wood roof' 1 'Has wood roof' 9 'Missing'.
missing values roofwood (9).

compute rooffibr = 0.
if (hc4 = 33) rooffibr = 1.
if (hc4 >= 98) rooffibr = 9.
variable label rooffibr 'Has calamine/cement fibre roof'.
value label rooffibr 0 'Not calamine/cement fibre roof' 1 'Has calamine/cement fibre roof' 9 'Missing'.
missing values rooffibr (9).

compute roofcer = 0.
if (hc4 = 34) roofcer = 1.
if (hc4 >= 98) roofcer = 9.
variable label roofcer 'Has ceramic tile roof'.
value label roofcer 0 'Not ceramic tile roof' 1 'Has ceramic tile roof' 9 'Missing'.
missing values roofcer (9).

compute roofcem = 0.
if (hc4 = 35) roofcem = 1.
if (hc4 >= 98) roofcem = 9.
variable label roofcem 'Has cement roof'.
value label roofcem 0 'Not cement roof' 1 'Has cement roof' 9 'Missing'.
missing values roofcem (9).

compute roofshng = 0.
if (hc4 = 36) roofshng = 1.
if (hc4 >= 98) roofshng = 9.
variable label roofshng 'Has shingle roof'.
value label roofshng 0 'Not shingle roof' 1 'Has shingle roof' 9 'Missing'.
missing values roofshng (9).

* type of wall.

compute wallno = 0.
if (hc5 = 11) wallno = 1.
if (hc5 >= 98) wallno = 9.
variable label wallno 'Has no wall'.
value label wallno 0 'Has wall' 1 'Has no wall' 9 'Missing'.
missing values wallno (9).

compute wallcane = 0.
if (hc5 = 12) wallcane = 1.
if (hc5 >= 98) wallcane = 9.
variable label wallcane 'Has cane/palm/trunk wall'.
value label wallcane 0 'Not cane/palm/trunk wall' 1 'Has cane/palm/trunk wall' 9 'Missing'.
missing values wallcane (9).

compute walldirt = 0.
if (hc5 = 13) walldirt = 1.
if (hc5 >= 98) walldirt = 9.
variable label walldirt 'Has dirt wall'.
value label walldirt 0 'Not dirt wall' 1 'Has dirt wall' 9 'Missing'.
missing values walldirt (9).

compute wallbam = 0.
if (hc5 = 21) wallbam = 1.
if (hc5 >= 98) wallbam = 9.
variable label wallbam 'Has bamboo with mud wall'.
value label wallbam 0 'Not bamboo with mud wall' 1 'Has bamboo with mud wall' 9 'Missing'.
missing values wallbam (9).

compute wallmud = 0.
if (hc5 = 22) wallmud = 1.
if (hc5 >= 98) wallmud = 9.
variable label wallmud 'Has stone with mud wall'.
value label wallmud 0 'Not stone with mud wall' 1 'Has stone with mud wall' 9 'Missing'.
missing values wallmud (9).

compute wallunad = 0.
if (hc5 = 23) wallunad = 1.
if (hc5 >= 98) wallunad = 9.
variable label wallunad 'Has uncovered adobe wall'.
value label wallunad 0 'Not uncovered adobe wall' 1 'Has uncovered adobe wall' 9 'Missing'.
missing values wallunad (9).

compute wallply = 0.
if (hc5 = 24) wallply = 1.
if (hc5 >= 98) wallply = 9.
variable label wallply 'Has plywood wall'.
value label wallply 0 'Not plywood wall' 1 'Has plywood wall' 9 'Missing'.
missing values wallply (9).

compute wallctn = 0.
if (hc5 = 25) wallctn = 1.
if (hc5 >= 98) wallctn = 9.
variable label wallctn 'Has carton wall'.
value label wallctn 0 'Not carton wall' 1 'Has carton wall' 9 'Missing'.
missing values wallctn (9).

compute wallre = 0.
if (hc5 = 26) wallre = 1.
if (hc5 >= 98) wallre = 9.
variable label wallre 'Has reused wood wall'.
value label wallre 0 'Not reused wood wall' 1 'Has reused wood wall' 9 'Missing'.
missing values wallre (9).

compute wallcem = 0.
if (hc5 = 31) wallcem = 1.
if (hc5 >= 98) wallcem = 9.
variable label wallcem 'Has cement wall'.
value label wallcem 0 'Not cement wall' 1 'Has cement wall' 9 'Missing'.
missing values wallcem (9).

compute wallstn = 0.
if (hc5 = 32) wallstn = 1.
if (hc5 >= 98) wallstn = 9.
variable label wallstn 'Has stone with lime/cement wall'.
value label wallstn 0 'Not stone with lime/cement wall' 1 'Has stone with lime/cement wall' 9 'Missing'.
missing values wallstn (9).

compute wallbrk = 0.
if (hc5 = 33) wallbrk = 1.
if (hc5 >= 98) wallbrk = 9.
variable label wallbrk 'Has brick wall'.
value label wallbrk 0 'Not brick wall' 1 'Has brick wall' 9 'Missing'.
missing values wallbrk (9).

compute wallblk = 0.
if (hc5 = 34) wallblk = 1.
if (hc5 >= 98) wallblk = 9.
variable label wallblk 'Has cement block wall'.
value label wallblk 0 'Not cement block wall' 1 'Has cement block wall' 9 'Missing'.
missing values wallblk (9).

compute walladob = 0.
if (hc5 = 35) walladob = 1.
if (hc5 >= 98) walladob = 9.
variable label walladob 'Has covered adobe wall'.
value label walladob 0 'Not covered adobe wall' 1 'Has covered adobe wall' 9 'Missing'.
missing values walladob (9).

compute wallplnk = 0.
if (hc5 = 36) wallplnk = 1.
if (hc5 >= 98) wallplnk = 9.
variable label wallplnk 'Has wood plank/shingle wall'.
value label wallplnk 0 'Not wood plank/shingle wall' 1 'Has wood plank/shingle wall' 9 'Missing'.
missing values wallplnk (9).

* type of cooking fuel.

compute fuelelec = 0.
if (hc6 = 01) fuelelec = 1.
if (hc6 >= 98) fuelelec = 9.
variable label fuelelec 'Household fuel type: electricity'.
value label fuelelec 0 'No' 1 'Yes' 9 'Missing'.
missing values fuelelec (9).

compute fuellpg = 0.
if (hc6 = 02) fuellpg = 1.
if (hc6 >= 98) fuellpg = 9.
variable label fuellpg 'Household fuel type: LPG'.
value label fuellpg 0 'No' 1 'Yes' 9 'Missing'.
missing values fuellpg (9).

compute fuelgas = 0.
if (hc6 = 03) fuelgas = 1.
if (hc6 >= 98) fuelgas = 9.
variable label fuelgas 'Household fuel type: natural gas'.
value label fuelgas 0 'No' 1 'Yes' 9 'Missing'.
missing values fuelgas (9).

compute fuelbio = 0.
if (hc6 = 04) fuelbio = 1.
if (hc6 >= 98) fuelbio = 9.
variable label fuelbio 'Household fuel type: biogas'.
value label fuelbio 0 'No' 1 'Yes' 9 'Missing'.
missing values fuelbio (9).

compute fuelker = 0.
if (hc6 = 05) fuelker = 1.
if (hc6 >= 98) fuelker = 9.
variable label fuelker 'Household fuel type: kerosene'.
value label fuelker 0 'No' 1 'Yes' 9 'Missing'.
missing values fuelker (9).

compute fuelcoal = 0.
if (hc6 = 06) fuelcoal = 1.
if (hc6 >= 98) fuelcoal = 9.
variable label fuelcoal 'Household fuel type: coal/lignite'.
value label fuelcoal 0 'No' 1 'Yes' 9 'Missing'.
missing values fuelcoal (9).

compute fuelchar = 0.
if (hc6 = 07) fuelchar = 1.
if (hc6 >= 98) fuelchar = 9.
variable label fuelchar 'Household fuel type: charcoal'.
value label fuelchar 0 'No' 1 'Yes' 9 'Missing'.
missing values fuelchar (9).

compute fuelwood = 0.
if (hc6 = 08) fuelwood = 1.
if (hc6 >= 98) fuelwood = 9.
variable label fuelwood 'Household fuel type: wood'.
value label fuelwood 0 'No' 1 'Yes' 9 'Missing'.
missing values fuelwood (9).

compute fuelstrw = 0.
if (hc6 = 09) fuelstrw = 1.
if (hc6 >= 98) fuelstrw = 9.
variable label fuelstrw 'Household fuel type: straw/shrub/grass'.
value label fuelstrw 0 'No' 1 'Yes' 9 'Missing'.
missing values fuelstrw (9).

compute fueldung = 0.
if (hc6 = 10) fueldung = 1.
if (hc6 >= 98) fueldung = 9.
variable label fueldung 'Household fuel type: animal dung'.
value label fueldung 0 'No' 1 'Yes' 9 'Missing'.
missing values fueldung (9).

compute fuelagre = 0.
if (hc6 = 11) fuelagre = 1.
if (hc6 >= 98) fuelagre = 9.
variable label fuelagre 'Household fuel type: agrciultural crop residue'.
value label fuelagre 0 'No' 1 'Yes' 9 'Missing'.
missing values fuelagre (9).

* other household assets.

compute elec = 0.
if (hc9a = 1) elec = 1.
if (hc9a = 9) elec = 9.
variable label elec 'Household has: electricity'.
value label elec 0 'No' 1 'Yes' 9 'Missing'.
missing values elec (9).

compute radio = 0.
if (hc9b = 1) radio = 1.
if (hc9b = 9) radio = 9.
variable label radio 'Household has: radio'.
value label radio 0 'No' 1 'Yes' 9 'Missing'.
missing values radio (9).

compute tv = 0.
if (hc9c = 1) tv = 1.
if (hc9c = 9) tv = 9.
variable label tv 'Household has: television'.
value label tv 0 'No' 1 'Yes' 9 'Missing'.
missing values tv (9).

compute mobile = 0.
if (hc9d = 1) mobile = 1.
if (hc9d = 9) mobile = 9.
variable label mobile 'Household has: mobile telephone'.
value label mobile 0 'No' 1 'Yes' 9 'Missing'.
missing values mobile (9).

compute phone = 0.
if (hc9e = 1) phone = 1.
if (hc9e = 9) phone = 9.
variable label phone 'Household has: non-mobile phone'.
value label phone 0 'No' 1 'Yes' 9 'Missing'.
missing values phone (9).

compute fridge = 0.
if (hc9f = 1) fridge = 1.
if (hc9f = 9) fridge = 9.
variable label fridge 'Household has: refrigerator'.
value label fridge 0 'No' 1 'Yes' 9 'Missing'.
missing values fridge (9).

* Other household assets 2.

compute watch = 0.
if (hc10a = 1) watch = 1.
if (hc10a = 9) watch = 9.
variable label watch 'Household member owns: watch'.
value label watch 0 'No' 1 'Yes' 9 'Missing'.
missing values watch (9).

compute bike = 0.
if (hc10b = 1) bike = 1.
if (hc10b = 9) bike = 9.
variable label bike 'Household member owns: bicycle'.
value label bike 0 'No' 1 'Yes' 9 'Missing'.
missing values bike (9).

compute moto = 0.
if (hc10c = 1) moto = 1.
if (hc10c = 9) moto = 9.
variable label moto 'Household member owns: motorcycle/scooter'.
value label moto 0 'No' 1 'Yes' 9 'Missing'.
missing values moto (9).

compute cart = 0.
if (hc10d = 1) cart = 1.
if (hc10d = 9) cart = 9.
variable label cart 'Household member owns: animal drawn cart'.
value label cart 0 'No' 1 'Yes' 9 'Missing'.
missing values cart (9).

compute car = 0.
if (hc10e = 1) car = 1.
if (hc10e = 9) car = 9.
variable label car 'Household member owns: car/truck'.
value label car 0 'No' 1 'Yes' 9 'Missing'.
missing values car (9).

compute boat = 0.
if (hc10f = 1) boat = 1.
if (hc10f = 9) boat = 9.
variable label boat 'Household member owns: boat with motor'.
value label boat 0 'No' 1 'Yes' 9 'Missing'.
missing values boat (9).


* Variables on agriculture and animal ownership have been taken out of factor analysis (see below) but recoding has been kept in 2006-11-06.


compute agland = 0.
if (hc11 = 1) agland = hc12.
if (hc12 >= 98) agland = 99.
variable label agland 'Household owns: agricultural land'.
value label agland 99 'Missing'.
missing values agland (99).

recode hc14a (0 thru 97 = copy) (98 thru 99 = sysmis) (else = 0) into cattle.
variable label cattle 'Household owns: cattle'.
value label cattle 99 'Missing'.
missing values cattle (99).

recode hc14b (0 thru 97 = copy) (98 thru 99 = sysmis) (else = 0) into bull.
variable label bull 'Household owns: milk cows or bull'.
value label bull 99 'Missing'.
missing values bull (99).

recode hc14c (0 thru 97 = copy) (98 thru 99 = sysmis) (else = 0) into horse.
variable label horse 'Household owns: horses, donkeys or mules'.
value label horse 99 'Missing'.
missing values horse (99).

recode hc14d (0 thru 97 = copy) (98 thru 99 = sysmis) (else = 0) into goat.
variable label goat 'Household owns: goat'.
value label goat 99 'Missing'.
missing values goat (99).

recode hc14e (0 thru 97 = copy) (98 thru 99 = sysmis) (else = 0) into sheep.
variable label sheep 'Household owns: sheep'.
value label sheep 99 'Missing'.
missing values sheep (99).

recode hc14f (0 thru 97 = copy) (98 thru 99 = sysmis) (else = 0) into chicken.
variable label chicken 'Household owns: chicken'.
value label chicken 99 'Missing'.
missing values chicken (99).

* source of drinking water.

compute watpdw = 0.
if (ws1 = 11) watpdw = 1.
if (ws1 >= 98) watpdw = 9.
variable label watpdw 'Has water piped into dwelling'.
value label watpdw 0 'Not water piped into dwelling' 1 'Has water piped into dwelling' 9 'Missing'.
missing values watpdw (9).

compute watpyd = 0.
if (ws1 = 12) watpyd = 1.
if (ws1 >= 98) watpyd = 9.
variable label watpyd 'Has water piped into yard/plot'.
value label watpyd 0 'Not water piped into yard/plot' 1 'Has water piped into yard/plot' 9 'Missing'.
missing values watpyd (9).

compute watptap = 0.
if (ws1 = 13) watptap = 1.
if (ws1 >= 98) watptap = 9.
variable label watptap 'Has public tap/standpipe for water'.
value label watptap 0 'Not public tap/standpipe for water' 1 'Has public tap/standpipe for water' 9 'Missing'.
missing values watptap (9).

compute watbore = 0.
if (ws1 = 21) watbore = 1.
if (ws1 >= 98) watbore = 9.
variable label watbore 'Has tubewell/borehole for water'.
value label watbore 0 'Not tubewell/borehole for water' 1 'Has tubewell/borehole for water' 9 'Missing'.
missing values watbore (9).

compute watpwell = 0.
if (ws1 = 31) watpwell = 1.
if (ws1 >= 98) watpwell = 9.
variable label watpwell 'Has protected well for water'.
value label watpwell 0 'Not protected well for water' 1 'Has protected well for water' 9 'Missing'.
missing values watpwell (9).

compute watuwell = 0.
if (ws1 = 32) watuwell = 1.
if (ws1 >= 98) watuwell = 9.
variable label watuwell 'Has unprotected well for water'.
value label watuwell 0 'Not unprotected well for water' 1 'Has unprotected well for water' 9 'Missing'.
missing values watuwell (9).

compute watpsprg = 0.
if (ws1 = 41) watpsprg = 1.
if (ws1 >= 98) watpsprg = 9.
variable label watpsprg 'Has protected spring for water'.
value label watpsprg 0 'Not protected spring for water' 1 'Has protected spring for water' 9 'Missing'.
missing values watpsprg (9).

compute watusprg = 0.
if (ws1 = 42) watusprg = 1.
if (ws1 >= 98) watusprg = 9.
variable label watusprg 'Has unprotected spring for water'.
value label watusprg 0 'Not unprotected spring for water' 1 'Has unprotected spring for water' 9 'Missing'.
missing values watusprg (9).

compute watrain = 0.
if (ws1 = 51) watrain = 1.
if (ws1 >= 98) watrain = 9.
variable label watrain 'Has rainwater for water'.
value label watrain 0 'Not rainwater for water' 1 'Has rainwater for water' 9 'Missing'.
missing values watrain (9).

compute wattank = 0.
if (ws1 = 61) wattank = 1.
if (ws1 >= 98) wattank = 9.
variable label wattank 'Has tanker truck for water'.
value label wattank 0 'Not tanker truck for water' 1 'Has tanker truck for water' 9 'Missing'.
missing values wattank (9).

compute watcart = 0.
if (ws1 = 71) watcart = 1.
if (ws1 >= 98) watcart = 9.
variable label watcart 'Has cart with small tank for water'.
value label watcart 0 'Not cart with small tank for water' 1 'Has cart with small tank for water' 9 'Missing'.
missing values watcart (9).

compute watsurf = 0.
if (ws1 = 81) watsurf = 1.
if (ws1 >= 98) watsurf = 9.
variable label watsurf 'Has surface water'.
value label watsurf 0 'Not surface water' 1 'Has surface water' 9 'Missing'.
missing values watsurf (9).

compute watbott = 0.
if (ws1 = 91) watbott = 1.
if (ws1 >= 98) watbott = 9.
variable label watbott 'Has bottled water'.
value label watbott 0 'Not bottled water' 1 'Has bottled water' 9 'Missing'.
missing values watbott (9).

* type of sanitary facility

compute sanfsew = 0.
if (ws7 = 11) sanfsew = 1.
if (ws7 >= 98) sanfsew = 9.
variable label sanfsew 'Has flush to piped sewer system toilet'.
value label sanfsew 0 'Not flush to piped sewer system toilet' 1 'Has flush to piped sewer system toilet' 9 'Missing'.
missing values sanfsew (9).

compute sanfsep = 0.
if (ws7 = 12) sanfsep = 1.
if (ws7 >= 98) sanfsep = 9.
variable label sanfsep 'Has flush to septic system toilet'.
value label sanfsep 0 'Not flush to septic system toilet' 1 'Has flush to septic system toilet' 9 'Missing'.
missing values sanfsep (9).

compute sanfpit = 0.
if (ws7 = 13) sanfpit = 1.
if (ws7 >= 98) sanfpit = 9.
variable label sanfpit 'Has flush to pit latrine toilet'.
value label sanfpit 0 'Not flush to pit latrine toilet' 1 'Has flush to pit latrine toilet' 9 'Missing'.
missing values sanfpit (9).

compute sanfelse = 0.
if (ws7 = 14) sanfelse = 1.
if (ws7 >= 98) sanfelse = 9.
variable label sanfelse 'Has flush to elsewhere toilet'.
value label sanfelse 0 'Not flush to elsewhere toilet' 1 'Has flush to elsewhere toilet' 9 'Missing'.
missing values sanfelse (9).

compute sanfdk = 0.
if (ws7 = 15) sanfdk = 1.
if (ws7 >= 98) sanfdk = 9.
variable label sanfdk 'Has flush to unknown place toilet'.
value label sanfdk 0 'Not flush to unknown place toilet' 1 'Has flush to unknown place toilet' 9 'Missing'.
missing values sanfdk (9).

compute sanvip = 0.
if (ws7 = 21) sanvip = 1.
if (ws7 >= 98) sanvip = 9.
variable label sanvip 'Has vent improved pit latrine toilet'.
value label sanvip 0 'Not vent improved pit latrine toilet' 1 'Has vent improved pit latrine toilet' 9 'Missing'.
missing values sanvip (9).

compute sanpitsl = 0.
if (ws7 = 22) sanpitsl = 1.
if (ws7 >= 98) sanpitsl = 9.
variable label sanpitsl 'Has pit latrine with slab toilet'.
value label sanpitsl 0 'Not pit latrine with slab toilet' 1 'Has pit latrine with slab toilet' 9 'Missing'.
missing values sanpitsl (9).

compute sanpit = 0.
if (ws7 = 23) sanpit = 1.
if (ws7 >= 98) sanpit = 9.
variable label sanpit 'Has pit latrine without slab toilet'.
value label sanpit 0 'Not pit latrine without slab toilet' 1 'Has pit latrine without slab toilet' 9 'Missing'.
missing values sanpit (9).

compute sancomp = 0.
if (ws7 = 31) sancomp = 1.
if (ws7 >= 98) sancomp = 9.
variable label sancomp 'Has composting toilet'.
value label sancomp 0 'Not composting toilet' 1 'Has composting toilet' 9 'Missing'.
missing values sancomp (9).

compute sanbuck = 0.
if (ws7 = 41) sanbuck = 1.
if (ws7 >= 98) sanbuck = 9.
variable label sanbuck 'Has bucket toilet'.
value label sanbuck 0 'Not bucket toilet' 1 'Has bucket toilet' 9 'Missing'.
missing values sanbuck (9).

compute sanhang = 0.
if (ws7 = 51) sanhang = 1.
if (ws7 >= 98) sanhang = 9.
variable label sanhang 'Has hanging toilet'.
value label sanhang 0 'Not hanging toilet' 1 'Has hanging toilet' 9 'Missing'.
missing values sanhang (9).

compute sannone = 0.
if (ws7 = 95) sannone = 1.
if (ws7 >= 98) sannone = 9.
variable label sannone 'Has bush/field/none toilet'.
value label sannone 0 'Not bush/field/none toilet' 1 'Has bush/field/none toilet' 9 'Missing'.
missing values sannone (9).

* Note that variables on agriculture and animal ownership have been taken out from the below commands 2006-11-06.

factor
  /variables
             persroom
             flres flrdng flrwd flrpq flrbam flrvl flrcer flrcem flrcpt
             roofno rooflf roofsod roofmat roofbam roofplnk roofmetl roofwood rooffibr roofcer roofcem roofshng
             wallno wallcane walldirt wallbam wallmud wallunad wallply wallctn wallre wallcem wallstn wallbrk wallblk walladob wallplnk
             fuelelec fuellpg fuelgas fuelbio fuelker fuelcoal fuelchar fuelwood fuelstrw fueldung fuelagre
             elec radio tv mobile phone fridge
             watch bike moto cart car boat
             watpdw watpyd watptap watbore watpwell watuwell watpsprg watusprg watrain wattank watcart watsurf watbott
             sanfsew sanfsep sanfpit sanfelse sanfdk sanvip sanpitsl sanpit sancomp sanbuck sanhang sannone
  /missing meansub
  /analysis
             persroom
             flres flrdng flrwd flrbam flrpq flrvl flrcer flrcem flrcpt
             roofno rooflf roofsod roofmat roofbam roofplnk roofmetl roofwood rooffibr roofcer roofcem roofshng
             wallno wallcane walldirt wallbam wallmud wallunad wallply wallctn wallre wallcem wallstn wallbrk wallblk walladob wallplnk
             fuelelec fuellpg fuelgas fuelbio fuelker fuelcoal fuelchar fuelwood fuelstrw fueldung fuelagre
             elec radio tv mobile phone fridge
             watch bike moto cart car boat
             watpdw watpyd watptap watbore watpwell watuwell watpsprg watusprg watrain wattank watcart watsurf watbott
             sanfsew sanfsep sanfpit sanfelse sanfdk sanvip sanpitsl sanpit sancomp sanbuck sanhang sannone
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

delete var wlthscor wlthind5.

save outfile="wealth.sav"
 /rename (fac1_1 = wlthscor) (nfac1_1 = wlthind5)
 /keep HH1 HH2 wlthscor wlthind5.

new file.
