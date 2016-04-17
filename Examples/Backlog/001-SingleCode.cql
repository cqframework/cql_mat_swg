codesystem "SNOMED-CT": '2.16.840.1.113883.6.96' version '2016A'

//code "Breastfeeding Intention": '12345678' codesystem "SNOMED-CT"

define "$Breastfeeding Intention":
  Code '123456789' from "SNOMED-CT" display 'Breastfeeding intention'

define "$Has Breastfeeding Intention":
  ["Risk Assessment, Performed": "$Breastfeeding Intention"] R
    where R.negationRationale is null
