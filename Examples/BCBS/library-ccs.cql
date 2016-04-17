/*

HPV Test      	Indicates an HPV test was performed on the indicated date of service.
                If this is present within 4 days of a cervical cytology screening, that screening is valid for 5 years.
                If this is not present within 4 days of a cervical cytology screening, that screening is only valid for 3 years.
                "HPV Tests"
                CPT, LOINC
                5 years

Pap Smear       Indicates a Pap Smear was provided on the indicated date of service, must include result for compliance
                "Cervical Cytology"
                CPT, HCPCS, LOINC
                5 years

Hx Hysterectomy	Date of total hysterectomy
                "Absence of Cervix"
                CPT, ICD10PCS, ICD10CM
                Unlimited

*/

/* I could not find these value sets */
valueset "HPV Tests": ''
valueset "Cervical Cytology": '2.16.840.1.113883.3.464.1004.1208'
valueset "Absence of Cervix": ''

parameter MeasurementPeriod Interval<DateTime>

define "Lookback Interval Five Years":
  Interval[start of MeasurementPeriod - 5 years, start of MeasurementPeriod]

/* Pap Smear       Indicates a Pap Smear was provided on the indicated date of service, must include result for compliance */

define "Pap Smear":
  exists ("Had Pap Smear in DOS")

define "Had Pap Smear in DOS":
  [Observation: "Cervical Cytology"] C
    where C.value = Code{code: '88141' system: "http://www.ama-assn.org/go/cpt" display: 'Cytopathology, cervical or vaginal (any reporting system), requiring interpretation by physician'}
      and C.effectiveDateTime intersect "Lookback Interval Five Years"

/*

  HPV Test      	Indicates an HPV test was performed on the indicated date of service.
                  If this is present within 4 days of a cervical cytology screening, that screening is valid for 5 years.
                  If this is not present within 4 days of a cervical cytology screening, that screening is only valid for 3 years.
                  TODO: I am not sure what to do with the two if-statements above...
*/

define "HPV Test":
  exists("Had HPV Test in DOS")

define "Had HPV Test in DOS":
  [Observation: "HPV Tests"] H
    where H.effectiveDateTime intersect "Lookback Interval Five Years"

/* Hx Hysterectomy	Date of total hysterectomy */

define "Hx Hysterectomy":
  [Observation: "Absence of Cervix"] A
    return A.effectiveDateTime
