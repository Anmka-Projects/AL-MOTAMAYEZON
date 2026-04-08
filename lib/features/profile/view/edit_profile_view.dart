import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/app/app_prefs.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/language_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:elmotamizon/common/widgets/default_button_widget.dart';
import 'package:elmotamizon/common/widgets/default_dropdown_menu_widget.dart';
import 'package:elmotamizon/common/widgets/default_error_widget.dart';
import 'package:elmotamizon/common/widgets/default_form_field.dart';
import 'package:elmotamizon/features/auth/signup/cubit/stages_grades_cubit/stages_grades_cubit.dart';
import 'package:elmotamizon/features/auth/signup/models/stages_grades_model.dart';
import 'package:elmotamizon/features/profile/cubit/profile_cubit.dart';
import 'package:elmotamizon/features/profile/models/profile_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _bioController = TextEditingController();
  final _qualificationController = TextEditingController();
  String? _imageUrl;
  bool _isEditMode = false;
  File? _pickedImageFile;
  StageModel? _selectedStage;
  GradeModel? _selectedGrade;

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().fetchProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    _bioController.dispose();
    _qualificationController.dispose();
    super.dispose();
  }

  void _fillFields(ProfileModel profile) {
    _nameController.text = profile.name ?? '';
    _emailController.text = profile.email ?? '';
    _phoneController.text = profile.phone ?? '';
    _birthDateController.text = profile.birthDate ?? '';
    _imageUrl = profile.image;
    _bioController.text = profile.teacherData?.bio ?? '';
    _qualificationController.text = profile.teacherData?.qualification ?? '';
  }

  void _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImageFile = File(picked.path);
        _imageUrl = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.editProfile.tr(),
            style: getBoldStyle(fontSize: 16.sp, color: ColorManager.primary)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: ColorManager.primary),
        actions: [
          if (!_isEditMode)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditMode = true;
                });
              },
            ),
        ],
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.status == Status.success && state.message != null) {
            AppFunctions.showsToast(
                state.message!, ColorManager.successGreen, context);
            Navigator.pop(context);
          } else if (state.status == Status.failure &&
              state.errorMessage != null) {
            AppFunctions.showsToast(
                state.errorMessage!, ColorManager.red, context);
          } else if (state.status == Status.success && state.profile != null) {
            _fillFields(state.profile!);
            _isEditMode = false;
            setState(() {});
          }
        },
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == Status.failure) {
            return DefaultErrorWidget(errorMessage: state.errorMessage ?? '');
          }
          return Padding(
            padding: EdgeInsets.all(20.r),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 45.r,
                            backgroundImage:
                                (_imageUrl != null && _imageUrl!.isNotEmpty
                                    ? NetworkImage(_imageUrl!)
                                    : (_pickedImageFile?.path ?? '').isNotEmpty
                                        ? FileImage(_pickedImageFile!)
                                        : null) as ImageProvider?,
                            backgroundColor: ColorManager.lightGrey,
                          ),
                          if (_isEditMode)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: _pickImage,
                                child: CircleAvatar(
                                  radius: 16.r,
                                  backgroundColor: ColorManager.primary,
                                  child: const Icon(Icons.edit,
                                      color: Colors.white, size: 18),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    DefaultFormField(
                      controller: _nameController,
                      enabled: _isEditMode == true ? true : false,
                      noBorder: false,
                      fillColor: ColorManager.fillColor,
                      borderColor: ColorManager.greyBorder,
                      hintText: AppStrings.fullName.tr(),
                      title: AppStrings.fullName.tr(),
                    ),
                    SizedBox(height: 15.h),
                    DefaultFormField(
                      controller: _emailController,
                      enabled: false,
                      noBorder: false,
                      fillColor: ColorManager.fillColor,
                      borderColor: ColorManager.greyBorder,
                      hintText: AppStrings.emailAddress.tr(),
                      title: AppStrings.emailAddress.tr(),
                    ),
                    SizedBox(height: 15.h),
                    DefaultFormField(
                      controller: _phoneController,
                      enabled: _isEditMode == true ? true : false,
                      noBorder: false,
                      fillColor: ColorManager.fillColor,
                      borderColor: ColorManager.greyBorder,
                      hintText: AppStrings.phoneNumber.tr(),
                      title: AppStrings.phoneNumber.tr(),
                    ),
                    SizedBox(height: 15.h),
                    DefaultFormField(
                      onTap: () {
                        _addTimeOnTap();
                      },
                      readOnly: true,
                      controller: _birthDateController,
                      enabled: _isEditMode == true ? true : false,
                      noBorder: false,
                      fillColor: ColorManager.fillColor,
                      borderColor: ColorManager.greyBorder,
                      hintText: AppStrings.birthYear.tr(),
                      title: AppStrings.birthYear.tr(),
                    ),
                    SizedBox(height: 15.h),
                    if (instance<AppPreferences>().getUserType() == 'student')
                      _stagesGradesWidget(
                          isEnabled: _isEditMode,
                          stageId: state.profile?.stage,
                          gradeId: state.profile?.grade),
                    if (instance<AppPreferences>().getUserType() ==
                        'teacher') ...[
                      SizedBox(height: 15.h),
                      DefaultFormField(
                        controller: _bioController,
                        enabled: _isEditMode == true ? true : false,
                        noBorder: false,
                        fillColor: ColorManager.fillColor,
                        borderColor: ColorManager.greyBorder,
                        hintText: AppStrings.teacherOverView.tr(),
                        title: AppStrings.teacherOverView.tr(),
                        maxLines: 3,
                      ),
                      SizedBox(height: 15.h),
                      DefaultFormField(
                        controller: _qualificationController,
                        enabled: _isEditMode == true ? true : false,
                        noBorder: false,
                        fillColor: ColorManager.fillColor,
                        borderColor: ColorManager.greyBorder,
                        hintText: AppStrings.qualification.tr(),
                        title: AppStrings.qualification.tr(),
                      ),
                    ],
                    SizedBox(height: 30.h),
                    if (_isEditMode)
                      Row(
                        children: [
                          Expanded(
                            child: DefaultButtonWidget(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context
                                      .read<ProfileCubit>()
                                      .updateTeacherProfile(
                                        name: _nameController.text,
                                        email: _emailController.text,
                                        birthDate: _birthDateController.text,
                                        image: _pickedImageFile?.path,
                                        bio: _bioController.text,
                                        qualification:
                                            _qualificationController.text,
                                        stageId: _selectedStage?.id ??
                                            state.profile?.stage,
                                        gradeId: _selectedGrade?.id ??
                                            state.profile?.grade,
                                      );
                                }
                              },
                              color: ColorManager.primary,
                              textColor: ColorManager.white,
                              text: AppStrings.save.tr(),
                              isLoading: state.status == Status.loading,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  DateTime? _selectedBirthDate;
  void _addTimeOnTap() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (context) => Container(
        height: MediaQuery.sizeOf(context).height * .5,
        decoration: const BoxDecoration(
            color: ColorManager.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            )),
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: StatefulBuilder(
                builder: (context, setState) => ScrollDatePicker(
                  selectedDate: _selectedBirthDate ?? DateTime(2000, 8),
                  minimumDate: DateTime(1990),
                  maximumDate: DateTime.now(),
                  locale: Locale(language),
                  onDateTimeChanged: (value) {
                    setState(() {
                      _selectedBirthDate = value;
                      _birthDateController.text =
                          value.toString().split(" ")[0];
                    });
                  },
                ),
              ),
            ),
            DefaultButtonWidget(
              onPressed: () {
                Navigator.pop(context);
                setState(() {});
              },
              text: AppStrings.save.tr(),
              color: ColorManager.primary,
              textColor: ColorManager.white,
              verticalPadding: 12.h,
            ),
          ],
        ),
      ),
    );
  }

  _stagesGradesWidget({
    required bool isEnabled,
    int? stageId,
    int? gradeId,
  }) {
    return BlocProvider(
      create: (context) => instance<StagesGradesCubit>()..getStagesGrades(),
      child: BlocConsumer<StagesGradesCubit, BaseState<StagesGradesModel>>(
        buildWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (stageId != null) {
            if (state.status == Status.success) {
              if ((state.data?.data?.stages ?? []).isNotEmpty) {
                _selectedStage = state.data?.data?.stages!.firstWhere(
                  (element) {
                    if (element.id == stageId) {
                      if ((element.grades ?? []).isNotEmpty) {
                        _selectedGrade = element.grades!
                            .firstWhere((element) => element.id == gradeId);
                      }
                    }
                    return element.id == stageId;
                  },
                );
              }
            }
          }
        },
        builder: (context, state) {
          if (state.status == Status.loading ||
              state.status == Status.initial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == Status.success) {
            return StatefulBuilder(builder: (context, setState) {
              return Column(
                children: [
                  DefaultDropdownMenuWidget<StageModel>(
                    onSelected: (value) {
                      setState(() {
                        _selectedStage = value;
                        if (_selectedGrade != null) _selectedGrade = null;
                      });
                    },
                    items: state.data?.data?.stages ?? [],
                    hintText: AppStrings.selectStage.tr(),
                    selectedValue: _selectedStage,
                    title: AppStrings.stage.tr(),
                    optionTitle: (item) => item?.name ?? '',
                    searchOptionTitle: (item) => item?.name ?? '',
                  ),
                  if (_selectedStage != null)
                    SizedBox(
                      height: 15.h,
                    ),
                  if (_selectedStage != null)
                    DefaultDropdownMenuWidget<GradeModel>(
                      onSelected: (value) {
                        setState(() {
                          _selectedGrade = value;
                        });
                      },
                      items: _selectedStage?.grades ?? [],
                      title: AppStrings.grade.tr(),
                      hintText: AppStrings.selectGrade.tr(),
                      selectedValue: _selectedGrade,
                      optionTitle: (item) => item?.name ?? '',
                      searchOptionTitle: (item) => item?.name ?? '',
                    ),
                ],
              );
            });
          } else {
            return InkWell(
              onTap: () => context.read<StagesGradesCubit>().getStagesGrades(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Text(state.errorMessage!)),
                  SizedBox(
                    width: 5.w,
                  ),
                  const Icon(
                    Icons.refresh,
                    color: ColorManager.primary,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
