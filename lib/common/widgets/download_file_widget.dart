import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/common/resources/assets_manager.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:elmotamizon/features/home/details/view/widgets/pdf_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DownloadFileWidget extends StatefulWidget {
  final String fileName;
  final String url;
  final bool isOpen;
  final void Function(String pdfLink, String name)? onOpenPdf;
  const DownloadFileWidget(
      {super.key,
      this.fileName = '',
      required this.url,
      this.isOpen = true,
      this.onOpenPdf});

  @override
  State<DownloadFileWidget> createState() => _DownloadFileWidgetState();
}

class _DownloadFileWidgetState extends State<DownloadFileWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 5.h),
      color: ColorManager.white,
      child: Row(
        children: [
          SvgPicture.asset(
            IconAssets.file,
            height: 20.w,
            width: 20.w,
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
              child: Text(
            widget.fileName,
            style: getSemiBoldStyle(
                fontSize: 15.sp, color: ColorManager.textColor),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          )),
          SizedBox(
            width: 10.w,
          ),
          TextButton(
              style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.h),
                  minimumSize: const Size(0, 0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.r))),
              onPressed: () async {
                if (!widget.isOpen) {
                  AppFunctions.showsToast(AppStrings.subscribeFirst.tr(),
                      ColorManager.red, context);
                  return;
                }
                if (widget.onOpenPdf != null) {
                  widget.onOpenPdf!(widget.url, widget.fileName);
                } else {
                  AppFunctions.navigateTo(
                    context,
                    PdfView(pdfLink: widget.url, name: widget.fileName),
                  );
                }
              },
              child: Text(
                AppStrings.download.tr(),
                style: getBoldStyle(
                    fontSize: 15.sp,
                    color: widget.isOpen
                        ? ColorManager.primary
                        : ColorManager.grey,
                    height: 1.5.h),
              )),
        ],
      ),
    );
  }
}
