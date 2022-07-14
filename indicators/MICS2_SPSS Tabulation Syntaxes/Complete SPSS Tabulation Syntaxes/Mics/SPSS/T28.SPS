get file = 'ch.sav'.

weight by chweight.

recode ML8 (1 = 1) (2 = 2) (7,9 = 3) into bednet.
variable label bednet "Slept under a bednet".
value label bednet
  1 "Yes"
  2 "No"
  3 "DK/missing".

recode ML9 (1 = 1) (2 = 2) (7,9 = 3) (else = sysmis) into treated.
variable label treated "Bednet treated".
value label treated
  1 "Yes"
  2 "No"
  3 "DK/missing".

tables
  /ftotal = tot1 "Total" tot2 "Number of children" tot3 "Children who slept under a bednet"
  /tables = HL3 + HI7 + HI6 + cage_6 + tot1 by bednet + tot2 + treated + tot3
  /statistics
    cpct(bednet (f5.1) '':HL3 HI7 HI6 cage_6)
    count(tot2 (f5.0) '')
    cpct(treated (f5.1) '':HL3 HI7 HI6 cage_6)
    count(tot3 (f5.0) '')
  /title
    "Table 28: Percentage of children 0-59 months of age who slept under an insecticide-impregnated bednet during the"
    "previous night, Country, Year"
  /caption
    "Monitoring IMCI and Malaria Indicator".
