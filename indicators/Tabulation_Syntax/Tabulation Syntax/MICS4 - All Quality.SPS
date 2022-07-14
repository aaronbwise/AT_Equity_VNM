* Running all data quality tables.

include "MICS4 - Table DQ.1.sps".
include "MICS4 - Table DQ.2.sps".
include "MICS4 - Table DQ.2M.sps".
include "MICS4 - Table DQ.3.sps".
include "MICS4 - Table DQ.4.sps".
include "MICS4 - Table DQ.4M.sps".
include "MICS4 - Table DQ.5.sps".
include "MICS4 - Table DQ.6.sps".
include "MICS4 - Table DQ.7.sps".
include "MICS4 - Table DQ.8.sps".
include "MICS4 - Table DQ.9.sps".
include "MICS4 - Table DQ.10.sps".
include "MICS4 - Table DQ.11.sps".
include "MICS4 - Table DQ.12.sps".
include "MICS4 - Table DQ.13.sps".
include "MICS4 - Table DQ.14.sps".
include "MICS4 - Table DQ.15.sps".
include "MICS4 - Table DQ.16.sps".
include "MICS4 - Table DQ.17 (BH).sps".
include "MICS4 - Table DQ.18 (BH).sps".
include "MICS4 - Table DQ.19 (BH).sps".

* Create the SPSS output with the DQ set of tables.
output save outfile = "Country MICS4 DQ Tables.spv".
* Export Output into an excel file.
output export
 /contents export = visible layers = printsetting modelviews = printsetting
 /xls documentfile = "Country MICS4 DQ Tables.xls"
   operation = createfile
   location = lastcolumn notescaptions = yes.
* Close the ouput.
output close *.