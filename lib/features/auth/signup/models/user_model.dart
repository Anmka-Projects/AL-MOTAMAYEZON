enum UserType {
  student,
  parent,
  teacher,
}

class UserTypeModel {
  int id;
  String nameAr;
  String nameEn;

  UserTypeModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });
}

