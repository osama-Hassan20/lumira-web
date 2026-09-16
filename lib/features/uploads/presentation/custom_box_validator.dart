import 'package:flutter/material.dart';

import '../../../core/utils/theme/app_colors.dart';
import '../../../core/utils/theme/app_font_styles.dart';

class CustomBoxValidator<T> extends FormField<T> {
  CustomBoxValidator({
    super.key,
    super.initialValue,
    super.validator,
    super.onSaved,
    required Widget Function(FormFieldState<T> state) builder,
    required BuildContext context,
    bool autovalidate = false,
  }) : super(
         autovalidateMode: autovalidate
             ? AutovalidateMode.always
             : AutovalidateMode.onUserInteraction, // Changed from disabled
         builder: (state) {
           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               builder(state),
               if (state.hasError)
                 Padding(
                   padding: const EdgeInsets.only(top: 4.0),
                   child: Text(
                     state.errorText ?? '',
                     style: AppFontStyle.regular12(
                       context, // Use state.context instead
                     ).copyWith(color: AppColors.red, fontSize: 13),
                   ),
                 ),
             ],
           );
         },
       );
}
