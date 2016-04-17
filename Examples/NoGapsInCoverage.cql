library HEDIS10625COVERAGE_QUICK version '1'

using QUICK

parameter MeasurementPeriod default Interval[@2014-01-01T00:00:00.0, @2015-01-01T00:00:00.0)

context Patient

define Coverages: [Coverage] C
   where (C.planholderIdentifier as Patient).id = Patient.id

     //and C.period during "MeasurementPeriod"
     and C.period overlaps "MeasurementPeriod" // I think we want to say "overlaps"

define function countGaps (Coverages List<Coverage>):
    Tuple {total: count(Coverages)}

define function GapSize (Coverages List<Coverage>):
    Tuple {size: days between Coverages[1].period.end and Coverages[2].period.start}

define isCovered:
   if ( countGaps("Coverages").total= 1 and gapSize("Coverages").size <= 45 days)
   then Tuple {Gaps: countGaps(C).total, Size: gapSize("Coverages").size}
   else {:}

// Bound the coverages to the beginning and ending of the measurement period
// Add periods to cover just before and after the measurement periods
// Collapse the result to determine the unique coverage space
define CoveragePeriods:
  collapse (
    Coverages C
      return period: Interval[
        if start of C.period < start of MeasurementPeriod then start of MeasurementPeriod else start of C.period,
        if end of C.period > end of MeasurementPeriod then end of MeasurementPeriod else end of C.period
    )
    union {
      Interval[start of MeasurementPeriod - 1 day, start of MeasurementPeriod],
      Interval[end of MeasurementPeriod, end of MeasurementPeriod + 1 day]
    }
  )

// A covered is then defined as a having only 1 or 2 coverage periods with no gap of 45 days or more
define IsCovered:
  Count(CoveragePeriods) between 1 and 2
    and not exists (
      from CoveragePeriods A, CoveragePeriods B
        where difference in days between end of A and start of B <= 45
   )

-----------------------------------------------------------------

The part where I feel pretty unsure is the line including this reference:
 Coverages[1].period.end


In general, does the above CQL will be a reasonable representation of the condition above? Am I referencing the list elements in the correct way?

Thanks,
Angelica.

// Assumes a collapsed list of intervals, sorted by interval start date
function CalculateGaps(intervals List<Interval>)
  intervals A
    define nextIntervals: intervals B where B after A
    { R: Interval[successor of end of A, predecessor of start of First(nextIntervals)] }


////////////////////////////////////////////////////////////////////
// Counting unique services in claims:

// I need to understand how 'distinct' actually works on lists with structured element types.
// Have a couple of use cases which are quite common in claims where I need to count number of
//  claims based on customized criteria. For example, if the same Claim captures two outpatient
// visits on different service dates then for counting purposes this claim should represent '2'
//  counts instead of 1.  In contrast, I may have two claims with the same claim id each capturing
//  the same visit type on the same service date. For counting purposes, these two claims should
//   represent '1' count instead of 2.

Count([Claims: "Some Value Set"] C return { C.claimId, C.visitType, C.serviceDate })


/////////////////////////////////////////////////////////////////////////////////////////
// Lipid Panel results



define "$results":
  ["Laboratory Test, Performed": "Lipid Panel"] L
    with ["Laboratory Test, Performed": "LDL"] C such that L.performedDateTime = C.performedDateTime
    where L.negationRationale is null
      and L.result < 130 mg/dL


/////////////////////////////////////////////////
// Medication Strengths

define "Active Drugs in FDB Part D":
   from [MedicationDispense] D,
      [Medication: "FDB Medicare Part D"] M
  where D.medicationCodeableConcept.coding.code in "FDB Medicare Part D"
    and EndsWith(D.medicationReference.reference, M.id) // This is the way to link the actual instances
     and D.medicationCodeableConcept.coding.code = D.code // This relies on the codes, but a patient may have been dispensed the same code multiple times, so this won't work in general
     and (duration in days of Interval [D.whenHandedOver , "Run Date"] / D.daysSupply) < "Tenant Supply Window"
  return {dailyDose: M.dosageInstruction.doseQuantity * M.product.ingredient.amount}
