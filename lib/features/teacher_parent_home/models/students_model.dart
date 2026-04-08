import 'package:equatable/equatable.dart';

class StudentsModel extends Equatable {
  const StudentsModel({
    required this.code,
    required this.message,
    required this.data,
    required this.pagination,
  });

  final int? code;
  final String? message;
  final List<StudentModel> data;
  final StudentsPaginationModel? pagination;

  StudentsModel copyWith({
    int? code,
    String? message,
    List<StudentModel>? data,
    StudentsPaginationModel? pagination,
  }) {
    return StudentsModel(
      code: code ?? this.code,
      message: message ?? this.message,
      data: data ?? this.data,
      pagination: pagination ?? this.pagination,
    );
  }

  factory StudentsModel.fromJson(Map<String, dynamic> json){
    return StudentsModel(
      code: json["code"],
      message: json["message"],
      data: json["data"] == null ? [] : List<StudentModel>.from(json["data"]!.map((x) => StudentModel.fromJson(x))),
      pagination: json["pagination"] == null ? null : StudentsPaginationModel.fromJson(json["pagination"]),
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

class StudentModel extends Equatable {
  const StudentModel({
    required this.id,
    required this.studentId,
    required this.image,
    required this.name,
    required this.birthDate,
    required this.code,
    required this.email,
    required this.phone,
    required this.userType,
    required this.stage,
    required this.stageName,
    required this.grade,
    required this.gradeName,
  });

  final int? id;
  final int? studentId;
  final String? image;
  final String? name;
  final dynamic birthDate;
  final String? code;
  final String? email;
  final String? phone;
  final String? userType;
  final int? stage;
  final String? stageName;
  final int? grade;
  final String? gradeName;

  StudentModel copyWith({
    int? id,
    int? studentId,
    String? image,
    String? name,
    dynamic birthDate,
    String? code,
    String? email,
    String? phone,
    String? userType,
    int? stage,
    String? stageName,
    int? grade,
    String? gradeName,
  }) {
    return StudentModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      image: image ?? this.image,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      code: code ?? this.code,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      userType: userType ?? this.userType,
      stage: stage ?? this.stage,
      stageName: stageName ?? this.stageName,
      grade: grade ?? this.grade,
      gradeName: gradeName ?? this.gradeName,
    );
  }

  factory StudentModel.fromJson(Map<String, dynamic> json){
    return StudentModel(
      id: json["id"],
      studentId: json["student_id"],
      image: json["image"],
      name: json["name"],
      birthDate: json["birth_date"],
      code: json["code"],
      email: json["email"],
      phone: json["phone"],
      userType: json["user_type"],
      stage: json["stage"],
      stageName: json["stageName"],
      grade: json["grade"],
      gradeName: json["gradeName"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "student_id": studentId,
    "image": image,
    "name": name,
    "birth_date": birthDate,
    "code": code,
    "email": email,
    "phone": phone,
    "user_type": userType,
    "stage": stage,
    "stageName": stageName,
    "grade": grade,
    "gradeName": gradeName,
  };

  @override
  List<Object?> get props => [id, studentId, image, name, birthDate, code, email, phone, userType, stage, stageName, grade, gradeName, ];
}

class StudentsPaginationModel extends Equatable {
  const StudentsPaginationModel({
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
  });

  final int? total;
  final int? currentPage;
  final int? lastPage;
  final int? perPage;

  StudentsPaginationModel copyWith({
    int? total,
    int? currentPage,
    int? lastPage,
    int? perPage,
  }) {
    return StudentsPaginationModel(
      total: total ?? this.total,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      perPage: perPage ?? this.perPage,
    );
  }

  factory StudentsPaginationModel.fromJson(Map<String, dynamic> json){
    return StudentsPaginationModel(
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
