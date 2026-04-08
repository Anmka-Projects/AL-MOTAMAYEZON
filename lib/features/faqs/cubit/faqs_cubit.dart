import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/http/pagination_helper.dart';
import 'package:elmotamizon/common/http/params.dart';
import 'package:elmotamizon/features/faqs/data_source/faqs_data_source.dart';
import 'package:elmotamizon/features/faqs/models/faqs_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FaqsCubit extends Cubit<BaseState<FaqModel>> {
  FaqsCubit(this._faqsDataSource)
      : super(const BaseState<FaqModel>()) {
    _paginationHandler = PaginationHandler<FaqModel, FaqsCubit>(
      bloc: this,
      pageSize: 10,
    );
  }

  final FaqsDataSource _faqsDataSource;
  late final PaginationHandler<FaqModel, FaqsCubit> _paginationHandler;

  Future<void> loadFirstMyFaqsPage() async {
    await _paginationHandler.loadFirstPage(
          (page, limit, [params]) => _faqsDataSource
          .faqs(PaginationParams(page: page, limit: limit)),
    );
  }

  Future<void> loadMoreMyFaqsPage() async {
    await _paginationHandler.fetchData(
          (page, limit, [params]) => _faqsDataSource
          .faqs(PaginationParams(page: page, limit: limit)),
    );
  }
}
