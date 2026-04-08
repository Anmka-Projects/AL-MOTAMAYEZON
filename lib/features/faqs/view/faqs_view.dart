import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:elmotamizon/common/widgets/custom_pull_to_request.dart';
import 'package:elmotamizon/common/widgets/default_app_bar.dart';
import 'package:elmotamizon/common/widgets/default_expansion_tile.dart';
import 'package:elmotamizon/features/faqs/cubit/faqs_cubit.dart';
import 'package:elmotamizon/features/faqs/models/faqs_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FaqsView extends StatefulWidget {
  const FaqsView({super.key});

  @override
  State<FaqsView> createState() => _FaqsViewState();
}

class _FaqsViewState extends State<FaqsView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => instance<FaqsCubit>()..loadFirstMyFaqsPage(),
  child: Scaffold(
      appBar: DefaultAppBar(text: AppStrings.faqs.tr(),),
      body: BlocBuilder<FaqsCubit, BaseState<FaqModel>>(
  builder: (context, state) {
    if(state.status == Status.loading){
      return const Center(child: CircularProgressIndicator(),);
    }
    if(state.status == Status.failure){
      return Center(child: Text(state.errorMessage ?? ''),);
    }
    return PullToRefresh(
      enableRefresh: false,
      enableLoadMore: true,
      onLoadMore: () => context.read<FaqsCubit>().loadMoreMyFaqsPage(),
      builder: (controller) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          children: [
            // Row(
            //   children: [
            //     Text("${AppStrings.lastUpdated.tr()}: 2023-01-01",style: getSemiBoldStyle(fontSize: 12.sp, color: ColorManager.blackText),),
            //     SizedBox(width: 10.w,),
            //     SvgPicture.asset(IconAssets.lastUpdate,height: 15.w,width: 15.w,),
            //   ],
            // ),
            SizedBox(height: 15.h,),
            Column(
              children: List.generate(state.items.length, (index) => _faq(state.items[index],index),),
            )
          ],
        ),
      );
    },);
  },
),
    ),
);
  }

  _faq(FaqModel faq,int index){
    return Padding(
      padding: EdgeInsets.only(bottom: 5.h),
      child: DefaultExpansionTile(
        initiallyExpanded: index == 0,
          name: faq.question??'',
        backgroundColor: ColorManager.bg,
        textColor: ColorManager.blackText,
        iconColor: ColorManager.blackText,
        radius: 15.r,
        optionsWidget: [
          Padding(
            padding: EdgeInsets.fromLTRB(15.w,5.h,15.w,10.h),
            child: Text(faq.answer??'',style: getMediumStyle(fontSize: 13.sp, color: ColorManager.blackText),),
          ),
        ],
      ),
    );
  }
}
