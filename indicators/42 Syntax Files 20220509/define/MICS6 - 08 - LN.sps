* Encoding: UTF-8.
* entry age in primary school in years .
compute primarySchoolEntryAge = 6 .

* number of grades, years in primary school .
compute primarySchoolGrades = 6 .

* number of grades, years in lower secondary school .
compute LowSecSchoolGrades = 3 .

* number of grades, years in upper secondary school .
compute UpSecSchoolGrades = 4 .

* entry age in secondary school in years, no need to customize .
compute LowSecSchoolEntryAge = primarySchoolEntryAge +  primarySchoolGrades.
compute UpSecSchoolEntryAge = primarySchoolEntryAge +  primarySchoolGrades + LowSecSchoolGrades.
compute primarySchoolCompletionAge = LowSecSchoolEntryAge - 1 .
compute LowSecSchoolCompletionAge = UpSecSchoolEntryAge - 1 .
compute UpSecSchoolCompletionAge = UpSecSchoolEntryAge + UpSecSchoolGrades - 1 .
