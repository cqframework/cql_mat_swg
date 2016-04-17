/*

Colonoscopy	          COL	Indicates a colonoscopy was provided on the indicated date of service,                    CPT, HCPCS	                       10 years
                      results/findings must be provided	ORU	"Colonoscopy"

Hx Colorectal Cancer	COL	Date of colorectal cancer diagnosis	ORU	"Colorectal Cancer"	                              HCPCS, ICD10CM	                   Unlimited

Hx Sigmoidoscopy	    COL	Most recent historic sigmoidoscopy date, results/findings must be provided	              CPT, HCPCS	                       5 years
                      ORU	"Flexible Sigmoidoscopy"

Hx Total Colectomy	  COL	Date of total colectomy	ORU	"Total Colectomy"	                                            CPT, ICD10PCS	                     Unlimited

iFOBT	                COL	Indicates completion of an immunochemical fecal occult blood test (iFOBT) as              CPT, HCPCS, LOINC       	         1 year
                      part of screening for colorectal cancer.  Results/findings must be provided.

gFOBT	                COL	Indicates completion of a GUAIAC fecal occult blood test (gFOBT) as part of screening     CPT, HCPCS, LOINC	                 1 year
                      for colorectal cancer.  Provide number of samples returned
                      (completion of test requires 3 results).	ORU	"FOBT"

Hx Colonoscopy	      COL	Most recent historic colonoscopy date	ORU	"Colonoscopy"	                                  CPT, HCPCS	                       10 years

*/

/*
https://ecqi.healthit.gov/system/files/ecqm/2014/EP/measures/CMS130v3.html
"Laboratory Test, Result: Fecal Occult Blood Test (FOBT)" using "Fecal Occult Blood Test (FOBT) Grouping Value Set (2.16.840.1.113883.3.464.1003.198.12.1011)"
"Procedure, Performed: Colonoscopy" using "Colonoscopy Grouping Value Set (2.16.840.1.113883.3.464.1003.108.12.1020)"
"Procedure, Performed: Flexible Sigmoidoscopy" using "Flexible Sigmoidoscopy Grouping Value Set (2.16.840.1.113883.3.464.1003.198.12.1010)"
"Procedure, Performed: Total Colectomy" using "Total Colectomy Grouping Value Set (2.16.840.1.113883.3.464.1003.198.12.1019)"

https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=3&ved=0ahUKEwjH8s7Qv_DLAhXsloMKHWWZAy8QFggpMAI&url=http%3A%2F%2Fwww.ncqa.org%2FPortals%2F0%2FHomepage%2FHEDIS_2015_Public_Comment_Value_Set_Directory.xlsx&usg=AFQjCNF_C4NgMFPA5IE2LQ3b17uOi8NmrQ&sig2=qtVajd628VNTb_yS9camxA&cad=rja
Non-Recommended Colorectal Cancer Screening in Older Adults	Colonoscopy	2.16.840.1.113883.3.464.1004.1064
Non-Recommended Colorectal Cancer Screening in Older Adults	Colorectal Cancer	2.16.840.1.113883.3.464.1004.1065
Non-Recommended Colorectal Cancer Screening in Older Adults	Flexible Sigmoidoscopy	2.16.840.1.113883.3.464.1004.1102
Non-Recommended Colorectal Cancer Screening in Older Adults	FOBT	2.16.840.1.113883.3.464.1004.1093

*/

valueset "Colonoscopy":	'2.16.840.1.113883.3.464.1004.1064'
valueset "Colorectal Cancer": '2.16.840.1.113883.3.464.1004.1064'
valueset "Flexible Sigmoidoscopy": '2.16.840.1.113883.3.464.1004.1102'
valueset "Total Colectomy": '2.16.840.1.113883.3.464.1003.198.12.1019'
valueset "Fecal Occult Blood Test (FOBT)": '2.16.840.1.113883.3.464.1003.198.12.1011'

parameter MeasurementPeriod Interval<DateTime>

define "Lookback Interval One Year":
  Interval[start of MeasurementPeriod - 1 years, start of MeasurementPeriod]

define "Lookback Interval Five Years":
  Interval[start of MeasurementPeriod - 5 years, start of MeasurementPeriod]

define "Lookback Interval Ten Years":
  Interval[start of MeasurementPeriod - 10 years, start of MeasurementPeriod]

// Colonoscopy - Indicates a colonoscopy was provided on the indicated date of service, results/findings must be provided.

define "Colonoscopy Performed":
  [Observation: "Colonoscopy"] C
    where C.effectiveDateTime intersect "Lookback Interval Ten Years"
      return C.value

// Hx Colorectal Cancer	Date of colorectal cancer diagnosis

define "Hx Colorectal Cancer":
  [Observation: "Colorectal Cancer"] C
    return C.effectiveDateTime

// Hx Sigmoidoscopy	- Most recent historic sigmoidoscopy date, results/findings must be provided

define "Hx Sigmoidoscopy":
  [Observation: "Flexible Sigmoidoscopy"] S
    where S.effectiveDateTime intersect "Lookback Interval Five Years"
      return First(S.value)
        sort by S.effectiveDateTime

// Hx Total Colectomy - Date of total colectomy

define "Hx Total Colectomy":
  [Observation: "Total Colectomy"] T
    return T.effectiveDateTime

// iFOBT - Indicates completion of an immunochemical fecal occult blood test (iFOBT) as part of screening for colorectal cancer.

define iFOBT:
  [Observation: "FOBT"] F
    where F.value = Code {code: '441579003' system: "http://snomed.org/sct" display: 'Measurement of occult blood in stool specimen using immunoassay (procedure)'}
      and where F.effectiveDateTime intersect "Lookback Interval One Year"

// gFOBT - Indicates completion of a GUAIAC fecal occult blood test (gFOBT) as part of screening for colorectal cancer.

define gFOBT:
  [Observation: "FOBT"] F
    where F.value = Code {code: '442554004' system: "http://snomed.org/sct" display: 'Guaiac test for occult blood in feces specimen (procedure)'}
      and where F.effectiveDateTime intersect "Lookback Interval One Year"

// Hx Colonoscopy - Most recent historic colonoscopy date

define "Hx Colonoscopy":
  [Observation: "Colonoscopy"] C
    where C.effectiveDateTime intersect "Lookback Interval Ten Years"
      return First(C.effectiveDateTime)
