import 'package:elmotamizon/app/app_prefs.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/features/support_whatsapp/data_source/support_whatsapp_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'support_whatsapp_state.dart';

class SupportWhatsappCubit extends Cubit<SupportWhatsappState> {
  SupportWhatsappCubit(this._dataSource) : super(const SupportWhatsappState());
  final SupportWhatsappDataSource _dataSource;

  Future<void> loadWhatsappNumber() async {
    emit(state.copyWith(status: Status.loading, errorMessage: null));
    final result = await _dataSource.getWhatsappSupportNumber();
    result.fold(
      (failure) => emit(state.copyWith(
        status: Status.failure,
        errorMessage: failure.message,
        failure: failure,
      )),
      (number) => emit(state.copyWith(
        status: Status.success,
        whatsappNumber: number,
      )),
    );
  }

  Future<void> sendTicket({required String message}) async {
    emit(state.copyWith(status: Status.loading, errorMessage: null));
    final result = await _dataSource.sendSupportTicket(
      studentId: instance<AppPreferences>().getUserId(),
      message: message,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        status: Status.failure,
        errorMessage: failure.message,
        failure: failure,
      )),
      (_) => emit(state.copyWith(
        status: Status.success,
        successMessage: 'Ticket sent via WhatsApp.',
      )),
    );
  }
}
