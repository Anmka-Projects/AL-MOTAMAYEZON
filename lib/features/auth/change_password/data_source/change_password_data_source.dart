
import 'package:elmotamizon/common/base/exports.dart';

abstract class ChangePasswordDataSource {
  Future<Either<Failure, void>> changePassword(
      String oldPassword, String newPassword);
}

class ChangePasswordDataSourceImpl implements ChangePasswordDataSource {
  final GenericDataSource _genericDataSource;

  ChangePasswordDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, void>> changePassword(
      String oldPassword, String newPassword) async {
    return _genericDataSource.postData<void>(
      endpoint: Endpoints.changePassword,
      data: {
        "old_password": oldPassword,
        "new_password": newPassword,
      },
    );
  }
}