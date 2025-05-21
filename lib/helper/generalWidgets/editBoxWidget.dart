import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plant_task/helper/styles/colorsRes.dart';

Widget editBoxWidget(
    BuildContext context,
    TextEditingController edtController,
    Function validationFunction,
    String label,
    String errorLabel,
    TextInputType inputType,
    {Widget? tailIcon,
    Widget? leadingIcon,
    bool? isLastField,
    bool? isEditable = true,
    bool? isObscureText = false,
    List<TextInputFormatter>? inputFormatters,
    TextInputAction? optionalTextInputAction,
    int? minLines,
    int? maxLines}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextFormField(
        enabled: isEditable,
        obscureText: isObscureText!,
        style: TextStyle(
          color:
              ColorsRes.mainTextColor, // Replace with your desired text color
        ),
        maxLines: maxLines,
        minLines: minLines,
        controller: edtController,
        textInputAction: optionalTextInputAction ??
            (isLastField == true ? TextInputAction.done : TextInputAction.next),
        decoration: InputDecoration(
          prefixIcon: leadingIcon,
          suffixIcon: tailIcon,
          prefixIconConstraints: const BoxConstraints(
            minWidth: 48,
            minHeight: 48,
          ),
          suffixIconConstraints: const BoxConstraints(
            minWidth: 48,
            minHeight: 48,
          ),
          fillColor: Theme.of(context).cardColor,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            borderSide: BorderSide(
               color: ColorsRes.appColor,// Replace with your desired focus border color
              width: 1,
              style: BorderStyle.solid,
              strokeAlign: BorderSide.strokeAlignCenter,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            borderSide: BorderSide(
              color: ColorsRes.subTitleMainTextColor.withOpacity(0.5),
              width: 1,
              style: BorderStyle.solid,
              strokeAlign: BorderSide.strokeAlignCenter,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            borderSide: BorderSide(
               color: ColorsRes.appColorRed,  // Replace with your desired error border color
              width: 1,
              style: BorderStyle.solid,
              strokeAlign: BorderSide.strokeAlignCenter,
                          ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            borderSide: BorderSide(
               color: ColorsRes.subTitleMainTextColor, // Replace with your desired enabled border color
              width: 1,
              style: BorderStyle.solid,
              strokeAlign: BorderSide.strokeAlignCenter,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.5),
              width: 1,
              style: BorderStyle.solid,
            ),
          ),
          labelText: label,
          labelStyle: TextStyle(color: ColorsRes.subTitleMainTextColor), // Replace with your desired label color
          isDense: true,
          floatingLabelStyle: WidgetStateTextStyle.resolveWith(
            (Set<WidgetState> states) {
              final Color color = states.contains(WidgetState.error)
                  ? Theme.of(context).colorScheme.error
                  : ColorsRes.appColor;
              return TextStyle(color: color, letterSpacing: 1.3);
            },
          ),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: inputType,
        inputFormatters: inputFormatters ?? [],
        validator: (String? value) {
          return validationFunction(value ?? "") == null ? null : errorLabel;
        },
      )
    ],
  );
}
