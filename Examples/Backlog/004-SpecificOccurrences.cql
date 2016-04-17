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

define "HIV Visits During Measurement Period":
  ["Encounter, Performed": "HIV Visit"] EP
    where Interval[EP.admissionDateTime, EP.dischargeDateTime] during "Measurement Period"

Visit { admissionDateTime: 2015-01-01 }
Visit { admissionDateTime: 2015-03-01 }
Visit { admissionDateTime: 2015-06-01 }

define "HIV Followup Visits":
  "HIV Visits During Measurement Period" V1
    with "$HIV Visits During Measurement Period" V2
      such that V1.admissionDateTime occurs 90 days or more after V2.dischargeDateTime

Visit { admissionDateTime: 2015-03-01 }
Visit { admissionDateTime: 2015-06-01 }

define "Most Recent HIV Followup Visit":
  First("HIV Followup Visits" V sort by { V1.admissionDateTime desc })

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

define "CD4+ Count With Results and Medications":
  ["Laboratory Test, Performed": "CD4+ Count"] LTP
    with ["Medication, Order": "Dapsone and pyrimethamine"] MODP
      such that MODP.signedDatetime occurs 3 months or less after LTP.stopDateTime

define "Dapsone and pyrimethamine Orders with CD4+ Count Laboratory Tests"
  ["Medication, Order": "Dapsone and pyrimethamine"] MODP
    with ["Laboratory Test, Performed": "CD4+ Count"] LTP
      such that MODP.signedDatetime occurs 3 months or less after LTP.stopDateTime
