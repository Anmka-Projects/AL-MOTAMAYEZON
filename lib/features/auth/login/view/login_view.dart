import 'package:elmotamizon/app/app_prefs.dart';
import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/common/extensions/context_extension.dart';
import 'package:elmotamizon/common/widgets/custom_text_field.dart';
import 'package:elmotamizon/constants/assets.dart';
import 'package:elmotamizon/features/auth/forget_password/view/forget_password_view.dart';
import 'package:elmotamizon/features/auth/login/cubit/login_cubit.dart';
import 'package:elmotamizon/features/auth/signup/models/user_model.dart';
import 'package:elmotamizon/features/auth/signup/view/signup_view.dart';
import 'package:elmotamizon/features/auth/user_type/user_type_view.dart';
import 'package:elmotamizon/features/auth/verify_otp/view/verify_otp_view.dart';
import 'package:elmotamizon/features/bottom_nav_bar/view/bottom_nav_bar_view.dart';
import 'package:elmotamizon/common/widgets/default_form_field.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../../../app/imports.dart';
import '../../../../common/resources/assets_manager.dart';
import '../../../../common/resources/color_manager.dart';
import '../../../../common/resources/strings_manager.dart';
import '../../../../common/resources/styles_manager.dart';
import '../../../../common/widgets/default_button_widget.dart';

class LoginView extends StatefulWidget {
  final int pageIndex;
  const LoginView({super.key, this.pageIndex = 2});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();
  // final String _countryCode = '+20';

  @override
  void dispose() {
    super.dispose();
    emailTextEditingController.dispose();
    _passwordController.dispose();
    _formKey.currentState?.dispose();
    // _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
              20.w, MediaQuery.sizeOf(context).height * .1, 20.w, 15.h),
          children: [
            // SizedBox(height: 30.h,),
            // Image.asset(ImageAssets.logo,height: 100.h,),
            // SizedBox(height: 40.h,),
            // Text(AppStrings.login.tr(), style: getBoldStyle(fontSize: 15.sp, color: ColorManager.black),textAlign: TextAlign.center,),
            // SizedBox(height: 5.h,),
            // Text(AppStrings.loginNow.tr(), style: getRegularStyle(fontSize: 15.sp, color: ColorManager.textColor),textAlign: TextAlign.center,),
            // SizedBox(height: 30.h,),
            // DefaultFormField(
            //   keyboardType: TextInputType.phone,
            //   noBorder: false,
            //   controller: _phoneController,
            //   fillColor: ColorManager.fillColor,
            //   borderColor: ColorManager.greyBorder,
            //   hintText: AppStrings.phoneNumber.tr(),
            //   title: AppStrings.phoneNumber.tr(),
            //   prefixWidget: CountryCodePicker(
            //     padding: EdgeInsets.all(2.r),
            //     onChanged: (value) {
            //       if(value.dialCode != null)  _countryCode = value.dialCode!;
            //     },
            //     // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
            //     initialSelection: 'EG',
            //     favorite: const ['EG','SA'],
            //     // optional. Shows only country name and flag
            //     showCountryOnly: false,
            //     // optional. Shows only country name and flag when popup is closed.
            //     showOnlyCountryWhenClosed: false,
            //     // optional. aligns the flag and the Text left
            //     alignLeft: false,
            //     dialogTextStyle: getBoldStyle(fontSize: 15.sp, color: ColorManager.black),
            //     showDropDownButton: true,
            //   ),
            // ),

            Column(
              children: [
                Gap(context.screenHeight * 0.1),
                Text(
                  AppStrings.welcome.tr(),
                  style: context.textTheme.displayLarge!.copyWith(
                    color: ColorManager.primary,
                    fontSize: 36.sp,
                  ),
                ),
                Text(
                  AppStrings.login.tr(),
                  style: context.textTheme.displayLarge!.copyWith(
                    color: ColorManager.primary,
                    fontSize: 40.sp,
                  ),
                ),
                Text(
                  AppStrings.enterYourData.tr(),
                  style: context.textTheme.bodyLarge!.copyWith(
                    color: ColorManager.textGrayColor,
                    fontSize: 18.sp,
                  ),
                ),
              ],
            ),
            Gap(context.screenHeight * 0.07),
            // Customtextfield(
            //   hintText: AppStrings.email.tr(),
            //   fillColor: Colors.white,
            //   textEditingController: emailTextEditingController,
            //   prefix: Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 15.h),
            //     child: SvgPicture.asset(
            //       Assets.assetsIconsEmail,
            //     ),
            //   ),
            // ),
            DefaultFormField(
              noBorder: false,
              controller: emailTextEditingController,
              fillColor: Colors.white,
              borderColor: ColorManager.greyBorder,
              hintText: AppStrings.emailAddress.tr(),
              title: AppStrings.emailAddress.tr(),
            ),

            SizedBox(
              height: 20.h,
            ),
            DefaultFormField(
              noBorder: false,
              controller: _passwordController,
              fillColor: Colors.white,
              borderColor: ColorManager.greyBorder,
              // prefixIconPath: IconAssets.lock,
              hintText: AppStrings.password.tr(),
              title: AppStrings.password.tr(),
              obscureText: true,
            ),
            SizedBox(
              height: 15.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                    onTap: () {
                      AppFunctions.navigateTo(
                          context, const ForgetPasswordView());
                    },
                    child: Text(
                      AppStrings.forgotPassword.tr(),
                      style: getBoldStyle(
                          fontSize: 14.sp, color: ColorManager.primary),
                    ))
              ],
            ),
            SizedBox(
              height: 30.h,
            ),
            _loginButton(context),
            SizedBox(
              height: 20.h,
            ),
            _signupWidget(),
            SizedBox(
              height: 10.h,
            ),
            _guestWidget(),
          ],
        ),
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<LoginCubit>(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == Status.failure) {
            AppFunctions.showsToast(
                state.errorMessage!, ColorManager.red, context);
            if (state.failure is ActiveAccountFailure) {
              AppFunctions.navigateTo(
                  context,
                  VerifyOtpView(
                      phone: emailTextEditingController.text,
                      isForgetPassword: false));
            }
          }
          if (state.status == Status.success) {
            AppFunctions.navigateToAndFinish(
                context,
                 BottomNavBarView(
                    pageIndex: widget.pageIndex,
                    ));
          }
        },
        builder: (context, state) {
          return DefaultButtonWidget(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                context.read<LoginCubit>().login(
                    emailTextEditingController.text,
                    _passwordController.text.trim());
              }
            },
            text: AppStrings.next.tr(),
            color: ColorManager.primary,
            textColor: ColorManager.white,
            isIcon: true,
            isText: true,
            textFirst: true,
            fontSize: 15.sp,
            isLoading: state.status == Status.loading,
            verticalPadding: state.status == Status.loading ? 15.h : 5.h,
            horizontalPadding: 5.w,
            radius: 25.r,
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
      ),
    );
  }

  Widget _signupWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.dontHaveAccount.tr(),
          style: getLightStyle(fontSize: 14.sp, color: ColorManager.textColor),
        ),
        SizedBox(
          width: 5.w,
        ),
        InkWell(
          onTap: () {
            AppFunctions.navigateTo(
                context,
                const SignUpView(
                  userType: 'student',
                ));
            // AppFunctions.navigateTo(context, const UserTypeView());
          },
          child: Text(
            AppStrings.signup.tr(),
            style: getBoldStyle(fontSize: 15.sp, color: ColorManager.primary),
          ),
        ),
      ],
    );
  }

  Widget _guestWidget() {
    return DefaultButtonWidget(
      elevation: 0,
      text: AppStrings.continueAsAGuest.tr(),
      color: ColorManager.white,
      textColor: ColorManager.primary,
      onPressed: () =>
          AppFunctions.navigateToAndFinish(context, const BottomNavBarView()),
    );
  }
}
