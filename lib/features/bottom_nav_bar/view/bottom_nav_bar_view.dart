import 'package:elmotamizon/common/base/courses_type.dart';
import 'package:elmotamizon/common/resources/assets_manager.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/constants/assets.dart';
import 'package:elmotamizon/features/home/Home/view/home_screen.dart';
import 'package:elmotamizon/features/home/Home/view/widgets/show_all.dart';
import 'package:elmotamizon/features/my_courses/view/my_courses_view.dart';
import 'package:elmotamizon/features/profile/view/profile_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../home/Home/view/my_books_view.dart';

class BottomNavBarView extends StatefulWidget {
  final int pageIndex;

  const BottomNavBarView({
    super.key,
    this.pageIndex = 2,
  });

  @override
  State<BottomNavBarView> createState() => _BottomNavBarViewState();
}

class _BottomNavBarViewState extends State<BottomNavBarView> {
  int _selectedIndex = 2;
  static final List<Widget> _studentViews = <Widget>[
    const MyCoursesView(),
    ShowAll(
      text: AppStrings.courseMaterials.tr(),
      type: CoursesType.courseMaterials,
    ),
    const HomeScreen(),
    const MyBooksView(),
    const ProfileView(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.pageIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: ColorManager.white,
      ),
      body: Center(
        child: _studentViews[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: ColorManager.white,
          elevation: 5,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: ColorManager.primary,
          unselectedItemColor: ColorManager.grey,
          selectedLabelStyle:
              TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
          unselectedLabelStyle:
              TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400,color: ColorManager.grey),
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: SvgPicture.asset(
                  IconAssets.myCourses,
                  width: 23.w,
                  height: 23.h,
                  color: ColorManager.grey,
                ),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: CircleAvatar(
                  radius: 25.r,
                  backgroundColor: ColorManager.primary,
                  child: SvgPicture.asset(
                    IconAssets.myCourses,
                    width: 24.w,
                    height: 24.h,
                    color: ColorManager.white,
                  ),
                ),
              ),
              label: AppStrings.myCourses.tr(),
            ),
            // BottomNavigationBarItem(
            //   icon: Padding(
            //     padding: EdgeInsets.only(bottom: 5.h),
            //     child: SvgPicture.asset(
            //       IconAssets.myCourses,
            //       width: 23.w,
            //       height: 23.h,
            //     ),
            //   ),
            //   activeIcon: Padding(
            //     padding: EdgeInsets.only(bottom: 5.h),
            //     child: CircleAvatar(
            //       radius: 23.r,
            //       backgroundColor: ColorManager.primary,
            //       child: SvgPicture.asset(
            //         IconAssets.myCourses,
            //         width: 23.w,
            //         height: 23.h,
            //         color: ColorManager.white,
            //       ),
            //     ),
            //   ),
            //   label: AppStrings.myCourses.tr(),
            // ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: SvgPicture.asset(
                  IconAssets.subject,
                  width: 23.w,
                  height: 23.h,
                  color: ColorManager.grey,
                ),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: CircleAvatar(
                  radius: 25.r,
                  backgroundColor: ColorManager.primary,
                  child: SvgPicture.asset(
                    IconAssets.subject,
                    width: 24.w,
                    height: 24.h,
                    color: ColorManager.white,
                  ),
                ),
              ),
              label: AppStrings.subjects.tr(),
            ),

//*******************home************************* */
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: SvgPicture.asset(
                  IconAssets.home,
                  width: 23.w,
                  height: 23.h,
                  color: ColorManager.grey,
                ),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: CircleAvatar(
                  radius: 25.r,
                  backgroundColor: ColorManager.primary,
                  child: SvgPicture.asset(
                    IconAssets.home,
                    width: 24.w,
                    height: 24.h,
                    color: ColorManager.white,
                  ),
                ),
              ),
              label: AppStrings.home.tr(),
            ),

            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: SvgPicture.asset(
                  Assets.assetsIconsBookSave,
                  width: 23.w,
                  height: 23.h,
                  color: ColorManager.grey,
                ),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: CircleAvatar(
                  radius: 25.r,
                  backgroundColor: ColorManager.primary,
                  child: SvgPicture.asset(
                    Assets.assetsIconsBookSave,
                    width: 24.w,
                    height: 24.h,
                    color: ColorManager.white,
                  ),
                ),
              ),
              label: AppStrings.socialist.tr(),
            ),

            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: SvgPicture.asset(
                  IconAssets.settings,
                  width: 23.w,
                  height: 23.h,
                  color: ColorManager.grey,
                ),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: CircleAvatar(
                  radius: 25.r,
                  backgroundColor: ColorManager.primary,
                  child: SvgPicture.asset(
                    IconAssets.settings,
                    width: 24.w,
                    height: 24.h,
                    color: ColorManager.white,
                  ),
                ),
              ),
              label: AppStrings.settings.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
