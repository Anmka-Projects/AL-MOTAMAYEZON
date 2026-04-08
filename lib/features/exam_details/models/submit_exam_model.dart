import 'package:equatable/equatable.dart';

class SubmitExamModel extends Equatable {
  const SubmitExamModel({
    required this.code,
    required this.message,
    required this.data,
  });

  final int? code;
  final String? message;
  final ExamResultModel? data;

  SubmitExamModel copyWith({
    int? code,
    String? message,
    ExamResultModel? data,
  }) {
    return SubmitExamModel(
      code: code ?? this.code,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory SubmitExamModel.fromJson(Map<String, dynamic> json){
    return SubmitExamModel(
      code: json["code"],
      message: json["message"],
      data: json["data"] == null ? null : ExamResultModel.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data?.toJson(),
  };

  @override
  List<Object?> get props => [
    code, message, data, ];
}

class ExamResultModel extends Equatable {
  const ExamResultModel({
    required this.score,
    required this.totalQuestions,
    required this.percentage,
  });

  final int? score;
  final int? totalQuestions;
  final double? percentage;

  ExamResultModel copyWith({
    int? score,
    int? totalQuestions,
    double? percentage,
  }) {
    return ExamResultModel(
      score: score ?? this.score,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      percentage: percentage ?? this.percentage,
    );
  }

  factory ExamResultModel.fromJson(Map<String, dynamic> json){
    return ExamResultModel(
      score: json["score"],
      totalQuestions: json["total_questions"],
      percentage: json["percentage"].toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    "score": score,
    "total_questions": totalQuestions,
    "percentage": percentage,
  };

  @override
  List<Object?> get props => [
    score, totalQuestions, percentage, ];
}
