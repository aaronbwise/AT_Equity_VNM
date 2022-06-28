* Encoding: windows-1252.
***.
*v2.2019-03-14.
*v03 - 2020-04-14. Labels in French and Spanish have been removed.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'wm.sav'.

include "CommonVarsWM.sps".

select if (WM17 = 1).

* select women that gave birth in two years preceeding the survey. 
select if (CM17 = 1).

weight by wmweight.

* Compute total number of women with a live birth in the last 2 years.
compute tot = 1.
value labels tot 1 " ".
variable labels tot "Number of women with a live birth in the last 2 years".

* Received at least two tetanus toxoid injections during the most recent pregnancy (MN9>=2).
compute twocr = 0.
if (MN9 >= 2 and MN9 <= 7) twocr = 100.
variable labels twocr "Percentage of women who received at least 2 doses during last pregnancy".

* Received one tetanus toxoid injection during the last pregnancy and at least one dose prior to the pregnancy (MN9=1 and MN12>=1) OR
* received at least two tetanus toxoid injections, the last of which was less than 3 years ago (MN12>=2 and MN14<3).
compute two3y = 0.
do if (twocr = 0).
+ if (MN9 = 1 and MN12 >= 1 and MN12 <= 7) two3y = 100.
+ if (MN12 >= 2 and MN12 <= 7 and MN14 < 3) two3y = 100.
end if.
variable labels two3y "2 doses, the last within prior 3 years".

* Received at least 3 tetanus toxoid injections over lifetime, the last of which was in the last 5 years (MN12>=3 and MN14< 5).
compute three5y = 0.
do if (twocr = 0 and two3y = 0).
+ if (MN12 >= 3 and MN12 <= 7 and MN14 < 5 ) three5y = 100.
end if.
variable labels three5y "3 doses, the last within prior 5 years".

* Received at least 4 tetanus toxoid injections over lifetime, the last of which was in the last 10 years (MN12>=4 and MN14< 10).
compute four10y = 0.
do if (twocr = 0 and two3y = 0 and three5y = 0).
+ if (MN12 >= 4 and MN12 <= 7 and MN14 < 10) four10y = 100.
end if.
variable labels four10y "4 doses, the last within prior 10 years".

* Received five or more tetanus toxoid injections (MN12>=5) at any point.
compute five = 0.
do if (twocr = 0 and two3y = 0 and three5y = 0 and four10y = 0).
+ if (MN12 >= 5 and MN12 <= 7) five = 100.
end if.
variable labels five "5 or more doses during lifetime".

compute protect = 0.
if (twocr = 100 or two3y = 100 or three5y = 100 or four10y = 100 or five = 100) protect = 100.
variable labels protect "Protected against tetanus [1]".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of women who did not receive two or more doses during pregnancy but received:".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

ctables
  /vlabels variables = layer total display = none
  /table total [c]         
         + hh6 [c]
         + hh7 [c]
         + welevel [c]
         + disability [c]
         + ethnicity[c]
         + windex5 [c]     by
    twocr [s] [mean '' f5.1] +
    layer [c] > (two3y [s] [mean '' f5.1] + three5y [s] [mean '' f5.1] + four10y [s] [mean '' f5.1] + five [s] [mean '' f5.1]) +
    protect [s] [mean '' f5.1] +
    tot [s] [count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table TM.5.1: Neonatal tetanus protection"
 	 "Percentage of women age 15-49 years with a live birth in the last 2 years whose most recent live birth was protected against neonatal tetanus, " + surveyname
  caption=
	 "[1] MICS indicator TM.7 - Neonatal tetanus protection".										

new file.