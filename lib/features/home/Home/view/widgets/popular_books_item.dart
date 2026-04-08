import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/widgets/default_button_widget.dart';
import 'package:elmotamizon/constants/assets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:elmotamizon/features/details/cubit/subscribe_teacher_cubit.dart';
import 'package:elmotamizon/features/details/models/course_details_model.dart';
import 'package:elmotamizon/features/favorites/cubit/add_to_favorites_cubit.dart';
import 'package:elmotamizon/features/home/Home/view/widgets/custom_card_image_and_book_mark.dart';
import 'package:elmotamizon/features/home/Home/view/widgets/custom_text_sub_title.dart';
import 'package:elmotamizon/features/home/Home/view/widgets/custom_text_title.dart';
import 'package:elmotamizon/features/payment/digital_payment_order_place_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../../details/view/widgets/pdf_view.dart';

class PopularBooksItem extends StatefulWidget {
  const PopularBooksItem({
    super.key,
    required this.popularBooks,
    this.width,
    this.haveSpacer,
  });

  final CourseModel popularBooks;
  final double? width;
  final bool? haveSpacer;

  @override
  State<PopularBooksItem> createState() => _PopularBooksItemState();
}

class _PopularBooksItemState extends State<PopularBooksItem> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<AddToFavoritesCubit>(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5.h,
        children: [
          CustomCardImageAndBookmark(
            isHaveBookMark: widget.haveSpacer,
            id: widget.popularBooks.id ?? 0,
            type: "book_id",
            width: widget.width,
            image: widget.popularBooks.image ?? "",
            inFavorite: widget.popularBooks.inFavorite == 1,
          ),
          CustomTextTitle(title: widget.popularBooks.name ?? ""),
          CustomTextSubTitle(subTitle: widget.popularBooks.teacher ?? ""),
          Row(
            children: [
              SvgPicture.asset(Assets.assetsIconsMoney),
              Gap(3.w),
              Expanded(
                child: CustomTextTitle(
                    title: widget.popularBooks.isFree == 1
                        ? AppStrings.free.tr()
                        : "${widget.popularBooks.price} ${AppStrings.pound.tr()}"),
              ),
            ],
          ),
          (widget.haveSpacer ?? true) ? const Spacer() : Gap(10.h),
          Align(
            alignment: Alignment.bottomCenter,
            child: StatefulBuilder(builder: (context, setState) {
              return BlocProvider(
                create: (context) =>
                    instance<SubscribeTeacherCubit>(),
                child: BlocConsumer<SubscribeTeacherCubit,
                    BaseState<String>>(
                  listener: (context, state) {
                    if (state.status == Status.success) {
                      // if (instance<AppPreferences>()
                      //     .getUserIsAppleReview() !=
                      //     1) {
                        AppFunctions.navigateTo(
                            context,
                            DigitalPaymentView(
                                url: state.data ?? '',
                              isBook: true,
                            ));
                      // } else {
                      //   courseState.data?.data?.isSubscribed = 1;
                      //   setState(() {});
                      // }
                    } else if (state.status == Status.failure) {
                      AppFunctions.showsToast(
                          state.errorMessage ?? '',
                          ColorManager.red,
                          context);
                    }
                  },
                  builder: (context, subscribeState) {
                    return DefaultButtonWidget(
                      verticalPadding: 5.h,
                      onPressed: () {
                        if (widget.popularBooks.isSubscribed == 1 || widget.popularBooks.isFree == 1) {
                          AppFunctions.navigateTo(
                            context,
                            PdfView(
                                pdfLink: widget.popularBooks.file ?? '',
                                name: widget.popularBooks.name ?? '',
                            ),
                          );
                        } else {
                          context.read<SubscribeTeacherCubit>()
                              .subscribeTeacher(
                                  teacherId: widget.popularBooks.id ?? 0,
                                  isBook: true,
                          );
                        }
                      },
                      text: widget.popularBooks.isFree == 1 || widget.popularBooks.isSubscribed == 1
                          ? AppStrings.download.tr()
                          : AppStrings.buyNow.tr(),
                      color: widget.popularBooks.isFree == 1 || widget.popularBooks.isSubscribed == 1
                          ? Colors.transparent
                          : ColorManager.primary,
                      textColor: widget.popularBooks.isFree == 1 || widget.popularBooks.isSubscribed == 1
                          ? ColorManager.primary
                          : ColorManager.white,
                      borderColor: widget.popularBooks.isFree == 1 || widget.popularBooks.isSubscribed == 1
                          ? ColorManager.primary
                          : Colors.transparent,
                      withBorder: true,
                      elevation: 0,
                      isLoading: subscribeState.isLoading,
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
