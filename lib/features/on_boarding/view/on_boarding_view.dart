import 'package:elmotamizon/app/app_prefs.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/resources/assets_manager.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/widgets/default_button_widget.dart';
import 'package:elmotamizon/common/widgets/default_error_widget.dart';
import 'package:elmotamizon/features/intro/view/intro_view.dart';
import 'package:elmotamizon/features/on_boarding/cubit/on_boarding_cubit.dart';
import 'package:elmotamizon/features/on_boarding/model/on_boarding_model.dart';
import 'package:elmotamizon/features/on_boarding/view/widgets/on_boarding_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  PageController onBoardingController = PageController();
  late OnBoardingCubit _onBoardingCubit;

  @override
  void initState() {
    super.initState();
    instance<AppPreferences>().setOnBoardingScreenViewed();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<OnBoardingCubit>()..getOnBoarding(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocBuilder<OnBoardingCubit, BaseState<OnBoardingModel>>(
        builder: (context, state) {
          _onBoardingCubit = context.read<OnBoardingCubit>();
          if (state.status == Status.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.status == Status.failure) {
            return DefaultErrorWidget(
              errorMessage: state.errorMessage ?? '',
              buttonTitle: AppStrings.getStart.tr(),
              onPressed: () => AppFunctions.navigateTo(context, const IntroView()),
            );
          }
          return Column(
          children: [
            _onBoardingData(state.data?.data??[]),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 30.h),
              child: Row(
                children: [
                  _indicator((state.data?.data??[]).length),
                  const Spacer(),
                  _startButton(),
                ],
              ),
            ),
          ],
        );
        },
      ),
      ),
    );
  }

  _onBoardingData(List<OnBoardingItemModel> items) {
    return Expanded(
      flex: 2,
      child: PageView.builder(
        physics:  const BouncingScrollPhysics(),
        controller: onBoardingController,
        onPageChanged: (int index) {
          _onBoardingCubit.goNext(index,items.length);
        },
        itemBuilder: (context, index) => OnBoardingWidget(
            item: items[index]),
        itemCount: items.length,
      ),
    );
  }

  _indicator(int length) {
    return SmoothPageIndicator(
      controller: onBoardingController,
      effect: ExpandingDotsEffect(
        dotColor: ColorManager.lightColor,
        dotHeight: 12.w,
        dotWidth: 12.w,
        spacing: 5.0.w,
        expansionFactor: 3.w,
        activeDotColor: ColorManager.primary,
      ),
      count: length,
    );
  }

  _startButton() {
    return _onBoardingCubit.isLast
        ? DefaultButtonWidget(
            onPressed: () {
              AppFunctions.navigateTo(context, const IntroView());
            },
            text: "\t\t${AppStrings.getStart.tr()}",
            isExpanded: false,
            color: ColorManager.primary,
            textColor: ColorManager.white,
            isIcon: true,
            isText: true,
            textFirst: true,
            fontSize: 15.sp,
            verticalPadding: 5.h,
            horizontalPadding: 5.w,
            radius: 25.r,
            iconBuilder: CircleAvatar(
              radius: 17.r,
              backgroundColor: ColorManager.white,
              child: SvgPicture.asset(
                IconAssets.rightArrow,
                color: ColorManager.primary,
                width: 15.w,
                height: 15.w,
              ),
            ),
          )
        : DefaultButtonWidget(
            onPressed: () {
              if (!_onBoardingCubit.isLast) {
                onBoardingController.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              } else {
                onBoardingController.animateTo(0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                );
              }
            },
            color: ColorManager.primary,
            isIcon: true,
            isText: false,
            verticalPadding: 15.h,
      horizontalPadding: 15.w,
            child: SvgPicture.asset(IconAssets.rightArrow,height: 20.h,width: 20.w,),
          );
  }
}
