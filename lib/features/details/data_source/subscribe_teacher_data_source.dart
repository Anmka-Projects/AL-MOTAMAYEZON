import 'dart:developer';

import 'package:elmotamizon/app/app_prefs.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/exports.dart';

abstract class SubscribeTeacherDataSource {
  Future<Either<Failure, String>> subscribeTeacher({
    required int teacherId,
    bool isBook = false,
  });
}

class SubscribeTeacherDataSourceImpl implements SubscribeTeacherDataSource {
  final ApiConsumer _apiConsumer;

  SubscribeTeacherDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, String>> subscribeTeacher({
    required int teacherId,
    bool isBook = false,
  }) async {
    try{
      final result = await _apiConsumer.post(
          instance<AppPreferences>().getUserIsAppleReview() == 1 && !isBook ? Endpoints.subscribeAppleReviewTeacher(teacherId) : Endpoints.subscribeTeacher,
        data: isBook ? {
            "book_id": teacherId
          } : {
          "course_id": teacherId,
        }
      );
      return result.fold((l) => Left(l), (r){
        final String paymentUrl = _extractPaymentUrl(r);
        if (paymentUrl.isEmpty &&
            !(instance<AppPreferences>().getUserIsAppleReview() == 1 &&
                !isBook)) {
          return Left(
            ServerFailure(
              message: (r['message']?.toString().trim().isNotEmpty ?? false)
                  ? r['message'].toString().trim()
                  : 'Payment link is not available right now',
            ),
          );
        }
        return Right(paymentUrl);
      });
    }catch(e,stackTrace){
      log("$stackTrace login error ${e.toString()}");
      return Left(ServerFailure(message: e.toString()));
    }
  }

  String _extractPaymentUrl(Map<String, dynamic> response) {
    String from(dynamic value) => value?.toString().trim() ?? '';

    final direct = from(response['payment_url']);
    if (direct.isNotEmpty) return direct;

    final data = response['data'];
    if (data is Map<String, dynamic>) {
      final nestedPaymentUrl = from(data['payment_url']);
      if (nestedPaymentUrl.isNotEmpty) return nestedPaymentUrl;

      final nestedUrl = from(data['url']);
      if (nestedUrl.isNotEmpty) return nestedUrl;
    }

    final topLevelUrl = from(response['url']);
    if (topLevelUrl.isNotEmpty) return topLevelUrl;

    return '';
  }
}