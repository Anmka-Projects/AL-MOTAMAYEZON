import 'package:equatable/equatable.dart';

class MyTeachersModel extends Equatable {
  const MyTeachersModel({
    required this.code,
    required this.message,
    required this.data,
    required this.pagination,
  });

  final int? code;
  final String? message;
  final List<TeacherModel> data;
  final MyTeachersPaginationModel? pagination;

  MyTeachersModel copyWith({
    int? code,
    String? message,
    List<TeacherModel>? data,
    MyTeachersPaginationModel? pagination,
  }) {
    return MyTeachersModel(
      code: code ?? this.code,
      message: message ?? this.message,
      data: data ?? this.data,
      pagination: pagination ?? this.pagination,
    );
  }

  factory MyTeachersModel.fromJson(Map<String, dynamic> json) {
    return MyTeachersModel(
      code: json["code"],
      message: json["message"],
      data: json["data"] == null
          ? []
          : List<TeacherModel>.from(
              json["data"]!.map((x) => TeacherModel.fromJson(x))),
      pagination: json["pagination"] == null
          ? null
          : MyTeachersPaginationModel.fromJson(json["pagination"]),
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
        code,
        message,
        data,
        pagination,
      ];
}

class TeacherModel extends Equatable {
  TeacherModel({
    required this.id,
    required this.teacherId,
    required this.image,
    required this.name,
    required this.email,
    required this.phone,
    required this.birthDate,
    required this.bio,
    required this.qualification,
    required this.price,
    required this.createdAt,
    required this.isSubscribed,
  });

  final int? id;
  final int? teacherId;
  final String? image;
  final String? name;
  final String? email;
  final String? phone;
  final String? birthDate;
  final String? bio;
  final String? qualification;
  final int? price;
  final String? createdAt;
  int? isSubscribed;

  TeacherModel copyWith({
    int? id,
    int? teacherId,
    String? image,
    String? name,
    String? email,
    String? phone,
    String? birthDate,
    String? bio,
    String? qualification,
    int? price,
    String? createdAt,
    int? isSubscribed,
  }) {
    return TeacherModel(
      id: id ?? this.id,
      teacherId: teacherId ?? this.teacherId,
      image: image ?? this.image,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      birthDate: birthDate ?? this.birthDate,
      bio: bio ?? this.bio,
      qualification: qualification ?? this.qualification,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
      isSubscribed: isSubscribed ?? this.isSubscribed,
    );
  }

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: json["id"],
      teacherId: json["teacher_id"],
      image: json["image"],
      name: json["name"],
      email: json["email"],
      phone: json["phone"],
      birthDate: json["birth_date"],
      bio: json["bio"],
      qualification: json["qualification"],
      price: json["price"],
      createdAt: json["created_at"] ?? "",
      isSubscribed: json["is_subscribed"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "teacher_id": teacherId,
        "image": image,
        "name": name,
        "email": email,
        "phone": phone,
        "birth_date": birthDate,
        "bio": bio,
        "qualification": qualification,
        "price": price,
        "created_at": createdAt,
        "is_subscribed": isSubscribed,
      };

  @override
  List<Object?> get props => [
        id,
        teacherId,
        image,
        name,
        email,
        phone,
        birthDate,
        bio,
        qualification,
        price,
        createdAt,
        isSubscribed
      ];
}

class MyTeachersPaginationModel extends Equatable {
  const MyTeachersPaginationModel({
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.perPage,
  });

  final int? currentPage;
  final int? lastPage;
  final int? total;
  final int? perPage;

  MyTeachersPaginationModel copyWith({
    int? currentPage,
    int? lastPage,
    int? total,
    int? perPage,
  }) {
    return MyTeachersPaginationModel(
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      total: total ?? this.total,
      perPage: perPage ?? this.perPage,
    );
  }

  factory MyTeachersPaginationModel.fromJson(Map<String, dynamic> json) {
    return MyTeachersPaginationModel(
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
        currentPage,
        lastPage,
        total,
        perPage,
      ];
}
