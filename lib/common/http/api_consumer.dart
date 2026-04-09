import 'dart:convert';
import 'dart:developer';
import 'package:elmotamizon/app/app_prefs.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/extensions/context_extension.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/features/auth/login/view/login_view.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../app/app.dart';
import 'either.dart';
import 'failure.dart';

abstract final class ApiConsumer {
  Future<Either<Failure, Map<String, dynamic>>> get(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  });

  Future<Either<Failure, Map<String, dynamic>>> post(
    String url, {
    Map<String, dynamic>? data,
    FormData? formData,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  });

  Future<Either<Failure, Map<String, dynamic>>> patch(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  });

  Future<Either<Failure, Map<String, dynamic>>> put(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  });

  Future<Either<Failure, Map<String, dynamic>>> delete(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, String>> downloadFile(
      String url,
      String savePath,
      {ProgressCallback? onReceiveProgress,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,}
      );

  Future<Either<Failure, Map<String, dynamic>>> uploadFile(
    String url, {
    required FormData formData,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  });

  void addInterceptor(Interceptor interceptor);

  void removeAllInterceptors();

  void updateHeader(Map<String, dynamic> headers);

  Future<Either<Failure, Map<String, dynamic>>> retryApiCall(
    Future<Either<Failure, Map<String, dynamic>>> Function() apiCall, {
    int retryCount = 0,
  });
}

final class BaseApiConsumer implements ApiConsumer {
  final Dio _dio;
  final int maxRetries;
  final Duration retryDelay;

  BaseApiConsumer({
    required Dio dio,
    int maxRetries = 2,
    Duration retryDelay = const Duration(seconds: 1),
  })  : _dio = dio,
        maxRetries = maxRetries,
        retryDelay = retryDelay;

  @override
  Future<Either<Failure, Map<String, dynamic>>> retryApiCall(
    Future<Either<Failure, Map<String, dynamic>>> Function() apiCall, {
    int retryCount = 0,
  }) async {
    final result = await apiCall();
    return result.fold(
      (failure) async {
        if (retryCount < maxRetries) {
          log("API failed, retrying attempt #${retryCount + 1}");
          await Future.delayed(retryDelay);
          return retryApiCall(apiCall, retryCount: retryCount + 1); //recursion
        } else {
          if (!_isNoDataFailureMessage(failure.message)) {
            log("Max retries reached, API failed: ${failure.message}");
          }
          return Left(failure);
        }
      },
      (success) => Right(success),
    );
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> get(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async
  {
    apiCall() async {
      try {
        final response = await _dio.get(
          url,
          queryParameters: queryParameters,
          options: Options(headers: headers),
          cancelToken: cancelToken,
          data: data,
          onReceiveProgress: onReceiveProgress,
        );
        return Right<Failure, Map<String, dynamic>>(
            response.data as Map<String, dynamic>);
      } on DioException catch (e) {
        if (!_isNoDataNotFoundError(e)) {
          log(e.toString());
        }
        final failure = _handleDioError(e);
        return Left<Failure, Map<String, dynamic>>(failure);
      } catch (e) {
        return Left<Failure, Map<String, dynamic>>(
            UnknownFailure(message: 'An unexpected error occurred: $e'));
      }
    }

    return await retryApiCall(apiCall);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> patch(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async
  {
    try {
      Response response = await _dio.patch(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
        data: data,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return Right(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      log(e.toString());
      final failure = _handleDioError(e);
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure(
          message: 'An unexpected error occurred${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> post(
    String url, {
    Map<String, dynamic>? data,
    FormData? formData,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      Response response = await _dio.post(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        data: data,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return Right(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final failure = _handleDioError(e);
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure(
          message: 'An unexpected error occurred${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> put(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      Response response = await _dio.put(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
        data: data,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return Right(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      log(e.toString());
      final failure = _handleDioError(e);
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure(
          message: 'An unexpected error occurred${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> delete(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      Response response = await _dio.delete(
        url,
        queryParameters: queryParameters,
        data: data,
        options: Options(headers: headers),
        cancelToken: cancelToken,
      );

      return Right(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      log(e.toString());
      final failure = _handleDioError(e);
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure(
          message: 'An unexpected error occurred${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> downloadFile(
      String url,
      String savePath,
      { ProgressCallback? onReceiveProgress,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,}
      ) async {
    try {
      await _dio.download(
        url,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      // Return the file path after successful download
      return Right(savePath);
    } on DioException catch (e) {
      log(e.toString());
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(
        UnknownFailure(message: 'An unexpected error occurred: ${e.toString()}'),
      );
    }
  }


  @override
  Future<Either<Failure, Map<String, dynamic>>> uploadFile(String url,
      {required FormData formData,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    try {
      Response response = await _dio.post(
        url,
        data: formData,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return Right(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      log(e.toString());
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(
          message: 'An unexpected error occurred${e.toString()}'));
    }
  }

  @override
  void removeAllInterceptors() {
    _dio.options.headers.clear();
  }

  @override
  void updateHeader(Map<String, dynamic> headers) {
    _dio.options.headers.addAll(headers);
  }

  @override
  void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        // scaffoldMessengerKey.currentContext!.showToast(text: 'تم الغاء الطلب ');
        return ServerFailure(message: 'تم إلغاء الطلب ');
      case DioExceptionType.connectionTimeout:
        // scaffoldMessengerKey.currentContext!.showToast(text: 'انتهت مهلة الاتصال ');
        return ServerFailure(message: 'انتهت مهلة الاتصال ');
      case DioExceptionType.receiveTimeout:
        // scaffoldMessengerKey.currentContext!.showToast(text: 'انتهت مهلة الاتصال ');
        return ServerFailure(message: 'انتهت مهلة الاستقبال في الاتصال ');
      case DioExceptionType.sendTimeout:
        // scaffoldMessengerKey.currentContext!.showToast(text: 'انتهت مهلة الاتصال ');
        return ServerFailure(message: 'انتهت مهلة الإرسال في الاتصال ');
      case DioExceptionType.badResponse://400-500
        if (error.response?.data != null) {
          try {
            final data = error.response!.data;
            final Map<String, dynamic> decoded =
                data is String ? json.decode(data) : data;
            if (error.response?.statusCode == 503) {
              return ServerFailure(message: 'network failure ${error.message}');
            }
            if (error.response?.statusCode == 401) {
              // scaffoldMessengerKey.currentContext?.showToast(text: error.response?.data?['message']??'');
            if(instance<AppPreferences>().getToken().isNotEmpty)  instance<AppPreferences>().logout();
              scaffoldMessengerKey.currentContext?.go(const LoginView());

              return UnauthorizedFailure(
                  message: error.response?.data['message'] ?? 'غير مصرح لك');
            }
            if (error.response?.statusCode == 413) {
              scaffoldMessengerKey.currentContext!
                  .showToast(text: 'File size is too large');

              return ServerFailure(
                message: 'File size is too large',
              );
            }
            if (error.response?.statusCode == 410) {
              scaffoldMessengerKey.currentContext!
                  .showToast(text: 'لقد تعرضت للحظر ');
              // scaffoldMessengerKey.currentContext!.goWithNoReturn(const LoginScreen());

              return BanFailure(
                message: 'لقد تعرضت للحظر ',
              );
            }
            // Handle OTP failure for 409 status code
            if (error.response?.statusCode == 409) {
              log('VERIFYERROR');
              return VerifyOTPFailure(message: 'خطأ في التحقق من الكود');
            }
            if(error.response?.statusCode == 415){
              return ActiveAccountFailure(message: error.response?.data['message']);
            }
            if (decoded.containsKey('message')) {
              String message = decoded['message'];

              // Process validation errors if present
              if (decoded.containsKey('errors') && decoded['errors'] is Map) {
                final Map<String, dynamic> errors = decoded['errors'];
                List<String> errorMessages = [];
                errors.forEach((key, value) {
                  if (value is List) {
                    errorMessages.addAll(value.map((e) => '$e').toList());
                  } else if (value is String) {
                    errorMessages.add(value);
                  }
                });

                if (errorMessages.isNotEmpty) {
                  scaffoldMessengerKey.currentContext!
                      .showToast(text: errorMessages[0]);
                  return ValidationFailure(
                    message: message,
                    errors: errorMessages,
                  );
                }
              }

              // scaffoldMessengerKey.currentContext!.showToast(text: texttext: )(message);
              return ServerFailure(message: message);
            }

            if(error.response?.statusCode == 404){
              return ServerFailure(message: AppStrings.unKnownError.tr());
            }
          } catch (e) {
            // scaffoldMessengerKey.currentContext!.showToast(text: texttext: )(e.toString());
            return ServerFailure(message: '${error.response?.data['message']}');
          }
        }
        // scaffoldMessengerKey.currentContext!.showToast(text: texttext: )(error.message!);
        return ServerFailure(message: '${error.response?.data['message']}');
      case DioExceptionType.badCertificate:
        return ServerFailure(message: 'تعذر الاتصال ');
      case DioExceptionType.connectionError:
        // navigatorKey.currentContext!.showTopSnackBar( child: Text("تعذر الاتصال"),backgroundColor: ColorManager.red);
        return NetworkFailure(message: AppStrings.noInternetError.tr());
      case DioExceptionType.unknown:
        return UnknownFailure(message: AppStrings.unKnownError.tr());
    }
  }

  bool _isNoDataFailureMessage(String message) {
    final normalized = message.toLowerCase();
    return normalized.contains('no-books-found') ||
        normalized.contains('no-courses-found') ||
        normalized.contains('no-favorites-found') ||
        normalized.contains('no-free-lessons-found');
  }

  bool _isNoDataNotFoundError(DioException error) {
    if (error.response?.statusCode != 404) return false;
    final data = error.response?.data;
    String message = '';
    if (data is Map<String, dynamic>) {
      message = (data['message'] ?? '').toString();
    } else if (data is String) {
      try {
        final decoded = json.decode(data);
        if (decoded is Map<String, dynamic>) {
          message = (decoded['message'] ?? '').toString();
        }
      } catch (_) {}
    }
    return _isNoDataFailureMessage(message);
  }
}
