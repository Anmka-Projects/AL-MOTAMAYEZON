import 'dart:developer';

import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:elmotamizon/common/widgets/default_form_field.dart';
import 'package:elmotamizon/constants/assets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:elmotamizon/features/teacher_parent_home/cubit/courses/courses_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchView extends StatefulWidget {
  final TextEditingController searchController;

  const SearchView({
    super.key,
    required this.searchController,
  });

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  bool isBook = false;
  bool isCourse = true;
  String type = "course";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(15.r),
            child: DefaultFormField(
              noBorder: false,
              hintText: AppStrings.search.tr(),
              borderColor: ColorManager.borderColor,
              fillColor: Colors.white,
              controller: widget.searchController,
              prefixWidget: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 15.h),
                child: SvgPicture.asset(Assets.assetsIconsNewSearch),
              ),
              onChanged: (value) {
                context.read<CoursesCubit>().loadFirstCoursesPage(
                      isSearch: true,
                      status: value,
                      searchType: type,
                    );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isCourse = true;
                    isBook = false;
                    type = "course";
                  });
                },
                child: _tabItem(
                    text: AppStrings.courses.tr(), isSelected: isCourse),
              ),
              SizedBox(width: 15.w,),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isCourse = false;
                    isBook = true;
                    type = "book";
                  });
                },
                child:
                    _tabItem(text: AppStrings.books.tr(), isSelected: isBook),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _tabItem({
    required String text,
    required bool isSelected,
  }) {
    return AnimatedContainer(
      width: MediaQuery.sizeOf(context).width*.45,
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
        decoration: BoxDecoration(
            color: isSelected ? ColorManager.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: ColorManager.primary,
            )),
        child: Text(
          text,
          style: getBoldStyle(
              fontSize: 13.sp,
              color: isSelected ? ColorManager.white : ColorManager.primary,
          ),
          textAlign: TextAlign.center,
        ),
    );
  }
}
