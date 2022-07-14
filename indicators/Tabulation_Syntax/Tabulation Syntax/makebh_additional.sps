* Create birth order, birth interval and mother's age at birth variables.
get file='bh.sav'.

sort cases by HH1 HH2 LN BHLN.

recode BHLN (1=1) (2,3=2) (4,5,6=3) (else=4) into brthord.
compute magebrt = BH4C-WDOB.
recode magebrt (lo thru 239=1) (240 thru 419=2) (420 thru hi=3).

* Not twin and not first.
if (BH4C<>lag(BH4C) and BHLN > 1) birthint = BH4C - lag(BH4C).
* Twin and not first.
if (BH4C=lag(BH4C) and BH4C<>lag(BH4C,2) and BHLN > 2) birthint = BH4C - lag(BH4C,2).
* Triplet and not first.
if (BH4C=lag(BH4C) and BH4C=lag(BH4C,2) and BH4C<>lag(BH4C,3) and BHLN > 3) birthint = BH4C - lag(BH4C,3).
recode birthint (sysmis=0) (lo thru 23=1) (24 thru 35=2) (36 thru 47=3) (48 thru hi=4).

variable labels 
  brthord 'Birth order'
 /magebrt "Mother's age at birth"
 /birthint "Previous birth interval".
value labels
  brthord 1 '1' 2 '2-3' 3 '4-6' 4 '7+'
 /magebrt 1 '<20' 2 '20-34' 3 '35+'
 /birthint 0 'First birth' 1 '<2 years' 2 '2 years' 3 '3 years' 4 '4+ years'.

save outfile='bh.sav'.