import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:elmotamizon/common/widgets/default_error_widget.dart';
import 'package:elmotamizon/common/widgets/default_expansion_tile.dart';
import 'package:elmotamizon/common/widgets/download_file_widget.dart';
import 'package:elmotamizon/features/details/models/course_or_lesson_or_exam_or_homework_model.dart';
import 'package:elmotamizon/features/details/view/widgets/course_or_lesson_or_exam_or_homework_widget.dart';
import 'package:elmotamizon/features/exam_details/models/exam_details_model.dart';
import 'package:elmotamizon/features/lesson_details/cubit/homeworks/homeworks_cubit.dart';
import 'package:elmotamizon/features/lesson_details/cubit/lesson_details/lesson_details_cubit.dart';
import 'package:elmotamizon/features/lesson_details/cubit/tests_cubit/tests_cubit.dart';
import 'package:elmotamizon/features/lesson_details/models/homeworks_model.dart';
import 'package:elmotamizon/features/lesson_details/models/lesson_details_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LessonDetailsView extends StatefulWidget {
  final int id;
  const LessonDetailsView({super.key, required this.id});

  @override
  State<LessonDetailsView> createState() => _LessonDetailsViewState();
}

class _LessonDetailsViewState extends State<LessonDetailsView> {
  late LessonDetailsCubit _lessonDetailsCubit;
  bool _isFullScreen = false;

  double calculateAspectRatio() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return screenHeight / screenWidth;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      instance<TestsCubit>().loadFirstTestsPage(widget.id);
      instance<HomeworksCubit>().loadFirstHomeworksPage(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<LessonDetailsCubit>()
        ..getLessonDetails(widget.id.toString()),
      child: Builder(builder: (context) {
        _lessonDetailsCubit = BlocProvider.of<LessonDetailsCubit>(context);
        return Scaffold(
          backgroundColor: ColorManager.bg,
          body: BlocConsumer<LessonDetailsCubit, BaseState<LessonDetailsModel>>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == Status.success) {
                _lessonDetailsCubit.initYoutubePlayer(
                    videoUrl: state.data?.data?.videoUrl ?? '');
              }
              if (state.status == Status.failure) {
                AppFunctions.showsToast(
                    state.errorMessage ?? '', ColorManager.red, context);
              }
            },
            builder: (context, state) {
              if (state.status == Status.failure) {
                return DefaultErrorWidget(
                  errorMessage: state.errorMessage ?? '',
                  onPressed: () => Navigator.pop(context),
                  buttonTitle: AppStrings.back.tr(),
                );
              }
              if (state.status == Status.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Column(
                children: [
                  _player(),
                  if (!_isFullScreen)
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.only(bottom: 15.h),
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  AppStrings.resources.tr(),
                                  style: getBoldStyle(
                                      fontSize: 14.sp,
                                      color: ColorManager.blackText),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                _resources(state.data?.data?.files ?? []),
                              ],
                            ),
                          ),
                          BlocProvider(
                            create: (context) => instance<TestsCubit>()
                              ..loadFirstTestsPage(widget.id),
                            child:
                                BlocBuilder<TestsCubit, BaseState<ExamModel>>(
                              builder: (context, state) {
                                return CourseOrLessonOrExamOrHomeWorkWidget(
                                  data: state.items.isEmpty
                                      ? [
                                          CourseOrLessonOrExamOrHomeworkModel(
                                            lesson: Lesson2Model(id: widget.id),
                                          ),
                                        ]
                                      : state.items
                                          .map(
                                            (e) =>
                                                CourseOrLessonOrExamOrHomeworkModel(
                                                    lesson: Lesson2Model(
                                                        id: widget.id),
                                                    exam: e),
                                          )
                                          .toList(),
                                  type: ItemType.exam,
                                  title: AppStrings.exams.tr(),
                                  state: state,
                                  showShimmer: state.status == Status.loading,
                                  errorMessage: state.errorMessage,
                                  context: context,
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          BlocProvider(
                            create: (context) => instance<HomeworksCubit>()
                              ..loadFirstHomeworksPage(widget.id),
                            child: BlocBuilder<HomeworksCubit,
                                BaseState<HomeworkModel>>(
                              builder: (context, state) {
                                return CourseOrLessonOrExamOrHomeWorkWidget(
                                  data: state.items.isEmpty
                                      ? [
                                          CourseOrLessonOrExamOrHomeworkModel(
                                            lesson: Lesson2Model(id: widget.id),
                                          ),
                                        ]
                                      : state.items
                                          .map(
                                            (e) =>
                                                CourseOrLessonOrExamOrHomeworkModel(
                                                    lesson: Lesson2Model(
                                                        id: widget.id),
                                                    homework: e),
                                          )
                                          .toList(),
                                  type: ItemType.homework,
                                  title: AppStrings.homeworks.tr(),
                                  state: state,
                                  showShimmer: state.status == Status.loading,
                                  errorMessage: state.errorMessage,
                                  context: context,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        );
      }),
    );
  }

  _player() {
    return BlocBuilder<LessonDetailsCubit, BaseState<LessonDetailsModel>>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return _lessonDetailsCubit.controller == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : YoutubePlayerBuilder(
                player: YoutubePlayer(
                  controller: _lessonDetailsCubit.controller!,
                  aspectRatio: calculateAspectRatio(),
                ),
                onEnterFullScreen: () {
                  setState(() {
                    _isFullScreen = true;
                  });
                },
                onExitFullScreen: () async {
                  setState(() {
                    _isFullScreen = false;
                  });
                  await Future.wait([
                    // SystemChrome.setPreferredOrientations([
                    //   DeviceOrientation.portraitUp,
                    //   DeviceOrientation.portraitDown,
                    // ]),
                    // if (!(defaultTargetPlatform == TargetPlatform.iOS)) ...[
                    SystemChrome.setEnabledSystemUIMode(
                      SystemUiMode.manual,
                      overlays: SystemUiOverlay.values,
                    ),
                    // ]
                  ]);
                },
                builder: (context, player) {
                  return Column(
                    children: [
                      SizedBox(
                        height: _isFullScreen
                            ? MediaQuery.of(context).size.height
                            : MediaQuery.of(context).size.height * .3,
                        child: player,
                      ),
                    ],
                  );
                });
      },
    );
  }

  _resources(List<FileModel> files) {
    return DefaultExpansionTile(
        initiallyExpanded: true,
        name: AppStrings.explainNotes.tr(),
        optionsWidget: List.generate(
          files.length,
          (index) => DownloadFileWidget(
            url: files[index].file ?? '',
            fileName: files[index].name ?? '',
          ),
        ));
  }
}
