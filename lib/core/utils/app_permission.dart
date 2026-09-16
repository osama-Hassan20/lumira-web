
// // ─── Permission enum ──────────────────────────────────────────────────────────
// // Single source of truth for every permission flag in the system.
// // Use [Permission.check] to evaluate a flag against an [EmployeePermissions].

// enum Permission {
//   home,
//   patients,
//   appointments,
//   consultations,
//   employees,
//   statistics,
//   servicePricing,
//   medicinesManage,
//   radiologyTests,
//   labTests,
//   chronicDiseases,
//   allergies,
//   surgery,
//   settings,
//   support,
// }

// extension PermissionX on Permission {
//   /// Returns `true` if this permission is granted in [p].
//   bool check(EmployeePermissions p) {
//     switch (this) {
//       case Permission.home:
//         return p.home;
//       case Permission.patients:
//         return p.patients;
//       case Permission.appointments:
//         return p.appointments;
//       case Permission.consultations:
//         return p.consultations;
//       case Permission.employees:
//         return p.employees;
//       case Permission.statistics:
//         return p.statistics;
//       case Permission.servicePricing:
//         return p.servicePricing;
//       case Permission.medicinesManage:
//         return p.medicinesManage;
//       case Permission.radiologyTests:
//         return p.radiologyTests;
//       case Permission.labTests:
//         return p.labTests;
//       case Permission.chronicDiseases:
//         return p.chronicDiseases;
//       case Permission.allergies:
//         return p.allergies;
//       case Permission.surgery:
//         return p.surgery;
//       case Permission.settings:
//         return p.settings;
//       case Permission.support:
//         return p.support;
//     }
//   }
// }
