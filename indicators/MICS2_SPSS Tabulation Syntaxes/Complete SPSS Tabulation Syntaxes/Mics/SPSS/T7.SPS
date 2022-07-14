get file = 'wm.sav'.

weight by wmweight.

compute total = 1.

aggregate outfile = 'tmp.sav'
  /break wage
  /totceb = sum(ceb)
  /totdead = sum(deadkids)
  /women = sum(total).

get file = 'tmp.sav'.

compute meanceb = totceb/women.

compute propdead = totdead/totceb.

table
  /observation = meanceb propdead women
  /ftotal = tot1 "Total"
  /table = wage + tot1 by meanceb + propdead + women
  /statistics
    mean(meanceb (f5.3) 'Mean number of CEB')
    mean(propdead (f5.3) 'Proportion dead')
    mean(women (f5.0) 'Number of women')
  /title
    "Table 7: Mean number of children ever born (CEB) and proportion dead by mother's age, Country, Year".

new file.

erase file = 'tmp.sav'.
