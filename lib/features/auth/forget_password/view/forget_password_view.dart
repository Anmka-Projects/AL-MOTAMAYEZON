import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/resources/assets_manager.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:elmotamizon/common/widgets/default_button_widget.dart';
import 'package:elmotamizon/common/widgets/default_form_field.dart';
import 'package:elmotamizon/features/auth/forget_password/bloc/forget_password_cubit.dart';
import 'package:elmotamizon/features/auth/verify_otp/view/verify_otp_view.dart';
// import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({
    super.key,
  });

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  late ForgetPasswordCubit _forgetPasswordBloc;
  // final String _countryCode = '+20';

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _formKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<ForgetPasswordCubit>(),
      child: Builder(builder: (context) {
        _forgetPasswordBloc = context.read<ForgetPasswordCubit>();
        return Scaffold(
          body: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                  20.w, MediaQuery.sizeOf(context).height * .1, 20.w, 15.h),
              children: [
                SizedBox(
                  height: 30.h,
                ),
                Image.asset(
                  ImageAssets.logo,
                  height: 100.h,
                ),
                SizedBox(
                  height: 40.h,
                ),
                Text(
                  AppStrings.forgotPassword.tr(),
                  style:
                      getBoldStyle(fontSize: 15.sp, color: ColorManager.black),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  AppStrings.enterYourPhoneNumber.tr(),
                  style: getRegularStyle(
                      fontSize: 15.sp, color: ColorManager.textColor),
                  textAlign: TextAlign.center,
                ),
                // SizedBox(
                //   height: 30.h,
                // ),
                // DefaultFormField(
                //   keyboardType: TextInputType.phone,
                //   noBorder: false,
                //   controller: _phoneController,
                //   fillColor: ColorManager.fillColor,
                //   borderColor: ColorManager.greyBorder,
                //   hintText: AppStrings.phoneNumber.tr(),
                //   title: AppStrings.phoneNumber.tr(),
                //   suffixIcon: CountryCodePicker(
                //     padding: EdgeInsets.all(2.r),
                //     onChanged: (value) {
                //       if (value.dialCode != null) {
                //         _countryCode = value.dialCode!;
                //       }
                //     },
                //     // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                //     initialSelection: 'EG',
                //     favorite: const ['EG', 'SA'],
                //     // optional. Shows only country name and flag
                //     showCountryOnly: false,
                //     // optional. Shows only country name and flag when popup is closed.
                //     showOnlyCountryWhenClosed: false,
                //     // optional. aligns the flag and the Text left
                //     alignLeft: false,
                //     dialogTextStyle: getBoldStyle(
                //         fontSize: 15.sp, color: ColorManager.black),
                //     showDropDownButton: true,
                //   ),
                // ),

                DefaultFormField(
                  noBorder: false,
                  controller: _emailController,
                  fillColor: ColorManager.fillColor,
                  borderColor: ColorManager.greyBorder,
                  hintText: AppStrings.emailAddress.tr(),
                  title: AppStrings.emailAddress.tr(),
                ),
                SizedBox(
                  height: 20.h,
                ),
                _activeAccountContent(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _activeAccountContent() {
    return BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == Status.failure) {
          AppFunctions.showsToast(
              state.errorMessage ?? '', ColorManager.red, context);
        }
        if (state.status == Status.success) {
          AppFunctions.navigateTo(
              context,
              VerifyOtpView(
                phone: _emailController.text.trim(),
                isForgetPassword: true,
              ));
        }
      },
      builder: (context, state) {
        return DefaultButtonWidget(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              _forgetPasswordBloc.forgetPassword(_emailController.text.trim());
            }
          },
          text: AppStrings.sendCode.tr(),
          color: ColorManager.primary,
          textColor: ColorManager.white,
          verticalPadding: state.status == Status.loading ? 15.h : 5.h,
          horizontalPadding: 5.w,
          radius: 25.r,
          borderColor: Colors.transparent,
          isLoading: state.status == Status.loading,
          isIcon: true,
          isText: true,
          textFirst: true,
          iconBuilder: CircleAvatar(
            radius: 18.r,
            backgroundColor: ColorManager.white,
            child: SvgPicture.asset(
              IconAssets.rightArrow,
              color: ColorManager.primary,
              width: 13.w,
              height: 13.w,
            ),
          ),
        );
      },
    );
  }
}
