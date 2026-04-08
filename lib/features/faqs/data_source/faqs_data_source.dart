import 'dart:developer';

import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/common/http/params.dart';
import 'package:elmotamizon/features/faqs/models/faqs_model.dart';

abstract class FaqsDataSource {
  Future<Either<Failure, List<FaqModel>>> faqs(
      PaginationParams params);
}

class FaqsDataSourceImpl implements FaqsDataSource {
  final GenericDataSource _genericDataSource;

  FaqsDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<FaqModel>>> faqs(
      PaginationParams params) async {
    try {
      return await _genericDataSource.fetchData<FaqModel>(
        endpoint: Endpoints.faqs,
        fromJson: FaqModel.fromJson,
        params: params,
      );
    } catch (e, stackTrace) {
      log("faqs error: ${e.runtimeType} - ${e.toString()}", stackTrace: stackTrace);
      return Left(ParsingFailure(message: e.toString()));
    }
  }
}
