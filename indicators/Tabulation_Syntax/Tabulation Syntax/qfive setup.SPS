******************************* QFIVE RELATED CUSTOMIZATION.
******************************* IMPORTANT! MAKE NACESSERY CHANGES.
* Set mean age of maternity .
compute meanage = 27.
* Set survey year.
compute syear = 2009.
* Set survey month.
compute smonth = 10.

**************************** END OF QFIVE RELATED CUSTOMIZATION.

include "surveyname.sps".

compute total = 1.
compute total1 = 1.
value label total1 1 'Total'.

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

compute meanceb = totceb/women.
compute propdead = totdead/totceb.
compute meansurv = totsurv/women.

COMMENT -- Begin commenting out TABLES command to be converted to CTABLES
* table
  /observation = meanceb meansurv propdead women
  /table = wage + total1 by meanceb + meansurv + propdead + women
  /statistics
    mean(meanceb (f5.3) 'Mean number of CEB')
    mean(propdead (f5.3) 'Proportion dead')
    mean(meansurv (f5.3) 'Mean number of children csurving')
    mean(women (f5.0) 'Number of women')
  /title
    "Table CM.1: Children ever born, children csurving and proportion dead " "Mean and total numbers of children ever born, children csurving and proportion dead by age of women, Country, Year" subgroup.

COMMENT -- End commenting out TABLES command.

COMMENT -- Begin CTABLES command.
ctables
  /table wage [c] + total1 [c] 
        BY meanceb [s] [mean,'Mean number of children ever born',f5.3]+
              totceb [s] [mean,"Total number of children ever born",f5.0]+
              meansurv[s][mean,'Mean number children surving',F5.3]+
              totsurv [s] [mean,"Total number of children surviving",f5.0]+
              propdead[s][mean,'Proportion dead',f5.3]+
              women[s][mean,'Number of women',f5.0]
  /title title = "Table CM.1: Children ever born, children csurving and proportion dead" 
  " Mean and total numbers of children ever born, children csurving and proportion dead by age of women, " + surveyname subgroup.	
COMMENT -- End CTABLES command.

* For table in French use the CTABLE command bellow.
*ctables
  /table wage [c] + total1 [c] 
        BY meanceb [s] [mean,'Mean number of children ever born',f5.3]+
              totceb [s] [mean,"Total number of children ever born",f5.0]+
              meansurv[s][mean,'Mean number children surving',F5.3]+
              totsurv [s] [mean,"Total number of children surviving",f5.0]+
              propdead[s][mean,'Proportion dead',f5.3]+
              women[s][mean,'Number of women',f5.0]
  /title title = "Tableau CM.1: Enfants nés vivants, enfants survivants et proportion des décès selon l'âge des femmes" 
  "Nombres moyens et totaux des enfants nés vivants, des enfants survivants et  proportion des décès selon l'âge des femmes, Pays, Année" subgroup.		

* QFIVE related.
get file = 'tmpcmr.sav'.
include file = 'qfive.sps'.

COMMENT -- Begin commenting out TABLES command to be converted to CTABLES
* table
  /observation = mceb propcd age qino tstarno qiso tstarso qiea tstarea qiwe tstarwe
  /table=wage  by mceb + propcd + age + qino + tstarno + qiso + tstarso + qiea + tstarea + qiwe + tstarwe
  /statistics
    mean( mceb '')
    mean( propcd '')
    mean( age '')
    mean( qino '')
    mean( tstarno '')
    mean( qiso '')
    mean( tstarso '')
    mean( qiea '')
    mean( tstarea '')
    mean( qiwe '')
    mean( tstarwe '')
  /title
    'Coale-Demeny Models (Trussel equations)' subgroup.
COMMENT -- End commenting out TABLES command.

COMMENT -- Begin CTABLES command.
ctables
  /table wage[C] BY
              mceb[S][MEAN,'']+
              propcd[S][MEAN,'']+
              age[S][MEAN,'']+
              qino[S][MEAN,'']+tstarno[S][MEAN,'']+
              qiso[S][MEAN,'']+tstarso[S][MEAN,'']+
              qiea[S][MEAN,'']+tstarea[S][MEAN,'']+
              qiwe[S][MEAN,'']+tstarwe[S][MEAN,'']
  /title title ='Coale-Demeny Models (Trussel equations)' subgroup.
COMMENT -- End CTABLES command.

COMMENT -- Begin commenting out TABLES command to be converted to CTABLES
* table
  /observation = refdateno imrno refdateso imrso refdateea imrea refdatewe imrwe
  /table=wage  by refdateno + imrno + refdateso + imrso + refdateea + imrea + refdatewe + imrwe
  /statistics
    mean( refdateno '')
    mean( imrno '')
    mean( refdateso '')
    mean( imrso '')
    mean( refdateea '')
    mean( imrea '')
    mean( refdatewe '')
    mean( imrwe '')
  /title
    'Infant Mortality Rate' subgroup.
COMMENT -- End commenting out TABLES command.

COMMENT -- Begin CTABLES command.
ctables
  /table wage[C] BY
              refdateno[S][MEAN,'']+imrno[S][MEAN,'']+
              refdateso[S][MEAN,'']+imrso[S][MEAN,'']+
              refdateea[S][MEAN,'']+imrea[S][MEAN,'']+
              refdatewe[S][MEAN,'']+imrwe[S][MEAN,'']
  /title title='Infant Mortality Rate' subgroup.
COMMENT -- End CTABLES command.

COMMENT -- Begin commenting out TABLES command to be converted to CTABLES
* table
  /observation = refdateno u5mrno refdateso u5mrso refdateea u5mrea refdatewe u5mrwe
  /table=wage  by refdateno + u5mrno + refdateso + u5mrso + refdateea + u5mrea + refdatewe + u5mrwe
  /statistics
    mean( refdateno '')
    mean( u5mrno '')
    mean( refdateso '')
    mean( u5mrso '')
    mean( refdateea '')
    mean( u5mrea '')
    mean( refdatewe '')
    mean( u5mrwe '')
  /title
    'Under-five Mortality Rate' subgroup.
COMMENT -- End commenting out TABLES command.

COMMENT -- Begin CTABLES command.
ctables
  /table wage[C] BY
              refdateno[S][MEAN,'']+u5mrno[S][MEAN,'']+
              refdateso[S][MEAN,'']+u5mrso[S][MEAN,'']+
              refdateea[S][MEAN,'']+u5mrea[S][MEAN,'']+
              refdatewe[S][MEAN,'']+u5mrwe[S][MEAN,'']
  /title title='Under-five Mortality Rate' subgroup.
COMMENT -- End CTABLES command.
