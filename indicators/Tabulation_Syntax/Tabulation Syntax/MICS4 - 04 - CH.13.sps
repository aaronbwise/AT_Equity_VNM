get file = 'hl.sav'.

sort cases by HH1 HH2 HL1.

save outfile = "tmp.sav"
  /keep HH1 HH2 HL1 HL10
  /rename HL1 = LN.

get file = "tn.sav".

sort cases by HH1 HH2.

compute itnh = 0.
if (TN5 >=11 and TN5 <= 18) itnh = 1.
if (TN5 >=21 and TN5 <= 28 and TN6 <12) itnh = 1.
if ((TN5 >= 31 or TN5 = 98) and TN6 <12 and TN8 = 1) itnh = 1.
if (TN5 >= 21 and TN5 <=98 and TN9 = 1 and TN10 < 12) itnh = 1.
variable labels  itnh "Percentage of households with at least one ITN".

aggregate outfile = "tmp1.sav"
  /break=HH1 HH2
  /itnh=max(itnh).

get file = "wm.sav".

sort cases by HH1 HH2 LN.

match files 
  /file=*
  /table='tmp.sav'
  /by hh1 hh2 ln.

match files 
  /file=*
  /table='tmp1.sav'
  /by hh1 hh2.

select if (WM7 = 1 and CP1 = 1).

weight by wmweight.

compute total = 1.
value labels total  1 "Number of pregnant women".
variable labels  total "".

compute sleep = 0.
if (HL10 = 1) sleep = 100.
variable labels  sleep "Percentage of pregnant wome who stayed in the household the previous night".

do if (sleep = 100).

+ compute netpresent = 0.
+ if (TN11 = 1) netpresent = 100.

+ compute itn = 0.
+ if (TN5 >=11 and TN5 <= 18) itn = 100.
+ if (TN5 >=21 and TN5 <= 28 and TN6 <12) itn = 100.
+ if ((TN5 >= 31 or TN5 = 98) and TN6 <12 and TN8 = 1) itn = 100.
+ if (TN5 >= 21 and TN5 <=98 and TN9 = 1 and TN10 < 12) itn = 100.

+ compute stotal = 1.
+ variable labels  stotal "".

end if.

variable labels  netpresent "Percentage of pregnant women who: Slept under any mosquito net ".
variable labels  itn "Percentage of pregnant women who: Slept under an insecticide treated net [1]".
value labels stotal 1 "Number of pregnant women who slept in the household the previous night".

do if (itnh = 1 and sleep = 100).

+ compute itnsl = 0.
+ if (itn = 100) itnsl = 100.

+ compute itnhtot = 1.
+ variable labels  itnhtot "".

end if.

variable labels  itnsl "Percentage of pregnant women who slept under an ITN, living in households with at least one ITN".
value labels itnhtot 1 "Number of pregnant women living in households with at least one ITN".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

* For labels in French uncomment commands bellow.

* value labels total  1 " Nombre de femmes enceintes".
* variable labels  sleep " Pourcentage de femmes enceintes ayant séjourné dans les ménages la nuit précédente".

* variable labels  netpresent " Pourcentage de femmes enceintes ayant: dormi sous n'importe quelle moustiquaire".
* variable labels  itn " Pourcentage de femmes enceintes ayant: dormi sous une moustiquaire imprégnée [1]".
* value labels stotal 1 " Nombre de femmes enceintes ayant dormi dans les ménages la nuit précédente".

* variable labels  itnsl "Pourcentage de femmes enceintes ayant dormi sous une MI et vivant dans les ménages ayant au moins une MI".
* value labels itnhtot 1 " Nombre de femmes enceintes vivant dans des ménages ayant au moins une MI".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables =  total tot stotal itnhtot
         display = none
  /table hh7 [c] + hh6 [c] + wage [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
   	sleep [s] [mean,'',f5.1] +  total [c] [count,'',f5.0] +
                  netpresent [s] [mean,'',f5.1] +  itn [s] [mean,'',f5.1] +  stotal [c] [count,'',f5.0] +
                  itnsl [s] [mean,'',f5.1] + itnhtot [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table CH.13: Pregnant women sleeping under mosquito nets"
		"Percentage of pregnant women who slept under a mosquito net during the previous night, by type of net, " + surveyname
  caption=
   "[1] MICS indicator 3.19".

* Ctables command in French.
*
ctables
  /vlabels variables =  total tot stotal itnhtot
         display = none
  /table hh7 [c] + hh6 [c] + wage [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
   	sleep [s] [mean,'',f5.1] +  total [c] [count,'',f5.0] +
                  netpresent [s] [mean,'',f5.1] +  itn [s] [mean,'',f5.1] +  stotal [c] [count,'',f5.0] +
                  itnsl [s] [mean,'',f5.1] + itnhtot [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Tableau CH.13: Femmes enceintes ayant dormi sous des moustiquaires	"
		"Pourcentage de femmes enceintes ayant dormi sous une moustiquaire durant la nuit précédente, par type de moustiquaire, " + surveyname
  caption=
   "[1] Indicateur MICS 3.19".

new file.

* erase working file.
erase file = "tmp.sav".