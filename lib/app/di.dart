part of 'imports.dart';

final instance = GetIt.instance;

Future<void> initAppModule() async {
  instance.allowReassignment = true;

  // shared prefs
  final sharedPrefs = await SharedPreferences.getInstance();
  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  // internet connection checker
  instance.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker());

  // app preferences
  instance.registerLazySingleton<AppPreferences>(
      () => AppPreferences(instance<SharedPreferences>()));

  // dio
  instance.registerLazySingleton<Dio>(() => Dio()
    ..options = BaseOptions(
      baseUrl: AppConstants.baseUrl,
      receiveDataWhenStatusError: true,
      // connectTimeout: const Duration(seconds: 60),
      // receiveTimeout: const Duration(seconds: 60),
      // sendTimeout: const Duration(seconds: 60),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Accept-Language': instance<AppPreferences>().getAppLanguage(),
        'Authorization': "Bearer ${instance<AppPreferences>().getToken()}",
      },
    )
    ..interceptors.addAll([
      if (!kReleaseMode)
        PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            responseHeader: true,
            responseBody: true,
            error: true,
            compact: true,
            maxWidth: 90,
            enabled: true)
    ]));

  // Dio for public / video download URLs (no Authorization header)
  instance.registerLazySingleton<Dio>(
    () => Dio()
      ..options = BaseOptions(
        receiveDataWhenStatusError: true,
        followRedirects: true,
      )
      ..interceptors.addAll([
        if (!kReleaseMode)
          PrettyDioLogger(
              requestHeader: true,
              requestBody: false,
              responseHeader: false,
              responseBody: false,
              error: true,
              compact: true,
              maxWidth: 90,
              enabled: true)
      ]),
    instanceName: 'video_download',
  );

  // api consumer
  instance.registerLazySingleton<ApiConsumer>(
      () => BaseApiConsumer(
            dio: instance(),
            maxRetries: 2,
            retryDelay: const Duration(seconds: 1),
          ));

  // data source
  instance.registerLazySingleton<GenericDataSource>(
      () => GenericDataSource(instance()));

  instance.registerLazySingleton<LoginDataSource>(
      () => LoginDataSourceImpl(instance()));
  instance.registerFactory<LoginCubit>(() => LoginCubit(instance()));
  instance.registerLazySingleton<RegisterDataSource>(
      () => RegisterDataSourceImpl(instance()));
  instance.registerFactory<RegisterCubit>(() => RegisterCubit(instance()));
  instance.registerLazySingleton<StagesGradesDataSource>(
      () => StagesGradesDataSourceImpl(instance()));
  instance
      .registerFactory<StagesGradesCubit>(() => StagesGradesCubit(instance()));
  instance.registerLazySingleton<VerifyOtpDataSource>(
      () => VerifyOtpDataSourceImpl(instance()));
  instance.registerFactory<VerifyOtpCubit>(() => VerifyOtpCubit(instance()));
  instance.registerLazySingleton<ResendOtpDataSource>(
      () => ResendOtpDataSourceImpl(instance()));
  instance.registerFactory<ResendOtpCubit>(() => ResendOtpCubit(instance()));
  instance.registerLazySingleton<ChangePasswordDataSource>(
      () => ChangePasswordDataSourceImpl(instance()));
  instance.registerFactory<ChangePasswordBloc>(
      () => ChangePasswordBloc(instance()));
  instance.registerLazySingleton<ResetPasswordDataSource>(
      () => ResetPasswordDataSourceImpl(instance()));
  instance.registerFactory<ResetPasswordCubit>(
      () => ResetPasswordCubit(instance()));
  instance.registerLazySingleton<SocialAuthDataSource>(
      () => SocialAuthDataSourceImpl(instance()));
  instance.registerFactory<SocialAuthCubit>(() => SocialAuthCubit(instance()));
  instance.registerLazySingleton<ForgetPasswordDataSource>(
      () => ForgetPasswordDataSourceImpl(instance()));
  instance.registerFactory<ForgetPasswordCubit>(
      () => ForgetPasswordCubit(instance()));
  instance.registerLazySingleton<AssignStudentDataSource>(
      () => AssignStudentDataSourceImpl(instance()));
  instance.registerFactory<AssignStudentCubit>(
      () => AssignStudentCubit(instance()));
  instance.registerLazySingleton<StudentsDataSource>(
      () => StudentsDataSourceImpl(instance()));
  instance.registerFactory<StudentsCubit>(() => StudentsCubit(instance()));
  instance.registerLazySingleton<AddCourseDataSource>(
      () => AddCourseDataSourceImpl(instance()));
  instance.registerFactory<AddCourseCubit>(() => AddCourseCubit(instance()));
  instance.registerLazySingleton<SubjectsDataSource>(
      () => SubjectsDataSourceImpl(instance()));
  instance.registerFactory<SubjectsCubit>(() => SubjectsCubit(instance()));
  instance.registerFactory<CoursesDataSource>(
      () => CoursesDataSourceImpl(instance()));
  instance.registerFactory<CoursesCubit>(() => CoursesCubit(instance()));
  instance.registerLazySingleton<CourseDetailsDataSource2>(
      () => CourseDetailsDataSourceImpl2(instance()));
  instance.registerLazySingleton<CourseDetailsDataSource>(
      () => CourseDetailsDataSourceImpl(instance()));
  instance.registerFactory<CourseDetailsCubit2>(
      () => CourseDetailsCubit2(instance()));
  instance.registerFactory<CourseDetailsCubit>(
      () => CourseDetailsCubit(instance()));
  instance.registerLazySingleton<LessonDetailsDataSource>(
      () => LessonDetailsDataSourceImpl(instance()));
  instance.registerFactory<LessonDetailsCubit>(
      () => LessonDetailsCubit(instance()));
  instance.registerLazySingleton<LessonsDataSource>(
      () => LessonsDataSourceImpl(instance()));
  instance.registerFactory<Lessons2Cubit>(() => Lessons2Cubit(instance()));
  instance.registerLazySingleton<AddLessonDataSource>(
      () => AddLessonDataSourceImpl(instance()));
  instance.registerFactory<AddLessonCubit>(() => AddLessonCubit(instance()));
  instance.registerLazySingleton<DeleteActiveCourseOrLessonDataSource>(
      () => DeleteActiveCourseOrLessonDataSourceImpl(instance()));
  instance.registerFactory<DeleteActiveCourseOrLessonCubit>(
      () => DeleteActiveCourseOrLessonCubit(instance()));
  instance.registerLazySingleton<DeleteFileDataSource>(
      () => DeleteFileDataSourceImpl(instance()));
  instance.registerFactory<DeleteFileCubit>(() => DeleteFileCubit(instance()));
  instance.registerLazySingleton<AddHomeworkDataSource>(
      () => AddHomeworkDataSourceImpl(instance()));
  instance
      .registerFactory<AddHomeworkCubit>(() => AddHomeworkCubit(instance()));
  instance.registerLazySingleton<HomeworksDataSource>(
      () => HomeworksDataSourceImpl(instance()));
  instance.registerFactory<HomeworksCubit>(() => HomeworksCubit(instance()));
  instance.registerLazySingleton<TestsDataSource>(
      () => TestsDataSourceSourceImpl(instance()));
  instance.registerFactory<TestsCubit>(() => TestsCubit(instance()));
  instance.registerLazySingleton<MyTeachersDataSource>(
      () => MyTeachersDataSourceImpl(instance()));
  instance.registerFactory<MyTeachersCubit>(() => MyTeachersCubit(instance()));
  instance.registerLazySingleton<LogoutDataSource>(
      () => LogoutDataSourceImpl(instance()));
  instance.registerFactory<LogoutCubit>(() => LogoutCubit(instance()));
  instance.registerLazySingleton<AddExamDataSource>(
      () => AddExamDataSourceImpl(instance()));
  instance.registerFactory<AddExamCubit>(() => AddExamCubit(instance()));
  instance.registerLazySingleton<DeleteQuestionDataSource>(
      () => DeleteQuestionDataSourceImpl(instance()));
  instance.registerFactory<DeleteQuestionCubit>(
      () => DeleteQuestionCubit(instance()));
  instance.registerLazySingleton<ExamDetailsDataSource>(
      () => ExamDetailsDataSourceImpl(instance()));
  instance
      .registerFactory<ExamDetailsCubit>(() => ExamDetailsCubit(instance()));
  instance.registerLazySingleton<SubmitExamDataSource>(
      () => SubmitExamDataSourceImpl(instance()));
  instance.registerLazySingleton<SubmitExamCubit>(
      () => SubmitExamCubit(instance()));
  instance.registerLazySingleton<SubmitHomeworkDataSource>(
      () => SubmitHomeworkDataSourceImpl(instance()));
  instance.registerFactory<SubmitHomeworkCubit>(
      () => SubmitHomeworkCubit(instance()));
  instance.registerLazySingleton<SubmissionsHomeworksDataSource>(
      () => SubmissionsHomeworksDataSourceImpl(instance()));
  instance.registerLazySingleton<SubmissionsHomeworksCubit>(
      () => SubmissionsHomeworksCubit(instance()));
  instance.registerLazySingleton<ProfileDataSource>(
      () => ProfileDataSourceImpl(instance()));
  instance.registerFactory<ProfileCubit>(() => ProfileCubit(instance()));
  instance.registerLazySingleton<GradeSubmissionDataSource>(
      () => GradeSubmissionDataSourceImpl(instance()));
  instance.registerFactory<GradeSubmissionCubit>(
      () => GradeSubmissionCubit(instance()));
  instance.registerLazySingleton<FaqsDataSource>(
      () => FaqsDataSourceImpl(instance()));
  instance.registerFactory<FaqsCubit>(() => FaqsCubit(instance()));
  instance.registerLazySingleton<PrivacyPolicyDataSource>(
      () => PrivacyPolicyDataSourceImpl(instance()));
  instance.registerFactory<PrivacyPolicyCubit>(
      () => PrivacyPolicyCubit(instance()));
  instance.registerLazySingleton<SubscribeTeacherDataSource>(
      () => SubscribeTeacherDataSourceImpl(instance()));
  instance.registerFactory<SubscribeTeacherCubit>(
      () => SubscribeTeacherCubit(instance()));
  instance.registerLazySingleton<ContactUsDataSource>(
      () => ContactUsDataSourceImpl(instance()));
  instance.registerFactory<ContactUsCubit>(() => ContactUsCubit(instance()));
  instance.registerLazySingleton<SupportWhatsappDataSource>(
      () => SupportWhatsappDataSourceImpl(instance()));
  instance.registerFactory<SupportWhatsappCubit>(
      () => SupportWhatsappCubit(instance()));
  instance.registerLazySingleton<SystemExamsDataSource>(
      () => SystemExamsDataSourceImpl(instance()));
  instance
      .registerFactory<SystemExamsCubit>(() => SystemExamsCubit(instance()));
  instance.registerLazySingleton<ExamSubmissionsDataSource>(
      () => ExamSubmissionsDataSourceImpl(instance()));
  instance.registerFactory<ExamSubmissionsCubit>(
      () => ExamSubmissionsCubit(instance()));
  instance.registerLazySingleton<ExamSubmissionDetailsDataSource>(
      () => ExamSubmissionDetailsDataSourceImpl(instance()));
  instance.registerFactory<ExamSubmissionDetailsCubit>(
      () => ExamSubmissionDetailsCubit(instance()));
  instance.registerLazySingleton<OnBoardingDataSource>(
      () => OnBoardingDataSourceImpl(instance()));
  instance.registerFactory<OnBoardingCubit>(() => OnBoardingCubit(instance()));
  instance.registerLazySingleton<BannersDataSource>(
      () => BannersDataSourceImpl(instance()));
  instance.registerFactory<BannersCubit>(() => BannersCubit(instance()));
  instance.registerLazySingleton<NotificationsDataSource>(
      () => NotificationsDataSourceImpl(instance()));
  instance.registerFactory<NotificationsCubit>(
      () => NotificationsCubit(instance()));

  // ********************************************************************
  //BooksCubit
  instance.registerLazySingleton<BooksDataSource>(
      () => BooksDataSourceImpl(instance()));
  instance.registerFactory<BooksCubit>(() => BooksCubit(instance()));

  // LessonsContentCubit
  instance.registerLazySingleton<LessonsContentDataSource>(
      () => LessonsContentDataSourceImpl(instance()));
  instance.registerFactory<LessonsContentCubit>(
      () => LessonsContentCubit(instance()));

  //VoiceNoteCubit
  instance.registerLazySingleton<VoiceNoteDataSource>(
      () => VoiceNoteDataSourceImpl(instance()));
  instance.registerFactory<VoiceNoteCubit>(() => VoiceNoteCubit(instance()));

  // AddToFavoritesCubit
  instance.registerFactory<AddToFavoritesDataSource>(
      () => AddToFavoritesDataSourceImpl(genericDataSource: instance()));
  instance.registerFactory<AddToFavoritesCubit>(
      () => AddToFavoritesCubit(instance()));

  //TeacherCubit
  instance.registerFactory<TeacherDataSource>(
      () => TeacherDataSourceImpl(instance()));
  instance.registerLazySingleton<TeacherCubit>(() => TeacherCubit(instance()));

  instance.registerFactory<ViewVideoDataSource>(
      () => ViewVideoDataSourceImpl(instance()));
  instance.registerFactory<ViewVideoCubit>(() => ViewVideoCubit(instance()));
  instance.registerFactory<SearchDataSource>(
      () => SearchDataSourceImpl(instance()));
  instance.registerFactory<SearchCubit>(() => SearchCubit(instance()));

  // ********************************************************************
  // Offline Encrypted Video (Clean Architecture)
  instance
      .registerLazySingleton<KeyDerivationService>(() => KeyDerivationService(
            secretSalt: AppConstants.offlineVideoEncryptionSalt,
          ));
  instance.registerLazySingleton<EncryptionService>(() => EncryptionService());
  instance.registerLazySingleton<SecurityCheckService>(
      () => SecurityCheckService());
  instance.registerLazySingleton<SecureKeyDatasource>(
      () => SecureKeyDatasourceImpl());
  instance.registerLazySingleton<RemoteVideoDownloadDatasource>(() =>
      RemoteVideoDownloadDatasourceImpl(
          instance.get<Dio>(instanceName: 'video_download')));
  instance.registerLazySingleton<LocalEncryptedVideoDatasource>(
      () => LocalEncryptedVideoDatasourceImpl());
  instance.registerLazySingleton<OfflineVideoRepository>(
      () => OfflineVideoRepositoryImpl(
            remoteDownload: instance(),
            localStorage: instance(),
            secureKey: instance(),
            keyDerivation: instance(),
            encryption: instance(),
            securityCheck: instance(),
            userId: instance<AppPreferences>().getUserId().toString(),
          ));
  instance.registerFactory<DownloadVideoUseCase>(
      () => DownloadVideoUseCaseImpl(instance()));
  instance.registerFactory<GetOfflineVideosUseCase>(
      () => GetOfflineVideosUseCaseImpl(instance()));
  instance.registerFactory<PlayOfflineVideoUseCase>(
      () => PlayOfflineVideoUseCaseImpl(instance()));
  instance.registerFactory<DeleteOfflineVideoUseCase>(
      () => DeleteOfflineVideoUseCaseImpl(instance()));
  instance.registerFactory<IsVideoDownloadedUseCase>(
      () => IsVideoDownloadedUseCaseImpl(instance()));
  instance.registerFactory<OfflineVideoCubit>(() => OfflineVideoCubit(
        getOfflineVideosUseCase: instance(),
        downloadVideoUseCase: instance(),
        playOfflineVideoUseCase: instance(),
        deleteOfflineVideoUseCase: instance(),
        isVideoDownloadedUseCase: instance(),
      ));
}
