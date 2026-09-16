import 'package:flutter/material.dart';
import 'theme/app_colors.dart';

enum RequestStatus { initial, loading, loadingMoreData, success, failure }

enum OtpPurpose { signUp, resetPassword, changePhone }

// دكتور / مساعد دكتور
enum UserRoles { doctor, receptionist }

// ─── Blood type enum ─────────────────────────────────────────────────────────

enum BloodType {
  aPositive,
  aNegative,
  bPositive,
  bNegative,
  abPositive,
  abNegative,
  oPositive,
  oNegative,
}

// ─── Gender enum ─────────────────────────────────────────────────────────────

enum Gender { male, female }

// ─── Support method type enum ───────────────────────────────────────────────
enum SupportMethodType { phone, email, address, facebook, x, instagram, link }

extension GenderX on Gender {
  String get backendKey {
    switch (this) {
      case Gender.male:
        return 'male';
      case Gender.female:
        return 'female';
    }
  }
}

// ─── Clinic type enum ────────────────────────────────────────────────────────

enum ClinicType { hospital, publicClinic, privateClinic }

extension ClinicTypeX on ClinicType {
  /// The value sent to the backend (matches ClinicType enum on server).
  String get backendKey {
    switch (this) {
      case ClinicType.hospital:
        return 'hospital';
      case ClinicType.publicClinic:
        return 'publicClinic';
      case ClinicType.privateClinic:
        return 'privateClinic';
    }
  }

  /// Used as a prefix for translation keys, e.g. `auth_${translationKey}_name`.
  String get translationKey {
    switch (this) {
      case ClinicType.hospital:
        return 'hospital';
      case ClinicType.publicClinic:
        return 'public_clinic';
      case ClinicType.privateClinic:
        return 'private_clinic';
    }
  }
}

// ─── Appointment status enum ──────────────────────────────────────────────────

enum AppointmentStatus { newStatus, rescheduled, completed, cancelled }

extension AppointmentStatusX on AppointmentStatus {
  String get backendKey {
    switch (this) {
      case AppointmentStatus.newStatus:
        return 'new';
      case AppointmentStatus.rescheduled:
        return 'rescheduled';
      case AppointmentStatus.completed:
        return 'completed';
      case AppointmentStatus.cancelled:
        return 'cancelled';
    }
  }
}

// ─── Visit type enum ─────────────────────────────────────────────────────────

enum VisitType {
  newVisit, // جديد
  followUp, // مراجعة
}

extension VisitTypeX on VisitType {
  /// The value sent to the backend in the request body.
  String get backendKey {
    switch (this) {
      case VisitType.newVisit:
        return 'new';
      case VisitType.followUp:
        return 'followUp';
    }
  }

  /// Translation key for the display label — pass to `context.l10n.tr()`.
  String get labelKey {
    switch (this) {
      case VisitType.newVisit:
        return 'home_visit_new';
      case VisitType.followUp:
        return 'home_visit_follow_up';
    }
  }
}

extension VisitTypeParseX on String? {
  VisitType toVisitType({VisitType fallback = VisitType.newVisit}) {
    return VisitType.values.firstWhere(
      (e) => e.backendKey == this,
      orElse: () => fallback,
    );
  }
}

enum NavigateAfterOtpVerification { signUp, forgotPassword, forgetPin }

// ─── Store join request status enum ──────────────────────────────────────────

enum StoreJoinStatus { pending, active, approved, rejected }

extension StoreJoinStatusX on StoreJoinStatus {
  String get backendKey {
    switch (this) {
      case StoreJoinStatus.pending:
        return 'pending';
      case StoreJoinStatus.active:
        return 'active';
      case StoreJoinStatus.approved:
        return 'approved';
      case StoreJoinStatus.rejected:
        return 'rejected';
    }
  }

  String get label {
    switch (this) {
      case StoreJoinStatus.pending:
        return 'قيد المراجعة';
      case StoreJoinStatus.active:
      case StoreJoinStatus.approved:
        return 'تمت الموافقة';
      case StoreJoinStatus.rejected:
        return 'مرفوض';
    }
  }

  Color get color {
    switch (this) {
      case StoreJoinStatus.pending:
        return AppColors.yellow;
      case StoreJoinStatus.active:
      case StoreJoinStatus.approved:
        return AppColors.green00;
      case StoreJoinStatus.rejected:
        return AppColors.red202;
    }
  }
}

extension StoreJoinStatusParseX on String? {
  StoreJoinStatus toStoreJoinStatus({
    StoreJoinStatus fallback = StoreJoinStatus.pending,
  }) {
    return StoreJoinStatus.values.firstWhere(
      (e) => e.backendKey == this,
      orElse: () => fallback,
    );
  }
}
