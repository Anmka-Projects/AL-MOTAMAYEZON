import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/common/resources/assets_manager.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/language_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:elmotamizon/common/widgets/default_button_widget.dart';
import 'package:elmotamizon/common/widgets/default_radio_button.dart';
import 'package:elmotamizon/features/auth/signup/models/user_model.dart';
import 'package:elmotamizon/features/auth/signup/view/signup_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserTypeView extends StatefulWidget {
  const UserTypeView({super.key});

  @override
  State<UserTypeView> createState() => _UserTypeViewState();
}

class _UserTypeViewState extends State<UserTypeView> {
  UserTypeModel? _selectedUserType;
  
  final List<UserTypeModel> _userTypes = [
    UserTypeModel(id: 1, nameAr: 'طالب', nameEn: "student"),
    UserTypeModel(id: 2, nameAr: 'معلم', nameEn: "teacher"),
    UserTypeModel(id: 3, nameAr: 'ولي أمر', nameEn: "parent"),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.fromLTRB(20.w, MediaQuery.sizeOf(context).height*.1, 20.w, 0),
        children: [
          SizedBox(height: 30.h,),
          Image.asset(ImageAssets.logo,width: 90.w,height: 90.w,),
          SizedBox(height: 40.h,),
          Text(AppStrings.joinAs.tr(), style: getBoldStyle(fontSize: 15.sp, color: ColorManager.black),textAlign: TextAlign.center,),
          SizedBox(height: 5.h,),
          Text(AppStrings.joinAsHint.tr(), style: getRegularStyle(fontSize: 12.sp, color: ColorManager.textColor),textAlign: TextAlign.center,),
          SizedBox(height: 30.h,),
          _userTypesWidget(),
          SizedBox(height: 30.h,),
          _nextButton(),
        ],
      ),
    );
  }

  Widget _userTypesWidget(){
    return StatefulBuilder(
      builder: (context,setState) {
        return Column(children: List.generate(_userTypes.length, (index) => _userTypeWidget(_userTypes[index],setState),),);
      }
    );
  }

  Widget _userTypeWidget(UserTypeModel userType,void Function(void Function()) setState){
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Material(
        elevation: 2,
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(10.r),
        child: DefaultRadioButton(
            selected: userType.id == _selectedUserType?.id,
          title: language == 'en' ? userType.nameEn : userType.nameAr,
          onTap: () {
            setState((){
              _selectedUserType = userType;
            });
          },
          moveToEnd: true,
          titleStyle: getMediumStyle(fontSize: 14.sp, color: ColorManager.textColor),
        ),
      ),
    );
  }

  Widget _nextButton(){
    return DefaultButtonWidget(
      onPressed: () {
        AppFunctions.navigateTo(context, SignUpView(userType: _selectedUserType?.nameEn??'student',));
      },
      text: "\t\t\t${AppStrings.next.tr()}",
      color: ColorManager.primary,
      textColor: ColorManager.white,
      isIcon: true,
      isText: true,
      textFirst: true,
      fontSize: 15.sp,
      verticalPadding: 5.h,
      horizontalPadding: 10,
      radius: 25.r,
      iconBuilder: CircleAvatar(
        radius: 17.r,
        backgroundColor: ColorManager.white,
        child: SvgPicture.asset(
          IconAssets.rightArrow,
          color: ColorManager.primary,
          width: 13.w,
          height: 13.w,
        ),
      ),
    );
  }
}
