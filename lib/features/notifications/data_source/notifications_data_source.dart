import 'dart:developer';

import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/common/http/params.dart';
import 'package:elmotamizon/features/notifications/models/notifications_model.dart';

abstract class NotificationsDataSource {
  Future<Either<Failure, List<NotificationModel>>> notifications(
      PaginationParams params);
}

class NotificationsDataSourceImpl implements NotificationsDataSource {
  final GenericDataSource _genericDataSource;

  NotificationsDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<NotificationModel>>> notifications(
      PaginationParams params) async {
    try {
      return await _genericDataSource.fetchData<NotificationModel>(
        endpoint: Endpoints.notifications,
        fromJson: NotificationModel.fromJson,
        params: params,
      );
    } catch (e, stackTrace) {
      log("notifications error: ${e.runtimeType} - ${e.toString()}",
          stackTrace: stackTrace);
      return Left(ParsingFailure(message: e.toString()));
    }
  }
}
