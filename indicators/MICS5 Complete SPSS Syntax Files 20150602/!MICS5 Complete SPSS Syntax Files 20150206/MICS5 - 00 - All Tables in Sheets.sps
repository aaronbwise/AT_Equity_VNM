* Add the working directory if needed, e.g. cd "C:\MICS5\SPSS". or remove to use the default directory.

cd "C:\MICS5\SPSS".

* macro to save the output as the sheet in appropriate workbook.
define saveSheet(!positional !tokens(1))
!let !n = !unquote(!1) .
!let !sheet = !quote(!tail(!tail(!n))) .
!if (!substr(!n,1,2)="DQ") !then .
!let !sheet = !1 . 
!ifend .
!if (!substr(!n,1,2)="SE") !then .
!let !sheet = !quote(!substr(!n,4))
!ifend .
output export 
 /xls documentfile = !quote(!concat("MICS5 - ",!substr(!n,1,!index(!n,".")),"xls"))
      sheet=!sheet
      operation=MODIFYSHEET
 /contents export = visible  .
output close * .
!enddefine .


* Run 00 Data Quality Tables set of tables.
insert file = 'MICS5 - Table DQ.1.SPS' .
saveSheet                   'DQ.1' .
insert file = 'MICS5 - Table DQ.2.SPS' .
saveSheet                   'DQ.2' .
insert file = 'MICS5 - Table DQ.3.SPS' .
saveSheet                   'DQ.3' .
insert file = 'MICS5 - Table DQ.4.SPS' .
saveSheet                   'DQ.4' .
insert file = 'MICS5 - Table DQ.5.SPS' .
saveSheet                   'DQ.5' .
insert file = 'MICS5 - Table DQ.6.SPS' .
saveSheet                   'DQ.6' .
insert file = 'MICS5 - Table DQ.7.SPS' .
saveSheet                   'DQ.7' .
insert file = 'MICS5 - Table DQ.8.SPS' .
saveSheet                   'DQ.8' .
insert file = 'MICS5 - Table DQ.9.SPS' .
saveSheet                   'DQ.9' .
insert file = 'MICS5 - Table DQ.10.SPS' .
saveSheet                   'DQ.10' .
insert file = 'MICS5 - Table DQ.11.SPS' .
saveSheet                   'DQ.11' .
insert file = 'MICS5 - Table DQ.12.SPS' .
saveSheet                   'DQ.12' .
insert file = 'MICS5 - Table DQ.13.SPS' .
saveSheet                   'DQ.13' .
insert file = 'MICS5 - Table DQ.14.SPS' .
saveSheet                   'DQ.14' .
insert file = 'MICS5 - Table DQ.15.SPS' .
saveSheet                   'DQ.15' .
insert file = 'MICS5 - Table DQ.16.SPS' .
saveSheet                   'DQ.16' .
insert file = 'MICS5 - Table DQ.17.SPS' .
saveSheet                   'DQ.17' .
insert file = 'MICS5 - Table DQ.18.SPS' .
saveSheet                   'DQ.18' .
insert file = 'MICS5 - Table DQ.19.SPS' .
saveSheet                   'DQ.19' .
insert file = 'MICS5 - Table DQ.20.SPS' .
saveSheet                   'DQ.20' .
insert file = 'MICS5 - Table DQ.21.SPS' .
saveSheet                   'DQ.21' .
insert file = 'MICS5 - Table DQ.22.SPS' .
saveSheet                   'DQ.22' .
insert file = 'MICS5 - Table DQ.23.SPS' .
saveSheet                   'DQ.23' .
insert file = 'MICS5 - Table DQ.24.SPS' .
saveSheet                   'DQ.24' .
insert file = 'MICS5 - Table DQ.25.SPS' .
saveSheet                   'DQ.25' .
insert file = 'MICS5 - Table DQ.26.SPS' .
saveSheet                   'DQ.26' .
* Table DQ.27 and Table DQ.28 are produced as part of MICS5 - 06 -RH.18&RH.19&RH.20.sps.


* Run 01 HH Sample and Survey Characteristics set of tables.
insert file = 'MICS5 - 01 - HH.01.sps' .
saveSheet             '01 - HH.01' .
insert file = 'MICS5 - 01 - HH.02.sps' .
saveSheet             '01 - HH.02' .
insert file = 'MICS5 - 01 - HH.03.sps' .
saveSheet             '01 - HH.03' .
insert file = 'MICS5 - 01 - HH.04.sps' .
saveSheet             '01 - HH.04' .
insert file = 'MICS5 - 01 - HH.04M.sps' .
saveSheet             '01 - HH.04M' .
insert file = 'MICS5 - 01 - HH.05.sps' .
saveSheet             '01 - HH.05' .
insert file = 'MICS5 - 01 - HH.06.sps' .
saveSheet             '01 - HH.06' .
insert file = 'MICS5 - 01 - HH.07.sps' .
saveSheet             '01 - HH.07' .
insert file = 'MICS5 - 01 - HH.08.sps' .
saveSheet             '01 - HH.08' .


* Run 02 CM Child Mortality .
insert file = 'MICS5 - 02 - CM.01&CM02&CM.03 (TSFB).sps' .
saveSheet             '02 - CM.01&CM02&CM.03 (TSFB)' .
insert file = 'MICS5 - 02 - CM.01&CM02&CM.03 (Age).sps' .
saveSheet             '02 - CM.01&CM02&CM.03 (Age)' .
insert file = 'MICS5 - 02 - CM.01&CM02&CM.03 (BH Version).sps' .
saveSheet             '02 - CM.01&CM02&CM.03 (BH Version)' .


* Run 03 NU Nutrition set of tables.
insert file = 'MICS5 - 03 - NU.01.sps' .
saveSheet             '03 - NU.01' .
insert file = 'MICS5 - 03 - NU.02.sps' .
saveSheet             '03 - NU.02' .
insert file = 'MICS5 - 03 - NU.03.sps' .
saveSheet             '03 - NU.03' .
insert file = 'MICS5 - 03 - NU.04.sps' .
saveSheet             '03 - NU.04' .
insert file = 'MICS5 - 03 - NU.05.sps' .
saveSheet             '03 - NU.05' .
insert file = 'MICS5 - 03 - NU.06.sps' .
saveSheet             '03 - NU.06' .
insert file = 'MICS5 - 03 - NU.07.sps' .
saveSheet             '03 - NU.07' .
insert file = 'MICS5 - 03 - NU.08.sps' .
saveSheet             '03 - NU.08' .
insert file = 'MICS5 - 03 - NU.09.sps' .
saveSheet             '03 - NU.09' .
insert file = 'MICS5 - 03 - NU.10.sps' .
saveSheet             '03 - NU.10' .


* Run 04 CH Child Health set of tables.
insert file = 'MICS5 - 04 - CH.01 (12 - 23 mo).sps' .
saveSheet             '04 - CH.01 (12 - 23 mo)' .
insert file = 'MICS5 - 04 - CH.01 (24 - 35 mo).sps' .
saveSheet             '04 - CH.01 (24 - 35 mo)' .
insert file = 'MICS5 - 04 - CH.01 (12 - 23 mo) vHF.sps' .
saveSheet             '04 - CH.01 (12 - 23 mo)' .
insert file = 'MICS5 - 04 - CH.01 (24 - 35 mo) vHF.sps' .
saveSheet             '04 - CH.01 (24 - 35 mo)' .
insert file = 'MICS5 - 04 - CH.2.sps' .
saveSheet             '04 - CH.2' .
insert file = 'MICS5 - 04 - CH.2 (Measles 12+ months).sps' .
saveSheet             '04 - CH.2 (Measles 12+ months)' .
insert file = 'MICS5 - 04 - CH.03.sps' .
saveSheet             '04 - CH.03' .
insert file = 'MICS5 - 04 - CH.04.sps' .
saveSheet             '04 - CH.04' .
insert file = 'MICS5 - 04 - CH.05.sps' .
saveSheet             '04 - CH.05' .
insert file = 'MICS5 - 04 - CH.06.sps' .
saveSheet             '04 - CH.06' .
insert file = 'MICS5 - 04 - CH.07.sps' .
saveSheet             '04 - CH.07' .
insert file = 'MICS5 - 04 - CH.08.sps' .
saveSheet             '04 - CH.08' .
insert file = 'MICS5 - 04 - CH.09.sps' .
saveSheet             '04 - CH.09' .
insert file = 'MICS5 - 04 - CH.10.sps' .
saveSheet             '04 - CH.10' .
insert file = 'MICS5 - 04 - CH.11.sps' .
saveSheet             '04 - CH.11' .
insert file = 'MICS5 - 04 - CH.12.sps' .
saveSheet             '04 - CH.12' .
insert file = 'MICS5 - 04 - CH.13.sps' .
saveSheet             '04 - CH.13' .
insert file = 'MICS5 - 04 - CH.14.sps' .
saveSheet             '04 - CH.14' .
insert file = 'MICS5 - 04 - CH.15.sps' .
saveSheet             '04 - CH.15' .
insert file = 'MICS5 - 04 - CH.16.sps' .
saveSheet             '04 - CH.16' .
insert file = 'MICS5 - 04 - CH.17.sps' .
saveSheet             '04 - CH.17' .
insert file = 'MICS5 - 04 - CH.18.sps' .
saveSheet             '04 - CH.18' .
insert file = 'MICS5 - 04 - CH.19.sps' .
saveSheet             '04 - CH.19' .
insert file = 'MICS5 - 04 - CH.20.sps' .
saveSheet             '04 - CH.20' .
insert file = 'MICS5 - 04 - CH.21.sps' .
saveSheet             '04 - CH.21' .
insert file = 'MICS5 - 04 - CH.22.sps' .
saveSheet             '04 - CH.22' .
insert file = 'MICS5 - 04 - CH.23.sps' .
saveSheet             '04 - CH.23' .
insert file = 'MICS5 - 04 - CH.24.sps' .
saveSheet             '04 - CH.24' .
insert file = 'MICS5 - 04 - CH.25.sps' .
saveSheet             '04 - CH.25' .


* Run 05 WS Water and Sanitation set of tables.
insert file = 'MICS5 - 05 - WS.01.sps' .
saveSheet             '05 - WS.01' .
insert file = 'MICS5 - 05 - WS.02.sps' .
saveSheet             '05 - WS.02' .
insert file = 'MICS5 - 05 - WS.03.sps' .
saveSheet             '05 - WS.03' .
insert file = 'MICS5 - 05 - WS.04.sps' .
saveSheet             '05 - WS.04' .
insert file = 'MICS5 - 05 - WS.05.sps' .
saveSheet             '05 - WS.05' .
insert file = 'MICS5 - 05 - WS.06.sps' .
saveSheet             '05 - WS.06' .
insert file = 'MICS5 - 05 - WS.07.sps' .
saveSheet             '05 - WS.07' .
insert file = 'MICS5 - 05 - WS.08.sps' .
saveSheet             '05 - WS.08' .
insert file = 'MICS5 - 05 - WS.09.sps' .
saveSheet             '05 - WS.09' .
insert file = 'MICS5 - 05 - WS.10.sps' .
saveSheet             '05 - WS.10' .


* Run 06 RH Reproductive Health set of tables.
insert file='MICS5 - 06 - RH.01&RH.02.sps' .
saveSheet           '06 - RH.01&RH.02' .
insert file='MICS5 - 06 - RH.03.sps' .      
saveSheet           '06 - RH.03' .
insert file='MICS5 - 06 - RH.04.sps' .      
saveSheet           '06 - RH.04' .
insert file='MICS5 - 06 - RH.04A.sps' .      
saveSheet           '06 - RH.04A' .
insert file='MICS5 - 06 - RH.04B.sps' .      
saveSheet           '06 - RH.04B' .
insert file='MICS5 - 06 - RH.05.sps' .      
saveSheet           '06 - RH.05' .
insert file='MICS5 - 06 - RH.06.sps' .      
saveSheet           '06 - RH.06' .
insert file='MICS5 - 06 - RH.07.sps' .      
saveSheet           '06 - RH.07' .
insert file='MICS5 - 06 - RH.08.sps' .      
saveSheet           '06 - RH.08' .
insert file='MICS5 - 06 - RH.09.sps' .      
saveSheet           '06 - RH.09' .
insert file='MICS5 - 06 - RH.10.sps' .      
saveSheet           '06 - RH.10' .
insert file='MICS5 - 06 - RH.11.sps' .      
saveSheet           '06 - RH.11' .
insert file='MICS5 - 06 - RH.12.sps' .      
saveSheet           '06 - RH.12' .
insert file='MICS5 - 06 - RH.13.sps' .      
saveSheet           '06 - RH.13' .
insert file='MICS5 - 06 - RH.14.sps' .      
saveSheet           '06 - RH.14' .
insert file='MICS5 - 06 - RH.15.sps' .      
saveSheet           '06 - RH.15' .
insert file='MICS5 - 06 - RH.16.sps' .      
saveSheet           '06 - RH.16' .
insert file='MICS5 - 06 - RH.17.sps' .      
saveSheet           '06 - RH.17' .
insert file='MICS5 - 06 -RH.18&RH.19&RH.20.sps' .      
saveSheet           '06 -RH.18&RH.19&RH.20'.
insert file='MICS5 - 06 - RH.21.sps' .      
saveSheet           '06 - RH.21' . 
insert file='MICS5 - 06 - RH.22.23.sps' .      
saveSheet           '06 - RH.22.23' .  


* Run 07 CD Child Development set of tables.
insert file = 'MICS5 - 07 - CD.01.sps' .
saveSheet             '07 - CD.01' .
insert file = 'MICS5 - 07 - CD.02.sps' .
saveSheet             '07 - CD.02' .
insert file = 'MICS5 - 07 - CD.03.sps' .
saveSheet             '07 - CD.03' .
insert file = 'MICS5 - 07 - CD.04.sps' .
saveSheet             '07 - CD.04' .
insert file = 'MICS5 - 07 - CD.05.sps' .
saveSheet             '07 - CD.05' .


* Run 08 ED Education set of tables.
insert file = 'MICS5 - 08 - ED.01.sps' .
saveSheet             '08 - ED.01' .
insert file = 'MICS5 - 08 - ED.01M.sps' .
saveSheet             '08 - ED.01M' .
insert file = 'MICS5 - 08 - ED.02.sps' .
saveSheet             '08 - ED.02' .
insert file = 'MICS5 - 08 - ED.03.sps' .
saveSheet             '08 - ED.03' .
insert file = 'MICS5 - 08 - ED.04.sps' .
saveSheet             '08 - ED.04' .
insert file = 'MICS5 - 08 - ED.05.sps' .
saveSheet             '08 - ED.05' .
insert file = 'MICS5 - 08 - ED.06.sps' .
saveSheet             '08 - ED.06' .
insert file = 'MICS5 - 08 - ED.07.sps' .
saveSheet             '08 - ED.07' .
insert file = 'MICS5 - 08 - ED.08.sps' .
saveSheet             '08 - ED.08' .
insert file = 'MICS5 - 08 - ED.09.sps' .
saveSheet             '08 - ED.09' .


* Run 09  CP Child Protection set of tables.
insert file =  'MICS5 - 09 - CP.01.sps' .
saveSheet              '09 - CP.01' .
insert file =  'MICS5 - 09 - CP.02.sps' .
saveSheet              '09 - CP.02' .
insert file =  'MICS5 - 09 - CP.03.sps' .
saveSheet              '09 - CP.03' .
insert file =  'MICS5 - 09 - CP.04.sps' .
saveSheet              '09 - CP.04' .
insert file =  'MICS5 - 09 - CP.05.sps' .
saveSheet              '09 - CP.05' .
insert file =  'MICS5 - 09 - CP.06.sps' .
saveSheet              '09 - CP.06' .
insert file =  'MICS5 - 09 - CP.07.sps' .
saveSheet              '09 - CP.07' .
insert file =  'MICS5 - 09 - CP.07M.sps' .
saveSheet              '09 - CP.07M' .
insert file =  'MICS5 - 09 - CP.08.sps' .
saveSheet              '09 - CP.08' .
insert file =  'MICS5 - 09 - CP.08M.sps' .
saveSheet              '09 - CP.08M' .
insert file =  'MICS5 - 09 - CP.09.sps' .
saveSheet              '09 - CP.09' .
insert file =  'MICS5 - 09 - CP.13.sps' .
saveSheet              '09 - CP.13' .
insert file =  'MICS5 - 09 - CP.13M.sps' .
saveSheet              '09 - CP.13M' .
insert file =  'MICS5 - 09 - CP.14.sps' .
saveSheet              '09 - CP.14' .
insert file =  'MICS5 - 09 - CP.15.sps' .
saveSheet              '09 - CP.15' .


* Run 10 HA HIV-AIDS and Sexual Behaviour set of tables .
insert file = 'MICS5 - 10 - HA.01.sps' .
saveSheet             '10 - HA.01' .
insert file = 'MICS5 - 10 - HA.01M.sps' .
saveSheet             '10 - HA.01M' .
insert file = 'MICS5 - 10 - HA.02.sps' .
saveSheet             '10 - HA.02' .
insert file = 'MICS5 - 10 - HA.02M.sps' .
saveSheet             '10 - HA.02M' .
insert file = 'MICS5 - 10 - HA.03.sps' .
saveSheet             '10 - HA.03' .
insert file = 'MICS5 - 10 - HA.03M.sps' .
saveSheet             '10 - HA.03M' .
insert file = 'MICS5 - 10 - HA.04.sps' .
saveSheet             '10 - HA.04' .
insert file = 'MICS5 - 10 - HA.04M.sps' .
saveSheet             '10 - HA.04M' .
insert file = 'MICS5 - 10 - HA.05.sps' .
saveSheet             '10 - HA.05' .
insert file = 'MICS5 - 10 - HA.06.sps' .
saveSheet             '10 - HA.06' .
insert file = 'MICS5 - 10 - HA.06M.sps' .
saveSheet             '10 - HA.06M' .
insert file = 'MICS5 - 10 - HA.07.sps' .
saveSheet             '10 - HA.07' .
insert file = 'MICS5 - 10 - HA.07M.sps' .
saveSheet             '10 - HA.07M' .
insert file = 'MICS5 - 10 - HA.08.sps' .
saveSheet             '10 - HA.08' .
insert file = 'MICS5 - 10 - HA.08M.sps' .
saveSheet             '10 - HA.08M' .
insert file = 'MICS5 - 10 - HA.09.sps' .
saveSheet             '10 - HA.09' .
insert file = 'MICS5 - 10 - HA.10.sps' .
saveSheet             '10 - HA.10' .
insert file = 'MICS5 - 10 - HA.11.sps' .
saveSheet             '10 - HA.11' .


* Run 11 MT Access to Mass Media and ICT Technology set of tables.
insert file = 'MICS5 - 11 - MT.01.sps' .
saveSheet             '11 - MT.01' .
insert file = 'MICS5 - 11 - MT.01M.sps' .
saveSheet             '11 - MT.01M' .
insert file = 'MICS5 - 11 - MT.02.sps' .
saveSheet             '11 - MT.02' .
insert file = 'MICS5 - 11 - MT.02M.sps' .
saveSheet             '11 - MT.02M' .


* Run 12 SW Subjective Well-Being set of tables.
insert file = 'MICS5 - 12 - SW.01.sps' .
saveSheet             '12 - SW.01' .
insert file = 'MICS5 - 12 - SW.01M.sps' .
saveSheet             '12 - SW.01M' .
insert file = 'MICS5 - 12 - SW.02.sps' .
saveSheet             '12 - SW.02' .
insert file = 'MICS5 - 12 - SW.02M.sps' .
saveSheet             '12 - SW.02M' .
insert file = 'MICS5 - 12 - SW.03.sps' .
saveSheet             '12 - SW.03' .
insert file = 'MICS5 - 12 - SW.03M.sps' .
saveSheet             '12 - SW.03M' .


* Run 13 TA Tobacco and Alcohol Use set of tables.
insert file = 'MICS5 - 13 - TA.01.sps' .
saveSheet             '13 - TA.01' .
insert file = 'MICS5 - 13 - TA.01M.sps' .
saveSheet             '13 - TA.01M' .
insert file = 'MICS5 - 13 - TA.02.sps' .
saveSheet             '13 - TA.02' .
insert file = 'MICS5 - 13 - TA.02M.sps' .
saveSheet             '13 - TA.02M' .
insert file = 'MICS5 - 13 - TA.03.sps' .
saveSheet             '13 - TA.03' .
insert file = 'MICS5 - 13 - TA.03M.sps' .
saveSheet             '13 - TA.03M' .


* Run Sample Error .
insert file = 'SE01 Sampling Error Calculation.SPS' .

