import 'package:equatable/equatable.dart';

class StagesGradesModel extends Equatable {
  const StagesGradesModel({
    this.code,
    this.message,
    this.data,
  });

  final int? code;
  final String? message;
  final StagesGradesDataModel? data;

  StagesGradesModel copyWith({
    int? code,
    String? message,
    StagesGradesDataModel? data,
  }) {
    return StagesGradesModel(
      code: code ?? this.code,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory StagesGradesModel.fromJson(Map<String, dynamic> json){
    return StagesGradesModel(
      code: json["code"],
      message: json["message"],
      data: json["data"] == null ? null : StagesGradesDataModel.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data?.toJson(),
  };

  @override
  List<Object?> get props => [code, message, data, ];
}

class StagesGradesDataModel extends Equatable {
  const StagesGradesDataModel({
    this.stages,
  });

  final List<StageModel>? stages;

  StagesGradesDataModel copyWith({
    List<StageModel>? stages,
  }) {
    return StagesGradesDataModel(
      stages: stages ?? this.stages,
    );
  }

  factory StagesGradesDataModel.fromJson(Map<String, dynamic> json){
    return StagesGradesDataModel(
      stages: json["stages"] == null ? [] : List<StageModel>.from(json["stages"]!.map((x) => StageModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "stages": stages?.map((x) => x.toJson()).toList(),
  };

  @override
  List<Object?> get props => [
    stages, ];
}

class StageModel extends Equatable {
  const StageModel({
    this.id,
    this.name,
    this.grades,
  });

  final int? id;
  final String? name;
  final List<GradeModel>? grades;

  StageModel copyWith({
    int? id,
    String? name,
    List<GradeModel>? grades,
  }) {
    return StageModel(
      id: id ?? this.id,
      name: name ?? this.name,
      grades: grades ?? this.grades,
    );
  }

  factory StageModel.fromJson(Map<String, dynamic> json){
    return StageModel(
      id: json["id"],
      name: json["name"],
      grades: json["grades"] == null ? [] : List<GradeModel>.from(json["grades"]!.map((x) => GradeModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "grades": grades?.map((x) => x.toJson()).toList(),
  };

  @override
  List<Object?> get props => [
    id, name, grades, ];
}

class GradeModel extends Equatable {
  const GradeModel({
    this.id,
    this.name,
  });

  final int? id;
  final String? name;

  GradeModel copyWith({
    int? id,
    String? name,
  }) {
    return GradeModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  factory GradeModel.fromJson(Map<String, dynamic> json){
    return GradeModel(
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
