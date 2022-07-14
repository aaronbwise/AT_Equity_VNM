get file = 'hh.sav'.

compute newclust = 1.
if (HI1 = lag(HI1,1)) newclust = 0.
variable label newclust "Completed clusters".

tables
  /observation = HI11 HI12 HI13 HI14 newclust
  /tables = HI6 > HI7 by HI10 + HI11 + HI12 + HI13 + HI14 + newclust
  /statistics
    count(HI10 (F5.0) '')
    sum(HI11 (F5.0) '')
    sum(HI12 (F5.0) '')
    sum(HI13 (F5.0) '')
    sum(HI14 (F5.0) '')
    sum(newclust (F5.0) '')
  /title
    "Weight Tabulation".
