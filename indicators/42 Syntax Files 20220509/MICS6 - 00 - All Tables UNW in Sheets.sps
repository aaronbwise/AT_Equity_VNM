* Encoding: UTF-8.
* Add the working directory if needed, e.g. cd "C:\MICS6\SPSS". or remove to use the default directory.

cd "C:\MICS6\SPSS".

set tnumbers = labels /tvars = labels /ovars = labels.

oms
 /destination viewer = no
 /select all except = tables.
output close *.

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
/xlsx documentfile = !quote(!concat("MICS6 - UNW",!substr(!n,1,!index(!n,".")),"xlsx"))
sheet=!sheet
operation=MODIFYSHEET
/contents export = visible layers = printsetting modelviews = printsetting.
output close * .
!enddefine .

* Run Chapter 4. Sample coverage and characteristics of respondents.
insert file = 'MICS6 - 04 - SR.1.1.sps' .
saveSheet             '04 - SR.1.1' .
insert file = 'MICS6 - 04 - SR.2.1.sps' .
saveSheet             '04 - SR.2.1' .
insert file = 'MICS6 - 04 - SR.2.2.sps' .
saveSheet             '04 - SR.2.2' .
insert file = 'MICS6 - 04 - SR.2.3.sps' .
saveSheet             '04 - SR.2.3' .
insert file = 'MICS6 - 04 - SR.3.1.sps' .
saveSheet             '04 - SR.3.1' .
insert file = 'MICS6 - 04 - SR.4.1.sps' .
saveSheet             '04 - SR.4.1' .
insert file = 'MICS6 - 04 - SR.5.1W.sps' .
saveSheet             '04 - SR.5.1W' .
insert file = 'MICS6 - 04 - SR.5.1M.sps' .
saveSheet             '04 - SR.5.1M' .
insert file = 'MICS6 - 04 - SR.5.2.sps' .
saveSheet             '04 - SR.5.2' .
insert file = 'MICS6 - 04 - SR.5.3.sps' .
saveSheet             '04 - SR.5.3' .
insert file = 'MICS6 - 04 - SR.6.1W.sps' .
saveSheet             '04 - SR.6.1.W' .
insert file = 'MICS6 - 04 - SR.6.1M.sps' .
saveSheet             '04 - SR.6.1M' .
insert file = 'MICS6 - 04 - SR.7.1W.sps' .
saveSheet             '04 - SR.7.1W' .
insert file = 'MICS6 - 04 - SR.7.1M.sps' .
saveSheet             '04 - SR.7.1M' .
insert file = 'MICS6 - 04 - SR.8.1W.sps' .
saveSheet             '04 - SR.8.1W' .
insert file = 'MICS6 - 04 - SR.8.1M.sps' .
saveSheet             '04 - SR.8.1M' .
insert file = 'MICS6 - 04 - SR.9.1W.sps' .
saveSheet             '04 - SR.9.1W' .
insert file = 'MICS6 - 04 - SR.9.1M.sps' .
saveSheet             '04 - SR.9.1M' .
insert file = 'MICS6 - 04 - SR.9.2.sps' .
saveSheet             '04 - SR.9.2' .
insert file = 'MICS6 - 04 - SR.9.3W.sps' .
saveSheet             '04 - SR.9.3W' .
insert file = 'MICS6 - 04 - SR.9.3M.sps' .
saveSheet             '04 - SR.9.3M' .
insert file = 'MICS6 - 04 - SR.9.4W.sps' .
saveSheet             '04 - SR.9.4W' .
insert file = 'MICS6 - 04 - SR.9.4M.sps' .
saveSheet             '04 - SR.9.4M' .
insert file = 'MICS6 - 04 - SR.10.1W.sps' .
saveSheet             '04 - SR.10.1W' .
insert file = 'MICS6 - 04 - SR.10.1M.sps' .
saveSheet             '04 - SR.10.1M' .
insert file = 'MICS6 - 04 - SR.10.2W.sps' .
saveSheet             '04 - SR.10.2W' .
insert file = 'MICS6 - 04 - SR.10.2M.sps' .
saveSheet             '04 - SR.10.2M' .
insert file = 'MICS6 - 04 - SR.10.3W.sps' .
saveSheet             '04 - SR.10.3W' .
insert file = 'MICS6 - 04 - SR.10.3M.sps' .
saveSheet             '04 - SR.10.3M' .
insert file = 'MICS6 - 04 - SR.11.1.sps' .
saveSheet             '04 - SR.11.1' .
insert file = 'MICS6 - 04 - SR.11.2.sps' .
saveSheet             '04 - SR.11.2' .
insert file = 'MICS6 - 04 - SR.11.3.sps' .
saveSheet             '04 - SR.11.3' .


* Run Chapter 5. Survive.
insert file = 'MICS6 - 05 - CS.1&CS.2&CS.3 (BH).sps' .
saveSheet             '05 - CS.1&CS.2&CS.3 (BH)' .
insert file = 'MICS6 - 05 - CS.1&CS.2&CS.3 (TSFB).sps' .
saveSheet             '05 - CS.1&CS.2&CS.3 (TSFB)' .


* Run Chapter 6. Thrive - Reproductive and maternal health.
insert file = 'MICS6 - 06 - TM.1.1&TM.2.1.sps' .
saveSheet             '06 - TM.1.1&TM.2.1'. 
insert file = 'MICS6 - 06 - TM.2.2W.sps' .
saveSheet             '06 - TM.2.2W' .
insert file = 'MICS6 - 06 - TM.2.2M.sps' .
saveSheet             '06 - TM.2.2M' .
insert file = 'MICS6 - 06 - TM.2.3W.sps' .
saveSheet             '06 - TM.2.3W' .
insert file = 'MICS6 - 06 - TM.2.3M.sps' .
saveSheet             '06 - TM.2.3M' .
insert file = 'MICS6 - 06 - TM.3.1.sps' .
saveSheet             '06 - TM.3.1' .
insert file = 'MICS6 - 06 - TM.3.2.sps' .
saveSheet             '06 - TM.3.2' .
insert file = 'MICS6 - 06 - TM.3.3.sps' .
saveSheet             '06 - TM.3.3' .
insert file = 'MICS6 - 06 - TM.3.4.sps' .
saveSheet             '06 - TM.3.4' .
insert file = 'MICS6 - 06 - TM.4.1.sps' .
saveSheet             '06 - TM.4.1' .
insert file = 'MICS6 - 06 - TM.4.2.sps' .
saveSheet             '06 - TM.4.2' .
insert file = 'MICS6 - 06 - TM.4.3.sps' .
saveSheet             '06 - TM.4.3' .
insert file = 'MICS6 - 06 - TM.5.1.sps' .
saveSheet             '06 - TM.5.1' .
insert file = 'MICS6 - 06 - TM.6.1.sps' .
saveSheet             '06 - TM.6.1' .
insert file = 'MICS6 - 06 - TM.6.2.sps' .
saveSheet             '06 - TM.6.2' .
insert file = 'MICS6 - 06 - TM.7.1.sps' .
saveSheet             '06 - TM.7.1' .
insert file = 'MICS6 - 06 - TM.8.1.sps' .
saveSheet             '06 - TM.8.1' .
insert file = 'MICS6 - 06 - TM.8.2.sps' .
saveSheet             '06 - TM.8.2' .
insert file = 'MICS6 - 06 - TM.8.3.sps' .
saveSheet             '06 - TM.8.3' .
insert file = 'MICS6 - 06 - TM.8.4.sps' .
saveSheet             '06 - TM.8.4' .
insert file = 'MICS6 - 06 - TM.8.5.sps' .
saveSheet             '06 - TM.8.5' .
insert file = 'MICS6 - 06 - TM.8.6.sps' .
saveSheet             '06 - TM.8.6' .
insert file = 'MICS6 - 06 - TM.8.7.sps' .
saveSheet             '06 - TM.8.7' .
insert file = 'MICS6 - 06 - TM.8.8.sps' .
saveSheet             '06 - TM.8.8' .
insert file = 'MICS6 - 06 - TM.8.9.sps' .
saveSheet             '06 - TM.8.9' .
insert file = 'MICS6 - 06 - TM.9.1&TM.9.2&TM.9.3&DQ.7.1&DQ7.2' .
saveSheet             '06 - TM.9.1&TM.9.2&TM.9.3&DQ.7.1&DQ7.2' .
insert file = 'MICS6 - 06 - TM.10.1W.sps' .
saveSheet             '06 - TM.10.1W' .
insert file = 'MICS6 - 06 - TM.10.1M.sps' .
saveSheet             '06 - TM.10.1M' .
insert file = 'MICS6 - 06 - TM.10.2W.sps' .
saveSheet             '06 - TM.10.2W' .
insert file = 'MICS6 - 06 - TM.10.2M.sps' .
saveSheet             '06 - TM.10.2M' .
insert file = 'MICS6 - 06 - TM.11.1W.sps' .
saveSheet             '06 - TM.11.1W' .
insert file = 'MICS6 - 06 - TM.11.1M.sps' .
saveSheet             '06 - TM.11.1M' .
insert file = 'MICS6 - 06 - TM.11.2W.sps' .
saveSheet             '06 - TM.11.2W' .
insert file = 'MICS6 - 06 - TM.11.2M.sps' .
saveSheet             '06 - TM.11.2M' .
insert file = 'MICS6 - 06 - TM.11.3W.sps' .
saveSheet             '06 - TM.11.3W' .
insert file = 'MICS6 - 06 - TM.11.3M.sps' .
saveSheet             '06 - TM.11.3M' .
insert file = 'MICS6 - 06 - TM.11.4W.sps' .
saveSheet             '06 - TM.11.4W' .
insert file = 'MICS6 - 06 - TM.11.4M.sps' .
saveSheet             '06 - TM.11.4M' .
insert file = 'MICS6 - 06 - TM.11.5.sps' .
saveSheet             '06 - TM.11.5'.
insert file = 'MICS6 - 06 - TM.11.6W.sps' .
saveSheet             '06 - TM.11.6W' .
insert file = 'MICS6 - 06 - TM.11.6M.sps' .
saveSheet             '06 - TM.11.6M' .
insert file = 'MICS6 - 06 - TM.12.1.sps' .
saveSheet             '06 - TM.12.1' .
insert file = 'MICS6 - 06 - TM.12.2.sps' .
saveSheet             '06 - TM.12.2'.


* Run Chapter 7. Thrive - Child health, nutrition and development.
insert file = 'MICS6 - 07 - TC.1.1 (12 - 23 mo).sps' .
saveSheet             '07 - TC.1.1 (12 - 23 mo)'. 
insert file = 'MICS6 - 07 - TC.1.1 (24 - 35 mo).sps' .
saveSheet             '07 - TC.1.1 (24 - 35 mo)'. 
insert file = 'MICS6 - 07 - TC.1.2.sps' .
saveSheet             '07 - TC.1.2'.
insert file = 'MICS6 - 07 - TC.2.1.sps' .
saveSheet             '07 - TC.2.1'.
insert file = 'MICS6 - 07 - TC.3.1.sps' .
saveSheet             '07 - TC.3.1'.
insert file = 'MICS6 - 07 - TC.3.2.sps' .
saveSheet             '07 - TC.3.2'.
insert file = 'MICS6 - 07 - TC.3.3.sps' .
saveSheet             '07 - TC.3.3'.
insert file = 'MICS6 - 07 - TC.3.4.sps' .
saveSheet             '07 - TC.3.4'.
insert file = 'MICS6 - 07 - TC.3.5.sps' .
saveSheet             '07 - TC.3.5'.
insert file = 'MICS6 - 07 - TC.4.1.sps' .
saveSheet             '07 - TC.4.1'.
insert file = 'MICS6 - 07 - TC.4.2.sps' .
saveSheet             '07 - TC.4.2'.
insert file = 'MICS6 - 07 - TC.4.3.sps' .
saveSheet             '07 - TC.4.3'.
insert file = 'MICS6 - 07 - TC.4.4.sps' .
saveSheet             '07 - TC.4.4'.
insert file = 'MICS6 - 07 - TC.4.5.sps' .
saveSheet             '07 - TC.4.5'.
insert file = 'MICS6 - 07 - TC.4.6.sps' .
saveSheet             '07 - TC.4.6'.
insert file = 'MICS6 - 07 - TC.4.7.sps' .
saveSheet             '07 - TC.4.7'.
insert file = 'MICS6 - 07 - TC.5.1.sps' .
saveSheet             '07 - TC.5.1'.
insert file = 'MICS6 - 07 - TC.6.1.sps' .
saveSheet             '07 - TC.6.1'.
insert file = 'MICS6 - 07 - TC.6.2.sps' .
saveSheet             '07 - TC.6.2'.
insert file = 'MICS6 - 07 - TC.6.3.sps' .
saveSheet             '07 - TC.6.3'.
insert file = 'MICS6 - 07 - TC.6.4.sps' .
saveSheet             '07 - TC.6.4'.
insert file = 'MICS6 - 07 - TC.6.5.sps' .
saveSheet             '07 - TC.6.5'.
insert file = 'MICS6 - 07 - TC.6.6.sps' .
saveSheet             '07 - TC.6.6'.
insert file = 'MICS6 - 07 - TC.6.7.sps' .
saveSheet             '07 - TC.6.7'.
insert file = 'MICS6 - 07 - TC.6.8.sps' .
saveSheet             '07 - TC.6.8'.
insert file = 'MICS6 - 07 - TC.6.9.sps' .
saveSheet             '07 - TC.6.9'.
insert file = 'MICS6 - 07 - TC.6.10.sps' .
saveSheet             '07 - TC.6.10'.
insert file = 'MICS6 - 07 - TC.6.11.sps' .
saveSheet             '07 - TC.6.11'.
insert file = 'MICS6 - 07 - TC.6.12.sps' .
saveSheet             '07 - TC.6.12'.
insert file = 'MICS6 - 07 - TC.6.13.sps' .
saveSheet             '07 - TC.6.13'.
insert file = 'MICS6 - 07 - TC.7.1.sps' .
saveSheet             '07 - TC.7.1'.
insert file = 'MICS6 - 07 - TC.7.2.sps' .
saveSheet             '07 - TC.7.2'.
insert file = 'MICS6 - 07 - TC.7.3.sps' .
saveSheet             '07 - TC.7.3'.
insert file = 'MICS6 - 07 - TC.7.4.sps' .
saveSheet             '07 - TC.7.4'.
insert file = 'MICS6 - 07 - TC.7.5.sps' .
saveSheet             '07 - TC.7.5'.
insert file = 'MICS6 - 07 - TC.7.6.sps' .
saveSheet             '07 - TC.7.6'.
insert file = 'MICS6 - 07 - TC.7.7.sps' .
saveSheet             '07 - TC.7.7'.
insert file = 'MICS6 - 07 - TC.7.8.sps' .
saveSheet             '07 - TC.7.8'.
insert file = 'MICS6 - 07 - TC.8.1.sps' .
saveSheet             '07 - TC.8.1'.
insert file = 'MICS6 - 07 - TC.9.1.sps' .
saveSheet             '07 - TC.9.1'.
insert file = 'MICS6 - 07 - TC.10.1.sps' .
saveSheet             '07 - TC.10.1'.
insert file = 'MICS6 - 07 - TC.10.2.sps' .
saveSheet             '07 - TC.10.2'.
insert file = 'MICS6 - 07 - TC.10.3.sps' .
saveSheet             '07 - TC.10.3'.
insert file = 'MICS6 - 07 - TC.11.1.sps' .
saveSheet             '07 - TC.11.1'.


* Run Chapter 8. Learn.
insert file = 'MICS6 - 08 - LN.1.1.sps' .
saveSheet             '08 - LN.1.1'. 
insert file = 'MICS6 - 08 - LN.1.2.sps' .
saveSheet             '08 - LN.1.2'. 
insert file = 'MICS6 - 08 - LN.2.1.sps' .
saveSheet             '08 - LN.2.1'. 
insert file = 'MICS6 - 08 - LN.2.2.sps' .
saveSheet             '08 - LN.2.2'. 
insert file = 'MICS6 - 08 - LN.2.3.sps' .
saveSheet             '08 - LN.2.3'. 
insert file = 'MICS6 - 08 - LN.2.4.sps' .
saveSheet             '08 - LN.2.4'. 
insert file = 'MICS6 - 08 - LN.2.5.sps' .
saveSheet             '08 - LN.2.5'. 
insert file = 'MICS6 - 08 - LN.2.6.sps' .
saveSheet             '08 - LN.2.6'. 
insert file = 'MICS6 - 08 - LN.2.7.sps' .
saveSheet             '08 - LN.2.7'. 
insert file = 'MICS6 - 08 - LN.2.8.sps' .
saveSheet             '08 - LN.2.8'. 
insert file = 'MICS6 - 08 - LN.3.1.sps' .
saveSheet             '08 - LN.3.1'. 
insert file = 'MICS6 - 08 - LN.3.2.sps' .
saveSheet             '08 - LN.3.2'. 
insert file = 'MICS6 - 08 - LN.3.3.sps' .
saveSheet             '08 - LN.3.3'. 
insert file = 'MICS6 - 08 - LN.4.1.sps' .
saveSheet             '08 - LN.4.1'. 
insert file = 'MICS6 - 08 - LN.4.2.sps' .
saveSheet             '08 - LN.4.2'. 

* Run Chapter 9. Protection from violence and exploitation.
insert file = 'MICS6 - 09 - PR.1.1.sps' .
saveSheet             '09 - PR.1.1'. 
insert file = 'MICS6 - 09 - PR.2.1.sps' .
saveSheet             '09 - PR.2.1'. 
insert file = 'MICS6 - 09 - PR.2.2.sps' .
saveSheet             '09 - PR.2.2'. 
insert file = 'MICS6 - 09 - PR.3.1.sps' .
saveSheet             '09 - PR.3.1'. 
insert file = 'MICS6 - 09 - PR.3.2.sps' .
saveSheet             '09 - PR.3.2'. 
insert file = 'MICS6 - 09 - PR.3.3.sps' .
saveSheet             '09 - PR.3.3'. 
insert file = 'MICS6 - 09 - PR.3.4.sps' .
saveSheet             '09 - PR.3.4'. 
insert file = 'MICS6 - 09 - PR.4.1W.sps' .
saveSheet             '09 - PR.4.1W'. 
insert file = 'MICS6 - 09 - PR.4.1M.sps' .
saveSheet             '09 - PR.4.1M'. 
insert file = 'MICS6 - 09 - PR.4.2W.sps' .
saveSheet             '09 - PR.4.2W'. 
insert file = 'MICS6 - 09 - PR.4.2M.sps' .
saveSheet             '09 - PR.4.2M'. 
insert file = 'MICS6 - 09 - PR.4.3.sps' .
saveSheet             '09 - PR.4.3'. 
insert file = 'MICS6 - 09 - PR.5.1.sps' .
saveSheet             '09 - PR.5.1'. 
insert file = 'MICS6 - 09 - PR.5.2.sps' .
saveSheet             '09 - PR.5.2'. 
insert file = 'MICS6 - 09 - PR.5.3.sps' .
saveSheet             '09 - PR.5.3'. 
insert file = 'MICS6 - 09 - PR.6.1W.sps' .
saveSheet             '09 - PR.6.1W'. 
insert file = 'MICS6 - 09 - PR.6.1M.sps' .
saveSheet             '09 - PR.6.1M'. 
insert file = 'MICS6 - 09 - PR.6.2W.sps' .
saveSheet             '09 - PR.6.2W'. 
insert file = 'MICS6 - 09 - PR.6.2M.sps' .
saveSheet             '09 - PR.6.2M'. 
insert file = 'MICS6 - 09 - PR.6.3W.sps' .
saveSheet             '09 - PR.6.3W'. 
insert file = 'MICS6 - 09 - PR.6.3M.sps' .
saveSheet             '09 - PR.6.3M'. 
insert file = 'MICS6 - 09 - PR.6.4W.sps' .
saveSheet             '09 - PR.6.4W'. 
insert file = 'MICS6 - 09 - PR.6.4M.sps' .
saveSheet             '09 - PR.6.4M'. 
insert file = 'MICS6 - 09 - PR.7.1W.sps' .
saveSheet             '09 - PR.7.1W'. 
insert file = 'MICS6 - 09 - PR.7.1M.sps' .
saveSheet             '09 - PR.7.1M'. 
insert file = 'MICS6 - 09 - PR.8.1W.sps' .
saveSheet             '09 - PR.8.1W'. 
insert file = 'MICS6 - 09 - PR.8.1M.sps' .
saveSheet             '09 - PR.8.1M'. 


* Run Chapter 10. Live in a safe and clean environment.
insert file = 'MICS6 - 10 - WS.1.1.sps' .
saveSheet             '10 - WS.1.1'. 
insert file = 'MICS6 - 10 - WS.1.2.sps' .
saveSheet             '10 - WS.1.2'. 
insert file = 'MICS6 - 10 - WS.1.3.sps' .
saveSheet             '10 - WS.1.3'. 
insert file = 'MICS6 - 10 - WS.1.4.sps' .
saveSheet             '10 - WS.1.4'. 
insert file = 'MICS6 - 10 - WS.1.5.sps' .
saveSheet             '10 - WS.1.5'. 
insert file = 'MICS6 - 10 - WS.1.6.sps' .
saveSheet             '10 - WS.1.6'. 
insert file = 'MICS6 - 10 - WS.1.7.sps' .
saveSheet             '10 - WS.1.7'. 
insert file = 'MICS6 - 10 - WS.1.8.sps' .
saveSheet             '10 - WS.1.8'. 
insert file = 'MICS6 - 10 - WS.1.9.sps' .
saveSheet             '10 - WS.1.9'. 
insert file = 'MICS6 - 10 - WS.2.1.sps' .
saveSheet             '10 - WS.2.1'. 
insert file = 'MICS6 - 10 - WS.3.1.sps' .
saveSheet             '10 - WS.3.1'. 
insert file = 'MICS6 - 10 - WS.3.2.sps' .
saveSheet             '10 - WS.3.2'. 
insert file = 'MICS6 - 10 - WS.3.3.sps' .
saveSheet             '10 - WS.3.3'. 
insert file = 'MICS6 - 10 - WS.3.4.sps' .
saveSheet             '10 - WS.3.4'. 
insert file = 'MICS6 - 10 - WS.3.5.sps' .
saveSheet             '10 - WS.3.5'. 
insert file = 'MICS6 - 10 - WS.3.6.sps' .
saveSheet             '10 - WS.3.6'. 
insert file = 'MICS6 - 10 - WS.4.1.sps' .
saveSheet             '10 - WS.4.1'. 
insert file = 'MICS6 - 10 - WS.4.2.sps' .
saveSheet             '10 - WS.4.2'. 


* Run Chapter 11.  Equitable chance in life. 
insert file = 'MICS6 - 11 - EQ.1.1.sps' .
saveSheet             '11 - EQ.1.1'. 
insert file = 'MICS6 - 11 - EQ.1.2.sps' .
saveSheet             '11 - EQ.1.2'. 
insert file = 'MICS6 - 11 - EQ.1.3.sps' .
saveSheet             '11 - EQ.1.3'. 
insert file = 'MICS6 - 11 - EQ.1.4.sps' .
saveSheet             '11 - EQ.1.4'. 
insert file = 'MICS6 - 11 - EQ.2.1W.sps' .
saveSheet             '11 - EQ.2.1W'. 
insert file = 'MICS6 - 11 - EQ.2.1M.sps' .
saveSheet             '11 - EQ.2.1M'. 
insert file = 'MICS6 - 11 - EQ.2.2.sps' .
saveSheet             '11 - EQ.2.2'. 
insert file = 'MICS6 - 11 - EQ.2.3.sps' .
saveSheet             '11 - EQ.2.3'. 
insert file = 'MICS6 - 11 - EQ.2.4.sps' .
saveSheet             '11 - EQ.2.4'. 
insert file = 'MICS6 - 11 - EQ.2.5.sps' .
saveSheet             '11 - EQ.2.5'. 
insert file = 'MICS6 - 11 - EQ.2.6.sps' .
saveSheet             '11 - EQ.2.6'. 
insert file = 'MICS6 - 11 - EQ.2.7.sps' .
saveSheet             '11 - EQ.2.7'. 
insert file = 'MICS6 - 11 - EQ.2.8.sps' .
saveSheet             '11 - EQ.2.8'. 
insert file = 'MICS6 - 11 - EQ.3.1W.sps' .
saveSheet             '11 - EQ.3.1W'. 
insert file = 'MICS6 - 11 - EQ.3.1M.sps' .
saveSheet             '11 - EQ.3.1M'. 
insert file = 'MICS6 - 11 - EQ.4.1W.sps' .
saveSheet             '11 - EQ.4.1W'. 
insert file = 'MICS6 - 11 - EQ.4.1M.sps' .
saveSheet             '11 - EQ.4.1M'. 
insert file = 'MICS6 - 11 - EQ.4.2W.sps' .
saveSheet             '11 - EQ.4.2W'. 
insert file = 'MICS6 - 11 - EQ.4.2M.sps' .
saveSheet             '11 - EQ.4.2M'. 


* Run Appendix 3. Estimates of Sampling Error.
insert file = 'SE MICS6 - 05 - CS.1&CS.2&CS.3 (BH).SPS' .
saveSheet             'AppC - SE.CS.1&CS.2&CS.3 (BH)' .
insert file = 'SE MICS6 - 06 - TM.1.1.SPS' .
saveSheet             'AppC - SE.TM.1.1' .
insert file = 'MICS6 - AC - 01 Sampling Error Calculation' .
saveSheet             'AppC - SE.01' .


* Run Appendix 4. Data Quality.
insert file = 'MICS6 - AD - DQ.1.1.SPS' .
saveSheet                   'AppD - DQ.1.1' .
insert file = 'MICS6 - AD - DQ.1.2W.SPS' .
saveSheet                   'AppD - DQ.1.2W' .
insert file = 'MICS6 - AD - DQ.1.2M.SPS' .
saveSheet                   'AppD - DQ.1.2M' .
insert file = 'MICS6 - AD - DQ.1.3.SPS' .
saveSheet                   'AppD - DQ.1.3' .
insert file = 'MICS6 - AD - DQ.1.4.SPS' .
saveSheet                   'AppD - DQ.1.4' .
insert file = 'MICS6 - AD - DQ.2.1.SPS' .
saveSheet                   'AppD - DQ.2.1' .
insert file = 'MICS6 - AD - DQ.2.2W.SPS' .
saveSheet                   'AppD - DQ.2.2W' .
insert file = 'MICS6 - AD - DQ.2.2M.SPS' .
saveSheet                   'AppD - DQ.2.2M' .
insert file = 'MICS6 - AD - DQ.2.3.SPS' .
saveSheet                   'AppD - DQ.2.3' .
insert file = 'MICS6 - AD - DQ.2.4.SPS' .
saveSheet                   'AppD - DQ.2.4' .
insert file = 'MICS6 - AD - DQ.2.5.SPS' .
saveSheet                   'AppD - DQ.2.5' .
insert file = 'MICS6 - AD - DQ.3.1.SPS' .
saveSheet                   'AppD - DQ.3.1' .
insert file = 'MICS6 - AD - DQ.3.2.SPS' .
saveSheet                   'AppD - DQ.3.2' .
insert file = 'MICS6 - AD - DQ.3.3W.SPS' .
saveSheet                   'AppD - DQ.3.3W' .
insert file = 'MICS6 - AD - DQ.3.3M.SPS' .
saveSheet                   'AppD - DQ.3.3M' .
insert file = 'MICS6 - AD - DQ.3.4.SPS' .
saveSheet                   'AppD - DQ.3.4' .
insert file = 'MICS6 - AD - DQ.3.5.SPS' .
saveSheet                   'AppD - DQ.3.5' .
insert file = 'MICS6 - AD - DQ.3.6.SPS' .
saveSheet                   'AppD - DQ.3.6' .
insert file = 'MICS6 - AD - DQ.3.7.SPS' .
saveSheet                   'AppD - DQ.3.7' .
insert file = 'MICS6 - AD - DQ.3.8.SPS' .
saveSheet                   'AppD - DQ.3.8' .
insert file = 'MICS6 - AD - DQ.4.1.SPS' .
saveSheet                   'AppD - DQ.4.1' .
insert file = 'MICS6 - AD - DQ.4.2.SPS' .
saveSheet                   'AppD - DQ.4.2' .
insert file = 'MICS6 - AD - DQ.4.3.SPS' .
saveSheet                   'AppD - DQ.4.3' .
insert file = 'MICS6 - AD - DQ.4.4.SPS' .
saveSheet                   'AppD - DQ.4.4' .
insert file = 'MICS6 - AD - DQ.5.1.SPS' .
saveSheet                   'AppD - DQ.5.1' .
insert file = 'MICS6 - AD - DQ.6.1.SPS' .
saveSheet                   'AppD - DQ.6.1' .
insert file = 'MICS6 - AD - DQ.6.2.SPS' .
saveSheet                   'AppD - DQ.6.2' .
insert file = 'MICS6 - AD - DQ.6.3.SPS' .
saveSheet                   'AppD - DQ.6.3' .
insert file = 'MICS6 - AD - DQ.6.4.SPS' .
saveSheet                   'AppD - DQ.6.4' .
omsend.
