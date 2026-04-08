import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/widgets/default_error_widget.dart';
import 'package:elmotamizon/features/favorites/cubit/add_to_favorites_cubit.dart';
import 'package:elmotamizon/features/home/Home/view/widgets/custom_card_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCardImageAndBookmark extends StatefulWidget {
  const CustomCardImageAndBookmark({
    super.key,
    required this.image,
    this.width,
    required this.inFavorite,
    required this.type,
    required this.id,
    this.isHaveBookMark,
  });

  final String image;
  final double? width;
  final bool inFavorite;
  final String type;
  final int id;
  final bool? isHaveBookMark;
  @override
  State<CustomCardImageAndBookmark> createState() =>
      _CustomCardImageAndBookmarkState();
}

class _CustomCardImageAndBookmarkState
    extends State<CustomCardImageAndBookmark> {
  bool isFavoriteVal = false;

  @override
  void initState() {
    isFavoriteVal = widget.inFavorite;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomCardImage(
          image: widget.image,
          width: widget.width,
        ),
        (widget.isHaveBookMark ?? true)
            ? PositionedDirectional(
                top: 10.h,
                end: 10.w,
                child: BlocConsumer<AddToFavoritesCubit, BaseState>(
                  listener: (context, state) {
                    if (state.status == Status.failure) {
                      setState(() {
                        isFavoriteVal = !isFavoriteVal;
                      });
                      DefaultErrorWidget(
                          errorMessage: state.errorMessage ?? '');
                    }
                    if (state.status == Status.success) {
                      log("==============statusCubit: ${state.status}");

                      AppFunctions.showsToast(
                          isFavoriteVal
                              ? AppStrings.addToFavoritesSuccess.tr()
                              : AppStrings.removeFromFavoritesSuccess.tr(),
                          ColorManager.successGreen,
                          context);
                    }
                  },
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          isFavoriteVal = !isFavoriteVal;
                        });
                        context
                            .read<AddToFavoritesCubit>()
                            .addToFavorites(type: widget.type, id: widget.id);
                      },
                      child: Container(
                        padding: EdgeInsets.all(3.r),
                        decoration: const BoxDecoration(
                          color: ColorManager.white,
                          shape: BoxShape.circle,
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Icon(
                            isFavoriteVal
                                ? Icons.bookmark
                                : Icons.bookmark_border_outlined,
                            color: ColorManager.primary,
                            size: 22.sp,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
