import 'package:elmotamizon/features/exam_details/models/exam_details_model.dart';
import 'package:equatable/equatable.dart';

class TestsModel extends Equatable {
     TestsModel({
        this.code,
        this.message,
        this.data,
        this.pagination,
    });

    int? code;
    String? message;
    List<ExamModel>? data;
    TestsPaginationModel? pagination;

    TestsModel copyWith({
        int? code,
        String? message,
        List<ExamModel>? data,
        TestsPaginationModel? pagination,
    }) {
        return TestsModel(
            code: code ?? this.code,
            message: message ?? this.message,
            data: data ?? this.data,
            pagination: pagination ?? this.pagination,
        );
    }

    factory TestsModel.fromJson(Map<String, dynamic> json){
        return TestsModel(
            code: json["code"],
            message: json["message"],
            data: json["data"] == null ? [] : List<ExamModel>.from(json["data"]!.map((x) => ExamModel.fromJson(x))),
            pagination: json["pagination"] == null ? null : TestsPaginationModel.fromJson(json["pagination"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data?.map((x) => x.toJson()).toList(),
        "pagination": pagination?.toJson(),
    };

    @override
    List<Object?> get props => [
        code, message, data, pagination, ];
}

class TestsPaginationModel extends Equatable {
     TestsPaginationModel({
        this.total,
        this.currentPage,
        this.lastPage,
        this.perPage,
    });

    int? total;
    int? currentPage;
    int? lastPage;
    int? perPage;

    TestsPaginationModel copyWith({
        int? total,
        int? currentPage,
        int? lastPage,
        int? perPage,
    }) {
        return TestsPaginationModel(
            total: total ?? this.total,
            currentPage: currentPage ?? this.currentPage,
            lastPage: lastPage ?? this.lastPage,
            perPage: perPage ?? this.perPage,
        );
    }

    factory TestsPaginationModel.fromJson(Map<String, dynamic> json){
        return TestsPaginationModel(
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
