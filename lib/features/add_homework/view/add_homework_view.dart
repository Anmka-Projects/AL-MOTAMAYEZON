import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/widgets/default_app_bar.dart';
import 'package:elmotamizon/common/widgets/default_button_widget.dart';
import 'package:elmotamizon/common/widgets/default_form_field.dart';
import 'package:elmotamizon/common/widgets/default_pick_files_widget.dart';
import 'package:elmotamizon/features/add_homework/cubit/add_homework_cubit.dart';
import 'package:elmotamizon/features/lesson_details/cubit/homeworks/homeworks_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class AddHomeworkView extends StatefulWidget {
  final int lessonId;
  final BuildContext homeworksContext;
  const AddHomeworkView({super.key, required this.lessonId, required this.homeworksContext});

  @override
  State<AddHomeworkView> createState() => _AddHomeworkViewState();
}

class _AddHomeworkViewState extends State<AddHomeworkView> {
  final TextEditingController _nameArController = TextEditingController();
  final TextEditingController _nameEnController = TextEditingController();
  String? _selectedImagePath;
  final List<String>? _files = [];


  @override
  void dispose() {
    super.dispose();
    _nameArController.dispose();
    _nameEnController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(text: AppStrings.addHomework.tr(),),
      body: ListView(
          padding: EdgeInsets.zero,
          children: [
            _newBody(),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: BlocProvider(
                create: (context) => instance<AddHomeworkCubit>(),
                child: BlocConsumer<AddHomeworkCubit, BaseState<String>>(
                  listener: (context, state) {
                    if (state.status == Status.success) {
                      AppFunctions.showsToast(state.data ?? '', ColorManager.successGreen, context);
                      widget.homeworksContext.read<HomeworksCubit>().loadFirstHomeworksPage(widget.lessonId);
                      Navigator.pop(context);
                    } else if (state.status == Status.failure) {
                      AppFunctions.showsToast(state.errorMessage ?? '', ColorManager.red, context);
                    }
                  },
                  builder: (context, state) {
                    return DefaultButtonWidget(
                      onPressed: () {
                        context.read<AddHomeworkCubit>().addHomework(
                          nameAr: _nameArController.text.trim(),
                          nameEn: _nameEnController.text.trim(),
                          files: _files??[],
                          imagePath: _selectedImagePath ?? '',
                          lessonId: widget.lessonId,
                        );
                      },
                      text: AppStrings.addHomework.tr(),
                      textColor: ColorManager.white,
                      color: ColorManager.primary,
                      // isExpanded: false,
                      // horizontalPadding: 30.w,
                      fontSize: 13.r,
                      isLoading: state.status == Status.loading,
                    );
                  },
                ),
              ),
            ),
          ]),
    );
  }

  _newBody() {
    return Padding(
      padding: EdgeInsets.fromLTRB(15.w, 0, 15.h, 15.h),
      child: Column(children: [
        SizedBox(height: 15.h,),
        DefaultFormField(
          noBorder: false,
          controller: _nameArController,
          fillColor: ColorManager.fillColor,
          borderColor: ColorManager.greyBorder,
          hintText: AppStrings.homeworkNameAr.tr(),
          title: AppStrings.homeworkNameAr.tr(),
        ),
        SizedBox(
          height: 20.h,
        ),
        DefaultFormField(
          controller: _nameEnController,
          noBorder: false,
          fillColor: ColorManager.fillColor,
          borderColor: ColorManager.greyBorder,
          hintText: AppStrings.homeworkNameEn.tr(),
          title: AppStrings.homeworkNameEn.tr(),
        ),
        SizedBox(
          height: 20.h,
        ),
      StatefulBuilder(
          builder: (context, setState) {
            return DefaultPickFilesWidget(
              imagesOnly: true,
              isSingle: true,
              title: AppStrings.homeworkPhoto.tr(),
              onPicked: (filesPaths, filesNames) {
                _selectedImagePath = filesPaths.first;
              },
              clear: _selectedImagePath == '',
            );
          }
      ),
        SizedBox(
          height: 20.h,
        ),
      StatefulBuilder(
        builder: (context,setState) {
          return DefaultPickFilesWidget(
            onPicked: (filesPaths, filesNames) {
              _files?.addAll(filesPaths);
            },
            onRemoveLocal: (index) {
              _files?.removeAt(index);
            },
            title: AppStrings.homeworkFiles.tr(),
            clear: _files==null,
          );
        }
      ),
        // const FilesWidget(),
      ],),
    );
  }

}
