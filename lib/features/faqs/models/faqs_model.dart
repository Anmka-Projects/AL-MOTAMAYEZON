import 'package:equatable/equatable.dart';

class FaqsModel extends Equatable {
  const FaqsModel({
    required this.code,
    required this.message,
    required this.data,
    required this.pagination,
  });

  final int? code;
  final String? message;
  final List<FaqModel> data;
  final Pagination? pagination;

  FaqsModel copyWith({
    int? code,
    String? message,
    List<FaqModel>? data,
    Pagination? pagination,
  }) {
    return FaqsModel(
      code: code ?? this.code,
      message: message ?? this.message,
      data: data ?? this.data,
      pagination: pagination ?? this.pagination,
    );
  }

  factory FaqsModel.fromJson(Map<String, dynamic> json){
    return FaqsModel(
      code: json["code"],
      message: json["message"],
      data: json["data"] == null ? [] : List<FaqModel>.from(json["data"]!.map((x) => FaqModel.fromJson(x))),
      pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
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

class FaqModel extends Equatable {
  const FaqModel({
    required this.question,
    required this.answer,
  });

  final String? question;
  final String? answer;

  FaqModel copyWith({
    String? question,
    String? answer,
  }) {
    return FaqModel(
      question: question ?? this.question,
      answer: answer ?? this.answer,
    );
  }

  factory FaqModel.fromJson(Map<String, dynamic> json){
    return FaqModel(
      question: json["question"],
      answer: json["answer"],
    );
  }

  Map<String, dynamic> toJson() => {
    "question": question,
    "answer": answer,
  };

  @override
  List<Object?> get props => [
    question, answer, ];
}

class Pagination extends Equatable {
  const Pagination({
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
  });

  final int? total;
  final int? currentPage;
  final int? lastPage;
  final int? perPage;

  Pagination copyWith({
    int? total,
    int? currentPage,
    int? lastPage,
    int? perPage,
  }) {
    return Pagination(
      total: total ?? this.total,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      perPage: perPage ?? this.perPage,
    );
  }

  factory Pagination.fromJson(Map<String, dynamic> json){
    return Pagination(
      total: json["total"],
      currentPage: json["current_page"],
      lastPage: json["last_page"],
      perPage: json["per_page"],
    );
  }

  Map<String, dynamic> toJson() => {
    "total": total,
    "current_page": currentPage,
    "last_page": lastPage,
    "per_page": perPage,
  };

  @override
  List<Object?> get props => [
    total, currentPage, lastPage, perPage, ];
}
