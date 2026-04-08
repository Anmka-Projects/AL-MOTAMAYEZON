import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:elmotamizon/features/on_boarding/model/on_boarding_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBoardingWidget extends StatefulWidget {
  final OnBoardingItemModel item;
  const OnBoardingWidget({super.key, required this.item});

  @override
  State<OnBoardingWidget> createState() => _OnBoardingWidgetState();
}

class _OnBoardingWidgetState extends State<OnBoardingWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
          Expanded(
            flex: 4,
            child: Image.network(
              widget.item.image??'',
            ),
          ),

        Expanded(

          child: Column(
            children: [
              Text(
                widget.item.title??'',
                style: getBoldStyle(fontSize: 16.sp, color: ColorManager.textColor),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                widget.item.description??'',
                style: getMediumStyle(fontSize: 13.sp, color: ColorManager.greyTextColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
