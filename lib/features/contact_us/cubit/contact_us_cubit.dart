import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/features/contact_us/data_source/contact_us_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'contact_us_state.dart';

class ContactUsCubit extends Cubit<ContactUsState> {
  ContactUsCubit(this._contactUsDataSource) : super(const ContactUsState());
  final ContactUsDataSource _contactUsDataSource;

  Future<void> contactUs({
    required String name,
    required String phone,
    required String email,
    required String subject,
    required String message,
  }) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _contactUsDataSource.contactUs(
      name: name,
      phone: phone,
      email: email,
      subject: subject,
      message: message,
    );
    result.fold(
      (failure) => emit(state.copyWith(status: Status.failure, errorMessage: failure.message, failure: failure)),
      (baseModel) => emit(state.copyWith(status: Status.success, message: baseModel.message)),
    );
  }
} 