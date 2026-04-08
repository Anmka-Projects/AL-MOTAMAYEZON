import 'package:equatable/equatable.dart';

class OnBoardingModel extends Equatable {
  const OnBoardingModel({
    required this.code,
    required this.message,
    required this.data,
  });

  final int? code;
  final String? message;
  final List<OnBoardingItemModel> data;

  OnBoardingModel copyWith({
    int? code,
    String? message,
    List<OnBoardingItemModel>? data,
  }) {
    return OnBoardingModel(
      code: code ?? this.code,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory OnBoardingModel.fromJson(Map<String, dynamic> json){
    return OnBoardingModel(
      code: json["code"],
      message: json["message"],
      data: json["data"] == null ? [] : List<OnBoardingItemModel>.from(json["data"]!.map((x) => OnBoardingItemModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data.map((x) => x?.toJson()).toList(),
  };

  @override
  List<Object?> get props => [
    code, message, data, ];
}

class OnBoardingItemModel extends Equatable {
  const OnBoardingItemModel({
    required this.banner,
    required this.title,
    required this.description,
    required this.image,
  });

  final String? banner;
  final String? title;
  final String? description;
  final String? image;

  OnBoardingItemModel copyWith({
    String? banner,
    String? title,
    String? description,
    String? image,
  }) {
    return OnBoardingItemModel(
      banner: banner ?? this.banner,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
    );
  }

  factory OnBoardingItemModel.fromJson(Map<String, dynamic> json){
    return OnBoardingItemModel(
      banner: json["banner"],
      title: json["title"],
      description: json["description"],
      image: json["image"],
    );
  }

  Map<String, dynamic> toJson() => {
    "banner": banner,
    "title": title,
    "description": description,
    "image": image,
  };

  @override
  List<Object?> get props => [
    banner, title, description, image, ];
}
