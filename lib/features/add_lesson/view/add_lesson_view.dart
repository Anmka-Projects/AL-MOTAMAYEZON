import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/widgets/default_app_bar.dart';
import 'package:elmotamizon/common/widgets/default_button_widget.dart';
import 'package:elmotamizon/common/widgets/default_form_field.dart';
import 'package:elmotamizon/common/widgets/default_pick_files_widget.dart';
import 'package:elmotamizon/features/add_lesson/cubit/add_lesson_cubit.dart';
import 'package:elmotamizon/features/add_lesson/cubit/delete_file/delete_file_cubit.dart';
import 'package:elmotamizon/features/details/cubit/lessons/lessons_cubit.dart';
import 'package:elmotamizon/features/lesson_details/models/lesson_details_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddLessonView extends StatefulWidget {
  final Lesson2Model? lesson;
  final int courseId;
  final BuildContext lessonsContext;

  const AddLessonView(
      {super.key,
      this.lesson,
      required this.courseId,
      required this.lessonsContext});

  @override
  State<AddLessonView> createState() => _AddLessonViewState();
}

class _AddLessonViewState extends State<AddLessonView> {
  final TextEditingController _nameArController = TextEditingController();
  final TextEditingController _nameEnController = TextEditingController();
  final TextEditingController _videoController = TextEditingController();
  String? _selectedImagePath;
  final List<String> _files = [];
  final List<String> _filesNames = [];

  @override
  void initState() {
    super.initState();
    if (widget.lesson != null) {
      _nameArController.text = widget.lesson!.nameAr ?? '';
      _nameEnController.text = widget.lesson!.nameEn ?? '';
      _videoController.text = widget.lesson!.videoUrl ?? '';
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameArController.dispose();
    _nameEnController.dispose();
    _videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<AddLessonCubit>(),
      child: Scaffold(
        appBar: DefaultAppBar(
          text: widget.lesson == null
              ? AppStrings.addLesson.tr()
              : AppStrings.editLesson.tr(),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          children: [
            DefaultFormField(
              noBorder: false,
              controller: _nameArController,
              fillColor: ColorManager.fillColor,
              borderColor: ColorManager.greyBorder,
              hintText: AppStrings.lessonNameAr.tr(),
              title: AppStrings.lessonNameAr.tr(),
            ),
            SizedBox(
              height: 20.h,
            ),
            DefaultFormField(
              noBorder: false,
              controller: _nameEnController,
              fillColor: ColorManager.fillColor,
              borderColor: ColorManager.greyBorder,
              hintText: AppStrings.lessonNameEn.tr(),
              title: AppStrings.lessonNameEn.tr(),
            ),
            SizedBox(
              height: 20.h,
            ),
            DefaultFormField(
              noBorder: false,
              controller: _videoController,
              fillColor: ColorManager.fillColor,
              borderColor: ColorManager.greyBorder,
              hintText: AppStrings.videoLink.tr(),
              title: AppStrings.lessonVideo.tr(),
            ),
            SizedBox(
              height: 20.h,
            ),
            StatefulBuilder(builder: (context, setState) {
              return DefaultPickFilesWidget(
                imagesOnly: true,
                isSingle: true,
                title: AppStrings.lessonPhoto.tr(),
                onPicked: (filesPaths, filesNames) {
                  _selectedImagePath = filesPaths.first;
                },
                clear: _selectedImagePath == null,
                remoteFiles: (widget.lesson?.image ?? '').isEmpty
                    ? []
                    : [widget.lesson?.image ?? ''],
              );
            }),
            SizedBox(
              height: 20.h,
            ),
            BlocProvider(
              create: (context) => instance<DeleteFileCubit>(),
              child: BlocConsumer<DeleteFileCubit, BaseState<String>>(
                listener: (context, state) {
                  if (state.status == Status.success) {
                    AppFunctions.showsToast(
                        state.data ?? '', ColorManager.successGreen, context);
                    widget.lessonsContext
                        .read<Lessons2Cubit>()
                        .loadFirstLessonsPage(widget.courseId);
                  } else if (state.status == Status.failure) {
                    AppFunctions.showsToast(
                        state.errorMessage ?? '', ColorManager.red, context);
                  }
                },
                builder: (context, state) {
                  return DefaultPickFilesWidget(
                    onPicked: (filesPaths, filesNames) {
                      _files.addAll(filesPaths);
                      _filesNames.addAll(filesNames);
                    },
                    onRemoveLocal: (index) {
                      _files.removeAt(index);
                      _filesNames.removeAt(index);
                    },
                    onRemoveRemote: (index) {
                      context
                          .read<DeleteFileCubit>()
                          .deleteFile(widget.lesson?.files?[index].id ?? 0);
                      widget.lesson?.files?.removeAt(index);
                    },
                    title: AppStrings.lessonFiles.tr(),
                    clear: _files.isNotEmpty,
                    remoteFiles: (widget.lesson?.files ?? []).isEmpty
                        ? null
                        : (widget.lesson?.files ?? [])
                            .map(
                              (e) => e.name ?? '',
                            )
                            .toList(),
                  );
                },
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            BlocConsumer<AddLessonCubit, BaseState<String>>(
              listener: (context, state) {
                if (state.status == Status.success) {
                  AppFunctions.showsToast(
                      state.data ?? '', ColorManager.successGreen, context);
                  widget.lessonsContext
                      .read<Lessons2Cubit>()
                      .loadFirstLessonsPage(widget.courseId)
                      .then(
                    (value) {
                      if (mounted) Navigator.pop(context);
                    },
                  );
                } else if (state.status == Status.failure) {
                  AppFunctions.showsToast(
                      state.errorMessage ?? '', ColorManager.red, context);
                }
              },
              builder: (context, state) {
                return DefaultButtonWidget(
                  onPressed: () {
                    context.read<AddLessonCubit>().addLesson(
                        nameAr: _nameArController.text,
                        nameEn: _nameEnController.text,
                        courseId: widget.courseId,
                        imagePath: _selectedImagePath ?? '',
                        videoUrl: _videoController.text,
                        files: _files,
                        filesNames: _filesNames,
                        lessonId: widget.lesson?.id);
                  },
                  text: widget.lesson == null
                      ? AppStrings.addLesson.tr()
                      : AppStrings.save.tr(),
                  textColor: ColorManager.white,
                  color: ColorManager.primary,
                  isExpanded: false,
                  horizontalPadding: 30.w,
                  fontSize: 13.r,
                  isLoading: state.status == Status.loading,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
