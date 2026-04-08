import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/app/app_prefs.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:elmotamizon/common/widgets/default_app_bar.dart';
import 'package:elmotamizon/common/widgets/default_button_widget.dart';
import 'package:elmotamizon/common/widgets/default_form_field.dart';
import 'package:elmotamizon/features/support_whatsapp/cubit/support_whatsapp_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportWhatsappView extends StatefulWidget {
  const SupportWhatsappView({super.key});

  @override
  State<SupportWhatsappView> createState() => _SupportWhatsappViewState();
}

class _SupportWhatsappViewState extends State<SupportWhatsappView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _openWhatsApp(String number, [String? prefillText]) async {
    final cleanNumber = number.replaceAll(RegExp(r'[^\d]'), '');
    final uri = Uri.parse(
      'https://wa.me/$cleanNumber${prefillText != null && prefillText.isNotEmpty ? '?text=${Uri.encodeComponent(prefillText)}' : ''}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          instance<SupportWhatsappCubit>()..loadWhatsappNumber(),
      child: Scaffold(
        appBar: DefaultAppBar(
          text: AppStrings.supportViaWhatsapp.tr(),
        ),
        body: BlocConsumer<SupportWhatsappCubit, SupportWhatsappState>(
          listener: (context, state) {
            if (state.status == Status.success) {
              if (state.successMessage != null) {
                _messageController.clear();
                AppFunctions.showsToast(
                  state.successMessage!,
                  ColorManager.successGreen,
                  context,
                );
              }
            } else if (state.status == Status.failure &&
                state.errorMessage != null) {
              AppFunctions.showsToast(
                state.errorMessage!,
                ColorManager.red,
                context,
              );
            }
          },
          builder: (context, state) {
            final isLoading = state.status == Status.loading;
            final number = state.whatsappNumber;
            final numberLoaded =
                state.status == Status.success || number != null;

            if (isLoading && !numberLoaded) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.supportViaWhatsappTitle.tr(),
                      style: getBoldStyle(
                        fontSize: 20.sp,
                        color: ColorManager.primary,
                      ),
                    ),
                    Gap(8.h),
                    Text(
                      AppStrings.supportViaWhatsappSubtitle.tr(),
                      style: getRegularStyle(
                        fontSize: 14.sp,
                        color: ColorManager.greyTextColor,
                      ),
                    ),
                    Gap(24.h),
                    // if (number == null || number.isEmpty)
                    //   Padding(
                    //     padding: EdgeInsets.only(bottom: 16.h),
                    //     child: Text(
                    //       AppStrings.whatsappNotConfigured.tr(),
                    //       style: getRegularStyle(
                    //         fontSize: 14.sp,
                    //         color: ColorManager.greyTextColor,
                    //       ),
                    //     ),
                    //   )
                    // else ...[
                    //   InkWell(
                    //     onTap: () => _openWhatsApp(number),
                    //     child: Container(
                    //       padding: EdgeInsets.symmetric(
                    //         vertical: 12.h,
                    //         horizontal: 16.w,
                    //       ),
                    //       decoration: BoxDecoration(
                    //         color: ColorManager.fillColor,
                    //         borderRadius: BorderRadius.circular(12.r),
                    //         border: Border.all(color: ColorManager.greyBorder),
                    //       ),
                    //       child: Row(
                    //         children: [
                    //           Icon(
                    //             Icons.chat,
                    //             color: Color(0xFF25D366),
                    //             size: 28.r,
                    //           ),
                    //           Gap(12.w),
                    //           Expanded(
                    //             child: Column(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 Text(
                    //                   AppStrings.openInWhatsapp.tr(),
                    //                   style: getBoldStyle(
                    //                     fontSize: 14.sp,
                    //                     color: ColorManager.primary,
                    //                   ),
                    //                 ),
                    //                 Text(
                    //                   number,
                    //                   style: getRegularStyle(
                    //                     fontSize: 12.sp,
                    //                     color: ColorManager.greyTextColor,
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //           Icon(
                    //             Icons.open_in_new,
                    //             size: 20.r,
                    //             color: ColorManager.greyTextColor,
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    //   Gap(20.h),
                    // ],
                    Text(
                      AppStrings.describeYourProblem.tr(),
                      style: getBoldStyle(
                        fontSize: 14.sp,
                        color: ColorManager.black,
                      ),
                    ),
                    Gap(8.h),
                    DefaultFormField(
                      noBorder: false,
                      fillColor: ColorManager.fillColor,
                      borderColor: ColorManager.greyBorder,
                      controller: _messageController,
                      hintText: AppStrings.message.tr(),
                      maxLines: 5,
                      maxLength: 1000,
                    ),
                    Gap(24.h),
                    SizedBox(
                      width: double.infinity,
                      child: DefaultButtonWidget(
                        onPressed: isLoading
                            ? null
                            : () {
                                final message = _messageController.text.trim();
                                if (message.isEmpty) {
                                  AppFunctions.showsToast(
                                    AppStrings.textFieldError.tr(),
                                    ColorManager.red,
                                    context,
                                  );
                                  return;
                                }
                                String number = state.whatsappNumber ?? '';
                                if (number.isEmpty) {
                                  AppFunctions.showsToast(
                                    AppStrings.whatsappNotConfigured.tr(),
                                    ColorManager.red,
                                    context,
                                  );
                                  return;
                                }
                                final userName =
                                    instance<AppPreferences>().getUserName();
                                final fullText =
                                    'انا الطالب $userName عندي مشكله $message';
                                if (number.startsWith('0')) {
                                  number = '+20' + number.substring(1);
                                }
                                _openWhatsApp(number, fullText);
                              },
                        text: AppStrings.sendTicket.tr(),
                        color: ColorManager.primary,
                        textColor: ColorManager.white,
                        fontSize: 15.sp,
                        isLoading: isLoading,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
