import 'package:equatable/equatable.dart';

class CourseDetailsModel extends Equatable {
  const CourseDetailsModel({
    this.code,
    this.message,
    this.data,
  });

  final int? code;
  final String? message;
  final CourseModel? data;

  CourseDetailsModel copyWith({
    int? code,
    String? message,
    CourseModel? data,
  }) {
    return CourseDetailsModel(
      code: code ?? this.code,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory CourseDetailsModel.fromJson(Map<String, dynamic> json) {
    return CourseDetailsModel(
      code: json["code"],
      message: json["message"],
      data: json["data"] == null ? null : CourseModel.fromJson(json["data"]),
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

class CourseModel extends Equatable {
   CourseModel({
    this.id,
    this.name,
    this.description,
    this.whatYouWillLearn,
    this.image,
    this.videoUrl,
    this.subjectId,
    this.stageId,
    this.gradeId,
    this.stage,
    this.grade,
    this.subject,
    this.status,
    this.teacher,
    this.created,
    this.lessonsCount,
    this.nameAr,
    this.nameEn,
    this.descriptionAr,
    this.descriptionEn,
    this.whatYouWillLearnAr,
    this.whatYouWillLearnEn,
    this.price,
    this.isSubscribed,
    this.rate,
    this.percentage,
    this.isFavorited,
    this.isFree,
    this.voiceCount,
    this.filesCount,
  });

  final int? id;
  final String? name;
  final String? description;
  final String? whatYouWillLearn;
  final String? image;
  final String? videoUrl;
  final int? subjectId;
  final int? gradeId;
  final int? stageId;
  final String? stage;
  final String? grade;

  final String? subject;
  final int? status;
  final String? teacher;
  final String? created;
  final int? lessonsCount;
  final String? nameAr;
  final String? nameEn;
  final String? descriptionAr;
  final String? descriptionEn;
  final String? whatYouWillLearnAr;
  final String? whatYouWillLearnEn;
  final dynamic price;
  int? isSubscribed;
  final num? rate;
  final num? percentage;
  final int? isFavorited;
  final int? isFree;
  final int? voiceCount;
  final int? filesCount;

  CourseModel copyWith({
    int? id,
    String? name,
    String? description,
    String? whatYouWillLearn,
    String? image,
    String? videoUrl,
    int? subjectId,
    int? gradeId,
    int? stageId,
    String? stage,
    String? grade,
    String? subject,
    int? status,
    String? teacher,
    String? created,
    int? lessonsCount,
    String? nameAr,
    String? nameEn,
    String? descriptionAr,
    String? descriptionEn,
    String? whatYouWillLearnAr,
    String? whatYouWillLearnEn,
    dynamic price,
    int? isSubscribed,
    num? rate,
    num? percentage,
    int? isFavorited,
    int? isFree,
    int? voiceCount,
    int? filesCount,
  }) {
    return CourseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      whatYouWillLearn: whatYouWillLearn ?? this.whatYouWillLearn,
      image: image ?? this.image,
      videoUrl: videoUrl ?? this.videoUrl,
      subjectId: subjectId ?? this.subjectId,
      gradeId: gradeId ?? this.gradeId,
      stageId: stageId ?? this.stageId,
      stage: stage ?? this.stage,
      grade: grade ?? this.grade,
      subject: subject ?? this.subject,
      status: status ?? this.status,
      teacher: teacher ?? this.teacher,
      created: created ?? this.created,
      lessonsCount: lessonsCount ?? this.lessonsCount,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      whatYouWillLearnAr: whatYouWillLearnAr ?? this.whatYouWillLearnAr,
      whatYouWillLearnEn: whatYouWillLearnEn ?? this.whatYouWillLearnEn,
      price: price ?? this.price,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      rate: rate ?? this.rate,
      percentage: percentage ?? this.percentage,
      isFavorited: isFavorited ?? this.isFavorited,
      isFree: isFree ?? this.isFree,
      voiceCount: voiceCount ?? this.voiceCount,
      filesCount: filesCount ?? this.filesCount,
    );
  }

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      whatYouWillLearn: json["what_you_will_learn"],
      image: json["image"],
      videoUrl: json["video_url"],
      subjectId: json["subject_id"],
      gradeId: json["grade_id"],
      stageId: json["stage_id"],
      stage: json["stage"],
      grade: json["grade"],
      subject: json["subject"],
      status: json["status"],
      teacher: json["teacher"],
      created: json["created"],
      lessonsCount: json["lessons_count"],
      nameAr: json["name_ar"],
      nameEn: json["name_en"],
      descriptionAr: json["description_ar"],
      descriptionEn: json["description_en"],
      whatYouWillLearnAr: json["what_ar"],
      whatYouWillLearnEn: json["what_en"],
      price: json["price"],
      isSubscribed: json["is_subscribed"] ?? 0,
      rate: json["rate"] ?? 0,
      percentage: json["percentage"] ?? 0,
      isFavorited: json["is_favorited"] ?? 0,
      isFree: json["is_free"] ?? 0,
      voiceCount: json["voice_count"] ?? 0,
      filesCount: json["files_count"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "what_you_will_learn": whatYouWillLearn,
        "image": image,
        "video_url": videoUrl,
        "subject_id": subjectId,
        "grade_id": gradeId,
        "stage_id": stageId,
        "stage": stage,
        "grade": grade,
        "subject": subject,
        "status": status,
        "teacher": teacher,
        "created": created,
        "lessons_count": lessonsCount,
        "name_ar": nameAr,
        "name_en": nameEn,
        "description_ar": descriptionAr,
        "description_en": descriptionEn,
        "what_ar": whatYouWillLearnAr,
        "what_en": whatYouWillLearnEn,
        "price": price,
        "is_subscribed": isSubscribed,
        "rate": rate,
        "percentage": percentage,
        "is_favorited": isFavorited,
        "is_free": isFree,
        "voice_count": voiceCount,
        "files_count": filesCount,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        whatYouWillLearn,
        image,
        videoUrl,
        subjectId,
        subject,
        status,
        teacher,
        created,
        lessonsCount,
        nameAr,
        nameEn,
        descriptionAr,
        descriptionEn,
        whatYouWillLearnAr,
        whatYouWillLearnEn,
        price,
        isSubscribed,
        rate,
        percentage,
        isFavorited,
        isFree,
        voiceCount,
        filesCount,
        stageId,
        stage,
        gradeId,
        grade
      ];
}
