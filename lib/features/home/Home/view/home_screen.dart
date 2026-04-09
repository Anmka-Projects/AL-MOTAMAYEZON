import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/app/app_prefs.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/base/courses_type.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/widgets/default_error_widget.dart';
import 'package:elmotamizon/common/widgets/default_form_field.dart';
import 'package:elmotamizon/constants/assets.dart';
import 'package:elmotamizon/features/bottom_nav_bar/view/bottom_nav_bar_view.dart';
import 'package:elmotamizon/features/details/models/course_details_model.dart';
import 'package:elmotamizon/features/home/Home/view/shimmer/custom_list_row_shimmer.dart';
import 'package:elmotamizon/features/home/Home/view/widgets/continue_watching.dart';
import 'package:elmotamizon/features/home/Home/view/widgets/search_widgets.dart';
import 'package:elmotamizon/features/home/cubit/search_cubit.dart';
import 'package:elmotamizon/features/home/details/view/details.dart';
import 'package:elmotamizon/features/home/Home/view/widgets/custom_widget_list.dart';
import 'package:elmotamizon/features/home/Home/view/widgets/free_content_item.dart';
import 'package:elmotamizon/features/home/Home/view/widgets/title_widget.dart';
import 'package:elmotamizon/features/home/Home/view/widgets/home_header.dart';
import 'package:elmotamizon/features/home/Home/view/widgets/show_all.dart';
import 'package:elmotamizon/features/home/Home/view/widgets/subject_widget.dart';
import 'package:elmotamizon/features/teacher_parent_home/cubit/courses/courses_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'widgets/popular_books_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  late SearchCubit _searchCubit;
  final CoursesCubit _subjectsCubit = instance<CoursesCubit>();
  final CoursesCubit _booksCubit = instance<CoursesCubit>();
  final CoursesCubit _freeLessonsCubit = instance<CoursesCubit>();

  @override
  void initState() {
    super.initState();
    _subjectsCubit.loadFirstCoursesPage();
    _booksCubit.loadFirstCoursesPage(isBooks: true);
    _freeLessonsCubit.loadFirstCoursesPage(isFreeLesson: true);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    _subjectsCubit.close();
    _booksCubit.close();
    _freeLessonsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => instance<SearchCubit>(),
  child: Builder(
    builder: (context) {
      _searchCubit = context.read<SearchCubit>();
      return Scaffold(
          body: RefreshIndicator(
            onRefresh: _refreshHomeData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 60.h, bottom: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                /// header
                const HomeHeader(),
                Gap(15.h),

                /// search
                _searchBar(),
                Gap(10.h),

                Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// continue watching
                        if (instance<AppPreferences>().getToken().isNotEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: continueWatching(loadingLength: 1),
                          ),
                        if (instance<AppPreferences>().getToken().isNotEmpty)
                          Gap(15.h),

                        _subjects(),
                        Gap(25.h),

                        /// books
                        _books(),
                        Gap(25.h),

                        /// free Content
                        _freeLessons(),
                        Gap(25.h),
                      ],
                    ),
                    if(_searchController.text.isNotEmpty)
                      SearchWidgets(searchCubit: _searchCubit,),
                  ],
                )
                ],
              ),
            ),
          ),
      );
    }
  ),
);
  }

  Future<void> _refreshHomeData() async {
    await Future.wait([
      _subjectsCubit.loadFirstCoursesPage(),
      _booksCubit.loadFirstCoursesPage(isBooks: true),
      _freeLessonsCubit.loadFirstCoursesPage(isFreeLesson: true),
      if (_searchController.text.trim().isNotEmpty)
        _searchCubit.loadFirstSearchPage(text: _searchController.text.trim()),
    ]);
  }

  _searchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: DefaultFormField(
        controller: _searchController,
        hintText: AppStrings.search.tr(),
        prefixIconPath: Assets.assetsIconsNewSearch,
        suffixIcon: _searchController.text.isEmpty ? null : IconButton(
            onPressed: () {
              _searchController.clear();
              setState(() {});
            },
            icon: Icon(Icons.close,color: ColorManager.red,size: 20.r,)),
        borderRadius: 10.r,
        disableHelperText: true,
        fillColor: ColorManager.white,
        borderColor: ColorManager.greyBorder,
        noBorder: false,
        onChanged: (value) {
          if (_debounce?.isActive ?? false) _debounce!.cancel();
          _debounce = Timer(const Duration(milliseconds: 800), () {
            if (!mounted) return;
            if (value.isNotEmpty) {
              _searchCubit.loadFirstSearchPage(text: value);
            }
            setState(() {});
          });
        },
      ),
    );
  }

  _subjects() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.h),
          child: TitleWidget(
            title: AppStrings.courseMaterials.tr(),
            onTap: () {
              AppFunctions.navigateTo(
                context,
                const BottomNavBarView(pageIndex: 1),
              );
            },
          ),
        ),
        Gap(15.h),
        BlocBuilder<CoursesCubit, BaseState<CourseModel>>(
          bloc: _subjectsCubit,
          builder: (context, state) {
            if (state.status == Status.loading) {
              return const CustomListRowShimmer();
            }
            if (state.status == Status.failure) {
              return DefaultErrorWidget(errorMessage: state.errorMessage ?? '');
            }
            if (state.items.isEmpty) {
              return DefaultErrorWidget(errorMessage: AppStrings.noData.tr());
            }
            return CustomWidgetList(
              list: state.items,
              child: (index) => GestureDetector(
                onTap: () {
                  AppFunctions.navigateTo(
                    context,
                    Details(id: "${state.items[index].id}"),
                  );
                },
                child: SubjectWidget(
                  width: 150.w,
                  subject: state.items[index],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  _books() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.h),
          child: TitleWidget(
            title: AppStrings.popularBooks.tr(),
            onTap: () {
              AppFunctions.navigateTo(
                context,

                const BottomNavBarView(
                  pageIndex: 3,
                ),
              );
            },
          ),
        ),
        Gap(16.h),
        BlocBuilder<CoursesCubit, BaseState<CourseModel>>(
          bloc: _booksCubit,
          builder: (context, state) {
            if (state.status == Status.loading) {
              return const CustomListRowShimmer();
            }
            if (state.status == Status.failure) {
              return DefaultErrorWidget(
                  errorMessage: state.errorMessage ?? '');
            }
            if (state.items.isEmpty) {
              return DefaultErrorWidget(errorMessage: AppStrings.noData.tr());
            }
            return CustomWidgetList(
              list: state.items,
              child: (index) =>
                  PopularBooksItem(popularBooks: state.items[index]),
            );
          },
        ),
      ],
    );
  }

  _freeLessons() {
    return BlocConsumer<CoursesCubit, BaseState<CourseModel>>(
      bloc: _freeLessonsCubit,
        listener: (context, state) {
          if (state.status == Status.failure) {
            AppFunctions.showsToast(state.errorMessage ?? 'An error occurred',
                ColorManager.red, context);
          }
        },
        builder: (context, state) {
          if (state.items.isEmpty && state.isSuccess) {
            return const SizedBox.shrink();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.h),
                child: TitleWidget(
                  title: AppStrings.freeContent.tr(),
                  onTap: () {
                    AppFunctions.navigateTo(
                      context,
                      ShowAll(
                        text: AppStrings.freeContent.tr(),
                        type: CoursesType.isFreeLesson,
                      ),
                    );
                  },
                ),
              ),
              Gap(16.h),
              if (state.isLoading)
                const CustomListRowShimmer()
              else if (state.isFailure)
                DefaultErrorWidget(errorMessage: state.errorMessage ?? '')
              else
                CustomWidgetList(
                  list: state.items,
                  child: (index) => GestureDetector(
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
                  ),
                ),
            ],
          );
        },
      );
  }
}
