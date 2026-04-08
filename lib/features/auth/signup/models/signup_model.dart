import 'package:equatable/equatable.dart';

class SignupModel extends Equatable {
  const SignupModel({
    required this.code,
    required this.message,
    required this.data,
  });

  final int? code;
  final String? message;
  final SignupDataModel? data;

  SignupModel copyWith({
    int? code,
    String? message,
    SignupDataModel? data,
  }) {
    return SignupModel(
      code: code ?? this.code,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory SignupModel.fromJson(Map<String, dynamic> json){
    return SignupModel(
      code: json["code"],
      message: json["message"],
      data: json["data"] == null ? null : SignupDataModel.fromJson(json["data"]),
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

class SignupDataModel extends Equatable {
  const SignupDataModel({
    required this.phone,
  });

  final String? phone;

  SignupDataModel copyWith({
    String? phone,
  }) {
    return SignupDataModel(
      phone: phone ?? this.phone,
    );
  }

  factory SignupDataModel.fromJson(Map<String, dynamic> json){
    return SignupDataModel(
      phone: json["phone"],
    );
  }

  Map<String, dynamic> toJson() => {
    "phone": phone,
  };

  @override
  List<Object?> get props => [phone];
}
