get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

compute total = 1.
value label total 1 "".
variable label total "Number of mothers/caretakers of children aged 0-59 months".

compute layer1 = 1.
value label layer1 1 " ".
variable label layer1 "Percentage of mother/caretakers of children aged 0-59 "+
  "months who think that a child should be taken immediately to a health "+
	"facility if the child:".

compute drink = 0.
if (CA14A = "A") drink = 100.
variable label drink "Is not able to drink or breastfeed".

compute sicker = 0.
if (CA14B = "B") sicker = 100.
variable label sicker "Becomes sicker".

compute fever = 0.
if (CA14C = "C") fever = 100.
variable label fever "Develops a fever".

compute fast = 0.
if (CA14D = "D") fast = 100.
variable label fast "Has fast breathing".

compute breath = 0.
if (CA14E = "E") breath = 100.
variable label breath "Has difficulty breathing".

compute blood = 0.
if (CA14F = "F") blood = 100.
variable label blood "Has blood in stool".

compute poorly = 0.
if (CA14G = "G") poorly = 100.
variable label poorly "Is drinking poorly".

compute other = 0.
if (CA14X = "X" | CA14Y = "Y" | CA14Z = "Z") other = 100.
variable label other "Has other symptoms".

compute twosigns = 0.
if (CA14D = "D" and CA14E = "E") twosigns = 100.
variable label twosigns "Mothers/caretakers who recognize the two danger "+
  "signs of pneumonia".

tables
  /format = zero
  /observation = drink sicker fever fast breath blood poorly other twosigns
  /ftotal = tot1 "Total"
  /table = HH7 + HH6 + melevel + wlthind5 + HC1B + tot1 by layer1 >
    (drink + sicker + fever + fast + breath + blood + poorly + other) +
		twosigns + total
  /statistics
    mean(drink (f5.1) '')
    mean(sicker (f5.1) '')
    mean(fever (f5.1) '')
    mean(fast (f5.1) '')
    mean(breath (f5.1) '')
    mean(blood (f5.1) '')
    mean(poorly (f5.1) '')
    mean(other (f5.1) '')
    mean(twosigns (f5.1) '')
    count(total (f5.0) '')
  /title
    "Table CH.7A: Knowledge of the two danger signs of pneumonia"
		"Percentage of mothers/caretakers of children aged 0-59 months by "+
		"knowledge of types of symptoms for taking a child immediately to a "
		"health facility, and percentage of mothers/caretakers who recognize "+
		"fast and difficult breathing as signs for seeking care immediately, "+
		"Country, Year".

new file.
