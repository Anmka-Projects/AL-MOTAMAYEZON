import 'package:equatable/equatable.dart';

class SubjectsModel extends Equatable {
  const SubjectsModel({
    required this.code,
    required this.message,
    required this.data,
  });

  final int? code;
  final String? message;
  final List<SubjectModel> data;

  SubjectsModel copyWith({
    int? code,
    String? message,
    List<SubjectModel>? data,
  }) {
    return SubjectsModel(
      code: code ?? this.code,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory SubjectsModel.fromJson(Map<String, dynamic> json){
    return SubjectsModel(
      code: json["code"],
      message: json["message"],
      data: json["data"] == null ? [] : List<SubjectModel>.from(json["data"]!.map((x) => SubjectModel.fromJson(x))),
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

class SubjectModel extends Equatable {
  const SubjectModel({
    required this.id,
    required this.name,
  });

  final int? id;
  final String? name;

  SubjectModel copyWith({
    int? id,
    String? name,
  }) {
    return SubjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  factory SubjectModel.fromJson(Map<String, dynamic> json){
    return SubjectModel(
      id: json["id"],
      name: json["name"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };

  @override
  List<Object?> get props => [
    id, name, ];
}
