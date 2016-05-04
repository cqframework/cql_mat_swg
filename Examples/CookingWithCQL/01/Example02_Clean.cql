/*
 * Depression Remission or Response for Adolescents and Adults
 */

/*
Initial Population

AND: Age >= 12 year(s) at: "Measurement Period"
AND: $DepressionEncounter
AND: $DepressionIndex
*/

/*
Depression Followup

AND: Union Of:
	"Risk Category Assessment: PHQ-9 Tool" satisfies all:
		(result)
		>= 5 month(s) starts after start of "$DepressionIndex"
		< 7 month(s) ends after start of "$DepressionIndex "
	“Risk Category Assessment: PHQ-9 Modified Score" satisfies all:
		(result)
		>= 5 month(s) starts after start of "$DepressionIndex"
		< 7 month(s) ends after start of "$DepressionIndex.
*/

/*
Depression Remission

AND: Union Of:
	"Risk Category Assessment: PHQ-9 Tool" satisfies all:
		(result<5)
		>= 5 month(s) starts after start of "$DepressionIndex"
		< 7 month(s) ends after start of "$DepressionIndex "
	“Risk Category Assessment: PHQ-9 Modified Score" satisfies all:
		(result<5)
		>= 5 month(s) starts after start of "$DepressionIndex"
		< 7 month(s) ends after start of "$DepressionIndex "
*/

/*
Depression Response

AND: Union Of:
	"Risk Category Assessment: PHQ-9 Tool" satisfies all:
		(result <= 50% $DepressionIndex)
		>= 5 month(s) starts after start of "$DepressionIndex"
		< 7 month(s) ends after start of "$DepressionIndex "
	“Risk Category Assessment: PHQ-9 Modified Score" satisfies all:
		(result <= 50% $DepressionIndex)
		>= 5 month(s) starts after start of "$DepressionIndex"
		< 7 month(s) ends after start of "$DepressionIndex "
*/

define "Depression Diagnosis":
  (["Diagnosis": "Major Depression Including Remission"]
    union ["Diagnosis": "Dysthymia"]
  )

define "Outpatient Encounter During Intake":
  ["Encounter, Performed": "Outpatient"] Encounter
    where Encounter.negationRationale is null
      and Interval[Encounter.admissionDateTime, Encounter.dischargeDateTime]
        during Interval[start of "Measurement Period" - 8 months, start of "Measurement Period" + 4 months]

define "Depression Encounter":
  "Outpatient Encounter During Intake" Encounter
    with "Depression Diagnosis" Diagnosis
      such that Interval[Encounter.admissionDateTime, Encounter.dischargeDateTime]
        overlaps Interval[Diagnosis.onsetDateTime, Diagnosis.abatementDateTime]

/*
$DepressionEncounter =
	$Encounter Satisfies all:
		<= 8 month(s) ends before start of "Measurement Period"
		<= 4 month(s) ends after start of "Measurement Period"
		satisfies any:
			overlaps "Diagnosis: Major Depression Including Remission"
			overlaps "Diagnosis: Dysthymia"
*/

/*
$DepressionIndex =
	Satisfies any:
		"FIRST: Risk Category Assessment: PHQ-9 Tool (result > 9 )" Satisfies any:
			during $Depression Encounter
			<=15 day(s) stars before start of $Depression Encounter
			<=15 day(s) starts after start of $Depression Encounter
		 “FIRST: Risk Category Assessment: PHQ-9 Modified Tool (result > 9 )" Satisfies any:
			during $Depression Encounter
			<=15 day(s) stars before start of $DepressionEncounter
			<=15 day(s) starts after start of $DepressionEncounter
*/
