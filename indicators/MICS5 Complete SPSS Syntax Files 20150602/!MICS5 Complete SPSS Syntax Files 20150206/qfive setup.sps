include "surveyname.sps".

compute total = 1.
compute total1 = 1.
value labels total1 1 'Total'.

aggregate outfile = 'tmpcmr.sav'
  /break wage
  /ceb = sum(ceb)
  /cdead = sum(cdead)
  /numwomen = n(total)
  /meanage = mean(meanage)
  /syear = mean(syear)
  /smonth = mean(smonth)
  /sex = mean(qfivesex ).

aggregate outfile = 'tmp.sav'
  /break wage
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

get file = 'tmp.sav'.

add files
  /file = *
  /file = 'tmp2.sav'.

compute meanceb = 0.
compute propdead = 0.
compute meansurv = 0.
if (women > 0) meanceb = totceb/women.
if (totceb > 0)  propdead = totdead/totceb.
if (women > 0) meansurv = totsurv/women.

compute ceb = 0.
compute csurv = 0.
value labels
  ceb 0 'Children ever born'
 /csurv 0 'Children surviving'.

ctables
  /vlabels variables = ceb meanceb totceb csurv meansurv totsurv propdead women wage total1 display = none
  /table total1 [c] + wage [c] 
        BY ceb [c] > (meanceb [s] [mean,'Mean',f6.4] + totceb [s] [mean,'Total',comma5.0])+
              csurv [c] > (meansurv[s][mean,'Mean',f6.4] + totsurv [s] [mean,'Total',comma5.0])+
              propdead[s][mean,'Proportion dead',f6.4]+
              women[s][mean,'Number of women age 15-49 years',comma5.0]
  /titles title = "Table CM.1: Children ever born, children surviving and proportion dead" ""
  " Mean and total numbers of children ever born, children surviving and proportion dead by age of women, " + surveyname subgroup
  corner = 'Age'.

* QFIVE related.
get file = 'tmpcmr.sav'.
include file = 'qfive.sps'.

ctables
  /table wage[C] BY
              propcd[S][MEAN,'',f6.4]+
              age[S][MEAN,'',f6.0]+
              qino[S][MEAN,''] + tstarno[S][MEAN,'']+
              qiso[S][MEAN,''] + tstarso[S][MEAN,'']+
              qiea[S][MEAN,''] + tstarea[S][MEAN,'']+
              qiwe[S][MEAN,''] + tstarwe[S][MEAN,'']
  /title title ='Coale-Demeny Models (Trussel equations)' subgroup.

missing values imrno imrso imrea imrwe u5mrno u5mrso u5mrea u5mrwe (-.999,.999).

ctables
  /format missing = "or" 
  /table wage[C] BY
              refdateno[S][MEAN,''] + imrno[S][MEAN,'',f7.1] + u5mrno[S][MEAN,'',f7.1] + 
              refdateso[S][MEAN,''] + imrso[S][MEAN,'',f7.1] + u5mrso[S][MEAN,'',f7.1] + 
              refdateea[S][MEAN,''] + imrea[S][MEAN,'',f7.1] + u5mrea[S][MEAN,'',f7.1] + 
              refdatewe[S][MEAN,''] + imrwe[S][MEAN,'',f7.1] + u5mrwe[S][MEAN,'',f7.1] 
  /titles title="Table CM.2: Infant and under-5 mortality rates by age groups of women	"+
   "Indirect estimates of infant and under-5 mortality rates by age of women, and reference dates for estimates,  [Model used] model, " + surveyname subgroup
  caption=
  "or: out of range of model life tables".


