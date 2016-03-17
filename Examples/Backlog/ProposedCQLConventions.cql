// Pascal-casing for model class names
// Camel-casing for model attribute names
// Always use quoted identifiers for variable and type names
// All variable names start with a $ within the quote
// Never use quoted identifiers for attribute names +1
// The central construct in CQL is a query, which is a clause-based construct:


//primary-source alias
//	with-or-without-clauses
//	where-clause
//	return-clause
//	sort-clause


// Simple queries can just be a single line:
[Encounter: "Inpatient"] E

// More complex queries need multiple lines, but clauses should be on their own line if possible:
[Encounter: "Inpatient"] E
  where duration in days of E.period >= 120

// If a clause needs more than one line, it's continuations are indented beneath the clause:
[CommunicationRequest] C
  where C.mode = 'ordered'
    and C.sender.role = 'nurse'
    and C.recipient.role = 'doctor'
    and C.indication in "Fever"

// Each new clause starts indented one level below the query:
[Encounter: "Inpatient"] E
  with [Condition: "Acute Pharyngitis"] P
    such that P.onsetDateTime during E.period
      and P.abatementDate after end of E.period
  where duration in days of E.period >= 120
  return Tuple { id: E.id, lengthOfStay: duration in days of E.period }
  sort by lengthOfStay desc
