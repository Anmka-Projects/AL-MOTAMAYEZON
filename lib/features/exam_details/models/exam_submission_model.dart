class ExamSubmissionModel {
  final int id;
  final int studentId;
  final String studentName;
  final int score;
  final int duration;
  final String submittedAt;

  ExamSubmissionModel({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.score,
    required this.duration,
    required this.submittedAt,
  });

  factory ExamSubmissionModel.fromJson(Map<String, dynamic> json) {
    return ExamSubmissionModel(
      id: json['id'],
      studentId: json['student_id'],
      studentName: json['student_name'],
      score: json['score'],
      duration: json['duration'],
      submittedAt: json['submitted_at'],
    );
  }
}

class ExamSubmissionsPagination {
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;

  ExamSubmissionsPagination({
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
  });

  factory ExamSubmissionsPagination.fromJson(Map<String, dynamic> json) {
    return ExamSubmissionsPagination(
      total: json['total'],
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      perPage: json['per_page'],
    );
  }
} 