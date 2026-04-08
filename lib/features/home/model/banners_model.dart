import 'package:equatable/equatable.dart';

class BannersModel extends Equatable {
  const BannersModel({
    required this.code,
    required this.message,
    required this.data,
  });

  final int? code;
  final String? message;
  final List<BannerModel> data;

  BannersModel copyWith({
    int? code,
    String? message,
    List<BannerModel>? data,
  }) {
    return BannersModel(
      code: code ?? this.code,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory BannersModel.fromJson(Map<String, dynamic> json){
    return BannersModel(
      code: json["code"],
      message: json["message"],
      data: json["data"] == null ? [] : List<BannerModel>.from(json["data"]!.map((x) => BannerModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data.map((x) => x.toJson()).toList(),
  };

  @override
  List<Object?> get props => [
    code, message, data, ];
}

class BannerModel extends Equatable {
  const BannerModel({
    required this.banner,
  });

  final String? banner;

  BannerModel copyWith({
    String? banner,
  }) {
    return BannerModel(
      banner: banner ?? this.banner,
    );
  }

  factory BannerModel.fromJson(Map<String, dynamic> json){
    return BannerModel(
      banner: json["banner"],
    );
  }

  Map<String, dynamic> toJson() => {
    "banner": banner,
  };

  @override
  List<Object?> get props => [
    banner, ];
}
