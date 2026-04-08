class ExamSubmissionDetailsModel {
  final int studentId;
  final String studentName;
  final String testName;
  final int score;
  final int duration;
  final String submittedAt;
  final List<ExamSubmissionAnswer> answers;

  ExamSubmissionDetailsModel({
    required this.studentId,
    required this.studentName,
    required this.testName,
    required this.score,
    required this.duration,
    required this.submittedAt,
    required this.answers,
  });

  factory ExamSubmissionDetailsModel.fromJson(Map<String, dynamic> json) {
    return ExamSubmissionDetailsModel(
      studentId: json['student_id'],
      studentName: json['student_name'],
      testName: json['test_name'],
      score: json['score'],
      duration: json['duration'],
      submittedAt: json['submitted_at'],
      answers: (json['answers'] as List)
          .map((e) => ExamSubmissionAnswer.fromJson(e))
          .toList(),
    );
  }
}

class ExamSubmissionAnswer {
  final String question;
  final String selectedAnswer;
  final int isCorrect;
  final String correctAnswer;

  ExamSubmissionAnswer({
    required this.question,
    required this.selectedAnswer,
    required this.isCorrect,
    required this.correctAnswer,
  });

  factory ExamSubmissionAnswer.fromJson(Map<String, dynamic> json) {
    return ExamSubmissionAnswer(
      question: json['question'],
      selectedAnswer: json['selected_answer'],
      isCorrect: json['is_correct'],
      correctAnswer: json['correct_answer'],
    );
  }
} 