get file = 'ch.sav'.

weight by chweight.

select if (cage >= 12 and cage <= 23).

compute total = 1.
value label total 1 "Number of children".

tables
  /table bcg + dpt1 + dpt2 + dpt3 + polio0 + polio1 + polio2 + polio3 + measles + allvacc + novacc + total
  /statistics
    cpct(bcg (f5.1) '')
    cpct(dpt1 (f5.1) '')
    cpct(dpt2 (f5.1) '')
    cpct(dpt3 (f5.1) '')
    cpct(polio0 (f5.1) '')
    cpct(polio1 (f5.1) '')
    cpct(polio2 (f5.1) '')
    cpct(polio3 (f5.1) '')
    cpct(measles (f5.1) '')
    cpct(allvacc (f5.1) '')
    cpct(novacc (f5.1) '')
    count(total (f5.1) '')
  /title
    "Table 21 Percentage of children 12-23 months immunized against childhood diseases at any time before the survey, Country, Year"
  /caption
    "World Summit for Children Goal => Number 22".

select if IM1 = 1.

*define a MACRO that calculates if a vaccination was given before 12 months.
define !vacc12 (vacc = !tokens(1)
               /year = !tokens(1)
               /month = !tokens(1)
               /newvar = !tokens(1)
               /vlabel = !tokens(1)).
compute !newvar = 0.
do if (!vacc = 1 and !year < 9996).
+ compute dov = (!year - 1900)*12 + 6.
+ if (!month < 96) dov = (!year - 1900)*12 + !month.
+ if (dov - cdob < 13) !newvar = 100.
end if.
variable label !newvar !vlabel.
!enddefine.

!vacc12 vacc=bcg year=IM2Y month=IM2M newvar=bcg_12 vlabel="BCG".

!vacc12 vacc=polio0 year=IM3AY month=IM3AM newvar=p0_12 vlabel="Polio 0".

!vacc12 vacc=polio1 year=IM3BY month=IM3BM newvar=p1_12 vlabel="Polio 1".

!vacc12 vacc=polio2 year=IM3CY month=IM3CM newvar=p2_12 vlabel="Polio 2".

!vacc12 vacc=polio3 year=IM3DY month=IM3DM newvar=p3_12 vlabel="Polio 3".

!vacc12 vacc=dpt1 year=IM4AY month=IM4AM newvar=d1_12 vlabel="DPT 1".

!vacc12 vacc=dpt2 year=IM4BY month=IM4BM newvar=d2_12 vlabel="DPT 2".

!vacc12 vacc=dpt3 year=IM4CY month=IM4CM newvar=d3_12 vlabel="DPT 3".

!vacc12 vacc=measles year=IM5Y month=IM5M newvar=m_12 vlabel="Measles".

compute all_12 = 0.
if (b_12 = 100 & m_12 = 100 & d1_12 = 100 & d2_12 = 100 & d3_12 = 100 & p1_12 = 100 & p2_12 = 100 & p3_12 = 100) all_12 = 100.
variable label all_12 "All vaccinations".

compute none_12 = 0.
if (b_12 = 0 & m_12 = 0 & d1_12 = 0 & d2_12 = 0 & d3_12 = 0 & p1_12 = 0 & p2_12 = 0 & p3_12 = 0) none_12 = 100.
variable label none_12 "No vaccinations".

tables
  /observation = b_12 d1_12 d2_12 d3_12 p0_12 p1_12 p2_12 p3_12 m_12 all_12 none_12
  /tables = b_12 + d1_12 + d2_12 + d3_12 + p0_12 + p1_12 + p2_12 + p3_12 + m_12 + all_12 + none_12
  /statistics
    mean(b_12 (f5.1) '')
    mean(d1_12 (f5.1) '')
    mean(d2_12 (f5.1) '')
    mean(d3_12 (f5.1) '')
    mean(p0_12 (f5.1) '')
    mean(p1_12 (f5.1) '')
    mean(p2_12 (f5.1) '')
    mean(p3_12 (f5.1) '')
    mean(m_12 (f5.1) '')
    mean(all_12 (f5.1) '')
    mean(none_12 (f5.1) '')
  /title
    "Table 21 Percentage of children 12-23 months immunized against childhood diseases before the first birthday, Country, Year"
  /caption
    "World Summit for Children Goal => Number 22".

