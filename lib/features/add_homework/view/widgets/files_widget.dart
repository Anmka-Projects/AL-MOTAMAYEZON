
import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/common/resources/assets_manager.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:elmotamizon/common/widgets/default_button_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';


class FilesWidget extends StatefulWidget {
  const FilesWidget({super.key});

  @override
  State<FilesWidget> createState() => _FilesWidgetState();
}

class _FilesWidgetState extends State<FilesWidget> {
  final List<String> _files = [];
  final List<String> _filesNames = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.homeworkFiles.tr(), style: getMediumStyle(
            fontSize: 13.sp, color: ColorManager.textColor),),
        SizedBox(height: 5.h,),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: Colors.transparent,
            border: Border.all(color: ColorManager.greyBorder),
          ),
          child: Row(
            children: [
              DefaultButtonWidget(
                onPressed: () {
                  _pickMultipleFiles();
                },
                text: AppStrings.chooseFile.tr(),
                color: ColorManager.primary,
                textColor: ColorManager.white,
                horizontalPadding: 20.w,
                isExpanded: false,
                fontSize: 13.sp,
                elevation: 0,
                verticalPadding: 14.h,
              )
            ],
          ),
        ),
        SizedBox(height: 10.h,),
        _filesWidget()
      ],
    );
  }

  _filesWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_files.length, (index) => _file(fileName: _filesNames[index],index: index),),
    );
  }

  _file({
   required String fileName,
   required int index,
}){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 10.w),
      child: Row(
        children: [
          SvgPicture.asset(IconAssets.file,height: 18.h,width: 18.w,),
          SizedBox(width: 10.w,),
          Expanded(child: Text(fileName,style: getSemiBoldStyle(fontSize: 13.sp, color: ColorManager.textColor,height: 2.h),)),
          SizedBox(width: 10.w,),
          InkWell(
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            onTap: (){
              setState(() {
                _files.removeAt(index);
                _filesNames.removeAt(index);
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Image.asset(IconAssets.delete,width: 15.w,height: 15.w,),
            ),
          )
        ],
      ),
    );
  }

  void _pickMultipleFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
      );

      if (result != null) {
        _filesNames.addAll(result.files.map((file) => file.name).toList());
        _files.addAll(result.files.map((file) => file.path!).toList());
        setState(() {});
      } else {
        return null;
      }
    } catch (e) {
    if(mounted)  AppFunctions.showsToast("Error picking files: $e", ColorManager.red, context);
      return null;
    }
  }
}
