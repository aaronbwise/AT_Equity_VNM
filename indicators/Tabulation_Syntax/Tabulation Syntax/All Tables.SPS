* Add the working directory if needed, e.g. cd "C:\MICS4\SPSS". or remove to use the default directory.
cd "C:\MICS4\SPSS".

* Run 01 HH Sample and Survey Characteristics set of tables.
insert file =  "MICS4 - 01 - HH.01.sps".
insert file =  "MICS4 - 01 - HH.02.sps".
insert file =  "MICS4 - 01 - HH.03.sps".
insert file =  "MICS4 - 01 - HH.04.sps".
insert file =  "MICS4 - 01 - HH.04M.sps".
insert file =  "MICS4 - 01 - HH.05.sps".

* Create the SPSS output with the 01 - HH set of tables.
output save outfile = "01 HH Sample and Survey Characteristics.spv".
* Export Output into an excel file.
output export
 /contents export = visible layers = printsetting modelviews = printsetting
 /xls documentfile = "01 HH Sample and Survey Characteristics.xls"
   operation = createfile
   location = lastcolumn notescaptions = yes.
* Close the ouput.
output close *.

* Run 02 CM Child Mortality tables.
insert file =  "MICS4 - 02 - CM.01&CM.02.sps".

* If Birth History was used: Run 02 CM Child Mortality tables.
*insert file =  "MICS4 - 02 - CM.01&CM02&CM.03 (BH Version).sps".

* Create the SPSS output with the 02 - CM set of tables.
output save outfile = "02 CM Child Mortality.spv".
* Export Output into an excel file.
output export
 /contents export = visible layers = printsetting modelviews = printsetting
 /xls documentfile = "02 CM Child Mortality.xls"
   operation = createfile
   location = lastcolumn notescaptions = yes.
* Close the ouput.
output close *.

* Run 03 NU Nutrition set of tables.
insert file =  "MICS4 - 03 - NU.01.sps".
insert file =  "MICS4 - 03 - NU.02.sps".
insert file =  "MICS4 - 03 - NU.03.sps".
insert file =  "MICS4 - 03 - NU.04.sps".
insert file =  "MICS4 - 03 - NU.05.sps".
insert file =  "MICS4 - 03 - NU.06.sps".
insert file =  "MICS4 - 03 - NU.07.sps".
insert file =  "MICS4 - 03 - NU.08.sps".
insert file =  "MICS4 - 03 - NU.09.sps".
insert file =  "MICS4 - 03 - NU.10.sps".
insert file =  "MICS4 - 03 - NU.11.sps".
insert file = "MICS4 - 03 - NU.01 NCHS standard.sps".

* Create the SPSS output with the 03 - NU set of tables.
output save outfile = "03 NU Nutrition.spv".
* Export Output into an excel file.
output export
 /contents export = visible layers = printsetting modelviews = printsetting
 /xls documentfile = "03 NU Nutrition.xls"
   operation = createfile
   location = lastcolumn notescaptions = yes.
* Close the ouput.
output close *.

* Run 04 CH Child Health set of tables.
insert file =  "MICS4 - 04 - CH.01.sps".
insert file =  "MICS4 - 04 - CH.02.sps".
insert file =  "MICS4 - 04 - CH.03.sps".
insert file =  "MICS4 - 04 - CH.04.sps".
insert file =  "MICS4 - 04 - CH.05.sps".
insert file =  "MICS4 - 04 - CH.06.sps".
insert file =  "MICS4 - 04 - CH.07.sps".
insert file =  "MICS4 - 04 - CH.08.sps".
insert file =  "MICS4 - 04 - CH.09.sps".
insert file =  "MICS4 - 04 - CH.10.sps".
insert file =  "MICS4 - 04 - CH.11.sps".
insert file =  "MICS4 - 04 - CH.12.sps".
insert file =  "MICS4 - 04 - CH.13.sps".
insert file =  "MICS4 - 04 - CH.14.sps".
insert file =  "MICS4 - 04 - CH.15.sps".
insert file =  "MICS4 - 04 - CH.16.sps".
insert file =  "MICS4 - 04 - CH.17.sps".

* Create the SPSS output with the 04 - CH set of tables.
output save outfile = "04 CH Child Health.spv".
* Export Output into an excel file.
output export
 /contents export = visible layers = printsetting modelviews = printsetting
 /xls documentfile = "04 CH Child Health.xls"
   operation = createfile
   location = lastcolumn notescaptions = yes.
* Close the ouput.
output close *.

* Run 05 WS Water and Sanitation set of tables.
insert file =  "MICS4 - 05 - WS.01.sps".
insert file =  "MICS4 - 05 - WS.02.sps".
insert file =  "MICS4 - 05 - WS.03.sps".
insert file =  "MICS4 - 05 - WS.04.sps".
insert file =  "MICS4 - 05 - WS.05.sps".
insert file =  "MICS4 - 05 - WS.06.sps".
insert file =  "MICS4 - 05 - WS.07.sps".
insert file =  "MICS4 - 05 - WS.08.sps".
insert file =  "MICS4 - 05 - WS.09.sps".
insert file =  "MICS4 - 05 - WS.10.sps".

* Create the SPSS output with the 05 - WS set of tables.
output save outfile = "05 WS Water and Sanitation.spv".
* Export Output into an excel file.
output export
 /contents export = visible layers = printsetting modelviews = printsetting
 /xls documentfile = "05 WS Water and Sanitation.xls"
   operation = createfile
   location = lastcolumn notescaptions = yes.
* Close the ouput.
output close *.

* Run 06 RH Reproductive Health set of tables.
insert file =  "MICS4 - 06 - RH.01.sps".
* if BH is included run BH version of RH.01 table.
*insert file = "MICS4 - 06 - RH.01 (BH Version).sps".
insert file =  "MICS4 - 06 - RH.02.sps".
insert file =  "MICS4 - 06 - RH.03.sps".
insert file =  "MICS4 - 06 - RH.04.sps".
insert file =  "MICS4 - 06 - RH.05.sps".
insert file =  "MICS4 - 06 - RH.06.sps".
insert file =  "MICS4 - 06 - RH.07.sps".
insert file =  "MICS4 - 06 - RH.08.sps".
insert file =  "MICS4 - 06 - RH.09.sps".
insert file =  "MICS4 - 06 - RH.10.sps".
insert file =  "MICS4 - 06 - RH.11.sps".
insert file =  "MICS4 - 06 - RH.12.sps".
insert file =  "MICS4 - 06 - RH.13.sps".
insert file =  "MICS4 - 06 - RH.14.sps".
insert file =  "MICS4 - 06 - RH.15.sps".
insert file =  "MICS4 - 06 - RH.16.sps".

* Create the SPSS output with the 06 - RH set of tables.
output save outfile = "06 RH Reproductive Health.spv".
* Export Output into an excel file.
output export
 /contents export = visible layers = printsetting modelviews = printsetting
 /xls documentfile = "06 RH Reproductive Health.xls"
   operation = createfile
   location = lastcolumn notescaptions = yes.
* Close the ouput.
output close *.

* Run 07 CD Child Development set of tables.
insert file =  "MICS4 - 07 - CD.01.sps".
insert file =  "MICS4 - 07 - CD.02.sps".
insert file =  "MICS4 - 07 - CD.03.sps".
insert file =  "MICS4 - 07 - CD.04.sps".
insert file =  "MICS4 - 07 - CD.05.sps".

* Create the SPSS output with the 07 - CD set of tables.
output save outfile = "07 CD Child Development.spv".
* Export Output into an excel file.
output export
 /contents export = visible layers = printsetting modelviews = printsetting
 /xls documentfile = "07 CD Child Development.xls"
   operation = createfile
   location = lastcolumn notescaptions = yes.
* Close the ouput.
output close *.

* Run 08 ED Education set of tables.
insert file =  "MICS4 - 08 - ED.01.sps".
insert file =  "MICS4 - 08 - ED.01M.sps".
insert file =  "MICS4 - 08 - ED.02.sps".
insert file =  "MICS4 - 08 - ED.03.sps".
insert file =  "MICS4 - 08 - ED.04.sps".
insert file =  "MICS4 - 08 - ED.05.sps".
insert file =  "MICS4 - 08 - ED.06.sps".
insert file =  "MICS4 - 08 - ED.07.sps".
insert file =  "MICS4 - 08 - ED.08.sps".

* Create the SPSS output with the 08 - ED set of tables.
output save outfile = "08 ED Education.spv".
* Export Output into an excel file.
output export
 /contents export = visible layers = printsetting modelviews = printsetting
 /xls documentfile = "08 ED Education.xls"
   operation = createfile
   location = lastcolumn notescaptions = yes.
* Close the ouput.
output close *.

* Run 09 CP Child Protection set of tables.
insert file =  "MICS4 - 09 - CP.01.sps".
insert file =  "MICS4 - 09 - CP.02.sps".
insert file =  "MICS4 - 09 - CP.03.sps".
insert file =  "MICS4 - 09 - CP.04.sps".
insert file =  "MICS4 - 09 - CP.05.sps".
insert file =  "MICS4 - 09 - CP.05M.sps".
insert file =  "MICS4 - 09 - CP.06.sps".
insert file =  "MICS4 - 09 - CP.06M.sps".
insert file =  "MICS4 - 09 - CP.07.sps".
insert file =  "MICS4 - 09 - CP.08.sps".
insert file =  "MICS4 - 09 - CP.09.sps".
insert file =  "MICS4 - 09 - CP.10.sps".
insert file =  "MICS4 - 09 - CP.11.sps".
insert file =  "MICS4 - 09 - CP.11M.sps".

* Create the SPSS output with the 09 - CP set of tables.
output save outfile = "09 CP Child Protection.spv".
* Export Output into an excel file.
output export
 /contents export = visible layers = printsetting modelviews = printsetting
 /xls documentfile = "09 CP Child Protection.xls"
   operation = createfile
   location = lastcolumn notescaptions = yes.
* Close the ouput.
output close *.

* Run 10 HA HIV-AIDS, Sexual Behaviour and Orphans set of tables.
insert file =  "MICS4 - 10 - HA.01.sps".
insert file =  "MICS4 - 10 - HA.01M.sps".
insert file =  "MICS4 - 10 - HA.02.sps".
insert file =  "MICS4 - 10 - HA.02M.sps".
insert file =  "MICS4 - 10 - HA.03.sps".
insert file =  "MICS4 - 10 - HA.03M.sps".
insert file =  "MICS4 - 10 - HA.04.sps".
insert file =  "MICS4 - 10 - HA.04M.sps".
insert file =  "MICS4 - 10 - HA.05.sps".
insert file =  "MICS4 - 10 - HA.05M.sps".
insert file =  "MICS4 - 10 - HA.06.sps".
insert file =  "MICS4 - 10 - HA.06M.sps".
insert file =  "MICS4 - 10 - HA.07.sps".
insert file =  "MICS4 - 10 - HA.08.sps".
insert file =  "MICS4 - 10 - HA.08M.sps".
insert file =  "MICS4 - 10 - HA.09.sps".
insert file =  "MICS4 - 10 - HA.09M.sps".
insert file =  "MICS4 - 10 - HA.10.sps".
insert file =  "MICS4 - 10 - HA.10M.sps".
insert file =  "MICS4 - 10 - HA.11.sps".
insert file =  "MICS4 - 10 - HA.11M.sps".
insert file =  "MICS4 - 10 - HA.12.sps".
insert file =  "MICS4 - 10 - HA.13.sps".

* Create the SPSS output with the 10 - HA set of tables.
output save outfile = "10 HA HIV-AIDS, Sexual Behaviour and Orphans.spv".
* Export Output into an excel file.
output export
 /contents export = visible layers = printsetting modelviews = printsetting
 /xls documentfile = "10 HA HIV-AIDS, Sexual Behaviour and Orphans.xls"
   operation = createfile
   location = lastcolumn notescaptions = yes.
* Close the ouput.
output close *.

