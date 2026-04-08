import 'package:easy_localization/easy_localization.dart';
import 'package:elmotamizon/common/extensions/context_extension.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/widgets/default_image_widget.dart';
import 'package:elmotamizon/constants/assets.dart';
import 'package:elmotamizon/features/home/details/models/teacher_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:html_unescape/html_unescape.dart';

class TeacherDetailsView extends StatelessWidget {
  const TeacherDetailsView({super.key, this.data});
  final TeacherDataModel? data;
  @override
  Widget build(BuildContext context) {
    final unescape = HtmlUnescape();
    // النص اللي جاي من الـ API
    final rawHtml = data?.bio ?? "";

// نفك مرتين
    final once = unescape.convert(rawHtml); // يحوّل &lt;h2&gt; → <h2>
    final decodedHtml = unescape.convert(once);
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
            child: Column(
              spacing: 10.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: DefaultImageWidget(
                    radius: 10.r,
                    image: data?.image ?? "",
                    //"https://almutamayizun.besohola.com/uploads/courses//1757847448_68c69f98cce51_about_2.jpg",
                  ),
                ),

                Text(
                  "${data?.name}",
                  style: context.textTheme.displaySmall,
                ),
                Text(
                  "${data?.qualification}",
                  style: const TextStyle(
                    color: ColorManager.grayColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: 5,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            spacing: 10.w,
                            children: [
                              SvgPicture.asset(
                                Assets.assetsIconsStudent,
                                width: 20.w,
                                height: 20.h,
                              ),
                              Expanded(
                                child: Text(
                                  //طالب
                                  "${data?.users} ${AppStrings.studens.tr()}",
                                  style: context.textTheme.bodyMedium!.copyWith(
                                    color: ColorManager.textGrayColor,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            spacing: 10.w,
                            children: [
                              SvgPicture.asset(
                                Assets.assetsIconsPlayCourse,
                                width: 20.w,
                                height: 20.h,
                              ),
                              Expanded(
                                child: Text(
                                  //كورس
                                  "${data?.courses} ${AppStrings.course.tr()}",
                                  style: context.textTheme.bodyMedium!.copyWith(
                                    color: ColorManager.textGrayColor,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Gap(20.w),
                      ],
                    ),
                  ],
                ),

                // for (var i = 0; i < data.length; i++)
                Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TextTitle(
                    //   //نبذه مختصره:
                    //   text: AppStrings.briefOverview.tr(),
                    // ),
                    // SubTextTitle(
                    //   text: "${data?.bio}",
                    // ),
                    Html(
                      data: decodedHtml,
                      // unescape.convert(
                      //   state.getContactUsModel!.data!.termsConditions ?? "",
                      // ), // ← HTML بعد فك التشفير
                      style: {
                        "body": Style(
                          fontSize: FontSize(16),
                          textAlign: TextAlign.right,
                          lineHeight: const LineHeight(1.6),
                        ),
                        "h2": Style(
                          fontSize: FontSize(18),
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      },
                    ),
                  ],
                ),
                Gap(30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TextTitle extends StatelessWidget {
  const TextTitle({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.textTheme.headlineMedium!.copyWith(
        color: ColorManager.textGrayColor,
        fontSize: 18.sp,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class SubTextTitle extends StatelessWidget {
  const SubTextTitle({
    super.key,
    required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.textTheme.headlineMedium!.copyWith(
        color: ColorManager.textGrayColor,
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
