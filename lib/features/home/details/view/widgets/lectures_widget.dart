import 'package:easy_localization/easy_localization.dart';
import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:elmotamizon/common/widgets/default_error_widget.dart';
import 'package:elmotamizon/common/widgets/shimmer_container_widget.dart';
import 'package:elmotamizon/constants/assets.dart';
import 'package:elmotamizon/features/home/details/cubit/lessons_content_cubit/lessons_content_cubit.dart';
import 'package:elmotamizon/features/home/details/models/lessons_content_model.dart';
import 'package:elmotamizon/features/home/details/view/widgets/book_text.dart';
import 'package:elmotamizon/features/home/details/view/widgets/custom_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LecturesWidget extends StatefulWidget {
  const LecturesWidget({
    super.key,
    required this.id, this.onSelected, this.lessonId,
  });
  final int id;
  final int? lessonId;
  final Function(LessonModel lesson)? onSelected;

  @override
  State<LecturesWidget> createState() => _LecturesWidgetState();
}

class _LecturesWidgetState extends State<LecturesWidget> {
  int? _selectedId;

  List<LessonModel> _uniqueLessons(List<LessonModel> lessons) {
    final Set<String> seenKeys = <String>{};
    final List<LessonModel> unique = <LessonModel>[];

    for (final lesson in lessons) {
      final String keyById = lesson.id != null ? 'id:${lesson.id}' : '';
      final String keyByVideo = (lesson.videoUrl ?? '').trim().isNotEmpty
          ? 'video:${(lesson.videoUrl ?? '').trim()}'
          : '';
      final String keyByName = (lesson.name ?? '').trim().isNotEmpty
          ? 'name:${(lesson.name ?? '').trim().toLowerCase()}'
          : '';

      final String key = keyById.isNotEmpty
          ? keyById
          : (keyByVideo.isNotEmpty ? keyByVideo : keyByName);
      if (key.isEmpty) {
        unique.add(lesson);
        continue;
      }

      if (!seenKeys.contains(key)) {
        seenKeys.add(key);
        unique.add(lesson);
      }
    }

    return unique;
  }

  @override
  void initState() {
    super.initState();
    _selectedId = widget.lessonId;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          instance<LessonsContentCubit>()..loadFirstLessonsContentPage(widget.id),
      child: BlocBuilder<LessonsContentCubit, BaseState<LessonModel>>(
        builder: (context, state) {
          if (state.status == Status.failure) {
            return DefaultErrorWidget(errorMessage: state.errorMessage ?? '');
          }
          if (state.status == Status.loading) {
            return Column(
              children: List.generate(3, (index) => Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: ShimmerContainerWidget(height: 20.h,width: double.infinity,),
              ),),
            );
          }
          final lessonsList = _uniqueLessons(state.items);
          return Column(
            spacing: 10.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTitle(title: AppStrings.lectures.tr()),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 15.h,
                children: lessonsList.asMap().entries.map((entry) {
                  final index = entry.key;
                  return GestureDetector(
                    onTap: () {
                      if(widget.onSelected != null && (_selectedId != lessonsList[index].id)){
                        if(lessonsList[index].isFree==1 || lessonsList[index].isSubscribed==1) {
                          widget.onSelected!(lessonsList[index]);
                          _selectedId = lessonsList[index].id ?? 0;
                          setState(() {});
                        }
                        else{
                          AppFunctions.showsToast(AppStrings.subscribeFirst.tr(), ColorManager.red, context);
                        }
                      }
                    },
                    child: BookText(
                      havePerfix: true,
                      havePostfix:
                      !(lessonsList[index].isFree == 1 || lessonsList[index].isSubscribed==1),
                      haveTime: true,
                      perfixIcon: Assets.assetsIconsPlayBlack,
                      postfixIcon: Assets.assetsIconsLock,
                      text: lessonsList[index].name ?? "",
                      time: "",
                      color: (_selectedId == lessonsList[index].id)
                          ? Colors.black
                          : null,
                    ),
                  );
                }).toList(),
              ),
              if(context.read<LessonsContentCubit>().hasMore)
                Gap(10.h),
              if(context.read<LessonsContentCubit>().hasMore)
              GestureDetector(
                onTap: () {
                  context.read<LessonsContentCubit>().loadMoreLessonsContentPage(widget.id);
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
