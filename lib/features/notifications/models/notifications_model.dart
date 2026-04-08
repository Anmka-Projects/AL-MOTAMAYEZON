import 'package:equatable/equatable.dart';

class NotificationsModel extends Equatable {
  const NotificationsModel({
    required this.code,
    required this.message,
    required this.data,
    required this.pagination,
  });

  final int? code;
  final String? message;
  final List<NotificationModel> data;
  final NotificationsPaginationModel? pagination;

  NotificationsModel copyWith({
    int? code,
    String? message,
    List<NotificationModel>? data,
    NotificationsPaginationModel? pagination,
  }) {
    return NotificationsModel(
      code: code ?? this.code,
      message: message ?? this.message,
      data: data ?? this.data,
      pagination: pagination ?? this.pagination,
    );
  }

  factory NotificationsModel.fromJson(Map<String, dynamic> json){
    return NotificationsModel(
      code: json["code"],
      message: json["message"],
      data: json["data"] == null ? [] : List<NotificationModel>.from(json["data"]!.map((x) => NotificationModel.fromJson(x))),
      pagination: json["pagination"] == null ? null : NotificationsPaginationModel.fromJson(json["pagination"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data.map((x) => x.toJson()).toList(),
    "pagination": pagination?.toJson(),
  };

  @override
  List<Object?> get props => [
    code, message, data, pagination, ];
}

class NotificationModel extends Equatable {
  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  final int? id;
  final String? title;
  final String? body;
  final DateTime? createdAt;

  NotificationModel copyWith({
    int? id,
    String? title,
    String? body,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json){
    return NotificationModel(
      id: json["id"],
      title: json["title"],
      body: json["body"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "body": body,
    "created_at": createdAt?.toIso8601String(),
  };

  @override
  List<Object?> get props => [
    id, title, body, createdAt, ];
}

class NotificationsPaginationModel extends Equatable {
  const NotificationsPaginationModel({
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.perPage,
  });

  final int? currentPage;
  final int? lastPage;
  final int? total;
  final int? perPage;

  NotificationsPaginationModel copyWith({
    int? currentPage,
    int? lastPage,
    int? total,
    int? perPage,
  }) {
    return NotificationsPaginationModel(
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      total: total ?? this.total,
      perPage: perPage ?? this.perPage,
    );
  }

  factory NotificationsPaginationModel.fromJson(Map<String, dynamic> json){
    return NotificationsPaginationModel(
      currentPage: json["current_page"],
      lastPage: json["last_page"],
      total: json["total"],
      perPage: json["per_page"],
    );
  }

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "last_page": lastPage,
    "total": total,
    "per_page": perPage,
  };

  @override
  List<Object?> get props => [
    currentPage, lastPage, total, perPage, ];
}
