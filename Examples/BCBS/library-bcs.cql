/*

Hx Mastectomy Bilat		Date of bilateral mastectomy	"Bilateral Mastectomy" "Unilateral Mastectomy" + "Bilateral Modifier"
"History of Bilateral Mastectomy"	CPT, ICD10CM, ICD10PCS	Unlimited

Hx Mastectomy Left	Date of left-sided unilateral mastectomy	"Unilateral Mastectomy" + "Left Modifier" same DOS
"Absence of Left Breast" "Unilateral Mastectomy Left" CPT, ICD10CM, ICD10PCS	Unlimited

Hx Mastectomy Right		Date of right-sided unilateral mastectomy		"Unilateral Mastectomy" + "Right Modifier" same DOS
"Absence of Right Breast" "Unilateral Mastectomy Right" CPT, ICD10CM, ICD10PCS	Unlimited

Mammography		Indicates mammography was provided on the indicated date of service		"Mammography"	CPT, HCPCS	27 months

*/

/* I could not find these value sets */
valueset "Bilateral Mastectomy": ''
valueset "Unilateral Mastectomy": ''
valueset "Bilateral Modifier": ''
valueset "History of Bilateral Mastectomy": ''

valueset "Left Modifier": ''
valueset "Absence of Left Breast": ''
valueset "Unilateral Mastectomy Left": ''

valueset "Right Modifier": ''
valueset "Absence of Right Breast": ''
valueset "Unilateral Mastectomy Right": ''

valueset "Mammography": ''

parameter MeasurementPeriod Interval<DateTime>

define "Lookback Interval Twenty-Seven Months":
  Interval[start of MeasurementPeriod - 27 months, start of MeasurementPeriod]

/* Hx Mastectomy Bilat		Date of bilateral mastectomy */

define "Hx Mastectomy Bilat":
  [Observation: "Bilateral Mastectomy"] B
    return B.effectiveDateTime

/*
Other ways to get this info:

define "Hx Mastectomy Bilat":
  [Observation: "Unilateral Mastectomy"] U
    where exists (
      [Observation: "Bilateral Modifier"] B
        where U.effectiveDateTime matches L.effectiveDateTime
    )
    return U.effectiveDateTime

define "Hx Mastectomy Bilat":
  [Observation: "History of Bilateral Mastectomy"] H
    return H.effectiveDateTime
    NOTE: Not sure which resource to use to represent a history
*/

/* Hx Mastectomy Left	 Date of left-sided unilateral mastectomy */

define "Hx Mastectomy Left":
  [Observation: "Unilateral Mastectomy"] U
    where exists (
      [Observation: "Left Modifier"] L
        where U.effectiveDateTime matches L.effectiveDateTime
      )
      return U.effectiveDateTime

/*
Other Ways to get this info:

define "Hx Mastectomy Left":
  [Observation: "Absence of Left Breast"] A
    return A.effectiveDateTime

define "Hx Mastectomy Left":
  [Observation: "Unilateral Mastectomy Left"] U
    return U.effectiveDateTime

*/

/* Hx Mastectomy Right		Date of right-sided unilateral mastectomy */

define "Hx Mastectomy Right":
  [Observation: "Unilateral Mastectomy"] U
    where exists (
      [Observation: "Right Modifier"] R
        where U.effectiveDateTime matches R.effectiveDateTime
      )
      return U.effectiveDateTime

/*
Other ways to get the info:

define "Hx Mastectomy Right":
  [Observation: "Absence of Right Breast"] A
    return A.effectiveDateTime

define "Hx Mastectomy Right":
  [Observation: "Unilateral Mastectomy Right"] U
    return U.effectiveDateTime

*/

/* Mammography		Indicates mammography was provided on the indicated date of service */

define Mammography:
  exists (
    [Observation: "Mammography"] M
      where M.effectiveDateTime intersect "Lookback Interval Twenty-Seven Months"
    )
