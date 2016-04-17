///////////////////////////////////////
// Filtering by Existence

/*
  "Occurrence A of Laboratory Test, Performed: CD4+ Count (result)"
*/

define "$CD4+ Count With Results and Medications":
  ["Laboratory Test, Performed": "CD4+ Count"] LTP
    where LTP.result is not null

// Comparison to null is not correct

define "$CD4+ Count With Results and Medications":
  ["Laboratory Test, Performed": "CD4+ Count"] LTP
    where LTP.result <> null

// This will fail because comparisons involving null are "unknown"

///////////////////////////////////////////
// Filtering by Value Set


define "$Denominator Exclusions 1":
  "$Encounter Inpatient" E
    where E.facilityLocation in "Neonatal Intensive Care Unit (NICU)"
      or E.dischargeStatus in "Patient Expired"
      or E.dischargeStatus in "Discharge To Acute Care Facility"


///////////////////////////////////////////////
// Filtering by Code

codesystem "SNOMED-CT": '2.16.840.1.113883.6.96' version '2016A'

define "$Breastfeeding Intention":
  Code '123456789' from "SNOMED-CT" display 'Breastfeeding intention'

define "$Has Breastfeeding Intention":
  ["Risk Assessment, Performed": "$Breastfeeding Intention"] R
    where R.negationRationale is null

//////////////////////////////////////////////
// Filtering by Values and Quantities

/* "Laboratory Test, Performed: LDL-c Test (result < 100 mg/dL)" */

define "$LDL-c Test In Range":
  ["Laboratory Test, Performed": "LDL-c Test"] LT
    where LT.result < 100 "mg/dL"


//////////////////////////////////////////////
// Related information

/*
  "Encounter, Performed: Hospital Inpatient" starts before start of "Diagnosis: Diabetes"
*/

define "$Valid Encounters":
  ["Encounter, Performed": "Hospital Inpatient"] E
    with ["Diagnosis": "Diabetes"] D
      such that E.admissionDatetime occurs before D.onsetDatetime

///////////////////////////////////////////////
// Date and Time comparisons

define "$Valid Encounters":
  ["Encounter, Performed": "Hospital Inpatient"] E
    with ["Diagnosis": "Diabetes"] D
      such that E.admissionDatetime occurs same day as D.onsetDatetime

///////////////////////////////////////////////
// Interval comparisons

/*
  "Encounter, Performed: Hospital Inpatient" during "Diagnosis: Diabetes"
*/

define "$Valid Encounters":
  ["Encounter, Performed": "Hospital Inpatient"] E
    with ["Diagnosis": "Diabetes"] D
      such that Interval[E.admissionDatetime, E.dischargeDatetime]
        during Interval[D.onsetDatetime, D.abatementDatetime]

/////////////////////////////////////////////////
// Combining Conditions

/*
  AND: "Occurrence A of Encounter, Performed: BH Outpatient encounter" >=
    42 day(s) starts before start of "Measurement End Date"
  AND: "Occurrence A of Encounter, Performed: BH Outpatient encounter"
    starts after start of "Measurement Start Date"
*/

define "$Valid Encounters":
  ["Encounter, Performed": "BH Outpatient encounter"] EP
    where EP.admissionDateTime occurs 42 days or less before end of "Measurement Period"
      and EP.admissionDateTime occurs after start of "Measurement Period"

/*
  AND: "Occurrence A of Encounter, Performed: HIV Visit" during "Measurement Period"
  AND: "Occurrence B of Encounter, Performed: HIV Visit" during "Measurement Period"
  AND: "Occurrence B of Encounter, Performed: HIV Visit" >= 90 day(s)
    starts after end of "Occurrence A of Encounter, Performed: HIV Visit"
*/

define "$HIV Visits During Measurement Period":
  ["Encounter, Performed": "HIV Visit"] EP
    where Interval[EP.admissionDateTime, EP.dischargeDateTime] during "Measurement Period"

define "$HIV Followup Visits":
  "$HIV Visits During Measurement Period" V1
    with "$HIV Visits During Measurement Period" V2
      such that V1.admissionDateTime occurs 90 days or more after V2.dischargeDateTime

/*
  AND: "Occurrence A of Medication, Order: Dapsone and pyrimethamine" <=
    3 month(s) starts after end of "Occurrence A of Laboratory Test, Performed: CD4+ Count (result)"
  AND: "Occurrent A of Medication, Order: Leucovorin" <= 3 month(s)
    starts after end of "Occurrence A of Laboratory Test, Performed:
      CD4+ Count (result)"
*/

define "$CD4+ Count With Results and Medications":
  ["Laboratory Test, Performed": "CD4+ Count"] LTP
    with ["Medication, Order": "Dapsone and pyrimethamine"] MODP
      such that MODP.signedDatetime occurs 3 months or less after LTP.stopDateTime
    with ["Medication, Order": "Leucovorin"] MOL
      such that MOL.signedDatetime occurs 3 months or less after LTP.stopDateTime
    where LTP.result is not null

/////////////////////////////////////////////////////////////////
// CMS 126 v4


/*
Initial Population =
    AND: Age >= 5 year(s) at: "Measurement Period"
    AND: Age < 64 year(s) at: "Measurement Period"
    AND: "Diagnosis, Active: Persistent Asthma" overlaps "Measurement Period"
    AND: Union of:
        "Encounter, Performed: Office Visit"
        "Encounter, Performed: Face-to-Face Interaction"
        "Encounter, Performed: Preventive Care - Established Office Visit, 0 to 17"
        "Encounter, Performed: Preventive Care Services - Established Office Visit, 18 and Up"
        "Encounter, Performed: Preventive Care Services-Initial Office Visit, 18 and Up"
        "Encounter, Performed: Preventive Care- Initial Office Visit, 0 to 17"
        "Encounter, Performed: Home Healthcare Services"
        during "Measurement Period"

Denominator =
    AND: Initial Population

Denominator Exclusions =
    OR: Union of:
        "Diagnosis, Active: Chronic Obstructive Pulmonary Disease"
        "Diagnosis, Active: Emphysema"
        "Diagnosis, Active: Cystic Fibrosis"
        "Diagnosis, Active: Acute Respiratory Failure"
        overlaps "Measurement Period"

Numerator =
    AND: "Medication, Dispensed: Preferred Asthma Therapy" during "Measurement Period"

Numerator Exclusions =
    None

Denominator Exceptions =
    None
*/

define "$In Demographic":
  AgeInYearsAt(start of "Measurement Period") >= 5
    and AgeInYearsAt(start of "Measurement Period") < 65

define "$Asthma Diagnosis":
  ["Diagnosis": "Persistent Asthma"] D
    where Interval[D.onsetDatetime, D.abatementDatetime] overlaps "Measurement Period"

define "$Valid Encounters":
  (["Encounter, Performed": "Office Visit"]
    union ["Encounter, Performed": "Face-to-Face Interaction"]
    union ["Encounter, Performed": "Preventive Care - Established Office Visit, 0 to 17"]
    union ["Encounter, Performed": "Preventive Care Services - Established Office Visit, 18 and Up"]
    union ["Encounter, Performed": "Preventive Care Services-Initial Office Visit, 18 and Up"]
    union ["Encounter, Performed": "Preventive Care- Initial Office Visit, 0 to 17"]
    union ["Encounter, Performed": "Home Healthcare Services"]
  ) E where Interval[E.admissionDateTime, E.dischargeDateTime] during "Measurement Period"

define "$In Initial Population":
  "$In Demographic"
    and exists "$Asthma Diagnosis"
    and exists "$Valid Encounters"

define "$In Denominator":
  "$In Initial Population" // Can repeat the condition, or omit the definition as implied by the structure of the measure

define "$Exclusionary Diagnoses":
  (["Diagnosis": "Chronic Obstructive Pulmonary Disease"]
    union ["Diagnosis": "Emphysema"]
    union ["Diagnosis": "Cystic Fibrosis"]
    union ["Diagnosis": "Actue Repiratory Failure"]
  ) D where Interval[D.onsetDatetime, D.abatementDatetime] overlaps "Measurement Period"

define "$Denominator Exceptions":
  exists "$Exclusionary Diagnoses"

define "$Preferred Asthma Therapy":
  ["Medication, Dispensed": "Preferred Asthma Therapy"] MD
    where Interval[MD.startDatetime, MD.stopDateTime] during "Measurement Period"

define "$Numerator":
  exists "$Preferred Asthma Therpay"
