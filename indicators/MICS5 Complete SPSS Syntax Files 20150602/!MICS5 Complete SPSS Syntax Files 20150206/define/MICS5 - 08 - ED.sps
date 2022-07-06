* entry age in primary school in years .
compute primarySchoolEntryAge = 7 .

* number of grades, years in primary school .
compute primarySchoolGrades = 8 .

* number of grades, years in secondary school .
compute secondarySchoolGrades = 4 .


* entry age in secondary school in years, no need to customize .
compute secondarySchoolEntryAge = primarySchoolEntryAge +  primarySchoolGrades.
compute primarySchoolCompletionAge = secondarySchoolEntryAge - 1 .
compute secondarySchoolCompletionAge = secondarySchoolEntryAge + secondarySchoolGrades - 1 .