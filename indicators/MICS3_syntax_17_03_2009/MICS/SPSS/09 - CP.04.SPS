get file = "hl.sav".

sort cases by HH1 HH2 HL1.

save out="tmp.sav"
 /keep HH1, HH2, HL1, HL5, HL4, melevel
 /rename (HL1 = CD11).

get file = "hh.sav".

select if (HH9 = 1).

* select households in which child discipline questionnaire was administered.
select if (not sysmis(CD12A)).

sort cases by HH1 HH2 CD11.

match files
  /file = *
  /table = 'tmp.sav'
  /by HH1 HH2 CD11.

* To analyze only for children selected use just hhweight.
weight by hhweight.
* To analyze for all children age 2-14 years, weight by hhweight * CD7.
* compute newwgt = hhweight*CD7.
* weight by newwgt.

select if (HL5 >= 2 and HL5 <= 14).

recode HL5 (2 thru 4 = 1) (5 thru 9 = 2) (10 thru 14 = 3) into agegrp.
variable label agegrp "Age".
value label agegrp
  1 "2-4 years"
  2 "5-9 years"
  3 "10-14 years".

compute nviolent = 0.
if ((CD12A = 1 or CD12B = 1 or CD12E = 1) and CD12C = 2 and CD12D = 2 and
  CD12F = 2 and CD12G = 2 and CD12H = 2 and CD12I = 2 and CD12J = 2 and 
	CD12K = 2) nviolent = 100.
variable label nviolent "Only non-violent discipline".

compute punish = 0.
if (CD12D = 1 or CD12H = 1) punish = 100.
variable label punish "Psychological punishment".

compute minor = 0.
if (CD12C = 1 or CD12F = 1 or CD12G = 1 or CD12J = 1) minor = 100.
variable label minor "Minor physical punishment".

compute severep = 0.
if (CD12I = 1 or CD12K = 1) severep = 100.
variable label Severep "Severe physical punishment".

compute any = 0.
if (punish = 100 or minor = 100 or severep = 100) any = 100.
variable label any "Any psychological or physical punishment *".

compute ndisvio = 0.
if (CD12A = 2 and CD12B = 2 and CD12C = 2 and CD12D = 2 and CD12E = 2 and
  CD12F = 2 and CD12G = 2 and CD12H = 2 and CD12I = 2 and CD12J = 2 and 
	CD12K = 2) ndisvio = 100.
variable label ndisvio "No discipline or punishment".

compute cdmiss = 0.
if (nviolent = 0 & any = 0 & ndisvio = 0) cdmiss = 100.
variable label cdmiss "Missing".

compute ppunish = 0.
if (CD13 = 1) ppunish = 100.
variable label ppunish "Mother/caretaker believes that the child needs to be physically punished".

compute layer = 0.
variable label layer "".
value label layer 0 "Percentage of children 2-14 years of age who experience:".

tables
  /format = zero
  /observation = nviolent punish minor severep any ndisvio cdmiss ppunish 
  /ftotal = tot1 "Total" tot2 "Number of children aged  2-14 years**"
  /tables = HL4 + HH7 + HH6 + agegrp + melevel + wlthind5 + HC1B + tot1 by 
	  layer > (nviolent + punish + minor + severep + any + ndisvio + cdmiss) + ppunish + tot2
  /statistics
    mean(nviolent (f5.1) '')
    mean(punish (f5.1) '')
    mean(minor (f5.1) '')
    mean(severep (f5.1) '')
    mean(any (f5.1) '')
    mean(ndisvio (f5.1) '')
    mean(ppunish (f5.1) '')
    mean(cdmiss (f5.1) '')
    count(tot2 (f5.0) '')
  /title
    "Table CP.4: Child discipline"
    "Percentage of children aged 2-14 years according to method of disciplining the child, Country, Year"
  /caption                                                                                                                                                                          
    "* MICS Indicator 74"
    "** Table is based on children aged 2-14 years randomly selected during fieldwork (one child selected per household, if any children in the age range) for whom the questions on child discipline were administered".

new file.

* delete working files.
erase file = 'tmp.sav'.

