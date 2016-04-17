/*
  Union of:
    * "Medication, Order not done: Medical Reason" for "Antithrombotic ingredient specific"
    * "Medication, Administered not done: Medical Reason" for "Antithrombotic Therapy"
    * "Medication, Order not done: Patient Refusal" for "Antithrombotic Therapy"
    * "Medication, Administered not done: Patient Refusal" for "Antithrombotic Therapy"
*/

define "$Antithrombotic Not Done":
  (["Medication, Order": "Antithrombotic ingredient specific"]
    union ["Medication, Order": "Antithrombotic Therapy"]) O
      where O.negationRationale in ("Medical Reason" union "Patient Refusal")

/*
  Union of:
    * "Medication, Discharge not done: Patient Refusal" for "Statin ingredient specific"
    * "Medication, Discharge not done: Medical Reason" for "Statin ingredeient specific"
*/

define "$Statin At Discharge Not Done":
  ["Medication, Discharge": "Statin ingredient specific"] MD
    //where MD.negationRationale in ("Patient Refusal" union "Medical Reason")
    where MD.negationRationale in "Patient Refusal"
      or MD.negationRationale in "Medical Reason"

/*
  Union of:
    * "Device, Applied not done: Medical Reason" for "Intermittent pneumatic compression devices (IPC)"
    * "Device, Applied not done: Medical Reason" for "Venous foot pumps (VFP)"
    * "Device, Applied not done: Medical Reason" for "Graduated compression stockings (GCS)"
    * "Device, Order not done: Medical Reason" for "Intermittent pneumatic compression devices (IPC)"
    * "Device, Order not done: Medical Reason" for "Venous foot pumps (VFP)"
    * "Device, Order not done: Medical Reason" for "Graduated compression stockings (GCS)"
*/

define "$No Device VTE Prophylaxis Medical Reason":
  (["Device, Applied": "Intermittent pneumatic compression devices (IPC)"]
      union ["Device, Applied": "Venous foot pumps (VFP)"]
      union ["Device, Applied": "Graduated compression stockings (GCS)"]
      union ["Device, Order": "Intermittent pneumatic compression devices (IPC)"]
      union ["Device, Order": "Venous foot pumps (VFP)"]
      union ["Device, Order": "Graduated compression stockings (GCS)"]
    ) DA
      where DA.negationRationale in "Medical Reason"
