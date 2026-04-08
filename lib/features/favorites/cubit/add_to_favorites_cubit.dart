import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/features/favorites/data_source/add_to_favorites_data_source.dart';

class AddToFavoritesCubit extends Cubit<BaseState<void>> {
  AddToFavoritesCubit(this.addToFavoritesDataSource) : super(const BaseState());
  final AddToFavoritesDataSource addToFavoritesDataSource;

  Future<void> addToFavorites({required String type, required int id}) async {
    emit(state.copyWith(status: Status.loading));
    final result =
        await addToFavoritesDataSource.addToFavorites(id: id, type: type);
    result.fold(
      (error) => emit(state.copyWith(
        status: Status.failure,
        errorMessage: error.message,
        failure: error,
      )),
      (success) => emit(state.copyWith(
        status: Status.success,
        // data: success,
      )),
    );
  }
}
