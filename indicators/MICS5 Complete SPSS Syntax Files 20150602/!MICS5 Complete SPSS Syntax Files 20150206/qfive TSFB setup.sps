compute TSFBm = wdoi - wdobfc.
* Frequencies of TSFB in months (if needed).
* fre TSFBm.
* Select only the five groups of time since first birth.
select if (TSFBm >= 0 and TSFBm < 300).
compute TSFB = trunc((TSFBm)/60)+1.
variable labels TSFB 'Time since first birth'.
value labels TSFB 1 '0-4' 2 '5-9' 3 '10-14' 4 '15-19' 5 '20-24'.

compute total = 1.
compute total1 = 1.
value labels total1 1 'Total'.

aggregate outfile = 'tmp.sav'
  /break TSFB
  /totceb = sum(ceb)
  /totdead = sum(cdead)
  /totsurv = sum(csurv)
  /women = sum(total).

aggregate outfile = 'tmp2.sav'
  /break total1
  /totceb = sum(ceb)
  /totdead = sum(cdead)
  /totsurv = sum(csurv)
  /women = sum(total).

aggregate outfile = 'tmpcmr.sav'
  /break TSFB
  /ceb = sum(ceb)
  /cdead = sum(cdead)
  /numwomen = n(total)
  /meanAge = mean(meanAge)
  /syear = mean(syear)
  /smonth = mean(smonth)
  /sex = mean(qfivesex ).

get file = 'tmp.sav'.

add files
  /file = *
  /file = 'tmp2.sav'.

compute meanceb = 0.
compute propdead = 0.
compute meansurv = 0.
if (women > 0) meanceb = totceb/women.
if (totceb > 0) propdead = totdead/totceb.
if (women > 0) meansurv = totsurv/women.

compute ceb = 0.
compute csurv = 0.
value labels
  ceb 0 'Children ever born'
 /csurv 0 'Children surviving'.

ctables
  /vlabels variables = ceb meanceb totceb csurv meansurv totsurv propdead women tsfb total1 display = none
  /mrsets countduplicates=yes
  /format empty=blank
  /table
           total1[c]  + TSFB[c]
   by       ceb [c] > (meanceb [s] [mean,'Mean',f6.4] + totceb [s] [mean,'Total',comma5.0])+
              csurv [c] > (meansurv[s][mean,'Mean',f6.4] + totsurv [s] [mean,'Total',comma5.0])+
              propdead[s][mean,'Proportion dead',f6.4]+
              women[s][mean,'Number of women',comma5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /titles title = "Table CM.1: Children ever born, children surviving and proportion dead" ""
  " Mean and total numbers of children ever born, children surviving and proportion dead by age of women, " + surveyname subgroup
  corner = 'Time since first birth'.							

* QFIVE related.
get file = 'tmpcmr.sav'.
include file = 'qfive TSFB.sps'.

ctables
  /mrsets countduplicates=yes
  /format empty=blank
  /table tsfb[c] by
              propcd[s][mean,'',f6.4]+
              age[s][mean,'',f6.0]+
              qino[s][mean,'']+tstarno[s][mean,'']+
              qiso[s][mean,'']+tstarso[s][mean,'']+
              qiea[s][mean,'']+tstarea[s][mean,'']+
              qiwe[s][mean,'']+tstarwe[s][mean,'']
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /titles title='Coale-Demeny Models' '(Trussel equations)' subgroup.

missing values imrno imrso imrea imrwe u5mrno u5mrso u5mrea u5mrwe (-.999,.999).

ctables
  /mrsets countduplicates=yes
  /format empty=blank missing = "or"
  /table
           TSFB[c] 
   by
              refdateno[S][MEAN,''] + imrno[S][MEAN,'',f7.1] + u5mrno[S][MEAN,'',f7.1] + 
              refdateso[S][MEAN,''] + imrso[S][MEAN,'',f7.1] + u5mrso[S][MEAN,'',f7.1] + 
              refdateea[S][MEAN,''] + imrea[S][MEAN,'',f7.1] + u5mrea[S][MEAN,'',f7.1] + 
              refdatewe[S][MEAN,''] + imrwe[S][MEAN,'',f7.1] + u5mrwe[S][MEAN,'',f7.1] 
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /titles title="Table CM.2: Infant and under-5 mortality rates by age groups of women	"+
   "Indirect estimates of infant and under-5 mortality rates by time since first birth of women, and reference dates for estimates, " +
                                                                                                           "[Model used] model, " + surveyname subgroup
  caption=
  "or: out of range of model life tables".
