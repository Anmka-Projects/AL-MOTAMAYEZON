// import 'package:elmotamizon/app/app_functions.dart';
// import 'package:elmotamizon/app/imports.dart';
// import 'package:elmotamizon/common/base/base_state.dart';
// import 'package:elmotamizon/common/resources/assets_manager.dart';
// import 'package:elmotamizon/common/resources/color_manager.dart';
// import 'package:elmotamizon/common/resources/strings_manager.dart';
// import 'package:elmotamizon/common/resources/styles_manager.dart';
// import 'package:elmotamizon/common/widgets/default_banner_widget.dart';
// import 'package:elmotamizon/common/widgets/default_button_widget.dart';
// import 'package:elmotamizon/features/auth/signup/view/signup_view.dart';
// import 'package:elmotamizon/features/home/cubit/banners_cubit.dart';
// import 'package:elmotamizon/features/home/model/banners_model.dart';
// import 'package:elmotamizon/features/home/view/widgets/home_app_bar_widget.dart';
// import 'package:elmotamizon/features/home/view/widgets/top_teachers_widget.dart';
// import 'package:elmotamizon/features/my_teachers/cubit/my_teachers_cubit.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class HomeView extends StatefulWidget {
//   const HomeView({super.key});

//   @override
//   State<HomeView> createState() => _HomeViewState();
// }

// class _HomeViewState extends State<HomeView> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => instance<MyTeachersCubit>()..loadFirstMyTeachersPage(isAll: true),
//       child: Builder(
//         builder: (context) {
//           return Scaffold(
//             body: ListView(
//               padding: EdgeInsets.only(bottom: 15.h),
//               physics: const ClampingScrollPhysics(),
//               children: [
//                 HomeAppBarWidget(studentsOrTeachersContext: context,isStudent: true,),
//                 _banners(),
//                 TopTeachersWidget(teachersContext: context,),
//                 _startWithelmotamizon(),
//               ],
//             ),
//           );
//         }
//       ),
//     );
//   }

//   _banners() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 10.w),
//       child: BlocProvider(
//         create: (context) =>
//         instance<BannersCubit>()
//           ..getBanners(),
//         child: BlocBuilder<BannersCubit, BaseState<BannersModel>>(
//           builder: (context, state) {
//             return DefaultBannerWidget<BannerModel>(
//               images: state.data?.data ?? [],
//               imageUrl: (image) => image.banner ?? '',
//               isLoading: state.status == Status.loading,
//             );
//           },
//         ),
//       ),
//     );
//   }

//   _startWithelmotamizon() {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
//       padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15.r),
//         gradient: const LinearGradient(colors: [
//           ColorManager.lightBlueSky,
//           ColorManager.lightGrey,
//         ]),
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CircleAvatar(
//                 radius: 45.r,
//                 backgroundColor: ColorManager.white,
//                 child: SvgPicture.asset(
//                   IconAssets.student,
//                   height: 60.w,
//                   width: 60.w,
//                 ),
//               ),
//               SizedBox(
//                 width: 15.w,
//               ),
//               Flexible(
//                   child: Text(
//                     AppStrings.letsStartWithelmotamizon.tr(),
//                     style: getBoldStyle(
//                         fontSize: 14.sp, color: ColorManager.black),
//                     textAlign: TextAlign.center,
//                   ),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 15.h,
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child: DefaultButtonWidget(
//                   onPressed: () {
//                     AppFunctions.navigateTo(
//                         context, const SignUpView(userType: 'teacher'));
//                   },
//                   text: AppStrings.becomeAConstructor.tr(),
//                   color: ColorManager.yellow,
//                   textColor: ColorManager.white,
//                   fontSize: 10.sp,
//                   horizontalPadding: 0,
//                   radius: 20.r,
//                   verticalPadding: 10.h,
//                 ),
//               ),
//               SizedBox(
//                 width: 10.w,
//               ),
//               Expanded(
//                 child: DefaultButtonWidget(
//                   onPressed: () {
//                     AppFunctions.navigateTo(
//                         context, const SignUpView(userType: 'student'));
//                   },
//                   text: AppStrings.iamStudent.tr(),
//                   color: Colors.transparent,
//                   textColor: ColorManager.textColor,
//                   fontSize: 10.sp,
//                   withBorder: true,
//                   borderColor: ColorManager.yellow,
//                   elevation: 0,
//                   radius: 20.r,
//                   verticalPadding: 10.h,
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
