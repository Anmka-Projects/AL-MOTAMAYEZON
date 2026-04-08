import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/common/resources/assets_manager.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:elmotamizon/common/widgets/default_button_widget.dart';
import 'package:elmotamizon/features/auth/login/view/login_view.dart';
import 'package:elmotamizon/features/auth/signup/view/signup_view.dart';
import 'package:elmotamizon/features/auth/user_type/user_type_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IntroView extends StatefulWidget {
  const IntroView({super.key});

  @override
  State<IntroView> createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.sizeOf(context).height*.25,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Image.asset(ImageAssets.logo),
              ),
              SizedBox(height: MediaQuery.sizeOf(context).height*.1,),
              DefaultButtonWidget(
                onPressed: () {
                  AppFunctions.navigateTo(context, const LoginView(pageIndex: 2));
                },
                text: "\t\t\t${AppStrings.signInWithYourAccount.tr()}",
                color: ColorManager.primary,
                textColor: ColorManager.white,
                isIcon: true,
                isText: true,
                textFirst: true,
                fontSize: 13.sp,
                verticalPadding: 5.h,
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
              ),
              SizedBox(height: 20.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppStrings.dontHaveAccount.tr(),style: getMediumStyle(fontSize: 14.sp, color: ColorManager.greyTextColor),),
                  SizedBox(width: 5.w,),
                  InkWell(
                    onTap: () {
                      AppFunctions.navigateTo(context, const SignUpView(userType: "student"));
                    },
                      child: Text(AppStrings.signup.tr(),style: getBoldStyle(fontSize: 14.sp, color: ColorManager.primary,decoration: TextDecoration.underline),)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
