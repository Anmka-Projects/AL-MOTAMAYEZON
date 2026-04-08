import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/common/http/endpoints.dart';
import 'package:elmotamizon/common/base/base_model.dart';

abstract class ContactUsDataSource {
  Future<Either<Failure, BaseModel>> contactUs({
    required String name,
    required String phone,
    required String email,
    required String subject,
    required String message,
  });
}

class ContactUsDataSourceImpl implements ContactUsDataSource {
  final ApiConsumer _apiConsumer;
  ContactUsDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, BaseModel>> contactUs({
    required String name,
    required String phone,
    required String email,
    required String subject,
    required String message,
  }) async {
    final result = await _apiConsumer.post(
      Endpoints.contactUs,
      data: {
        'name': name,
        'phone': phone,
        'email': email,
        'subject': subject,
        'message': message,
      },
    );
    return result.fold(
      (l) => Left(l),
      (r) => Right(BaseModel.fromJson(r)),
    );
  }
} 