import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/features/auth/login/view/login_view.dart';
import 'package:elmotamizon/features/auth/reset_password/bloc/reset_password_cubit.dart';
import 'package:elmotamizon/common/widgets/default_form_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/imports.dart';
import '../../../../common/resources/assets_manager.dart';
import '../../../../common/resources/color_manager.dart';
import '../../../../common/resources/strings_manager.dart';
import '../../../../common/resources/styles_manager.dart';
import '../../../../common/widgets/default_button_widget.dart';

class ResetPasswordView extends StatefulWidget {
  final String phone;
  const ResetPasswordView({super.key, required this.phone});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();


  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _formKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, MediaQuery.sizeOf(context).height*.1, 20.w, 15.h),
          children: [
            SizedBox(height: 30.h,),
            Image.asset(ImageAssets.logo,height: 100.h,),
            SizedBox(height: 40.h,),
            Text(AppStrings.resetPassword.tr(), style: getBoldStyle(fontSize: 15.sp, color: ColorManager.black),textAlign: TextAlign.center,),
            SizedBox(height: 5.h,),
            Text(AppStrings.yourNewPasswordMustBeDifferent.tr(), style: getRegularStyle(fontSize: 15.sp, color: ColorManager.textColor),textAlign: TextAlign.center,),
            SizedBox(height: 30.h,),
            DefaultFormField(
              noBorder: false,
              controller: _passwordController,
              fillColor: ColorManager.fillColor,
              borderColor: ColorManager.greyBorder,
              // prefixIconPath: IconAssets.lock,
              hintText: AppStrings.newPassword.tr(),
              title: AppStrings.newPassword.tr(),
              obscureText: true,
            ),
            SizedBox(height: 20.h,),
            DefaultFormField(
              noBorder: false,
              controller: _confirmPasswordController,
              fillColor: ColorManager.fillColor,
              borderColor: ColorManager.greyBorder,
              // prefixIconPath: IconAssets.lock,
              hintText: AppStrings.newPasswordConfirmation.tr(),
              title: AppStrings.newPasswordConfirmation.tr(),
              obscureText: true,
            ),
            SizedBox(height: 30.h,),
            _resetPasswordButton(context),
          ],
        ),
      ),
    );
  }

  Widget _resetPasswordButton(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<ResetPasswordCubit>(),
      child: BlocConsumer<ResetPasswordCubit, BaseState<String>>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if(state.status == Status.failure){
            AppFunctions.showsToast(state.errorMessage!, ColorManager.red, context);
          }
          if(state.status == Status.success){
            AppFunctions.showsToast(state.data??'', ColorManager.successGreen, context);
            AppFunctions.navigateToAndFinish(context, const LoginView());
          }
        },
        builder: (context, state) {

          return DefaultButtonWidget(
            onPressed: () {
              if(_formKey.currentState?.validate()??false) {
                context.read<ResetPasswordCubit>().resetPassword(widget.phone, _passwordController.text.trim(), _confirmPasswordController.text.trim());
              }
            },
            text: AppStrings.save.tr(),
            color: ColorManager.primary,
            textColor: ColorManager.white,
            isIcon: true,
            isText: true,
            textFirst: true,
            fontSize: 15.sp,
            isLoading: state.status== Status.loading,
            verticalPadding: state.status== Status.loading ? 15.h : 5.h,
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
}
