import 'package:elmotamizon/common/base/exports.dart';

abstract interface class AddToFavoritesDataSource {
  Future<Either<Failure, String>> addToFavorites(
      {required String type, required int id});
}

class AddToFavoritesDataSourceImpl implements AddToFavoritesDataSource {
  final GenericDataSource genericDataSource;

  AddToFavoritesDataSourceImpl({required this.genericDataSource});

  @override
  Future<Either<Failure, String>> addToFavorites(
      {required String type, required int id}) async {
    final result = await genericDataSource.postData(
      endpoint: Endpoints.addToFavorites,
      data: {
        if (type == "course_id") "course_id": id,
        if (type == "book_id") "book_id": id,
      },
    );
    return result.fold(
      (left) => Left(left),
      (right) => Right("Add To Favorites successful"),
    );
  }
}
