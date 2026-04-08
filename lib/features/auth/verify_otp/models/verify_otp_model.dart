import 'package:equatable/equatable.dart';

class VerifyOtpModel extends Equatable {
  const VerifyOtpModel({
    required this.code,
    required this.message,
    required this.data,
  });

  final int? code;
  final String? message;
  final VerifyCodeDataModel? data;

  VerifyOtpModel copyWith({
    int? code,
    String? message,
    VerifyCodeDataModel? data,
  }) {
    return VerifyOtpModel(
      code: code ?? this.code,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory VerifyOtpModel.fromJson(Map<String, dynamic> json){
    return VerifyOtpModel(
      code: json["code"],
      message: json["message"],
      data: json["data"] == null ? null : VerifyCodeDataModel.fromJson(json["data"]),
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

class VerifyCodeDataModel extends Equatable {
  const VerifyCodeDataModel({
    required this.user,
    required this.token,
  });

  final UserModel? user;
  final String? token;

  VerifyCodeDataModel copyWith({
    UserModel? user,
    String? token,
  }) {
    return VerifyCodeDataModel(
      user: user ?? this.user,
      token: token ?? this.token,
    );
  }

  factory VerifyCodeDataModel.fromJson(Map<String, dynamic> json){
    return VerifyCodeDataModel(
      user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
      token: json["token"],
    );
  }

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "token": token,
  };

  @override
  List<Object?> get props => [
    user, token, ];
}

class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
    required this.stage,
    required this.grade,
    required this.code,
    required this.image,
    required this.isAppleReview,
  });

  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? userType;
  final int? stage;
  final int? grade;
  final String? code;
  final String? image;
  final int? isAppleReview;

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? userType,
    int? stage,
    int? grade,
    String? code,
    String? image,
    int? isAppleReview,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      userType: userType ?? this.userType,
      stage: stage ?? this.stage,
      grade: grade ?? this.grade,
      code: code ?? this.code,
      image: image ?? this.image,
      isAppleReview: isAppleReview ?? this.isAppleReview,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      phone: json["phone"],
      userType: json["user_type"],
      stage: json["stage"],
      grade: json["grade"],
      code: json["code"],
      image: json["image"],
      isAppleReview: json["is_apple_review"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "user_type": userType,
    "stage": stage,
    "grade": grade,
    "code": code,
    "image": image,
    "is_apple_review": isAppleReview,
  };

  @override
  List<Object?> get props => [
    name, email, phone, userType, stage, grade, code, image, isAppleReview];
}
