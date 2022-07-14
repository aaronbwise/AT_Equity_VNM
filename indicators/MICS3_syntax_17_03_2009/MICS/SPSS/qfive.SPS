* SET PRINTBACK = OFF.

PRESERVE.
SET ERRORS=NONE.
FILE HANDLE lifetabledir /NAME='C:\MICS\SPSS\lifetables' .
RESTORE. 

* Find mean children ever born per woman .
COMPUTE mceb = ceb / numwomen .

* Find proportion children dead .
COMPUTE propcd = deadkids / ceb .

SET MXLOOP = 50.

MATRIX.
GET wage /VARIABLES wage /FILE=* .
GET ceb /VARIABLES ceb /FILE=* .
GET deadkids /VARIABLES deadkids /FILE=* .
GET numwomen /VARIABLES numwomen /FILE=* .
GET mceb /VARIABLES mceb /FILE=* .
GET propcd /VARIABLES propcd /FILE=* .
GET meanage /VARIABLES meanage /FILE=* .
GET syear /VARIABLES syear /FILE=* .
GET smonth /VARIABLES smonth /FILE=* .
GET sex/VARIABLES sex/FILE=* .

COMPUTE age = {1; 2; 3; 5; 10; 15; 20} .

COMPUTE A = mceb(1)/mceb(2) .
COMPUTE B = mceb(2)/mceb(3) .

COMPUTE ABage = { 1; A; B; meanage(1)} .
COMPUTE AB = { 1; A; B} .

* Get coefficients for creating ak .
GET akcolat /VARIABLES akcoeflat1 to akcoeflat4 /FILE='lifetables\akcoef.sav' .
GET akcochi /VARIABLES akcoefchi1 to akcoefchi4 /FILE='lifetables\akcoef.sav' .
GET akcosa /VARIABLES akcoefsa1 to akcoefsa4 /FILE='lifetables\akcoef.sav' .
GET akcofa /VARIABLES akcoeffa1 to akcoeffa4 /FILE='lifetables\akcoef.sav' .
GET akcoge /VARIABLES akcoefge1 to akcoefge4 /FILE='lifetables\akcoef.sav' .
GET akcono /VARIABLES akcoefno1 to akcoefno3 /FILE='lifetables\akcoef.sav' .
GET akcoso /VARIABLES akcoefso1 to akcoefso3 /FILE='lifetables\akcoef.sav' .
GET akcoea /VARIABLES akcoefea1 to akcoefea3 /FILE='lifetables\akcoef.sav' .
GET akcowe /VARIABLES akcoefwe1 to akcoefwe3 /FILE='lifetables\akcoef.sav' .

COMPUTE AKlat = akcolat*ABage .
COMPUTE AKchi = akcochi*ABage .
COMPUTE AKsa = akcosa*ABage .
COMPUTE AKfa = akcofa*ABage .
COMPUTE AKge = akcoge*ABage .
COMPUTE AKno = akcono*AB .
COMPUTE AKso = akcoso*AB .
COMPUTE AKea = akcoea*AB .
COMPUTE AKwe = akcowe*AB .

COMPUTE Qilat = AKlat&*propcd .
COMPUTE Qichi = AKchi&*propcd .
COMPUTE Qisa = AKsa&*propcd .
COMPUTE Qifa = AKfa&*propcd .
COMPUTE Qige = AKge&*propcd .
COMPUTE Qino = AKno&*propcd .
COMPUTE Qiso = AKso&*propcd .
COMPUTE Qiea = AKea&*propcd .
COMPUTE Qiwe = AKwe&*propcd .

* Get coefficients for finding t(x) and reference date .
GET eco /FILE='lifetables\e.sav' .
GET fco  /FILE='lifetables\f.sav' .
GET gco /FILE='lifetables\g.sav' .

COMPUTE tstar = TRANSPOS(eco + A*fco + B*gco).
COMPUTE surdate = syear(1) + ((smonth(1) - 0.5)/12).
COMPUTE refdate = surdate - tstar .

* PRINT Qilat .
* PRINT tstar .
* PRINT refdate .


COMPUTE Qi = { Qilat, Qichi, Qisa, Qifa, Qige, Qino, Qiso, Qiea, Qiwe} .

COMPUTE IMR = tstar*0.
COMPUTE U5MR = IMR.
COMPUTE CMR = IMR.

* Read lifetables .
DO IF (sex(1) = 1) .
+        GET fulltab /FILE='lifetables\lifetablesmale.sav' .
ELSE IF (sex(1) = 2) .
+        GET fulltab /FILE='lifetables\lifetablesfemale.sav' .
ELSE .
+        GET fulltab /FILE='lifetables\lifetablesboth.sav' .
END IF.

COMPUTE end = 0.
LOOP K = 1 TO 9.
* Extract lifetable for the current model .
+    DO IF (K > 5).
+        COMPUTE start = end + 1 .
+        COMPUTE end = 5*41+ (K-5)*25 .
+        COMPUTE lifetab = fulltab(start:end,:) .
+        COMPUTE numrows = 25 .
+    ELSE .
+        COMPUTE start = end + 1 .
+        COMPUTE end = (K)*41 .
+        COMPUTE lifetab = fulltab(start:end,:) .
+        COMPUTE numrows = 41 .
+    END IF.

+    LOOP J = 1 TO 7.
* Check bounds.
+        DO IF (lifetab(1, J) < Qi(J,K)).
+            COMPUTE IMR(J,K) = 0.999.
+            COMPUTE U5MR(J,K) = 0.999.
+            COMPUTE CMR(J,K) = 0.999.
+        ELSE IF (lifetab(NROW(lifetab),J) > Qi(J,K)).
+            COMPUTE IMR(J,K) = 0.
+            COMPUTE U5MR(J,K) = 0.
+            COMPUTE CMR(J,K) = 0.
+        ELSE.
+            LOOP I = 1 TO numrows .
+                DO IF (lifetab(I,J) <= Qi(J,K)).
+                    BREAK.
+                END IF.
+            END LOOP.
+            COMPUTE HF = (Qi(J,K) - lifetab(I-1,J))/(lifetab(I,J) - lifetab(I-1,J)).
+            COMPUTE IMR(J,K) = (1 - HF)*lifetab(I-1,1) + HF*lifetab(I,1).
+            COMPUTE U5MR(J,K) = (1 - HF)*lifetab(I-1,4) + HF*lifetab(I,4).
+            COMPUTE CMR(J,K) = (U5MR(J,K)-IMR(J,K))/(1 - IMR(J,K)).
*+            PRINT I.
*+            PRINT HF.
*+            PRINT lifetab(I,J).
*+            PRINT lifetab(I-1,J).
*+            PRINT IMR(J,1).
+        END IF.
+    END LOOP.
END LOOP.

*PRINT Qilat.
*PRINT HF.
* PRINT refdate.
* PRINT tstar.
* PRINT Qi.
* PRINT IMR.
* PRINT U5MR.
* PRINT CMR.

SAVE {wage, ceb, deadkids, numwomen, mceb, propcd, age,
	Qi(:,1), refdate(:,1), tstar(:,1), IMR(:,1), U5MR(:,1), CMR(:,1),
	Qi(:,2), refdate(:,2), tstar(:,2), IMR(:,2), U5MR(:,2), CMR(:,2),
	Qi(:,3), refdate(:,3), tstar(:,3), IMR(:,3), U5MR(:,3), CMR(:,3),
	Qi(:,4), refdate(:,4), tstar(:,4), IMR(:,4), U5MR(:,4), CMR(:,4),
	Qi(:,5), refdate(:,5), tstar(:,5), IMR(:,5), U5MR(:,5), CMR(:,5),
	Qi(:,6), refdate(:,6), tstar(:,6), IMR(:,6), U5MR(:,6), CMR(:,6),
	Qi(:,7), refdate(:,7), tstar(:,7), IMR(:,7), U5MR(:,7), CMR(:,7),
	Qi(:,8), refdate(:,8), tstar(:,8), IMR(:,8), U5MR(:,8), CMR(:,8),
	Qi(:,9), refdate(:,9), tstar(:,9), IMR(:,9), U5MR(:,9), CMR(:,9)} 
	/OUTFILE=* 
	/VARIABLES wage, ceb, deadkids, numwomen, mceb, propcd, age,
	qilat, refdatelat, tstarlat, imrlat, u5mrlat, cmrlat, 
	qichi, refdatechi, tstarchi, imrchi, u5mrchi, cmrchi,
	qisa, refdatesa, tstarsa, imrsa, u5mrsa, cmrsa, 
	qifa, refdatefa, tstarfa, imrfa, u5mrfa, cmrfa, 
	qige, refdatege, tstarge, imrge, u5mrge, cmrge, 
	qino, refdateno, tstarno, imrno, u5mrno, cmrno, 
	qiso, refdateso, tstarso, imrso, u5mrso, cmrso, 
	qiea, refdateea, tstarea, imrea, u5mrea, cmrea, 
	qiwe, refdatewe, tstarwe, imrwe, u5mrwe, cmrwe.
END MATRIX .

VARIABLE LABEL
	wage 'Age group' 
	ceb 'Children ever born' 
	deadkids 'Children dead' 
	numwomen 'Total number of women' 
	mceb 'Mean children ever born' 
	propcd 'Proportion children dead of born'
	age 'Age i' .

VALUE LABEL wage 1 '15-19' 2 '20-24' 3 '25-29' 4 '30-34' 5 '35-39' 6 '40-44' 7 '45-49' .

VARIABLE LABEL
	qilat 'Q(i) Latin America' 
	refdatelat 'Reference date Latin America '
	tstarlat 't(i) Latin America' 
	imrlat 'Infant Mortality Rate Latin America' 
	cmrlat 'Child Mortality Rate Latin America' 
	u5mrlat 'Under-five Mortality Rate Latin America' .

VARIABLE LABEL
	qisa 'Q(i) South Asian' 
	refdatesa 'Reference date South Asian'
	tstarsa 't(i) South Asian' 
	imrsa 'Infant Mortality Rate South Asian' 
	cmrsa 'Child Mortality Rate South Asian' 
	u5mrsa 'Under-five Mortality Rate South Asian' .

VARIABLE LABEL
	qichi 'Q(i) Chilean' 
	refdatechi 'Reference date Chilean '
	tstarchi 't(i) Chilean' 
	imrchi 'Infant Mortality Rate Chilean'
	cmrchi 'Child Mortality Rate Chilean' 
	u5mrchi 'Under-five Mortality Rate Chilean' .

VARIABLE LABEL
	qifa 'Q(i) Far East' 
	refdatefa 'Reference date Far East '
	tstarfa 't(i) Far East' 
	imrfa 'Infant Mortality Rate Far East' 
	cmrfa 'Child Mortality Rate Far East' 
	u5mrfa 'Under-five Mortality Rate Far East' .

VARIABLE LABEL
	qige 'Q(i) General' 
	refdatege 'Reference date General '
	tstarge 't(i) General' 
	imrge 'Infant Mortality Rate General' 
	cmrge 'Child Mortality Rate General' 
	u5mrge 'Under-five Mortality Rate General' .

VARIABLE LABEL
	qino 'Q(i) North' 
	refdateno 'Reference date North '
	tstarno 't(i) North' 
	imrno 'Infant Mortality Rate North' 
	cmrno 'Child Mortality Rate North' 
	u5mrno 'Under-five Mortality Rate North' .

VARIABLE LABEL
	qiso 'Q(i) South' 
	refdateso 'Reference date South '
	tstarso 't(i) South' 
	imrso 'Infant Mortality Rate South' 
	cmrso 'Child Mortality Rate South' 
	u5mrso 'Under-five Mortality Rate South' .

VARIABLE LABEL
	qiea 'Q(i) East' 
	refdateea 'Reference date East '
	tstarea 't(i) East' 
	imrea 'Infant Mortality Rate East' 	
	cmrea 'Child Mortality Rate East' 
	u5mrea 'Under-five Mortality Rate East' .

VARIABLE LABEL
	qiwe 'Q(i) West' 
	refdatewe 'Reference date West '
	tstarwe 't(i) West' 
	imrwe 'Infant Mortality Rate West'
	cmrwe 'Child Mortality Rate West' 
	u5mrwe 'Under-five Mortality Rate West' .

FORMATS age (F8.0) ceb (F8.0) deadkids (F8.0) numwomen (F8.0) mceb (F8.3) propcd (F8.3).
FORMATS qilat (F8.3) /tstarlat (F8.1) /refdatelat (F8.1) /imrlat (F8.3) /u5mrlat (F8.3) /cmrlat (F8.3) .
FORMATS qifa (F8.3) /tstarfa (F8.1) /refdatefa (F8.1) /imrfa (F8.3) /u5mrfa (F8.3) /cmrfa (F8.3) .
FORMATS qisa (F8.3) /tstarsa (F8.1) /refdatesa (F8.1) /imrsa (F8.3) /u5mrsa (F8.3) /cmrsa (F8.3) .
FORMATS qichi (F8.3) /tstarchi (F8.1) /refdatechi (F8.1) /imrchi (F8.3) /u5mrchi (F8.3) /cmrchi (F8.3) .
FORMATS qige (F8.3) /tstarge (F8.1) /refdatege (F8.1) /imrge (F8.3) /u5mrge (F8.3) /cmrge (F8.3) .
FORMATS qino (F8.3) /tstarno (F8.1) /refdateno (F8.1) /imrno (F8.3) /u5mrno (F8.3) /cmrno (F8.3) .
FORMATS qiso (F8.3) /tstarso (F8.1) /refdateso (F8.1) /imrso (F8.3) /u5mrso (F8.3) /cmrso (F8.3) .
FORMATS qiea (F8.3) /tstarea (F8.1) /refdateea (F8.1) /imrea (F8.3) /u5mrea (F8.3) /cmrea (F8.3) .
FORMATS qiwe (F8.3) /tstarwe (F8.1) /refdatewe (F8.1) /imrwe (F8.3) /u5mrwe (F8.3) /cmrwe (F8.3) .

EXECUTE.

