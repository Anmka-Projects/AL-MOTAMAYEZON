import 'package:equatable/equatable.dart';

class ExamDetailsModel extends Equatable {
  const ExamDetailsModel({
    required this.code,
    required this.message,
    required this.data,
  });

  final int? code;
  final String? message;
  final ExamModel? data;

  ExamDetailsModel copyWith({
    int? code,
    String? message,
    ExamModel? data,
  }) {
    return ExamDetailsModel(
      code: code ?? this.code,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory ExamDetailsModel.fromJson(Map<String, dynamic> json){
    return ExamDetailsModel(
      code: json["code"],
      message: json["message"],
      data: json["data"] == null ? null : ExamModel.fromJson(json["data"]),
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

class ExamModel extends Equatable {
  const ExamModel({
    required this.id,
    required this.lessonName,
    required this.name,
    required this.nameAr,
    required this.nameEn,
    required this.image,
    required this.duration,
    required this.status,
    required this.questions,
    required this.createdAt,
    required this.counts,
    required this.description,
    required this.isAdminCreated,
    required this.studentSubmission,
  });

  final int? id;
  final String? lessonName;
  final String? name;
  final String? nameAr;
  final String? nameEn;
  final String? image;
  final int? duration;
  final int? status;
  final List<QuestionModel>? questions;
  final String? createdAt;
  final int? counts;
  final String? description;
  final int? isAdminCreated;
  final ExamSubmissionModel? studentSubmission;

  ExamModel copyWith({
    int? id,
    String? lessonName,
    String? name,
    String? nameAr,
    String? nameEn,
    String? image,
    int? duration,
    int? status,
    List<QuestionModel>? questions,
    String? createdAt,
    int? counts,
    String? description,
    int? isAdminCreated,
    ExamSubmissionModel? studentSubmission,
  }) {
    return ExamModel(
      id: id ?? this.id,
      lessonName: lessonName ?? this.lessonName,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      image: image ?? this.image,
      duration: duration ?? this.duration,
      status: status ?? this.status,
      questions: questions ?? this.questions,
      createdAt: createdAt ?? this.createdAt,
      counts: counts ?? this.counts,
      description: description ?? this.description,
      isAdminCreated: isAdminCreated ?? this.isAdminCreated,
      studentSubmission: studentSubmission ?? this.studentSubmission,
    );
  }

  factory ExamModel.fromJson(Map<String, dynamic> json){
    return ExamModel(
      id: json["id"],
      lessonName: json["lessonName"],
      name: json["name"],
      nameAr: json["name_ar"],
      nameEn: json["name_en"],
      image: json["image"],
      duration: json["duration"],
      status: json["status"],
      questions: json["questions"] == null ? [] : List<QuestionModel>.from(json["questions"]!.map((x) => QuestionModel.fromJson(x))),
      createdAt: json["created_at"] ?? "",
      counts: json["counts"] ?? 0,
      description: json["description"] ?? '',
      isAdminCreated: json["is_admin_created"] ?? 0,
      studentSubmission: json["student_submission"] == null ? null : ExamSubmissionModel.fromJson(json["student_submission"]!),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "lessonName": lessonName,
    "name": name,
    "name_ar": nameAr,
    "name_en": nameEn,
    "image": image,
    "duration": duration,
    "status": status,
    "questions": questions?.map((x) => x.toJson()).toList(),
    "created_at": createdAt,
    "counts": counts,
    "description": description,
    "is_admin_created": isAdminCreated,
    "student_submission": studentSubmission?.toJson(),
  };

  @override
  List<Object?> get props => [id, lessonName, name, image, duration, status, questions, createdAt, counts, description, studentSubmission];
}

class QuestionModel extends Equatable {
  QuestionModel({
    required this.id,
    required this.title,
    required this.answers,
    this.image,
  });

  final int? id;
  String? title;
  final List<AnswerModel>? answers;
  String? image;

  QuestionModel copyWith({
    int? id,
    String? title,
    List<AnswerModel>? answers,
    String? image,
  }) {
    return QuestionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      answers: answers ?? this.answers,
      image: image ?? this.image,
    );
  }

  factory QuestionModel.fromJson(Map<String, dynamic> json){
    return QuestionModel(
      id: json["id"],
      title: json["title"],
      answers: json["answers"] == null ? [] : List<AnswerModel>.from(json["answers"]!.map((x) => AnswerModel.fromJson(x))),
      image: json["image"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "answers": answers?.map((x) => x.toJson()).toList(),
    "image": image,
  };

  @override
  List<Object?> get props => [
    id, title, answers,
    image,
  ];
}

class AnswerModel extends Equatable {
   AnswerModel({
    required this.id,
    required this.answerText,
    required this.isCorrect,
  });

  final int? id;
  String? answerText;
  int? isCorrect;

  AnswerModel copyWith({
    int? id,
    String? answerText,
    int? isCorrect,
  }) {
    return AnswerModel(
      id: id ?? this.id,
      answerText: answerText ?? this.answerText,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

  factory AnswerModel.fromJson(Map<String, dynamic> json){
    return AnswerModel(
      id: json["id"],
      answerText: json["answer_text"],
      isCorrect: json["is_correct"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "answer_text": answerText,
    "is_correct": isCorrect,
  };

  @override
  List<Object?> get props => [
    id, answerText, isCorrect, ];
}

class ExamSubmissionModel extends Equatable {
  const ExamSubmissionModel({
    required this.id,
    required this.duration,
    required this.score,
    required this.submittedAt,
  });

  final int? id;
  final String? duration;
  final String? score;
  final String? submittedAt;

  ExamSubmissionModel copyWith({
    int? id,
    String? duration,
    String? score,
    String? submittedAt,
  }) {
    return ExamSubmissionModel(
      id: id ?? this.id,
      score: score ?? this.score,
      duration: duration ?? this.duration,
      submittedAt: submittedAt ?? this.submittedAt,
    );
  }

  factory ExamSubmissionModel.fromJson(Map<String, dynamic> json){
    return ExamSubmissionModel(
      id: json["id"],
      duration: json["duration"],
      score: json["score"],
      submittedAt: json["submitted_at"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "duration": duration,
    "score": score,
    "submitted_at": submittedAt,
  };

  @override
  List<Object?> get props => [
    id, duration, score, submittedAt, ];
}
