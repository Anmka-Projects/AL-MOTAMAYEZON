import 'package:easy_localization/easy_localization.dart';
import 'package:elmotamizon/common/base/courses_type.dart';
import 'package:elmotamizon/common/extensions/context_extension.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/widgets/custom_button.dart';
import 'package:elmotamizon/constants/assets.dart';
import 'package:elmotamizon/features/home/Home/view/widgets/show_all.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import 'widgets/custom_card_image.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:elmotamizon/common/widgets/default_app_bar.dart';

class MyBooksView extends StatefulWidget {
  const MyBooksView({super.key});

  @override
  State<MyBooksView> createState() => _MyBooksViewState();
}

class _MyBooksViewState extends State<MyBooksView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        text: AppStrings.socialist.tr(),
        withLeading: false,
        backgroundColor: ColorManager.white,
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            _tabBar(),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.only(top: 20.h),
                    child: ShowAll(
                      text: AppStrings.popularBooks.tr(),
                      type: CoursesType.isBooks,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(top: 20.h),
                    child: ShowAll(
                      text: AppStrings.popularBooks.tr(),
                      type: CoursesType.isFavoriteBook,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(top: 20.h),
                    child: ShowAll(
                      text: AppStrings.popularBooks.tr(),
                      type: CoursesType.subscribedBooks,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  StatefulBuilder _tabBar() {
    return StatefulBuilder(builder: (context, setState) {
      return TabBar(
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          dividerColor: Colors.transparent,
          indicatorColor: Colors.transparent,
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          labelPadding: EdgeInsetsDirectional.symmetric(horizontal: 5.w),
          onTap: (value) {
            _currentIndex = value;
            // if(value == 0){
            //   context.read<CoursesCubit>().loadFirstCoursesPage(isFavorite: true);
            // } else if(value == 1){
            //   context.read<CoursesCubit>().loadFirstCoursesPage(inProgress: true);
            // } else if(value == 2){
            //   context.read<CoursesCubit>().loadFirstCoursesPage(isCompleted: true);
            // }
            setState(() {});
          },
          tabs: [
            _tabItem(
              isSelected: _currentIndex == 0,
              text: AppStrings.all.tr(),
            ),
            _tabItem(
              isSelected: _currentIndex == 1,
              text: AppStrings.savedBooks.tr(),
            ),
            _tabItem(
              isSelected: _currentIndex == 2,
              text: AppStrings.purchased.tr(),
            ),
          ]);
    });
  }

  Widget _tabItem({
    required String text,
    required bool isSelected,
  }) {
    return AnimatedContainer(
        width: 130.w,
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
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
              color: isSelected ? ColorManager.white : ColorManager.primary),
          textAlign: TextAlign.center,
        ));
  }
}

// class MyBooks extends StatelessWidget {
//   const MyBooks({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           AppStrings.socialist.tr(),
//           style: context.textTheme.displaySmall,
//         ),
//         centerTitle: true,
//       ),
//       body:
//           // socialist.isEmpty
//           //     ? const SocialistEmptyWidget()
//           //     :
//           BlocProvider(
//         create: (context) => instance<CoursesCubit>()
//           ..loadFirstCoursesPage(isFavoriteBook: true),
//         child: courseList(currentIndex: 3),
//       ),
//     );
//   }
// }

// class SocialistEmptyWidget extends StatelessWidget {
//   const SocialistEmptyWidget({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(Assets.assetsImagesNoSocialist),
//               Gap(20.h),
//               Text(
//                 AppStrings.noSubscriptions.tr(),
//                 style: context.textTheme.displaySmall,
//               ),
//               Gap(20.h),
//               Text(
//                 AppStrings.subscribeToTheCourse.tr(),
//                 style: context.textTheme.headlineMedium!.copyWith(
//                   color: ColorManager.textGrayColor,
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Gap(20.h),
//               CustomButton(
//                 height: 45.h,
//                 onPressed: () {},
//                 text: AppStrings.subscribeNow.tr(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class SocialistItem extends StatelessWidget {
  const SocialistItem({
    super.key,
    required this.socialist,
  });

  final Map<String, dynamic> socialist;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 10.r),
      margin: EdgeInsets.symmetric(horizontal: 20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomCardImage(
            image: socialist['image'],
            width: context.screenWidth,
          ),
          const Gap(10),
          Text(
            socialist['name'],
            style: context.textTheme.bodyMedium!.copyWith(
              color: Colors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
          ),
          Text(
            socialist['description'],
            style: context.textTheme.bodyMedium!.copyWith(
              color: ColorManager.primary,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
          ),
          Gap(10.w),
          DataRowOfSocialist(socialist: socialist),
          Gap(20.h),
          CustomButton(
            height: 45.h,
            onPressed: () {},
            text: AppStrings.completeTheCourse.tr(),
          ),
          Gap(10.h),
        ],
      ),
    );
  }
}

class DataRowOfSocialist extends StatelessWidget {
  const DataRowOfSocialist({
    super.key,
    required this.socialist,
  });

  final Map<String, dynamic> socialist;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(Assets.assetsIconsTdesignMoney),
        Gap(10.w),
        Expanded(
          flex: 2,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              AppStrings.amountPaid.tr(),
              style: context.textTheme.bodyMedium!.copyWith(
                color: ColorManager.textGrayColor,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "${socialist['price']} ${AppStrings.pound.tr()}",
              style: context.textTheme.bodyMedium!.copyWith(
                color: Colors.black,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            )
          ]),
        ),
        const Spacer(),
        SvgPicture.asset(Assets.assetsIconsTime),
        Gap(10.w),
        Flexible(
          flex: 2,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              AppStrings.subscriptionDate.tr(),
              style: context.textTheme.bodyMedium!.copyWith(
                color: ColorManager.textGrayColor,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "${socialist['date']}",
              style: context.textTheme.bodyMedium!.copyWith(
                color: ColorManager.textGrayColor,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            )
          ]),
        ),
      ],
    );
  }
}
