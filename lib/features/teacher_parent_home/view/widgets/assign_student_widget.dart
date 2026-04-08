import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/widgets/default_button_widget.dart';
import 'package:elmotamizon/common/widgets/default_expansion_tile.dart';
import 'package:elmotamizon/common/widgets/default_form_field.dart';
import 'package:elmotamizon/features/teacher_parent_home/cubit/assign_student/assign_student_cubit.dart';
import 'package:elmotamizon/features/teacher_parent_home/cubit/students/students_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AssignStudentWidget extends StatefulWidget {
  final BuildContext studentsContext;
  const AssignStudentWidget({super.key, required this.studentsContext});

  @override
  State<AssignStudentWidget> createState() => _AssignStudentWidgetState();
}

class _AssignStudentWidgetState extends State<AssignStudentWidget> {
  final TextEditingController _codeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<AssignStudentCubit>(),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: DefaultExpansionTile(
            radius: 15.r,
            initiallyExpanded: true,
            name: AppStrings.assignStudent.tr(),
            optionsWidget: [
              Container(
                color: ColorManager.white,
                padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 15.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: DefaultFormField(
                        controller: _codeController,
                        noBorder: false,
                        fillColor: ColorManager.fillColor,
                        borderColor: ColorManager.greyBorder,
                        // title: AppStrings.studentCode.tr(),
                        hintText: AppStrings.enterStudentCode.tr(),
                        withValidate: false,
                      ),
                    ),
                    SizedBox(width: 10.w,),
                    BlocConsumer<AssignStudentCubit, BaseState<String>>(
                      listener: (context, state) {
                        if (state.status == Status.success) {
                          _codeController.clear();
                          AppFunctions.showsToast(state.data??'', ColorManager.successGreen, context);
                          widget.studentsContext.read<StudentsCubit>().loadFirstStudentsPage();
                        }else if (state.status == Status.failure) {
                          AppFunctions.showsToast(state.errorMessage??'', ColorManager.red, context);
                        }
                      },
                      builder: (context, state) {
                        return DefaultButtonWidget(
                          text: AppStrings.submit.tr(),
                          horizontalPadding: 15.w,
                          color: ColorManager.primary,
                          textColor: ColorManager.white,
                          borderColor: ColorManager.greyBorder,
                          isExpanded: false,
                          isLoading: state.status == Status.loading,
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              context.read<AssignStudentCubit>().assignStudent(_codeController.text.trim());
                            }
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
