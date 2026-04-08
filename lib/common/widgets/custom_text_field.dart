import 'package:elmotamizon/common/extensions/context_extension.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui' as ui;

class Customtextfield extends StatelessWidget {
  const Customtextfield(
      {super.key,
      required this.hintText,
      required this.textEditingController,
      this.prefix,
      this.suffix,
      this.obscureText = false,
      this.isFilled = false,
      this.maxLines = 1, // Default value for maxLines
      this.validator,
      this.fillColor,
      this.keyboardType,
      this.maxlength,
      this.onSubmitted,
      this.noBorder,
      this.radius,
      this.hintStyle,
      this.onChanged,
      this.readOnly,
      this.borderColor});
  final String hintText;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final Color? borderColor;
  final bool? noBorder;
  final TextEditingController textEditingController;
  final Widget? prefix;
  final Widget? suffix;
  final bool obscureText;
  final int maxLines; // Allows customization of max lines
  final double? radius;
  final bool isFilled;
  final TextInputType? keyboardType; // Dynamic type for flexibility
  final String? Function(String?)? onSubmitted;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final int? maxlength; // Optional max length
  final bool? readOnly;
  // final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        readOnly: readOnly ?? false,
        onFieldSubmitted: onSubmitted,
        onChanged: onChanged,
        keyboardType: keyboardType,
        style: readOnly ?? false
            ? context.textTheme.headlineLarge!.copyWith(color: Colors.grey)
            : context.textTheme.headlineLarge,
        validator: validator,
        controller: textEditingController,
        obscureText: obscureText,
        maxLines: maxLines,
        maxLength: maxlength,
        selectionHeightStyle: ui.BoxHeightStyle.includeLineSpacingMiddle,
        // onTapOutside: (event) => _focusNode.unfocus(),// FocusNode().unfocus()
        decoration: InputDecoration(
          errorMaxLines: 3,
          contentPadding:
              EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.w),
          hintText: hintText,
          fillColor:
              isFilled ? Theme.of(context).scaffoldBackgroundColor : fillColor,
          filled: true,
          hintStyle:
              hintStyle ?? TextStyle(color: Colors.grey, fontSize: 14.sp),
          prefixIcon: prefix,
          suffixIcon: suffix,
          border: OutlineInputBorder(
              borderSide:
                  BorderSide(color: borderColor ?? ColorManager.borderColor),
              borderRadius: BorderRadius.circular(radius ?? 10.r)),
          enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: borderColor ?? ColorManager.borderColor),
              borderRadius: BorderRadius.circular(radius ?? 10.r)),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: borderColor ?? ColorManager.primary),
              borderRadius: BorderRadius.circular(radius ?? 10.r)),
          errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorManager.borderColor),
              borderRadius: BorderRadius.circular(radius ?? 10.r)),
          disabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorManager.borderColor),
              borderRadius: BorderRadius.circular(radius ?? 10.r)),
          errorStyle: TextStyle(
            fontSize: 12.sp,
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
        ));
  }
}
