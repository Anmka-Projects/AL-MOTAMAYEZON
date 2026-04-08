import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/resources/assets_manager.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/language_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:elmotamizon/common/widgets/default_button_widget.dart';
import 'package:elmotamizon/common/widgets/default_dropdown_menu_widget.dart';
import 'package:elmotamizon/common/widgets/default_form_field.dart';
import 'package:elmotamizon/common/widgets/default_pick_files_widget.dart';
import 'package:elmotamizon/features/auth/signup/cubit/register_cubit/register_cubit.dart';
import 'package:elmotamizon/features/auth/login/view/login_view.dart';
import 'package:elmotamizon/features/auth/signup/cubit/stages_grades_cubit/stages_grades_cubit.dart';
import 'package:elmotamizon/features/auth/signup/models/signup_model.dart';
import 'package:elmotamizon/features/auth/signup/models/stages_grades_model.dart';
import 'package:elmotamizon/features/auth/verify_otp/view/verify_otp_view.dart';
import 'package:elmotamizon/features/privacy_policy/view/privacy_policy_view.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

class SignUpView extends StatefulWidget {
  final int pageIndex;
  final String userType;
  const SignUpView({super.key, this.pageIndex = 0, required this.userType});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _birthYearController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _teacherOverviewController =
      TextEditingController();
  final TextEditingController _childCodeController = TextEditingController();
  StageModel? _selectedStage;
  GradeModel? _selectedGrade;
  DateTime? _selectedBirthDate;
  String? _selectedImagePath;
  String _countryCode = '+20';

  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _fullNameController.dispose();
    _birthYearController.dispose();
    _confirmPasswordController.dispose();
    _teacherOverviewController.dispose();
    _childCodeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<RegisterCubit>(),
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 25.h),
            children: [
              SizedBox(height: 30.h),
              Image.asset(
                ImageAssets.logo,
                width: 90.w,
                height: 90.w,
              ),
              SizedBox(height: 40.h),
              Text(
                AppStrings.signup.tr(),
                style: getBoldStyle(fontSize: 15.sp, color: ColorManager.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5.h),
              Text(
                AppStrings.signupHint.tr(),
                style: getRegularStyle(
                    fontSize: 15.sp, color: ColorManager.textColor),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30.h,
              ),
              DefaultFormField(
                noBorder: false,
                controller: _fullNameController,
                fillColor: ColorManager.fillColor,
                borderColor: ColorManager.greyBorder,
                hintText: AppStrings.fullName.tr(),
                title: AppStrings.fullName.tr(),
              ),
              SizedBox(
                height: 20.h,
              ),
              DefaultFormField(
                noBorder: false,
                controller: _emailController,
                fillColor: ColorManager.fillColor,
                borderColor: ColorManager.greyBorder,
                hintText: AppStrings.emailAddress.tr(),
                title: AppStrings.emailAddress.tr(),
              ),
              SizedBox(
                height: 20.h,
              ),
              DefaultFormField(
                noBorder: false,
                controller: _phoneController,
                fillColor: ColorManager.fillColor,
                borderColor: ColorManager.greyBorder,
                hintText: AppStrings.phoneNumber.tr(),
                title: AppStrings.phoneNumber.tr(),
                prefixWidget: CountryCodePicker(
                  padding: EdgeInsets.all(2.r),
                  onChanged: (value) {
                    if (value.dialCode != null) _countryCode = value.dialCode!;
                  },
                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                  initialSelection: 'EG',
                  favorite: const ['EG', 'SA'],
                  // optional. Shows only country name and flag
                  showCountryOnly: false,
                  // optional. Shows only country name and flag when popup is closed.
                  showOnlyCountryWhenClosed: false,
                  // optional. aligns the flag and the Text left
                  alignLeft: false,
                  dialogTextStyle:
                      getBoldStyle(fontSize: 15.sp, color: ColorManager.black),
                  showDropDownButton: true,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              DefaultFormField(
                onTap: () {
                  _addTimeOnTap();
                },
                readOnly: true,
                noBorder: false,
                controller: _birthYearController,
                fillColor: ColorManager.fillColor,
                borderColor: ColorManager.greyBorder,
                hintText: AppStrings.birthYear.tr(),
                title: AppStrings.birthYear.tr(),
                suffixIcon: Padding(
                  padding: EdgeInsets.all(13.r),
                  child: SvgPicture.asset(IconAssets.calender),
                ),
              ),
              if (widget.userType == "student")
                SizedBox(
                  height: 15.h,
                ),
              if (widget.userType == "student") _stagesGradesWidget(),
              if (widget.userType == "parent")
                SizedBox(
                  height: 15.h,
                ),
              // if(widget.userType == "teacher")
              // DefaultFormField(
              //   noBorder: false,
              //   controller: _teacherOverviewController,
              //   fillColor: ColorManager.fillColor,
              //   borderColor: ColorManager.greyBorder,
              //   hintText: AppStrings.teacherOverView.tr(),
              //   title: AppStrings.teacherOverView.tr(),
              //   withValidate: false,
              //   maxLines: 5,
              // ),
              if (widget.userType == "parent")
                DefaultFormField(
                  noBorder: false,
                  controller: _childCodeController,
                  fillColor: ColorManager.fillColor,
                  borderColor: ColorManager.greyBorder,
                  hintText: AppStrings.childCode.tr(),
                  title: AppStrings.childCode.tr(),
                ),
              SizedBox(
                height: 20.h,
              ),
              DefaultPickFilesWidget(
                imagesOnly: true,
                isSingle: true,
                title: AppStrings.photo.tr(),
                onPicked: (filesPaths, filesNames) {
                  _selectedImagePath = filesPaths.first;
                },
              ),
              SizedBox(
                height: 20.h,
              ),
              DefaultFormField(
                noBorder: false,
                controller: _passwordController,
                fillColor: ColorManager.fillColor,
                borderColor: ColorManager.greyBorder,
                // prefixIconPath: IconAssets.lock,
                hintText: AppStrings.password.tr(),
                title: AppStrings.password.tr(),
                obscureText: true,
              ),
              SizedBox(
                height: 20.h,
              ),
              DefaultFormField(
                noBorder: false,
                controller: _confirmPasswordController,
                fillColor: ColorManager.fillColor,
                borderColor: ColorManager.greyBorder,
                // prefixIconPath: IconAssets.lock,
                hintText: AppStrings.confirmPasswordHint.tr(),
                title: AppStrings.confirmPassword.tr(),
                obscureText: true,
              ),
              SizedBox(
                height: 10.h,
              ),
              _terms(),
              SizedBox(
                height: 30.h,
              ),
              _signupButton(context),
              SizedBox(
                height: 20.h,
              ),
              _loginWidget(),
            ],
          ),
        ),
      ),
    );
  }

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
                  minimumDate: DateTime(1800),
                  maximumDate: DateTime.now(),
                  locale: Locale(language),
                  onDateTimeChanged: (value) {
                    setState(() {
                      _selectedBirthDate = value;
                      _birthYearController.text =
                          value.toString().split(" ")[0];
                    });
                  },
                ),
              ),
            ),
            DefaultButtonWidget(
              onPressed: () {
                _selectedBirthDate ??= DateTime(2000, 8);
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

  Widget _signupButton(BuildContext context) {
    return BlocConsumer<RegisterCubit, BaseState<SignupModel>>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == Status.failure) {
          AppFunctions.showsToast(
              state.errorMessage ?? '', ColorManager.red, context);
        }
        if (state.status == Status.success) {
          AppFunctions.navigateToAndFinish(
              context,
              VerifyOtpView(
                phone: _emailController.text.trim(),
                isForgetPassword: false,
              ));
        }
      },
      builder: (context, state) {
        return DefaultButtonWidget(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              context.read<RegisterCubit>().register(
                    name: _fullNameController.text.trim(),
                    email: _emailController.text.trim(),
                    phone: _countryCode + _phoneController.text.trim(),
                    password: _passwordController.text.trim(),
                    passwordConfirmation:
                        _confirmPasswordController.text.trim(),
                    userType: widget.userType,
                    stageId: _selectedStage?.id,
                    gradeId: _selectedGrade?.id,
                    imagePath: _selectedImagePath,
                    birthDate: _birthYearController.text.trim(),
                    childCode: _childCodeController.text.trim(),
                  );
            }
          },
          text: AppStrings.signup.tr(),
          color: ColorManager.primary,
          textColor: ColorManager.white,
          isIcon: true,
          isText: true,
          textFirst: true,
          fontSize: 15.sp,
          isLoading: state.status == Status.loading,
          verticalPadding: state.status == Status.loading ? 15.h : 5.h,
          horizontalPadding: 5.w,
          radius: 25.r,
          iconBuilder: CircleAvatar(
            radius: 18.r,
            backgroundColor: ColorManager.white,
            child: SvgPicture.asset(
              IconAssets.rightArrow,
              color: ColorManager.primary,
              width: 13.w,
              height: 13.w,
            ),
          ),
        );
      },
    );
  }

  Widget _loginWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.alreadyHaveAccount.tr(),
          style: getLightStyle(fontSize: 14.sp, color: ColorManager.textColor),
        ),
        SizedBox(
          width: 5.w,
        ),
        InkWell(
          onTap: () {
            AppFunctions.navigateTo(context, const LoginView());
          },
          child: Text(
            AppStrings.login.tr(),
            style: getBoldStyle(fontSize: 15.sp, color: ColorManager.primary),
          ),
        ),
      ],
    );
  }

  Widget _terms() {
    return Wrap(
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          AppStrings.byCreatingAccountYouAgreeWith.tr(),
          style: getLightStyle(fontSize: 12.sp, color: ColorManager.textColor),
        ),
        SizedBox(
          width: 5.w,
        ),
        InkWell(
          onTap: () {
            AppFunctions.navigateTo(
                context, const PrivacyPolicyView(infoType: InfoType.terms));
          },
          child: Text(
            AppStrings.terms.tr(),
            style: getBoldStyle(fontSize: 13.sp, color: ColorManager.primary),
          ),
        ),
      ],
    );
  }

  _stagesGradesWidget() {
    return BlocProvider(
      create: (context) => instance<StagesGradesCubit>()..getStagesGrades(),
      child: BlocBuilder<StagesGradesCubit, BaseState<StagesGradesModel>>(
        buildWhen: (previous, current) => previous.status != current.status,
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
