get file = 'ch.sav'.

weight by chweight.

select if (UF9 = 1).

recode ML10 (1 = 100) (else = 0) into bednet.
variable label bednet "Slept under a bednet *".

compute trnet = 0.
if (ML12 = 11 or ML12 = 12) trnet = 100.
if ((ML12 = 21 or ML12 = 22) and ML11 < 12) trnet = 100.
if (ML11 < 12 and ML13 = 1) trnet = 100.
if (ML14 = 1 and ML15 < 12) trnet = 100.
variable label trnet "Sleep under an insecticide treated net **".

* create a variable that equal 100 IF child slept under an untreated net.
compute untreat = 0.
if ((ML12 = 21 or ML12 = 22) and (ML11 >= 12 and ML11 <= 95) and 
	((ML14 = 2) or (ML14 = 1 and ML15 >= 12 and ML15 <= 95))) untreat = 100.
if ((ML12 = 31 or ML12 = 32 or ML12 = 36 or ML12 = 98 or ML12 = 99) and 
	(ML13 = 2 or (ML13 <> 2 and ML11 >= 12 and ML11 <= 95)) and 
	((ML14 = 2) or (ML14 = 1 and ML15 >= 12 and ML15 <= 95))) untreat = 100.
variable label untreat "Slept under an untreated net".

* it is unknown if a child's net was treated if: the child slept under a net
* and the net was neither treated nor untreated.
compute iftreat = 0.
if (bednet = 100 & trnet = 0 & untreat = 0) iftreat = 100.
variable label iftreat "Slept under a net but don't know if treated".

recode ML10 (8,9 = 100) (else = 0) into dk.
variable label dk "Don't know if slept under a net".
 
recode ML10 (2 = 100) (else = 0) into notsleep.
variable label notsleep "Did not sleep under a bednet". 

tables
  /format = zero
  /observation = bednet trnet untreat iftreat dk notsleep
  /ftotal = tot1 "Total" tot2 "Number of children aged 0-59 months" 
  /table = HL4 + HH7 + HH6 + cage_11 + wlthind5 + HC1B + tot1 by 
	  bednet + trnet + untreat + iftreat + dk + notsleep + tot2 
  /statistics
    means(bednet (f5.1) '')
    means(trnet (f5.1) '')
    means(untreat (f5.1) '')
    means(iftreat (f5.1) '')
    means(dk (f5.1) '')
    means(notsleep (f5.1) '')
    count(tot2 (f5.0) '')
  /title
    "Table CH.11: Children sleeping under bednets"
		"Percentage of children aged 0-59 months who slept under an insecticide "+
		"treated net during the previous night, Country, Year"
  /caption
    "* MICS indicator 38"
		"** MICS indicator 37; MDG indicator 22".

new file.
