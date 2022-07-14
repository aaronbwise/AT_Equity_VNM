get file = 'hl.sav'.

weight by hhweight.

compute total = 1.
variable label total "Total".
value label total 1 "".

* NEXT TWO LINES SHOULD BE ADDED IF THE SURVEY WAS CONDUCTED HALF A YEAR OR LATER THAN THE BEGINNING OF THE SCHOOL YEAR. 
*compute hl5 = hl5-1.
*variable label hl5 "Age at beginning of school year".

compute boysp  = 0.
if (HL4 = 1 and HL5 >= 6 and HL5 <= 10 ) boysp = 1.
variable label boysp "Number of primary school age boys".

compute narbp = 0.
if (HL4 = 1 and HL5 >= 6 and HL5 <= 10 and ED4 = 1 and (ED6A >= 1 and ED6A <= 3)) narbp = 1.
if (HL4 = 1 and HL5 = 10 and ED3A = 1 and ED3B = 5 and ED4 =  2) narbp  = 1.
variable label narbp "Number of primary school age boys attending primary "+
  "school".

compute girlsp = 0.
if (HL4 = 2 and HL5 >= 6 and HL5 <= 10) girlsp = 1.
variable label girlsp "Number of primary school age girls".

compute narfp = 0.
if (HL4 = 2 and HL5 >= 6 and HL5 <= 10 and ED4 = 1 and (ED6A >= 1 and ED6A <= 3)) narfp = 1.
if (HL4 = 2 and HL5 = 10 and ED3A = 1 and ED3B = 5 and ED4 =  2) narfp  = 1.
variable label narfp "Number of primary school age girls attending primary "+
  "school".

compute boyss = 0.
if (HL4 = 1 and HL5 >= 11 and HL5 <= 17) boyss = 1.
variable label boyss "Number of secondary school age boys".

compute narbs = 0.
if (HL4 = 1 and HL5 >= 11 and HL5 <= 17 and ED4 =1 and (ED6A >= 2 and ED6A <= 3)) narbs = 1.
if (HL4 = 1 and HL5 = 17 and ED3A = 2 and ED3B = 6 and ED4 = 2) narbs = 1.
variable label narbs "Number of secondary school age boys attending secondary "+
  "school".

compute girlss = 0.
if (HL4 = 2 and HL5 >= 11 and HL5 <= 17) girlss = 1.
variable label girlss "Number of secondary school age girls".

compute narfs  = 0.
if (HL4 = 2 and HL5 >= 11 and HL5 <= 17 and ED4 =1 and (ED6A >= 2 and ED6A <= 3)) narfs =  1.
if (HL4 = 2 and HL5 = 17 and ED3A = 2 and ED3B = 6 and ED4 = 2) narfs = 1.
variable label narfs "Number of secondary school age girls attending secondary "+
  "school".

aggregate outfile = 'tmp1.sav'
  /break   = HL4
  /nboysp  = sum(boysp)
  /nnarbp  = sum(narbp)
  /ngirlsp = sum(girlsp)
  /nnarfp  = sum(narfp)
  /nboyss  = sum(boyss)
  /nnarbs  = sum(narbs)
  /ngirlss = sum(girlss)
  /nnarfs  = sum(narfs).

aggregate outfile = 'tmp2.sav'
  /break   = HH7
  /nboysp  = sum(boysp)
  /nnarbp  = sum(narbp)
  /ngirlsp = sum(girlsp)
  /nnarfp  = sum(narfp)
  /nboyss  = sum(boyss)
  /nnarbs  = sum(narbs)
  /ngirlss = sum(girlss)
  /nnarfs  = sum(narfs).

aggregate outfile = 'tmp3.sav'
  /break   = HH6
  /nboysp  = sum(boysp)
  /nnarbp  = sum(narbp)
  /ngirlsp = sum(girlsp)
  /nnarfp  = sum(narfp)
  /nboyss  = sum(boyss)
  /nnarbs  = sum(narbs)
  /ngirlss = sum(girlss)
  /nnarfs  = sum(narfs).

aggregate outfile = 'tmp4.sav'
  /break   = melevel
  /nboysp  = sum(boysp)
  /nnarbp  = sum(narbp)
  /ngirlsp = sum(girlsp)
  /nnarfp  = sum(narfp)
  /nboyss  = sum(boyss)
  /nnarbs  = sum(narbs)
  /ngirlss = sum(girlss)
  /nnarfs  = sum(narfs).

aggregate outfile = 'tmp5.sav'
  /break   = wlthind5
  /nboysp  = sum(boysp)
  /nnarbp  = sum(narbp)
  /ngirlsp = sum(girlsp)
  /nnarfp  = sum(narfp)
  /nboyss  = sum(boyss)
  /nnarbs  = sum(narbs)
  /ngirlss = sum(girlss)
  /nnarfs  = sum(narfs).

aggregate outfile = 'tmp6.sav'
  /break   = HC1B
  /nboysp  = sum(boysp)
  /nnarbp  = sum(narbp)
  /ngirlsp = sum(girlsp)
  /nnarfp  = sum(narfp)
  /nboyss  = sum(boyss)
  /nnarbs  = sum(narbs)
  /ngirlss = sum(girlss)
  /nnarfs  = sum(narfs).

aggregate outfile = 'tmp7.sav'
  /break   = total
  /nboysp  = sum(boysp)
  /nnarbp  = sum(narbp)
  /ngirlsp = sum(girlsp)
  /nnarfp  = sum(narfp)
  /nboyss  = sum(boyss)
  /nnarbs  = sum(narbs)
  /ngirlss = sum(girlss)
  /nnarfs  = sum(narfs).

get file = 'tmp1.sav'.

add files
  /file = *
  /file = 'tmp2.sav'
  /file = 'tmp3.sav'
  /file = 'tmp4.sav'
  /file = 'tmp5.sav'
  /file = 'tmp6.sav'
  /file = 'tmp7.sav'.

if (ngirlsp > 0) pgirls = (nnarfp/ngirlsp)*100.
variable label pgirls "Primary school net attendance ratio (NAR), girls".

if (nboysp > 0) pboys = (nnarbp/nboysp)*100.
variable label pboys "Primary school net attendance ratio (NAR), boys".

if (pboys > 0) ratio1 = (pgirls/pboys).
variable label ratio1 "Gender parity index (GPI) for primary school NAR*".

if (ngirlss > 0) sgirls = (nnarfs/ngirlss)*100.
variable label sgirls "Secondary school net attendance ratio (NAR), girls".

if (nboyss > 0) sboys = (nnarbs/nboyss)*100.
variable label sboys "Secondary school net attendance ratio (NAR), boys".

if (sboys > 0) ratio2 = (sgirls/sboys).
variable label ratio2 "Gender parity index (GPI) for secondary school NAR*".

tables
  /format = zero
  /observation = pgirls pboys ratio1 sgirls sboys ratio2
  /ftotal = tot1 "Total"
  /tables =  HH7 + HH6 + melevel + wlthind5 + HC1B + total by 
	  pgirls + pboys + ratio1 + sgirls + sboys + ratio2
  /statistics
    mean(pgirls (f5.1) '')
    mean(pboys (f5.1) '')
    mean(ratio1 (f5.2) '')
    mean(sgirls (f5.1) '')
    mean(sboys (f5.1) '')
    mean(ratio2 (f5.2) '')
  /title
    "Table ED.7 : Education gender parity"
		"Ratio of girls to boys attending primary education and ratio of girls "+
		"to boys attending secondary education, Country, Year"
  /caption
    "* MICS Indicator 61; MDG Indicator 9".
new file.

*delete working files.
erase file = 'tmp1.sav'.
erase file = 'tmp2.sav'.
erase file = 'tmp3.sav'.
erase file = 'tmp4.sav'.
erase file = 'tmp5.sav'.
erase file = 'tmp6.sav'.
erase file = 'tmp7.sav'.
