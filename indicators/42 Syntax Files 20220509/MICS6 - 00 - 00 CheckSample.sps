* Encoding: windows-1252.
** HOUSEHOLD WEIGHT CHECKING FREQUENCIES **.

get file = 'hh.sav'.

select if (HH46 = 1).

TITLE '!!! UNWEIGHTED FREQUENCIES FOR HOUSEHOLD !!!'.
FREQUENCIES
  VARIABLES=HH6 HH7
  /ORDER=  ANALYSIS .

weight by HHWEIGHT.

TITLE '!!! WEIGHTED FREQUENCIES FOR HOUSEHOLD !!!'.
FREQUENCIES
  VARIABLES=HH6 HH7
  /ORDER=  ANALYSIS .

** WOMEN WEIGHT CHECKING FREQUENCIES **.

get file = 'wm.sav'.

select if (WM17 = 1).

TITLE '!!! UNWEIGHTED FREQUENCIES FOR WOMEN !!!'.
FREQUENCIES
  VARIABLES=HH6 HH7 welevel wage
  /ORDER=  ANALYSIS.

weight by wmweight.

TITLE '!!! WEIGHTED FREQUENCIES FOR WOMEN !!!'.
FREQUENCIES
  VARIABLES=HH6 HH7 welevel wage
  /ORDER=  ANALYSIS.

** MEN WEIGHT CHECKING FREQUENCIES **.

get file = 'mn.sav'.

select if (MWM17 = 1).

TITLE '!!! UNWEIGHTED FREQUENCIES FOR MEN !!!'.
FREQUENCIES
  VARIABLES=HH6 HH7 mwelevel mwage
  /ORDER=  ANALYSIS.

weight by mnweight.

TITLE '!!! WEIGHTED FREQUENCIES FOR MEN !!!'.
FREQUENCIES
  VARIABLES=HH6 HH7 mwelevel mwage
  /ORDER=  ANALYSIS.

** CHILDREN WEIGHT CHECKING FREQUENCIES **.

get file = 'ch.sav'.

select if (UF17 = 1).

TITLE '!!! UNWEIGHTED FREQUENCIES FOR CHILDREN !!!'.
FREQUENCIES
  VARIABLES=HH6 HH7 melevel cage
  /ORDER=  ANALYSIS .

weight by CHWEIGHT.

TITLE '!!! WEIGHTED FREQUENCIES FOR CHILDREN !!!'.
FREQUENCIES
  VARIABLES=HH6 HH7 melevel cage
  /ORDER=  ANALYSIS .


get file = 'fs.sav'.

select if (FS17 = 1).

TITLE '!!! UNWEIGHTED FREQUENCIES FOR CHILDREN !!!'.
FREQUENCIES
  VARIABLES=HH6 HH7 melevel fsage
  /ORDER=  ANALYSIS .

weight by FSHWEIGHT.

TITLE '!!! WEIGHTED FREQUENCIES FOR CHILDREN !!!'.
FREQUENCIES
  VARIABLES=HH6 HH7 melevel fsage
  /ORDER=  ANALYSIS .
