import 'package:equatable/equatable.dart';

class TeacherDetailsModel extends Equatable {
  const TeacherDetailsModel({
    this.code,
    this.message,
    this.data,
  });

  final int? code;
  final String? message;
  final TeacherDataModel? data;

  TeacherDetailsModel copyWith({
    int? code,
    String? message,
    TeacherDataModel? data,
  }) {
    return TeacherDetailsModel(
      code: code ?? this.code,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory TeacherDetailsModel.fromJson(Map<String, dynamic> json) {
    return TeacherDetailsModel(
      code: json["code"],
      message: json["message"],
      data:
          json["data"] == null ? null : TeacherDataModel.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data?.toJson(),
      };

  @override
  List<Object?> get props => [code, message, data];
}

class TeacherDataModel extends Equatable {
  const TeacherDataModel({
    this.id,
    this.image,
    this.name,
    this.birthDate,
    this.email,
    this.phone,
    this.userType,
    this.isAppleReview,
    this.bio,
    this.qualification,
    this.users,
    this.courses,
  });

  final int? id;
  final String? image;
  final String? name;
  final String? birthDate;
  final String? email;
  final String? phone;
  final String? userType;
  final bool? isAppleReview;
  final String? bio;
  final String? qualification;
  final int? users;
  final int? courses;

  TeacherDataModel copyWith({
    int? id,
    String? image,
    String? name,
    String? birthDate,
    String? email,
    String? phone,
    String? userType,
    bool? isAppleReview,
    String? bio,
    String? qualification,
    int? users,
    int? courses,
  }) {
    return TeacherDataModel(
      id: id ?? this.id,
      image: image ?? this.image,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      userType: userType ?? this.userType,
      isAppleReview: isAppleReview ?? this.isAppleReview,
      bio: bio ?? this.bio,
      qualification: qualification ?? this.qualification,
      users: users ?? this.users,
      courses: courses ?? this.courses,
    );
  }

  factory TeacherDataModel.fromJson(Map<String, dynamic> json) {
    return TeacherDataModel(
      id: json["id"],
      image: json["image"],
      name: json["name"],
      birthDate: json["birth_date"],
      email: json["email"],
      phone: json["phone"],
      userType: json["user_type"],
      isAppleReview: json["is_apple_review"],
      bio: json["bio"],
      qualification: json["qualification"],
      users: json["users"],
      courses: json["courses"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
        "birth_date": birthDate,
        "email": email,
        "phone": phone,
        "user_type": userType,
        "is_apple_review": isAppleReview,
        "bio": bio,
        "qualification": qualification,
        "users": users,
        "courses": courses,
      };

  @override
  List<Object?> get props => [
        id,
        image,
        name,
        birthDate,
        email,
        phone,
        userType,
        isAppleReview,
        bio,
        qualification,
        users,
        courses,
      ];
}
