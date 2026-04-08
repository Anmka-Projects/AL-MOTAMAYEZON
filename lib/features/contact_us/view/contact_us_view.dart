import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:elmotamizon/common/widgets/default_app_bar.dart';
import 'package:elmotamizon/common/widgets/default_button_widget.dart';
import 'package:elmotamizon/common/widgets/default_form_field.dart';
import 'package:elmotamizon/features/contact_us/cubit/contact_us_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactUsView extends StatefulWidget {
  const ContactUsView({super.key});

  @override
  State<ContactUsView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(text: AppStrings.contactUs.tr(),),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.contactUsTitle.tr(),
                  style: getBoldStyle(fontSize: 20.sp, color: ColorManager.primary),
                ),
                SizedBox(height: 5.h),
                Text(
                  AppStrings.contactUsSubtitle.tr(),
                  style: getRegularStyle(fontSize: 14.sp, color: ColorManager.greyTextColor),
                ),
                SizedBox(height: 30.h),
                DefaultFormField(
                  noBorder: false,
                  fillColor: ColorManager.fillColor,
                  borderColor: ColorManager.greyBorder,
                  controller: _nameController,
                  hintText: AppStrings.fullName.tr(),
                ),
                SizedBox(height: 15.h),
                DefaultFormField(
                  keyboardType: TextInputType.phone,
                  noBorder: false,
                  fillColor: ColorManager.fillColor,
                  borderColor: ColorManager.greyBorder,
                  controller: _phoneController,
                  hintText: AppStrings.phoneNumber.tr(),
                ),
                SizedBox(height: 15.h),
                DefaultFormField(
                  noBorder: false,
                  fillColor: ColorManager.fillColor,
                  borderColor: ColorManager.greyBorder,
                  controller: _emailController,
                  hintText: AppStrings.emailAddress.tr(),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 15.h),
                DefaultFormField(
                  noBorder: false,
                  fillColor: ColorManager.fillColor,
                  borderColor: ColorManager.greyBorder,
                  controller: _subjectController,
                  hintText: AppStrings.contactSubject.tr(),
                ),
                SizedBox(height: 15.h),
                DefaultFormField(
                  noBorder: false,
                  fillColor: ColorManager.fillColor,
                  borderColor: ColorManager.greyBorder,
                  controller: _messageController,
                  hintText: AppStrings.message.tr(),
                  maxLines: 5,
                ),
                SizedBox(height: 30.h),
                BlocProvider(
                  create: (context) => instance<ContactUsCubit>(),
                  child: BlocConsumer<ContactUsCubit, ContactUsState>(
                    listener: (context, state) {
                      if (state.status == Status.success) {
                        _nameController.clear();
                        _phoneController.clear();
                        _emailController.clear();
                        _subjectController.clear();
                        _messageController.clear();
                        AppFunctions.showsToast(state.message ?? AppStrings.messageSentSuccessfully.tr(), ColorManager.successGreen, context);
                      } else if (state.status == Status.failure) {
                        AppFunctions.showsToast(state.errorMessage ?? AppStrings.unKnownError.tr(), ColorManager.red, context);
                      }
                    },
                    builder: (context, state) {
                      final isLoading = state.status == Status.loading;
                      return SizedBox(
                        width: double.infinity,
                        child: DefaultButtonWidget(
                          onPressed: () {
                              context.read<ContactUsCubit>().contactUs(
                                name: _nameController.text,
                                email: _emailController.text,
                                phone: _phoneController.text,
                                subject: _subjectController.text,
                                message: _messageController.text,
                              );
                          },
                          text: AppStrings.sendMessage.tr(),
                          color: ColorManager.primary,
                          textColor: ColorManager.white,
                          fontSize: 15.sp,
                          isLoading: isLoading,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 