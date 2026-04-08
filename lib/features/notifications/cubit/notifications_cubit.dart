import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/http/pagination_helper.dart';
import 'package:elmotamizon/common/http/params.dart';
import 'package:elmotamizon/features/faqs/data_source/faqs_data_source.dart';
import 'package:elmotamizon/features/faqs/models/faqs_model.dart';
import 'package:elmotamizon/features/notifications/data_source/notifications_data_source.dart';
import 'package:elmotamizon/features/notifications/models/notifications_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsCubit extends Cubit<BaseState<NotificationModel>> {
  NotificationsCubit(this._notificationsDataSource)
      : super(const BaseState<NotificationModel>()) {
    _paginationHandler = PaginationHandler<NotificationModel, NotificationsCubit>(
      bloc: this,
      pageSize: 10,
    );
  }

  final NotificationsDataSource _notificationsDataSource;
  late final PaginationHandler<NotificationModel, NotificationsCubit> _paginationHandler;

  Future<void> loadFirstNotificationsPage() async {
    await _paginationHandler.loadFirstPage(
          (page, limit, [params]) => _notificationsDataSource
          .notifications(PaginationParams(page: page, limit: limit)),
    );
  }

  Future<void> loadMoreNotificationsPage() async {
    await _paginationHandler.fetchData(
          (page, limit, [params]) => _notificationsDataSource
          .notifications(PaginationParams(page: page, limit: limit)),
    );
  }
}
