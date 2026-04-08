import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/http/pagination_helper.dart';
import 'package:elmotamizon/common/http/params.dart';
import 'package:elmotamizon/features/home/details/data_source/books_data_source.dart';
import 'package:elmotamizon/features/home/details/models/book_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BooksCubit extends Cubit<BaseState<BookModel>> {
  BooksCubit(this._coursesDataSource) : super(const BaseState<BookModel>()) {
    _paginationHandler = PaginationHandler<BookModel, BooksCubit>(
      bloc: this,
      pageSize: 10,
    );
  }

  final BooksDataSource _coursesDataSource;
  late final PaginationHandler<BookModel, BooksCubit> _paginationHandler;

  Future<void> loadFirstBooksPage(int courseId) async {
    await _paginationHandler.loadFirstPage(
      (page, limit, [params]) => _coursesDataSource.getBooks(
          PaginationParams(page: page, limit: limit), courseId),
    );
  }

  Future<void> loadMoreBooksPage(int courseId) async {
    await _paginationHandler.fetchData(
      (page, limit, [params]) => _coursesDataSource.getBooks(
          PaginationParams(page: page, limit: limit), courseId),
    );
  }

  int get pageSize => _paginationHandler.pageSize;
  bool get hasMore => _paginationHandler.hasMoreData;
}
