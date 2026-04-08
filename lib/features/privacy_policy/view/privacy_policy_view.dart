import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/widgets/default_app_bar.dart';
import 'package:elmotamizon/features/privacy_policy/cubit/privacy_policy_cubit.dart';
import 'package:elmotamizon/features/privacy_policy/models/privacy_policy_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_html/flutter_html.dart';

enum InfoType{
  privacyPolicy,
  aboutUs,
  terms
}

class PrivacyPolicyView extends StatefulWidget {
  final InfoType infoType;
  const PrivacyPolicyView({super.key, required this.infoType});

  @override
  State<PrivacyPolicyView> createState() => _PrivacyPolicyViewState();
}

class _PrivacyPolicyViewState extends State<PrivacyPolicyView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      instance<PrivacyPolicyCubit>()
        ..privacyPolicy(type: widget.infoType),
      child: Scaffold(
        appBar: DefaultAppBar(text: widget.infoType == InfoType.aboutUs ? AppStrings.aboutUs.tr() : widget.infoType == InfoType.terms ? AppStrings.terms.tr() : AppStrings.privacyPolicy.tr(),),
        body: BlocBuilder<PrivacyPolicyCubit, BaseState<PrivacyPolicyModel>>(
          builder: (context, state) {
            if(state.status == Status.loading){
              return const Center(child: CircularProgressIndicator(),);
            }
            if(state.status == Status.failure){
              return Center(child: Text(state.errorMessage ?? ''),);
            }
            return ListView(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              children: [
                Html(data: state.data?.data?.description ?? ''),
              ],
            );
          },
        ),
      ),
    );
  }
}
