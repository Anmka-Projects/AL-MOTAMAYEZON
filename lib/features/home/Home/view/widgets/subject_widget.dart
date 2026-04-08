import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/features/details/models/course_details_model.dart';
import 'package:elmotamizon/features/favorites/cubit/add_to_favorites_cubit.dart';
import 'package:elmotamizon/features/home/Home/view/widgets/custom_card_image_and_book_mark.dart';
import 'package:elmotamizon/features/home/Home/view/widgets/custom_text_sub_title.dart';
import 'package:elmotamizon/features/home/Home/view/widgets/custom_text_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubjectWidget extends StatelessWidget {
  const SubjectWidget({
    super.key,
    required this.subject,
    this.width,
  });

  final CourseModel subject;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<AddToFavoritesCubit>(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomCardImageAndBookmark(
            type: "course_id",
            id: subject.id ?? 0,
            width: width,
            image: subject.image ?? "",
            inFavorite: subject.inFavorite == 1,
          ),
          SizedBox(
            height: 10.h,
          ),
          CustomTextTitle(title: subject.name ?? ""),
          SizedBox(
            height: 3.h,
          ),
          CustomTextSubTitle(subTitle: subject.teacher ?? ""),
          SizedBox(
            height: 3.h,
          ),
        ],
      ),
    );
  }
}
