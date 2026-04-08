import 'package:easy_localization/easy_localization.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/extensions/context_extension.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:elmotamizon/common/widgets/default_error_widget.dart';
import 'package:elmotamizon/common/widgets/download_file_widget.dart';
import 'package:elmotamizon/common/widgets/shimmer_container_widget.dart';
import 'package:elmotamizon/features/home/details/cubit/books_cubit/books_cubit.dart';
import 'package:elmotamizon/features/home/details/models/book_model.dart';
import 'package:elmotamizon/features/home/details/models/course_details_model.dart';
import 'package:elmotamizon/features/home/details/view/widgets/custom_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CourseDetails extends StatelessWidget {
  const CourseDetails({
    super.key,
    required this.text,
    required this.id,
    this.course,
    this.onOpenPdf,
  });
  final String text;
  final int id;
  final CourseModel? course;
  final void Function(String, String)? onOpenPdf;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<BooksCubit>()..loadFirstBooksPage(id),
      child: BlocBuilder<BooksCubit, BaseState<BookModel>>(
        builder: (context, state) {
          final booksList = state.items;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTitle(title: AppStrings.courseOverview.tr()),
              Text(
                AppStrings.content.tr(),
                style: context.textTheme.bodyMedium!.copyWith(
                  color: ColorManager.textGrayColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
              ),
              Text(
                text,
                style: context.textTheme.bodyMedium!.copyWith(
                  color: ColorManager.textGrayColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
              ),
              Gap(20.h),
              CustomTitle(title: AppStrings.attachedBooks.tr()),
              if(state.status == Status.failure)
                DefaultErrorWidget(errorMessage: state.errorMessage ?? '')
              else if(state.status == Status.loading)
                Column(
                  children: List.generate(3, (index) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: ShimmerContainerWidget(height: 20.h,width: double.infinity,),
                  ),),
                )
              else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: booksList.asMap().entries.map(
                  (entry) {
                    final index = entry.key;
                    return DownloadFileWidget(
                      url: booksList[index].file ?? '',
                      fileName: booksList[index].name ?? '',
                      isOpen: booksList[index].isFree==1 || booksList[index].isSubscribed==1,
                      onOpenPdf: onOpenPdf,
                    );
                  },
                ).toList(),

              ),
              if(context.read<BooksCubit>().hasMore)
                Gap(10.h),
              if(context.read<BooksCubit>().hasMore)
                GestureDetector(
                  onTap: () {
                    context.read<BooksCubit>().loadMoreBooksPage(id);
                  },
                  child: Text(
                    AppStrings.loadMore2.tr(),
                    style: getBoldStyle(
                      fontSize: 15.sp,
                      color: ColorManager.primary,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
