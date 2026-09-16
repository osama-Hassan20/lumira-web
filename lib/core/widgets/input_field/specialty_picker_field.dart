// import 'package:flutter/material.dart';

// import '../../../config/app_constants.dart';
// import '../../../core/animations/slide_transition_animation.dart';
// import '../../../core/dependency_injection/dependency_injection.dart';
// import '../../../core/extensions/localization_extension.dart';
// import '../../../core/models/query_param_model.dart';
// import '../../../core/models/reference_data_model.dart';
// import '../../../core/uses cases/get_specialties_use_case.dart';
// import '../animated_dialog.dart';
// import '../custom_text_field.dart';
// import '../../../features/auth/presentation/screens/widgets/sign_up/sign_up_selection_list_dialog.dart';

// /// A self-contained specialty picker field.
// ///
// /// Renders a read-only [CustomTextField] wrapped in a [SlideTransitionAnimation].
// /// On tap it shows a selection dialog that fetches its own data.
// /// The chosen value's name is written into [controller], and both
// /// [onChanged] (with name) and [onSelected] (with model) are called.
// class SpecialtyPickerField extends StatelessWidget {
//   const SpecialtyPickerField({
//     super.key,
//     required this.controller,
//     this.onChanged,
//     this.onSelected,
//   });

//   final TextEditingController controller;
//   final ValueChanged<String>? onChanged;
//   final ValueChanged<ReferenceDataModel>? onSelected;

//   Future<void> _openPicker(BuildContext context) async {
//     final selected = await showAnimatedDialog<ReferenceDataModel>(
//       context: context,
//       child: SignUpSelectionListDialog<ReferenceDataModel>(
//         title: context.l10n.tr('auth_specialties_dialog_title'),
//         onFetch: (page) => getIt.get<GetSpecialtiesUseCase>().call(
//               params: QueryParamModel(page: page, limit: 20),
//             ),
//         labelBuilder: (m) => m.name,
//         emptyText: context.l10n.tr('auth_specialties_empty'),
//       ),
//     );

//     if (selected == null) return;
//     controller.text = selected.name;
//     onChanged?.call(selected.name);
//     onSelected?.call(selected);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SlideTransitionAnimation(
//       duration: const Duration(
//         milliseconds:
//             AppConstants.animationDuration + AppConstants.animationIncrement,
//       ),
//       begin: const Offset(0, 1),
//       end: Offset.zero,
//       curve: Curves.easeOutCubic,
//       child: CustomTextField(
//         controller: controller,
//         title: context.l10n.tr('auth_specialty'),
//         hintText: context.l10n.tr('auth_select_specialty'),
//         readOnly: true,
//         onTap: () => _openPicker(context),
//         suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
//       ),
//     );
//   }
// }
