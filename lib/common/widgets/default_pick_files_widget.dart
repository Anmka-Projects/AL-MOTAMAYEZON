import 'dart:io';

import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/common/resources/assets_manager.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:elmotamizon/common/widgets/default_button_widget.dart';
import 'package:elmotamizon/common/widgets/default_image_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DefaultPickFilesWidget<T> extends StatefulWidget {
  final bool isSingle;
  final bool imagesOnly;
  final Function(List<String> filesPaths, List<String> filesNames)? onPicked;
  final Function(int index)? onRemoveLocal;
  final Function(int index)? onRemoveRemote;
  final String title;
  final bool clear;
  final List<String>? remoteFiles;
  final List<String>? localFiles;
  final List<String>? localFilesNames;

  const DefaultPickFilesWidget({
    super.key,
    this.isSingle = false,
    this.onPicked,
    this.title = '',
    this.imagesOnly = false,
    this.clear = false,
    this.onRemoveLocal,
    this.remoteFiles,
    this.onRemoveRemote,
    this.localFiles,
    this.localFilesNames,
  });

  @override
  State<DefaultPickFilesWidget> createState() => _DefaultPickFilesWidgetState();
}

class _DefaultPickFilesWidgetState extends State<DefaultPickFilesWidget> {
  List<String> _files = [];
  List<String> _filesNames = [];

  @override
  Widget build(BuildContext context) {
    if (widget.localFiles != null) {
      _files = widget.localFiles!;
      _filesNames = widget.localFilesNames!;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title.isNotEmpty)
          Text(
            widget.title,
            style:
                getMediumStyle(fontSize: 13.sp, color: ColorManager.textColor),
          ),
        if (widget.title.isNotEmpty)
          SizedBox(
            height: 5.h,
          ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: ColorManager.white,
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
              ),
              SizedBox(
                width: 10.w,
              ),
              Flexible(
                child: Text(
                  _files.isEmpty && (widget.remoteFiles ?? []).isEmpty
                      ? AppStrings.noFileSelected.tr()
                      : _filesNames.isNotEmpty && widget.isSingle
                          ? _filesNames[0]
                          : '',
                  style: getSemiBoldStyle(
                      fontSize: 13.sp, color: ColorManager.blackText),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
            ],
          ),
        ),
        if (widget.imagesOnly &&
            widget.isSingle &&
            (_files.isNotEmpty || (widget.remoteFiles ?? []).isNotEmpty))
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: _files.isNotEmpty
                ? Image.file(
                    File(_files.first),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: MediaQuery.sizeOf(context).height * .2,
                  )
                : DefaultImageWidget(
                    image: widget.remoteFiles!.first,
                    height: MediaQuery.sizeOf(context).height * .2,
                  ),
          ),
        if (!widget.isSingle)
          SizedBox(
            height: 10.h,
          ),
        if ((widget.remoteFiles ?? []).isNotEmpty && !widget.isSingle)
          _remoteFilesWidget(),
        SizedBox(height: 10.h),
        if (!widget.isSingle) _localFilesWidget(),
      ],
    );
  }

  _localFilesWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        _files.length,
        (index) =>
            _file(fileName: _filesNames[index], index: index, isLocal: true),
      ),
    );
  }

  _remoteFilesWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        widget.remoteFiles?.length ?? 0,
        (index) => _file(
            fileName: (widget.remoteFiles ?? [])[index],
            index: index,
            isLocal: false),
      ),
    );
  }

  _file({
    required String fileName,
    required int index,
    required bool isLocal,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
      child: Row(
        children: [
          SvgPicture.asset(
            IconAssets.file,
            height: 18.h,
            width: 18.w,
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
              child: Text(
            fileName,
            style: getSemiBoldStyle(
                fontSize: 13.sp, color: ColorManager.textColor, height: 2.h),
          )),
          SizedBox(
            width: 10.w,
          ),
          InkWell(
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            onTap: () {
              setState(() {
                if (isLocal) {
                  _files.removeAt(index);
                  _filesNames.removeAt(index);
                  if (widget.onRemoveLocal != null)
                    widget.onRemoveLocal!(index);
                } else {
                  widget.onRemoveRemote!(index);
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Image.asset(
                IconAssets.delete,
                width: 15.w,
                height: 15.w,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _pickMultipleFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: widget.isSingle ? false : true,
        type: widget.imagesOnly ? FileType.image : FileType.any,
      );

      if (result != null) {
        // Enforce max file size (2 MB) for images
        List<PlatformFile> pickedFiles = result.files;
        if (widget.imagesOnly) {
          const int maxBytes = 2048 * 1024; // 2048 KB
          final filtered =
              pickedFiles.where((f) => f.size <= maxBytes).toList();

          if (filtered.length != pickedFiles.length && mounted) {
            AppFunctions.showsToast(
              "Selected image must be smaller than 2 MB",
              ColorManager.red,
              context,
            );
          }

          // If all selected files are too large, abort
          if (filtered.isEmpty) {
            return;
          }

          pickedFiles = filtered;
        }

        if (widget.isSingle) {
          _filesNames.clear();
          _files.clear();
        }
        _filesNames.addAll(pickedFiles.map((file) => file.name).toList());
        _files.addAll(pickedFiles.map((file) => file.path!).toList());
        if (widget.onPicked != null) widget.onPicked!(_files, _filesNames);
        setState(() {});
      } else {
        return null;
      }
    } catch (e) {
      if (mounted) {
        AppFunctions.showsToast(
            "Error picking files: $e", ColorManager.red, context);
      }
      return null;
    }
  }
}
