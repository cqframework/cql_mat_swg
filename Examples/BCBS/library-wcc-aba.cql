/*

BMI Percent	 WCC, ABA	 BMI percentile measurements
"BMI Percentile"
ICD10CM
2 years

Body Mass Index (BMI) Value	 ABA	 value identifying body mass
"BMI Value"
ICD10CM
2 years

Height	ABA, WCC	Value of height plus units, ie 70 inches or 5 feet 10 inches
No value set, but must be retrieved for ABA compliance data to be used in a standard supplmenetal data source according to NCQA General Guideline 34 under the heading 'Required Data Elements'
2 years

Weight	ABA, WCC	Value of weight plus units, ie 85 kg or 200 lbs
No value set, but must be retrieved for ABA compliance data to be used in a standard supplmenetal data source according to NCQA General Guideline 34 under the heading 'Required Data Elements'
2 years

*/

/* I could not find these value sets */
valueset "BMI Percentile": ''
valueset "BMI Value": ''

parameter MeasurementPeriod Interval<DateTime>

define "Lookback Interval Two Years":
  Interval[start of MeasurementPeriod - 2 years, start of MeasurementPeriod]

/* BMI Percent	 BMI percentile measurements */

define "BMI Percent":
  [Observation: "BMI Percentile"] P
    where P.effectiveDateTime intersect "Lookback Interval Two Years"
      return P.value

/* Body Mass Index (BMI) Value	  value identifying body mass */

define "Body Mass Index (BMI) Value":
  [Observation: "BMI Value"] V
    where V.effectiveDateTime intersect "Lookback Interval Two Years"
      return P.value

/* TODO: Not sure how to represent Height and Weight */
