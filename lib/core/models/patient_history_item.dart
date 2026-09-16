// ─── PatientHistoryItem ──────────────────────────────────────────────────────
//
// Covers all list-based fields shared between ConsultationModel & PatientModel:
//   • medications      → idKey = 'medication', has frequency + notes
//   • labTests         → idKey = 'test',        has file + notes
//   • radiologyTests   → idKey = 'radiology',   has file + notes
//   • pastSurgeries    → idKey = 'surgery',      has name + date
//   • allergies        → plain String
//   • chronicDiseases  → plain String
//   • pastMedications  → idKey = 'medication'
//   • pastLabTests     → idKey = 'test'
//   • pastRadiologyTests → idKey = 'radiology'

import 'package:equatable/equatable.dart';

class PatientHistoryItem extends Equatable {
  final String? id; // _id of the list-item itself
  final String?
  refId; // id of the referenced document (medication / test / radiology)
  final String?
  name; // display name (medicationName / plain string / surgery name)
  final DateTime? date; // surgery date / followUpDate
  final String? file; // file path or URL
  final String? notes; // notes for lab/radiology/medication
  final String? frequency; // medication frequency

  const PatientHistoryItem({
    this.id,
    this.refId,
    this.name,
    this.date,
    this.file,
    this.notes,
    this.frequency,
  });

  // ─── fromJson ──────────────────────────────────────────────────────────────

  factory PatientHistoryItem.fromJson(dynamic json, String idKey) {
    // Plain string (e.g. allergies / chronicDiseases)
    if (json == null) return const PatientHistoryItem();
    if (json is String) return PatientHistoryItem(name: json);
    if (json is! Map<String, dynamic>) return const PatientHistoryItem();

    final refRaw = json[idKey];
    String? refId;
    String? name;

    if (refRaw != null) {
      // Populated object
      if (refRaw is Map) {
        refId = refRaw['_id']?.toString() ?? refRaw['id']?.toString();
        name = refRaw['name']?.toString();
      } else {
        refId = refRaw.toString();
      }
    }

    // Name fallback: <idKey>Name field (e.g. medicationName) or any
    // key that ends with 'Name' (e.g. imageName for radiology).
    name ??=
        json['${idKey}Name']?.toString() ??
        json['${idKey}name']?.toString() ??
        json['name']?.toString();

    if (name == null) {
      for (final k in json.keys) {
        if (k.toLowerCase().endsWith('name')) {
          name = json[k]?.toString();
          if (name != null) break;
        }
      }
    }

    return PatientHistoryItem(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      refId: refId,
      name: name,
      date: json['date'] != null
          ? DateTime.tryParse(json['date'].toString())
          : json['followUpDate'] != null
          ? DateTime.tryParse(json['followUpDate'].toString())
          : null,
      file: json['file']?.toString(),
      notes: json['notes']?.toString(),
      frequency: json['frequency']?.toString(),
    );
  }

  // ─── toJson ────────────────────────────────────────────────────────────────

  Map<String, dynamic> toJson(String idKey) {
    final nameKey = idKey == 'radiology' ? 'imageName' : '${idKey}Name';
    final shouldIncludeDate =
        idKey == 'surgery' ||
        idKey == 'pastSurgeries' ||
        idKey == 'test' ||
        idKey == 'pastLabTests';
    final dateValue =
        date ??
        (idKey == 'pastLabTests'
            ? DateTime.now().toUtc()
            : null);

    return {
      if (refId != null) idKey: refId,
      if (name != null) nameKey: name,
      if (shouldIncludeDate && dateValue != null)
        'date': dateValue.toIso8601String(),
      if (file != null) 'file': file,
      if (notes != null) 'notes': notes,
      if (frequency != null) 'frequency': frequency,
    };
  }

  // ─── copyWith ──────────────────────────────────────────────────────────────

  PatientHistoryItem copyWith({
    String? id,
    String? refId,
    String? name,
    DateTime? date,
    String? file,
    String? notes,
    String? frequency,
  }) => PatientHistoryItem(
    id: id ?? this.id,
    refId: refId ?? this.refId,
    name: name ?? this.name,
    date: date ?? this.date,
    file: file ?? this.file,
    notes: notes ?? this.notes,
    frequency: frequency ?? this.frequency,
  );

  // ─── Equatable ──────────────────────────────────────────────────────────────

  @override
  List<Object?> get props => [id, refId, name, date, file, notes, frequency];
}
