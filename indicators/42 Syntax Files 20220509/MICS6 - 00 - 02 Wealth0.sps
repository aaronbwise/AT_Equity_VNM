* Encoding: windows-1252.

*	Describe where the hh.sav and hl.sav data files are stored.
cd "C:\MICS6\SPSS".

*	Replace below "Survey name, Year" with the name of the country/survey, and the year of fieldwork - this will appear in all 
	outputs of these programs.
define surveyname ()
  "Survey name, Survey year"
!enddefine.


insert file = "W1.sps".

insert file = "W2.sps".

insert file = "W3.sps".

insert file = "W4.sps".

insert file = "W5.sps".

new file.

