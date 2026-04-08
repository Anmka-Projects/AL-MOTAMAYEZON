import 'package:easy_localization/easy_localization.dart';
import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/base/courses_type.dart';
import 'package:elmotamizon/common/extensions/context_extension.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/widgets/default_error_widget.dart';
import 'package:elmotamizon/features/details/models/course_details_model.dart';
import 'package:elmotamizon/features/home/Home/view/widgets/free_content_item.dart';
import 'package:elmotamizon/features/home/Home/view/widgets/popular_books_item.dart';
import 'package:elmotamizon/features/home/Home/view/widgets/search_view.dart';
import 'package:elmotamizon/features/home/Home/view/widgets/subject_widget.dart';
import 'package:elmotamizon/features/home/details/view/details.dart';
import 'package:elmotamizon/features/teacher_parent_home/cubit/courses/courses_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shimmer/card_column_shimmer.dart';
import 'custom_vetricalt_list.dart';

class ShowAll extends StatelessWidget {
  const ShowAll({
    super.key,
    required this.text,
    required this.type,
  });
  final String text;
  final CoursesType type;
  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return BlocProvider(
      create: (context) => instance<CoursesCubit>()
        ..loadFirstCoursesPage(
          inProgress: type == CoursesType.inProgress,
          isBooks: type == CoursesType.isBooks,
          isCompleted: type == CoursesType.isCompleted,
          isFavorite: type == CoursesType.isFavorite,
          isFavoriteBook: type == CoursesType.isFavoriteBook,
          isFreeLesson: type == CoursesType.isFreeLesson,
          isSubscribedBooks: type == CoursesType.subscribedBooks,
          isSearch: type == CoursesType.search,
          status: searchController.text.isNotEmpty ? searchController.text : null,
        ),
      child: Scaffold(
        appBar: type == CoursesType.isBooks ||
                type == CoursesType.isFavoriteBook ||
                type == CoursesType.subscribedBooks ||
                type == CoursesType.search
            ? type == CoursesType.search
                ? PreferredSize(
                    preferredSize: Size(context.screenWidth, 150),
                    child: BlocBuilder<CoursesCubit, BaseState<CourseModel>>(
                      builder: (context, state) {
                        return SearchView(
                          searchController: searchController,
                        );
                      },
                    ))
                : null
            : AppBar(
                title: Text(text.tr()),
              ),
        body: BlocConsumer<CoursesCubit, BaseState<CourseModel>>(
          listener: (context, state) {
            if (state.status == Status.failure) {
              AppFunctions.showsToast(state.errorMessage ?? 'An error occurred',
                  ColorManager.red, context);
            }
          },
          builder: (context, state) {
            if (state.status == Status.loading) {
              return CustomVetricalList(
                list: [
                  CourseModel(),
                  CourseModel(),
                  CourseModel(),
                  CourseModel()
                ],
                child: (index) => const CardColumnShimmer(),
                isDetails: false,
              );
            }
            if (state.status == Status.failure) {
              return DefaultErrorWidget(errorMessage: state.errorMessage ?? '');
            }
            if (state.items.isEmpty) {
              return DefaultErrorWidget(errorMessage: AppStrings.noData.tr());
            }
            final data = state.items;
            return CustomVetricalList(
              isDetails: !(type == CoursesType.isBooks || type == CoursesType.isFavoriteBook || type == CoursesType.subscribedBooks),
              list: data,
              child: (index) {
                return type == CoursesType.isBooks ||
                        type == CoursesType.isFavoriteBook ||
                        type == CoursesType.subscribedBooks ||
                        (type == CoursesType.search && data[index].type == "book")
                    ? PopularBooksItem(
                        popularBooks: data[index],
                        width: context.screenWidth,
                      )
                    : type == CoursesType.isFreeLesson
                        ? GestureDetector(
                            onTap: () {
                              AppFunctions.navigateTo(
                                context,
                                Details(
                                  id: "${state.items[index].courseId}",
                                  videoId: state.items[index].id,
                                  videoUrl: state.items[index].videoUrl,
                                ),
                              );
                            },
                            child: FreeContentItem(
                              freeContent: state.items[index],
                            ),
                          )
                        : SubjectWidget(
                            width: double.infinity,
                            subject: data[index] //state.items[index],
                            );
              },
            );
          },
        ),
      ),
    );
  }
}
