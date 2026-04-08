import 'package:equatable/equatable.dart';

class PrivacyPolicyModel extends Equatable {
  const PrivacyPolicyModel({
    required this.code,
    required this.message,
    required this.data,
  });

  final int? code;
  final String? message;
  final Data? data;

  PrivacyPolicyModel copyWith({
    int? code,
    String? message,
    Data? data,
  }) {
    return PrivacyPolicyModel(
      code: code ?? this.code,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory PrivacyPolicyModel.fromJson(Map<String, dynamic> json){
    return PrivacyPolicyModel(
      code: json["code"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
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

class Data extends Equatable {
  const Data({
    required this.banner,
    required this.title,
    required this.description,
    required this.image,
    required this.updatedAt,
  });

  final String? banner;
  final String? title;
  final String? description;
  final String? image;
  final String? updatedAt;

  Data copyWith({
    String? banner,
    String? title,
    String? description,
    String? image,
    String? updatedAt,
  }) {
    return Data(
      banner: banner ?? this.banner,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      banner: json["banner"],
      title: json["title"],
      description: json["description"],
      image: json["image"],
      updatedAt: json["updated_at"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "banner": banner,
    "title": title,
    "description": description,
    "image": image,
    "updated_at": updatedAt,
  };

  @override
  List<Object?> get props => [
    banner, title, description, image, updatedAt, ];
}
