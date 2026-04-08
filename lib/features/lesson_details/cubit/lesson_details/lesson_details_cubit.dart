import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/features/lesson_details/data_source/lesson_details_data_source.dart';
import 'package:elmotamizon/features/lesson_details/models/lesson_details_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class LessonDetailsCubit extends Cubit<BaseState<LessonDetailsModel>> {
  LessonDetailsCubit(this._courseDetailsDataSource) : super(const BaseState());
  final LessonDetailsDataSource _courseDetailsDataSource;

  Future<void> getLessonDetails(String id) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _courseDetailsDataSource.getLessonDetails(id);
    result.fold(
          (failure) => emit(state.copyWith(status: Status.failure, failure: failure, errorMessage: failure.message)),
          (success) => emit(state.copyWith(status: Status.success, data: success)),
    );
  }

  YoutubePlayerController? controller;

  void initYoutubePlayer({required String videoUrl}) {
    emit(state.copyWith(status: Status.loading));
    controller = YoutubePlayerController(

      initialVideoId: AppFunctions.getYoutubeVideoId(videoUrl) ,


      flags: const YoutubePlayerFlags(
          autoPlay: false,
          hideThumbnail: true,

      ),
    );
    emit(state.copyWith(status: Status.custom));
  }

  @override
  Future<void> close() {
    controller?.dispose();
    return super.close();
  }
}
