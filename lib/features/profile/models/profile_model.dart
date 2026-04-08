import 'package:equatable/equatable.dart';

class ProfileModel extends Equatable {
  final int? id;
  final String? image;
  final String? name;
  final String? birthDate;
  final String? code;
  final String? email;
  final String? phone;
  final String? userType;
  final int? stage;
  final String? stageName;
  final int? grade;
  final String? gradeName;
  final TeacherData? teacherData;

  const ProfileModel({
    this.id,
    this.image,
    this.name,
    this.birthDate,
    this.code,
    this.email,
    this.phone,
    this.userType,
    this.stage,
    this.stageName,
    this.grade,
    this.gradeName,
    this.teacherData,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    id: json['id'],
    image: json['image'],
    name: json['name'],
    birthDate: json['birth_date'],
    code: json['code'],
    email: json['email'],
    phone: json['phone'],
    userType: json['user_type'],
    stage: json['stage'],
    stageName: json['stageName'],
    grade: json['grade'],
    gradeName: json['gradeName'],
    teacherData: json['teacher_data'] != null ? TeacherData.fromJson(json['teacher_data']) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'image': image,
    'name': name,
    'birth_date': birthDate,
    'code': code,
    'email': email,
    'phone': phone,
    'user_type': userType,
    'stage': stage,
    'stageName': stageName,
    'grade': grade,
    'gradeName': gradeName,
    'teacher_data': teacherData?.toJson(),
  };

  @override
  List<Object?> get props => [id, image, name, birthDate, code, email, phone, userType, stage, stageName, grade, gradeName, teacherData];
}

class TeacherData extends Equatable {
  final String? bio;
  final String? qualification;
  final int? price;

  const TeacherData({this.bio, this.qualification, this.price});

  factory TeacherData.fromJson(Map<String, dynamic> json) => TeacherData(
    bio: json['bio'],
    qualification: json['qualification'],
    price: json['price'],
  );

  Map<String, dynamic> toJson() => {
    'bio': bio,
    'qualification': qualification,
    'price': price,
  };

  @override
  List<Object?> get props => [bio, qualification, price];
} 