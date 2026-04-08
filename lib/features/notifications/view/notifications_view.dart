import 'package:elmotamizon/app/app_prefs.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:elmotamizon/common/widgets/custom_pull_to_request.dart';
import 'package:elmotamizon/common/widgets/default_app_bar.dart';
import 'package:elmotamizon/common/widgets/default_error_widget.dart';
import 'package:elmotamizon/features/notifications/cubit/notifications_cubit.dart';
import 'package:elmotamizon/features/notifications/models/notifications_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<NotificationsCubit>()..loadFirstNotificationsPage(),
      child: Scaffold(
        appBar: DefaultAppBar(text: AppStrings.notifications.tr(),backgroundColor: ColorManager.primary,titleColor: ColorManager.white,),
        body: BlocBuilder<NotificationsCubit, BaseState<NotificationModel>>(
          builder: (context, state) {
            if (state.status == Status.failure) {
              return DefaultErrorWidget(errorMessage: state.errorMessage ?? '');
            }
            if (state.status == Status.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state.status == Status.success && state.items.isEmpty) {
              return DefaultErrorWidget(errorMessage: AppStrings.noData.tr());
            }

            return PullToRefresh(
              enableRefresh: false,
              enableLoadMore: true,
              onLoadMore: () => context.read<NotificationsCubit>().loadMoreNotificationsPage(),
              builder: (context) {
                return _notifications(state.items);
              }
            );
          },
        ),
      ),
    );
  }

 Widget _notifications(List<NotificationModel> notifications) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
      itemCount: notifications.length,
      separatorBuilder: (context, index) => Divider(height: 20.h,),
      itemBuilder: (context, index) {
        return _notification(notifications[index]);
      },
    );
  }

  _notification(NotificationModel notification) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      decoration: BoxDecoration(
        // color: ColorManager.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  notification.title??'',
                  style: getMediumStyle(fontSize: 13.sp, color: ColorManager.textColor),
                ),
              ),
              Text(
                DateFormat(instance<AppPreferences>().getAppLanguage() == 'en' ? "hh:mm a   dd/MM/yyyy" : "yyyy/MM/dd   hh:mm a", instance<AppPreferences>().getAppLanguage())
                    .format(notification.createdAt??DateTime.now()),
                style: getMediumStyle(
                    fontSize: 13.sp, color: ColorManager.grey),
              ),
            ],
          ),
          SizedBox(height: 5.h,),
          Text(
            notification.body??'',
            style: getBoldStyle(fontSize: 14.sp, color: ColorManager.greyTextColor),
          ),
        ],
      ),
    );
  }
}
