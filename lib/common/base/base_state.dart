import 'exports.dart';

enum Status { initial, loading, success, failure, isLoadingMore,custom }

extension BaseStateX<T> on BaseState<T> {
  bool get isInitial => status == Status.initial;

  bool get isLoading => status == Status.loading;

  bool get isSuccess => status == Status.success;

  bool get isFailure => status == Status.failure;

  bool get isLoadingMore => status == Status.isLoadingMore;

  bool get isCustom => status == Status.custom;

  bool get isEmpty => isSuccess && items.isEmpty;

  bool get hasData => data != null;
}

class BaseState<T> extends Equatable {
  final Status status;
  final String? errorMessage;
  final T? data;
  final List<T> items;
  final Map<String, dynamic> metadata;
  final Failure? failure;
  const BaseState({
    this.status = Status.initial,
    this.failure,
    this.errorMessage,
    this.data,
    this.items = const [],
    this.metadata = const {},
  });

  BaseState<T> copyWith({
    Status? status,
    String? errorMessage,
    Failure? failure,
    T? data,
    List<T>? items,
    Map<String, dynamic>? metadata,
  }) {
    return BaseState<T>(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      errorMessage: errorMessage ?? this.errorMessage,
      data: data ?? this.data,
      items: items ?? this.items,
      metadata: metadata ?? this.metadata, // Copy metadata
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, data, items, metadata,failure];
}