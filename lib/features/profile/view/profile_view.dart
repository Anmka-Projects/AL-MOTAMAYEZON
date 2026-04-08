import 'package:elmotamizon/app/app_prefs.dart';
import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/features/auth/login/view/login_view.dart';
import 'package:elmotamizon/features/faqs/view/faqs_view.dart';
import 'package:elmotamizon/features/privacy_policy/view/privacy_policy_view.dart';
import 'package:elmotamizon/features/splash/view/splash_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elmotamizon/features/profile/cubit/logout_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../common/base/base_state.dart';

import '../../../common/resources/assets_manager.dart';
import '../../../common/resources/color_manager.dart';
import '../../../common/resources/strings_manager.dart';
import '../../../common/resources/styles_manager.dart';
import '../../../common/widgets/default_list_tile.dart';
import 'package:elmotamizon/features/profile/view/edit_profile_view.dart';
import 'package:elmotamizon/features/profile/cubit/profile_cubit.dart';
import 'package:elmotamizon/features/contact_us/view/contact_us_view.dart';
import 'package:elmotamizon/features/support_whatsapp/view/support_whatsapp_view.dart';
import 'package:elmotamizon/features/offline_video/presentation/view/offline_videos_screen.dart';
import 'package:elmotamizon/features/offline_video/presentation/cubit/offline_video_cubit.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<LogoutCubit>(),
      child: SafeArea(
        child: Scaffold(
          body: ListView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              // _header(),
              Gap(20.h),
              const UserData(),
              SizedBox(
                height: 20.h,
              ),

              if (instance<AppPreferences>().getToken().isNotEmpty)
                DefaultListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (context) => instance<ProfileCubit>(),
                          child: const EditProfileView(),
                        ),
                      ),
                    ).then(
                      (value) {
                        setState(() {});
                      },
                    );
                  },
                  iconPath: IconAssets.profile,
                  text: AppStrings.editProfile.tr(),
                ),

              DefaultListTile(
                iconPath: IconAssets.language,
                text: AppStrings.changeLanguage.tr(),
                actionButtonText:
                    instance<AppPreferences>().getAppLanguage() == "ar"
                        ? "English"
                        : "العربية",
                withUnderLine: true,
                actionButtonOnPressed: () {
                  instance<AppPreferences>().changeAppLanguage().then(
                    (value) {
                      if (mounted) {
                        AppFunctions.navigateToAndFinish(
                            context, const SplashView());
                      }
                    },
                  );
                },
              ),

              //********************************************** */
              DefaultListTile(
                onTap: () {
                  AppFunctions.navigateTo(context, const FaqsView());
                },
                iconPath: IconAssets.faqs,
                text: AppStrings.faqs.tr(),
              ),

              DefaultListTile(
                onTap: () {
                  AppFunctions.navigateTo(
                      context,
                      const PrivacyPolicyView(
                        infoType: InfoType.privacyPolicy,
                      ));
                },
                iconPath: IconAssets.privacyPolicy,
                text: AppStrings.privacyPolicy.tr(),
              ),
              DefaultListTile(
                onTap: () {
                  AppFunctions.navigateTo(
                      context,
                      const PrivacyPolicyView(
                        infoType: InfoType.terms,
                      ));
                },
                iconPath: IconAssets.privacyPolicy,
                text: AppStrings.terms.tr(),
              ),
              DefaultListTile(
                onTap: () {
                  AppFunctions.navigateTo(
                      context,
                      const PrivacyPolicyView(
                        infoType: InfoType.aboutUs,
                      ));
                },
                iconPath: IconAssets.aboutUs,
                text: AppStrings.aboutUs.tr(),
              ),

              DefaultListTile(
                onTap: () {
                  AppFunctions.navigateTo(
                    context,
                    OfflineVideosScreen(
                      cubit: instance<OfflineVideoCubit>(),
                    ),
                  );
                },
                iconPath: IconAssets.profile,
                text: AppStrings.myVideos.tr(),
              ),
              DefaultListTile(
                onTap: () {
                  AppFunctions.navigateTo(context, const ContactUsView());
                },
                iconPath: IconAssets.profile,
                text: AppStrings.contactUs.tr(),
              ),
              if (instance<AppPreferences>().getUserType() == "student" &&
                  instance<AppPreferences>().getToken().isNotEmpty)
                DefaultListTile(
                  onTap: () {
                    AppFunctions.navigateTo(
                        context, const SupportWhatsappView());
                  },
                  iconPath: IconAssets.profile,
                  text: AppStrings.supportViaWhatsapp.tr(),
                ),
              BlocConsumer<LogoutCubit, LogoutState>(
                listener: (context, state) async {
                  if (state.status == Status.success) {
                    await instance<AppPreferences>().logout();
                    if (mounted) {
                      AppFunctions.navigateToAndFinish(
                          context,
                          const LoginView(
                            pageIndex: 4,
                          ));
                    }
                  } else if (state.status == Status.failure &&
                      state.errorMessage != null) {
                    AppFunctions.showsToast(
                        state.errorMessage!, ColorManager.red, context);
                  }
                },
                builder: (context, state) {
                  return DefaultListTile(
                    isLoading: state.status == Status.loading,
                    onTap: () {
                      if (instance<AppPreferences>().getToken().isNotEmpty) {
                        context.read<LogoutCubit>().logout();
                      } else {
                        AppFunctions.navigateTo(
                            context,
                            const LoginView(
                              pageIndex: 4,
                            ));
                      }
                    },
                    iconPath: IconAssets.logout,
                    text: instance<AppPreferences>().getToken().isNotEmpty
                        ? AppStrings.logout.tr()
                        : AppStrings.login.tr(),
                  );
                },
              ),
              if (instance<AppPreferences>().getToken().isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: BlocConsumer<LogoutCubit, LogoutState>(
                    listener: (context, state) async {
                      if (state.status == Status.success) {
                        await instance<AppPreferences>().logout();
                        if (mounted) {
                          AppFunctions.navigateToAndFinish(
                              context,
                              const LoginView(
                                pageIndex: 4,
                              ));
                        }
                      } else if (state.status == Status.failure &&
                          state.errorMessage != null) {
                        AppFunctions.showsToast(
                            state.errorMessage!, ColorManager.red, context);
                      }
                    },
                    builder: (context, state) {
                      return DefaultListTile(
                        onTap: () {
                          AppFunctions.showMyDialog(
                            context,
                            title: AppStrings.confirmDeleteAccount.tr(),
                            onConfirm: () {
                              if (instance<AppPreferences>()
                                  .getToken()
                                  .isNotEmpty) {
                                context
                                    .read<LogoutCubit>()
                                    .logout(isDelete: true);
                              } else {
                                AppFunctions.navigateTo(
                                    context,
                                    const LoginView(
                                      pageIndex: 4,
                                    ));
                              }
                            },
                          );
                        },
                        iconPath: IconAssets.deleteAccount,
                        text: AppStrings.deleteAccount.tr(),
                        tileColor: ColorManager.red,
                        itemsColor: ColorManager.white,
                        isLoading: state.status == Status.custom,
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  _header() {
    return Container(
      padding: EdgeInsets.fromLTRB(
          0, MediaQuery.sizeOf(context).height * .07, 0, 15.h),
      decoration: BoxDecoration(
        color: ColorManager.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                // Icon(
                //   Icons.arrow_back_ios_new_rounded,
                //   color: ColorManager.white,
                //   size: 20.r,
                // ),
                Expanded(
                    child: Text(
                  AppStrings.profile.tr(),
                  style:
                      getBoldStyle(fontSize: 15.sp, color: ColorManager.white),
                  textAlign: TextAlign.center,
                )),
              ],
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          CircleAvatar(
            radius: 50.r,
            backgroundColor: ColorManager.black,
            child: CircleAvatar(
              radius: 49.r,
              backgroundColor: ColorManager.primary,
              child: CircleAvatar(
                radius: 45.r,
                backgroundImage: instance<AppPreferences>().getUserImage() ==
                        null
                    ? const AssetImage(ImageAssets.profile)
                    : NetworkImage(instance<AppPreferences>().getUserImage()!)
                        as ImageProvider,
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            instance<AppPreferences>().getUserName(),
            style: getBoldStyle(fontSize: 15.sp, color: ColorManager.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10.h,
          ),
          if (instance<AppPreferences>().getUserType() == "student")
            InkWell(
              onTap: () {
                AppFunctions.copyText(
                    text: instance<AppPreferences>().getStudentCode(),
                    context: context,
                    mounted: mounted);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.copy_rounded,
                      color: ColorManager.white, size: 23.r),
                  SizedBox(width: 5.w),
                  Text(
                    instance<AppPreferences>().getStudentCode(),
                    style: getBoldStyle(
                        fontSize: 15.sp, color: ColorManager.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class UserData extends StatefulWidget {
  const UserData({
    super.key,
  });

  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        spacing: 10.w,
        children: [
          SizedBox(
            width: 60.w,
            height: 60.h,
            child: CircleAvatar(
              radius: 45.r,
              backgroundColor: ColorManager.greyBorder,
              backgroundImage: instance<AppPreferences>().getUserImage() == null
                  ? const AssetImage(ImageAssets.profile)
                  : NetworkImage(
                      instance<AppPreferences>().getUserImage()!,
                    ) as ImageProvider,
            ),
          ),
          Flexible(
            child: Column(
              spacing: 5.w,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  instance<AppPreferences>().getUserName(),
                  style: getBoldStyle(
                    fontSize: 15.sp,
                    color: ColorManager.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                // Text(
                //   "mohamed.zima224@gmail.com",
                //   style: getBoldStyle(
                //     fontSize: 15.sp,
                //     color: ColorManager.greyTextColor,
                //   ),
                //   textAlign: TextAlign.center,
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
