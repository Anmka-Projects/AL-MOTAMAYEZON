import 'package:easy_localization/easy_localization.dart';
import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/widgets/default_error_widget.dart';
import 'package:elmotamizon/features/details/models/course_details_model.dart';
import 'package:elmotamizon/features/home/Home/view/shimmer/card_column_shimmer.dart';
import 'package:elmotamizon/features/home/Home/view/widgets/custom_vetricalt_list.dart';
import 'package:elmotamizon/features/home/Home/view/widgets/popular_books_item.dart';
import 'package:elmotamizon/features/home/Home/view/widgets/subject_widget.dart';
import 'package:elmotamizon/features/home/cubit/search_cubit.dart';
import 'package:elmotamizon/features/home/details/view/details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchWidgets extends StatefulWidget {
  final SearchCubit? searchCubit;
  const SearchWidgets({super.key, required this.searchCubit});

  @override
  State<SearchWidgets> createState() => _SearchWidgetsState();
}

class _SearchWidgetsState extends State<SearchWidgets> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      color: ColorManager.white,
      child: BlocProvider.value(
        value: widget.searchCubit!,
        child: BlocBuilder<SearchCubit, BaseState<CourseModel>>(
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
            return CustomVetricalList(
              list: state.items,
              child: (index) => state.items[index].type == "book" ? PopularBooksItem(
                popularBooks: state.items[index],
                width: 200.w,
              ) : GestureDetector(
                onTap: () {
                  AppFunctions.navigateTo(
                    context,
                    Details(id: "${state.items[index].id}"),
                  );
                },
                child: SubjectWidget(
                    width: double.infinity,
                    subject: state.items[index] //state.items[index],
                ),
              ),
              isDetails: false,
            );
          },
        ),
      ),
    );
  }
}
