import 'dart:async';

import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/app/app_prefs.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/resources/assets_manager.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:elmotamizon/common/widgets/default_form_field.dart';
import 'package:elmotamizon/features/my_teachers/cubit/my_teachers_cubit.dart';
import 'package:elmotamizon/features/notifications/view/notifications_view.dart';
import 'package:elmotamizon/features/teacher_parent_home/cubit/students/students_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeAppBarWidget extends StatefulWidget {
  final BuildContext studentsOrTeachersContext;
  final bool isStudent;
  const HomeAppBarWidget({super.key, required this.studentsOrTeachersContext, required this.isStudent});

  @override
  State<HomeAppBarWidget> createState() => _HomeAppBarWidgetState();
}

class _HomeAppBarWidgetState extends State<HomeAppBarWidget> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0.w, 0, 0.h, 15.h),
      padding: EdgeInsets.symmetric(vertical: 15.h,horizontal: 15.w),
      decoration: BoxDecoration(
        color: ColorManager.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15.r),
          bottomRight: Radius.circular(15.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: MediaQuery.sizeOf(context).height*.05,),
          _helloSection(),
          SizedBox(height: 20.h,),
          _searchBar(),
        ],
      ),
    );
  }

  Widget _helloSection(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${AppStrings.hello.tr()} ${instance<AppPreferences>().getUserName()}',style: getBoldStyle(fontSize: 17.sp, color: ColorManager.white),),
              SizedBox(height: 2.h,),
              Text(AppStrings.goodMorning.tr(),style: getMediumStyle(fontSize: 15.sp, color: ColorManager.white),),
            ],
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              AppFunctions.navigateTo(context, const NotificationsView());
            },
            child: CircleAvatar(
              radius: 20.r,
              backgroundColor: ColorManager.white.withOpacity(.3),
              child: SvgPicture.asset(IconAssets.notification,height: 18.w,width: 18.w,),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar(){
    return DefaultFormField(
      controller: _searchController,
      noBorder: false,
      hintText: AppStrings.search.tr(),
      prefixIconPath: IconAssets.search,
      onChanged: (value) {
        if (_debounce?.isActive ?? false) _debounce!.cancel();
        _debounce = Timer(const Duration(milliseconds: 800), () {
          if (value.isNotEmpty) {
            if(widget.isStudent){
              widget.studentsOrTeachersContext.read<MyTeachersCubit>().searchText = value;
              widget.studentsOrTeachersContext.read<MyTeachersCubit>().loadFirstMyTeachersPage(isAll: true,);
            }else {
              widget.studentsOrTeachersContext.read<StudentsCubit>().searchText = value;
              widget.studentsOrTeachersContext.read<StudentsCubit>().loadFirstStudentsPage();
            }
          }else{
            if(widget.isStudent){
              widget.studentsOrTeachersContext.read<MyTeachersCubit>().searchText = null;
              widget.studentsOrTeachersContext.read<MyTeachersCubit>().loadFirstMyTeachersPage(isAll: true);
            }else {
              widget.studentsOrTeachersContext.read<StudentsCubit>().searchText = null;
              widget.studentsOrTeachersContext.read<StudentsCubit>().loadFirstStudentsPage();
            }
          }
        });
      },
      // suffixIcon: Row(
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     Text(AppStrings.teachers.tr(),style: getMediumStyle(fontSize: 13.sp, color: ColorManager.greyTextColor),),
      //     SvgPicture.asset(IconAssets.downArrow,height: 7.w,width: 7.w,),
      //   ],
      // ),
    );
  }
}
