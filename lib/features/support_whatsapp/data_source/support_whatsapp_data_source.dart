import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/common/http/endpoints.dart';

abstract class SupportWhatsappDataSource {
  Future<Either<Failure, String?>> getWhatsappSupportNumber();
  Future<Either<Failure, void>> sendSupportTicket({
    required int studentId,
    required String message,
  });
}

class SupportWhatsappDataSourceImpl implements SupportWhatsappDataSource {
  final ApiConsumer _apiConsumer;
  SupportWhatsappDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, String?>> getWhatsappSupportNumber() async {
    final result = await _apiConsumer.get(Endpoints.supportWhatsappNumber);
    return result.fold(
      (l) => Left(l),
      (r) {
        final data = r['data'] as Map<String, dynamic>?;
        final number = data?['whatsapp_support_number'] as String?;
        return Right(number);
      },
    );
  }

  @override
  Future<Either<Failure, void>> sendSupportTicket({
    required int studentId,
    required String message,
  }) async {
    final result = await _apiConsumer.post(
      Endpoints.supportWhatsapp,
      data: {
        'student_id': studentId,
        'message': message,
      },
    );
    return result.fold(
      (l) => Left(l),
      (r) => Right(null),
    );
  }
}
