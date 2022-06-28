* Encoding: windows-1252.
* SET PRINTBACK = OFF.

PRESERVE.
SET ERRORS=NONE.
FILE HANDLE lifetabledir /NAME='lifetablesTSFB' .
RESTORE. 

* Find mean children ever born per woman .
COMPUTE mceb = ceb / numwomen .

* Find proportion children dead .
COMPUTE propcd = cdead / ceb .

SET MXLOOP = 100.

MATRIX.
GET tsfb /VARIABLES tsfb /FILE=* .
GET ceb /VARIABLES ceb /FILE=* .
GET cdead /VARIABLES cdead /FILE=* .
GET numwomen /VARIABLES numwomen /FILE=* .
GET mceb /VARIABLES mceb /FILE=* .
GET propcd /VARIABLES propcd /FILE=* .
GET meanAge /VARIABLES meanAge /FILE=* .
GET syear /VARIABLES syear /FILE=* .
GET smonth /VARIABLES smonth /FILE=* .
GET sex /VARIABLES sex /FILE=* .

COMPUTE age = {2; 5; 5; 5; 15} .

COMPUTE A = mceb(1)/mceb(2) .
COMPUTE B = mceb(2)/mceb(3) .

COMPUTE ABage = { 1; A; B; meanAge(1)} .
COMPUTE AB = { 1; A; B} .

* Get coefficients for creating ak .
GET akcono /VARIABLES akcoefno1 to akcoefno3 /FILE='lifetabledir\akcoef.sav' .
GET akcoso /VARIABLES akcoefso1 to akcoefso3 /FILE='lifetabledir\akcoef.sav' .
GET akcoea /VARIABLES akcoefea1 to akcoefea3 /FILE='lifetabledir\akcoef.sav' .
GET akcowe /VARIABLES akcoefwe1 to akcoefwe3 /FILE='lifetabledir\akcoef.sav' .

* AK(i) = a(i) + b(i)*A + c(i)*B.
COMPUTE AKno = akcono*AB .
COMPUTE AKso = akcoso*AB .
COMPUTE AKea = akcoea*AB .
COMPUTE AKwe = akcowe*AB .

COMPUTE Qino = AKno&*propcd .
COMPUTE Qiso = AKso&*propcd .
COMPUTE Qiea = AKea&*propcd .
COMPUTE Qiwe = AKwe&*propcd .

* Get coefficients for finding t(x) and reference date .
GET dco /FILE='lifetabledir\d.sav' .
GET eco /FILE='lifetabledir\e.sav' .
GET fco  /FILE='lifetabledir\f.sav' .

COMPUTE tstar = TRANSPOS(dco + A*eco + B*fco).
COMPUTE surdate = syear(1) + ((smonth(1) - 0.5)/12).
COMPUTE refdate = surdate - tstar .

* PRINT tstar .
* PRINT refdate .

COMPUTE Qi = { Qino, Qiso, Qiea, Qiwe } .

COMPUTE IMR = tstar*0.
COMPUTE U5MR = IMR.
COMPUTE CMR = IMR.

* Read lifetables .
DO IF (sex(1) = 1) .
+        GET fulltab /FILE='lifetabledir\lifetablesmale.sav' .
ELSE IF (sex(1) = 2) .
+        GET fulltab /FILE='lifetabledir\lifetablesfemale.sav' .
ELSE .
+        GET fulltab /FILE='lifetabledir\lifetablesboth.sav' .
END IF.

* Place start/end after UN life tables to begin with Coale/Demeny Life tables.
COMPUTE end = 5*81.

* for each model.
LOOP K = 1 TO 4.
* Extract lifetable for the current model .
+        COMPUTE start = end + 1 .
+        COMPUTE end = (5 + K)*81.
+        COMPUTE lifetab = fulltab(start:end,:) .
+        COMPUTE numrows = 81 .

* for all periods.
+    LOOP J = 1 TO 5.
+        DO IF (J = 1).
+            COMPUTE M = 2.
+        ELSE IF (J = 5).
+            COMPUTE M = 6.
+        ELSE.
+            COMPUTE M = 4.
+        END IF.
* Check bounds.
+        DO IF (Qi(J,K) = 0).
+            COMPUTE IMR(J,K) = 0.
+            COMPUTE U5MR(J,K) = 0.
+            COMPUTE CMR(J,K) = 0.
+        ELSE IF (lifetab(1, M) < Qi(J,K)).
+            COMPUTE IMR(J,K) = 0.999.
+            COMPUTE U5MR(J,K) = 0.999.
+            COMPUTE CMR(J,K) = 0.999.
+        ELSE IF (lifetab(NROW(lifetab),M) > Qi(J,K)).
+            COMPUTE IMR(J,K) = -0.999.
+            COMPUTE U5MR(J,K) = -0.999.
+            COMPUTE CMR(J,K) = -0.999.
+        ELSE.
+            LOOP I = 1 TO numrows .
+                DO IF (lifetab(I,M) <= Qi(J,K)).
+                    BREAK.
+                END IF.
+            END LOOP.
+            COMPUTE HF = (Qi(J,K) - lifetab(I-1,M))/(lifetab(I,M) - lifetab(I-1,M)).
+            COMPUTE IMR(J,K) = ( (1 - HF)*lifetab(I-1,1) + HF*lifetab(I,1) ) *1000.
+            COMPUTE U5MR(J,K) = ( (1 - HF)*lifetab(I-1,4) + HF*lifetab(I,4) ) *1000.
+            COMPUTE CMR(J,K) = (U5MR(J,K)-IMR(J,K))/(1 - IMR(J,K)).
*+            PRINT I.
*+            PRINT HF.
*+            PRINT lifetab(I,J).
*+            PRINT lifetab(I-1,J).
*+            PRINT IMR(J,1).
+        END IF.
+    END LOOP.
END LOOP.

* PRINT HF.
* PRINT refdate.
* PRINT tstar.
* PRINT Qi.
* PRINT IMR.
* PRINT U5MR.
* PRINT CMR.

SAVE {tsfb, ceb, cdead, numwomen, mceb, propcd, age,
    Qi(:,1), refdate(:,1), tstar(:,1), IMR(:,1), U5MR(:,1), CMR(:,1),
    Qi(:,2), refdate(:,2), tstar(:,2), IMR(:,2), U5MR(:,2), CMR(:,2),
    Qi(:,3), refdate(:,3), tstar(:,3), IMR(:,3), U5MR(:,3), CMR(:,3),
    Qi(:,4), refdate(:,4), tstar(:,4), IMR(:,4), U5MR(:,4), CMR(:,4)}
    /OUTFILE=* 
    /VARIABLES tsfb, ceb, cdead, numwomen, mceb, propcd, age,
    qino, refdateno, tstarno, imrno, u5mrno, cmrno, 
    qiso, refdateso, tstarso, imrso, u5mrso, cmrso, 
    qiea, refdateea, tstarea, imrea, u5mrea, cmrea, 
    qiwe, refdatewe, tstarwe, imrwe, u5mrwe, cmrwe.
END MATRIX .

VARIABLE LABELS
    tsfb 'Time since first birth' 
    ceb 'Children ever born' 
    cdead 'Children dead' 
    numwomen 'Total number of women' 
    mceb 'Mean children ever born' 
    propcd 'Proportion children dead of born'
    age 'Age x' .

VALUE LABELS tsfb 1 '0-4' 2 '5-9' 3 '10-14' 4 '15-19' 5 '20-24'.

VARIABLE LABELS
    qino 'Q(x) North' 
    refdateno 'Reference date North '
    tstarno 't(x) North' 
    imrno 'Infant Mortality Rate North' 
    cmrno 'Child Mortality Rate North' 
    u5mrno 'Under-five Mortality Rate North' .

VARIABLE LABELS
    qiso 'Q(x) South' 
    refdateso 'Reference date South '
    tstarso 't(x) South' 
    imrso 'Infant Mortality Rate South' 
    cmrso 'Child Mortality Rate South' 
    u5mrso 'Under-five Mortality Rate South' .

VARIABLE LABELS
    qiea 'Q(x) East' 
    refdateea 'Reference date East '
    tstarea 't(x) East' 
    imrea 'Infant Mortality Rate East'     
    cmrea 'Child Mortality Rate East' 
    u5mrea 'Under-five Mortality Rate East' .

VARIABLE LABELS
    qiwe 'Q(x) West' 
    refdatewe 'Reference date West '
    tstarwe 't(x) West' 
    imrwe 'Infant Mortality Rate West'
    cmrwe 'Child Mortality Rate West' 
    u5mrwe 'Under-five Mortality Rate West' .

FORMATS age (F8.0) ceb (F8.0) cdead (F8.0) numwomen (F8.0) mceb (F8.3) propcd (F8.3).
FORMATS qino (F8.3) /tstarno (F8.1) /refdateno (F8.1) /imrno (F8.3) /u5mrno (F8.3) /cmrno (F8.3) .
FORMATS qiso (F8.3) /tstarso (F8.1) /refdateso (F8.1) /imrso (F8.3) /u5mrso (F8.3) /cmrso (F8.3) .
FORMATS qiea (F8.3) /tstarea (F8.1) /refdateea (F8.1) /imrea (F8.3) /u5mrea (F8.3) /cmrea (F8.3) .
FORMATS qiwe (F8.3) /tstarwe (F8.1) /refdatewe (F8.1) /imrwe (F8.3) /u5mrwe (F8.3) /cmrwe (F8.3) .

EXECUTE.

