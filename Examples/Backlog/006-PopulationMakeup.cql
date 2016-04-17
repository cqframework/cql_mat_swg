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
