import 'dart:developer';

import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/common/http/params.dart';
import 'package:elmotamizon/features/home/details/models/voice_note_model.dart';

abstract class VoiceNoteDataSource {
  Future<Either<Failure, List<VoiceNoteModel>>> getVoiceNote(
      PaginationParams params, int courseId);
}

class VoiceNoteDataSourceImpl implements VoiceNoteDataSource {
  final GenericDataSource _genericDataSource;

  VoiceNoteDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<VoiceNoteModel>>> getVoiceNote(
      PaginationParams params, int courseId) async {
    try {
      return await _genericDataSource.fetchData<VoiceNoteModel>(
        endpoint: Endpoints.voiceNote(courseId),
        fromJson: VoiceNoteModel.fromJson,
        params: params,
      );
    } catch (e, stackTrace) {
      log("VoiceNote error: ${e.runtimeType} - ${e.toString()}",
          stackTrace: stackTrace);
      return Left(ParsingFailure(message: e.toString()));
    }
  }
}
