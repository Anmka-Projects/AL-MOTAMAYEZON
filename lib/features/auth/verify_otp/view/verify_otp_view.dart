import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/app/app_prefs.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/resources/assets_manager.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:elmotamizon/common/widgets/default_button_widget.dart';
import 'package:elmotamizon/features/auth/login/view/login_view.dart';
import 'package:elmotamizon/features/auth/reset_password/view/reset_password_view.dart';
import 'package:elmotamizon/features/auth/signup/models/user_model.dart';
import 'package:elmotamizon/features/auth/verify_otp/bloc/resend_otp/resend_otp_cubit.dart';
import 'package:elmotamizon/features/auth/verify_otp/bloc/verify_otp/verify_otp_bloc.dart';
import 'package:elmotamizon/features/bottom_nav_bar/view/bottom_nav_bar_view.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

class VerifyOtpView extends StatefulWidget {
  final String phone;
  final bool isForgetPassword;
  const VerifyOtpView(
      {super.key, required this.phone, required this.isForgetPassword});

  @override
  State<VerifyOtpView> createState() => _VerifyOtpViewState();
}

class _VerifyOtpViewState extends State<VerifyOtpView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _pinController = TextEditingController();
  late VerifyOtpCubit _verifyOtpCubit;
  late ResendOtpCubit _resendOtpCubit;

  @override
  void dispose() {
    super.dispose();
    _formKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => instance<VerifyOtpCubit>(),
        ),
        BlocProvider(
          create: (context) => instance<ResendOtpCubit>(),
        ),
      ],
      child: Builder(builder: (context) {
        _verifyOtpCubit = context.read<VerifyOtpCubit>();
        _resendOtpCubit = context.read<ResendOtpCubit>();
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
                  AppStrings.verifyCode.tr(),
                  style:
                      getBoldStyle(fontSize: 15.sp, color: ColorManager.black),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10.h,
                ),
                // Text(
                //   '${AppStrings.enterTheCodeWeSentToYourPhone.tr()} ${widget.phone}',
                //   style: getRegularStyle(
                //       fontSize: 15.sp, color: ColorManager.textColor),
                //   textAlign: TextAlign.center,
                // ),
                // SizedBox(
                //   height: 30.h,
                // ),
                _otpField(context),
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

  _otpField(BuildContext context) {
    final defaultPinTheme = PinTheme(
      // width: 45.w,
      // height: 45.h,
      padding: EdgeInsets.symmetric(vertical: 10.w),
      textStyle: TextStyle(
          fontSize: 20.sp,
          color: ColorManager.primary,
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: ColorManager.greyBorder),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: ColorManager.primary),
      borderRadius: BorderRadius.circular(10),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: ColorManager.white,
      ),
    );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Pinput(
          length: 5,
          keyboardType: TextInputType.number,
          controller: _pinController,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: focusedPinTheme,
          submittedPinTheme: submittedPinTheme,
          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
          textInputAction: TextInputAction.next,
          showCursor: true,
          validator: (value) {
            if (value?.isEmpty ?? false) {
              return AppStrings.textFieldError.tr();
            }
            return null;
          },
          onCompleted: (code) {
            _verifyOtpCubit.verifyOtp(
                widget.phone, code, widget.isForgetPassword);
          },
        ),
      ),
    );
  }

  Widget _activeAccountContent() {
    return BlocConsumer<VerifyOtpCubit, BaseState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == Status.failure) {
          AppFunctions.showsToast(
              state.errorMessage ?? '', ColorManager.red, context);
        }
        if (state.status == Status.success) {
          if (widget.isForgetPassword) {
            AppFunctions.navigateTo(
                context, ResetPasswordView(phone: widget.phone));
          } else {
            if (instance<AppPreferences>().getUserType() != "teacher") {
              AppFunctions.navigateToAndFinish(
                  context, const BottomNavBarView());
            } else {
              AppFunctions.navigateToAndFinish(context, const LoginView());
            }
          }
        }
      },
      builder: (context, state) {
        return BlocConsumer<ResendOtpCubit, BaseState<String>>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == Status.failure) {
              AppFunctions.showsToast(
                  state.errorMessage ?? '', ColorManager.red, context);
            }
            if (state.status == Status.success) {
              AppFunctions.showsToast(
                  state.data ?? '', ColorManager.successGreen, context);
            }
          },
          builder: (context, state) {
            return DefaultButtonWidget(
              elevation: 0,
              onPressed: () {
                _resendOtpCubit.resendOtp(
                    widget.phone, widget.isForgetPassword);
              },
              text: AppStrings.resendCode.tr(),
              color: Colors.transparent,
              textColor: ColorManager.primary,
              verticalPadding: 12.h,
              borderColor: Colors.transparent,
              isText: true,
              isIcon: true,
              isExpanded: false,
              isLoading: state.status == Status.loading,
              loadingColor: ColorManager.primary,
              textFirst: true,
              iconBuilder: Icon(
                Icons.refresh,
                color: ColorManager.primary,
                size: 25.r,
              ),
            );
          },
        );
      },
    );
  }
}
