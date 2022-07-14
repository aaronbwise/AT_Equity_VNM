compute total = 1.
compute total1 = 1.
value label total1 1 'Total'.

compute surviv = ceb - deadkids.

aggregate outfile = 'tmp.sav'
  /break wage
  /totceb = sum(ceb)
  /totdead = sum(deadkids)
  /totsurv = sum(surviv)
  /women = sum(total).

aggregate outfile = 'tmp2.sav'
  /break total1
  /totceb = sum(ceb)
  /totdead = sum(deadkids)
  /totsurv = sum(surviv)
  /women = sum(total).

* QFIVE related.
* Set mean age of maternity .
compute meanage = 27.
* Set survey year.
compute syear = 2005.
* Set survey month.
compute smonth = 9.
aggregate outfile = 'tmpcmr.sav'
  /break wage
  /ceb = sum(ceb)
  /deadkids = sum(deadkids)
  /numwomen = n(total)
  /meanage = mean(meanage)
  /syear = mean(syear)
  /smonth = mean(smonth)
  /sex = mean(qfivesex ).

get file = 'tmp.sav'.

add files
  /file = *
  /file = 'tmp2.sav'.

compute meanceb = totceb/women.
compute propdead = totdead/totceb.
compute meansurv = totsurv/women.

COMMENT -- Begin commenting out TABLES command to be converted to CTABLES
 table
  /observation = meanceb meansurv propdead women
  /table = wage + total1 by meanceb + meansurv + propdead + women
  /statistics
    mean(meanceb (f5.3) 'Mean number of CEB')
    mean(propdead (f5.3) 'Proportion dead')
    mean(meansurv (f5.3) 'Mean number of children surviving')
    mean(women (f5.0) 'Number of women')
  /title
    "Table CM.2: Children ever born and proportion dead " " Mean number of children ever born and proportion dead by age of women, Country, Year" subgroup.

COMMENT -- End commenting out TABLES command.

COMMENT -- Begin CTABLES command.
CTABLES
  /MRSETS COUNTDUPLICATES=YES
  /FORMAT EMPTY=BLANK
  /TABLE wage[C]+total1[C] BY
	  meanceb[S][MEAN,'Mean number of children ever born',F5.3]+
	  meansurv[S][MEAN,'Mean number children surviving',F5.3]+
              propdead[S][MEAN,'Proportion dead',F5.3]+
              women[S][MEAN,'Number of women',F5.0]
  /CATEGORIES VAR=ALL EMPTY=EXCLUDE MISSING=EXCLUDE
  /SLABELS POSITION=COLUMN
  /TITLE TITLE="Table CM.2: Children ever born, children surviving, proportion dead" 
  " Mean number of children ever born, children surviving and proportion dead by age of women, Country, Year" subgroup.
COMMENT -- End CTABLES command.

* QFIVE related.
get file = 'tmpcmr.sav'.
include file = 'qfive.sps'.

COMMENT -- Begin commenting out TABLES command to be converted to CTABLES
 table
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
CTABLES
  /MRSETS COUNTDUPLICATES=YES
  /FORMAT EMPTY=BLANK
  /TABLE wage[C] BY
	  mceb[S][MEAN,'']+
              propcd[S][MEAN,'']+
              age[S][MEAN,'']+
              qino[S][MEAN,'']+tstarno[S][MEAN,'']+
              qiso[S][MEAN,'']+tstarso[S][MEAN,'']+
              qiea[S][MEAN,'']+tstarea[S][MEAN,'']+
              qiwe[S][MEAN,'']+tstarwe[S][MEAN,'']
  /CATEGORIES VAR=ALL EMPTY=EXCLUDE MISSING=EXCLUDE
  /SLABELS POSITION=COLUMN
  /TITLE TITLE='Coale-Demeny Models (Trussel equations)' subgroup.
COMMENT -- End CTABLES command.

COMMENT -- Begin commenting out TABLES command to be converted to CTABLES
 table
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
CTABLES
  /MRSETS COUNTDUPLICATES=YES
  /FORMAT EMPTY=BLANK
  /TABLE wage[C] BY
	  refdateno[S][MEAN,'']+imrno[S][MEAN,'']+
              refdateso[S][MEAN,'']+imrso[S][MEAN,'']+
              refdateea[S][MEAN,'']+imrea[S][MEAN,'']+
              refdatewe[S][MEAN,'']+imrwe[S][MEAN,'']
  /CATEGORIES VAR=ALL EMPTY=EXCLUDE MISSING=EXCLUDE
  /SLABELS POSITION=COLUMN
  /TITLE TITLE='Infant Mortality Rate' subgroup.
COMMENT -- End CTABLES command.

COMMENT -- Begin commenting out TABLES command to be converted to CTABLES
 table
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
CTABLES
  /MRSETS COUNTDUPLICATES=YES
  /FORMAT EMPTY=BLANK
  /TABLE wage[C] BY
	  refdateno[S][MEAN,'']+u5mrno[S][MEAN,'']+
              refdateso[S][MEAN,'']+u5mrso[S][MEAN,'']+
              refdateea[S][MEAN,'']+u5mrea[S][MEAN,'']+
              refdatewe[S][MEAN,'']+u5mrwe[S][MEAN,'']
  /CATEGORIES VAR=ALL EMPTY=EXCLUDE MISSING=EXCLUDE
  /SLABELS POSITION=COLUMN
  /TITLE TITLE='Under-five Mortality Rate' subgroup.
COMMENT -- End CTABLES command.
