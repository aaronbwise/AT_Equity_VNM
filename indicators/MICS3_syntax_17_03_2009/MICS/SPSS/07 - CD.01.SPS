get file = 'hl.sav'.

compute nofather = 0.
if (HL11 <> 1 or HL12 = 0) nofather = 100.
variable label nofather "Living in a household without their natural father".

sort cases by HH1 HH2 HL1.

save outfile = "tmp.sav"
 /keep HH1 HH2 HL1 nofather felevel
 /rename (HL1 = LN).

get file = 'ch.sav'.

select if (UF9 = 1).

sort cases by HH1 HH2 LN.

match files
  /file = *
  /table='tmp.sav'
  /by HH1 HH2 LN.

weight by chweight.

compute total = 1.
variable label total "Number of children aged 0-59 months".
value label total 1 "".

compute layer = 0.
value label layer 0 "Percentage of children aged 0-59 months".
variable lable layer "".

compute activity = 0.
if (BR8AM = "A" or BR8AF = "B" or BR8AO = "X") activity = activity + 1.
if (BR8BM = "A" or BR8BF = "B" or BR8BO = "X") activity = activity + 1.
if (BR8CM = "A" or BR8CF = "B" or BR8CO = "X") activity = activity + 1.
if (BR8DM = "A" or BR8DF = "B" or BR8DO = "X") activity = activity + 1.
if (BR8EM = "A" or BR8EF = "B" or BR8EO = "X") activity = activity + 1.
if (BR8FM = "A" or BR8FF = "B" or BR8FO = "X") activity = activity + 1.
variable label activity "Mean number of activities household members engage in with the child".

recode activity (4 thru hi = 100) (else = 0) into activ4.
variable label activ4 "For whom household members engaged in four or more "+
  "activities that promote learning and school readiness *".

count factive = BR8AF BR8BF BR8CF BR8DF BR8EF BR8FF ("B").
variable label factive "Mean number of activities the father engage in with the child".
recode factive (1 thru hi = 100) (else = 0) into fact.
variable label fact "For whom the father engaged in one or more activities "+
  "that promote learning and school readiness **".

recode cage (0 thru 23 = 1) (else = 2) into age2.
variable label age2 "Age".
value label age2 1 "0-23 months" 2 "24-59 months".

tables
  /format = zero  
  /observation activ4 activity fact factive nofather
  /ftotal tot1 "Total"
  /table = HL4 + HH7 + HH6 + age2 + melevel + felevel + wlthind5 + HC1B + tot1 
	  by layer > (activ4 + activity + fact + factive + nofather) + total
  /statistics
    mean(activ4 (f5.1) '')
    mean(activity (f5.1) '')
    mean(fact (f5.1) '')
    mean(factive (f5.1) '')
    mean(nofather (f5.1) '')
    count(total (f5.0) '')
  /title
    "Table CD.1: Family support for learning"
    "Percentage of children aged 0-59 months for whom household members are "+
		"engaged in activities that promote learning and school readiness, Country, Year"
  /caption
    "* MICS indicator 46"
    "** MICS indicator 47".

new file.

*delete working files.
erase file = 'tmp.sav'.
