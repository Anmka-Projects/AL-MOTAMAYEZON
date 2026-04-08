import 'package:elmotamizon/app/app_prefs.dart';
import 'package:elmotamizon/app/imports.dart';

abstract interface class Endpoints {
  static const String register = '/register';
  static const String login = '/login';
  static const String verifyOTP = '/verify-otp';
  static const String socialLogin = '/social_login';

  static const String forgetPassword = '/forgot/password';
  static const String changePassword = '/change_password';
  static const String sendOTP = '/send_otp';
  static const String confirmOTP = '/confirm_otp';
  static const String resetPassword = '/forgot/reset-password';
  static const String verifyAccount = '/verify_account';
  static const String logout = '/logout';
  static const String grades = '/grades';
  static const String stagesGrades = '/stage';
  static const String resendOTP = '/resend-otp';
  static const String verifyOTPForgetPassword = '/forgot/verify-otp';
  static const String resendOTPForgetPassword = '/forgot/resend-otp';
  static String assignStudent =
      instance<AppPreferences>().getUserType() == "teacher"
          ? '/teacher/subscribe-student'
          : '/parent-student/assign';
  static String teacherStudents = '/teacher/my-students';
  static String parentStudents = "/parent-student/students";
  static const String addCourse = '/create/course';
  static String editCourse(int id) => '/course/$id/update';
  static const String courses = '/courses';
  static const String subjects = '/subjects';
  static String courseDetails(String id) => '/course/$id';
  //instance<AppPreferences>().getUserType() == "teacher" ? '/course/$id' : '/course/data/$id';
  static String lessonDetails(String id) =>
      instance<AppPreferences>().getUserType() == "teacher"
          ? '/lesson/$id'
          : '/lesson/data/$id';
  static String lessons(int id) =>
      instance<AppPreferences>().getUserType() == "teacher"
          ? '/course/lessons/$id'
          : '/course/lesson/$id';
  static String booksInCourse(int id) => '/course/books/$id';
  static String lessonsContent(int id) => '/course/lessons/$id';
  static String voiceNote(int id) => '/course/voices/$id';
  static const String addLesson = '/lesson/create';
  static String editLesson(int id) => '/lesson/$id/update';
  static String deleteCourse(int id) => '/course/$id';
  static String toggleActiveCourse(int id) => '/course/$id/toggle-status';
  static String deleteLesson(int id) => '/lesson/$id';
  static String toggleActiveLesson(int id) => '/lesson/$id/toggle-status';
  static String deleteFile(int id) => '/lesson-file/file/$id';
  static const String addHomework = '/homework/upload';
  static String homeworks(int id, {bool isStudentDetails = false}) =>
      instance<AppPreferences>().getUserType() == "teacher" && !isStudentDetails
          ? '/homework/homeworks/$id'
          : instance<AppPreferences>().getUserType() == "student"
              ? "/lesson/homeworks/$id"
              : '/parent/child/$id/homeworks';
  static String exams(int id, {bool isStudentDetails = false}) =>
      instance<AppPreferences>().getUserType() == "teacher" && !isStudentDetails
          ? '/tests/lesson/$id'
          : instance<AppPreferences>().getUserType() == "student"
              ? '/lesson/tests/$id'
              : ('/parent/child/$id/tests');
  static String deleteHomework(int id) => '/homework/homework/$id';
  static String deleteExam(int id) => '/tests/$id';
  static const String myTeachers = '/student/my-teachers';
  static const String allTeachers = '/teachers/all';
  static String editExam(int id) => '/tests/update/$id';
  static const String addExam = '/tests/store';
  static String deleteQuestion(int id) => '/tests/question/$id';
  static String examDetails(int id) =>
      instance<AppPreferences>().getUserType() == "teacher"
          ? '/test/$id'
          : "/student/tests/$id";
  static String teacherCoursesById(int id) => '/teacher/courses/$id';
  static String childCoursesById(int id) => '/parent/child/$id/courses';
  static String submitExam(int examId) => '/student/tests/$examId/submit';
  static const String submitHomework = '/homework-submission/submit';
  static String submissionsHomework(int homeworkId) =>
      '/homework-submission/submissions/$homeworkId';
  static const String userData = '/user/data';
  static String updateTeacherProfile =
      instance<AppPreferences>().getUserType() == "teacher"
          ? '/teacher/update-profile'
          : instance<AppPreferences>().getUserType() == "parent"
              ? '/parent/update/profile'
              : '/student/update/profile';
  static String gradeSubmission(int submissionId) =>
      '/homework-submission/submission/$submissionId';
  static const String faqs = '/faq';
  static const String privacyPolicy = '/privacy';
  static const String about = '/about-us';
  static const String terms = '/terms';
  static const String subscribeTeacher = '/initiate-payment';
  static String subscribeAppleReviewTeacher(int teacherId) =>
      '/student/subscription/$teacherId';
  static const String contactUs = '/contact';
  static const String supportWhatsappNumber = '/support/whatsapp-number';
  static const String supportWhatsapp = '/support/whatsapp';
  static String systemExams(int id) => '/tests/system/all/$id';
  static const String onBoarding = '/sliders';
  static const String banners = '/banners';
  static const String notifications = '/notifications';
  static String search(String text) => '/search?q=$text';
  static String submissionDetails(int submissionId) =>
      "/tests/submission/data/$submissionId";
  static const String deleteAccount = '/delete/account';
  static const String favorite = '/favorites/courses';
  //favoriteBook
  static const String favoriteBook = '/favorites/books';
  static const String freeLesson = '/free/lesson';
  static const String books = '/books';

  static const String progress = "/my/courses";
  //addToFavorites
  static const String addToFavorites = '/favorites/toggle';
  //teacher
  static const String teacher = '/teacher/data';
  //subscribedBooks
  static const String subscribedBooks = '/my/books';
  static String viewVideo(int id) => '/lessons/$id/view';
  // courcesSearch
  static const String courcesSearch = '/search';
}
