/*

Blood Pressure		value providing blood pressure
"Systolic  Less Than 140"
"Systolic Greater Than/Equal To 140"
"Diastolic Less Than 80"
"Diastolic 80-89"
"Diastolic Greater Than/Equal To 90"
CPT
1 year

Hx HTN	Earliest date practice was aware of hypertension
"Essential Hypertension"
ICD10CM
3 years

*/

valueset "Systolic Less Than 140": '2.16.840.1.113883.3.464.1004.1243'
valueset "Systolic Greater Than/Equal To 140": '2.16.840.1.113883.3.464.1004.1242'
valueset "Diastolic Less Than 80": '2.16.840.1.113883.3.464.1004.1084'
valueset "Diastolic 80-89": '2.16.840.1.113883.3.464.1004.1082'
valueset "Diastolic Greater Than/Equal To 90": '2.16.840.1.113883.3.464.1004.1083'
valueset "Essential Hypertension": '2.16.840.1.113883.3.464.1004.1122'

parameter MeasurementPeriod Interval<DateTime>

define "Lookback Interval One Year":
  Interval[start of MeasurementPeriod - 1 years, start of MeasurementPeriod]

define "Lookback Interval Three Years":
  Interval[start of MeasurementPeriod - 3 years, start of MeasurementPeriod]

// Blood Pressure

define "Blood Pressure Groupings"
  [Observation: "Systolic Less Than 140"]
    union [Observation: "Systolic Greater Than/Equal To 140"]
    union [Observation: "Diastolic Less Than 80"]
    union [Observation: "Diastolic 80-89"]
    union [Observation: "Diastolic Greater Than/Equal To 90"]

define "Blood Pressure":
  "Blood Pressure Groupings" B
      where B.effectiveDateTime intersect "Lookback Interval One Year"

// Hx HTN

define "Hx HTN":
  [Observation: "Essential Hypertension"] H
    return First(H.effectiveDateTime)
      where H.effectiveDateTime intersect "Lookback Interval Three Years"
