import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/app/app_prefs.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/extensions/context_extension.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/widgets/default_button_widget.dart';
import 'package:elmotamizon/common/widgets/default_error_widget.dart';
import 'package:elmotamizon/common/widgets/default_image_widget.dart';
import 'package:elmotamizon/features/details/cubit/subscribe_teacher_cubit.dart';
import 'package:elmotamizon/features/home/details/cubit/course_details/course_details_cubit.dart';
import 'package:elmotamizon/features/home/details/cubit/view_video/view_video_cubit.dart';
import 'package:elmotamizon/features/home/details/models/course_details_model.dart';
import 'package:elmotamizon/features/home/details/view/widgets/course_details.dart';
import 'package:elmotamizon/features/home/details/view/widgets/custom_title.dart';
import 'package:elmotamizon/features/home/details/view/widgets/lectures_widget.dart';
import 'package:elmotamizon/features/home/details/view/widgets/pdf_view.dart';
import 'package:elmotamizon/features/home/details/view/widgets/row_for_book_number.dart';
import 'package:elmotamizon/features/home/details/view/widgets/teacher_data.dart';
import 'package:elmotamizon/features/home/details/view/widgets/voice_note.dart';
import 'package:elmotamizon/features/payment/digital_payment_order_place_screen.dart';
import 'package:elmotamizon/features/offline_video/domain/entities/downloadable_video.dart';
import 'package:elmotamizon/features/offline_video/presentation/cubit/offline_video_cubit.dart';
import 'package:elmotamizon/features/offline_video/presentation/cubit/offline_video_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:video_player/video_player.dart';

class Details extends StatefulWidget {
  const Details({super.key, required this.id, this.videoId, this.videoUrl});
  final String id;
  final int? videoId;
  final String? videoUrl;
  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  bool _isFullScreen = false;
  int selectedType = 0;
  bool _showVideoPlayer = false;
  int? currentVideoId;
  VideoPlayerController? _videoController;
  bool isFullScreen = false;
  bool isVideoPlaying = false;
  bool _controlsVisible = true;
  double _playbackSpeed = 1.0;
  String? _currentVideoUrl;
  String? _currentVideoTitle;
  String? _currentVideoId;
  bool _hasRequestedDownload = false;
  String? _openedPdfLink;
  String? _openedPdfName;
  final OfflineVideoCubit _offlineVideoCubit = instance<OfflineVideoCubit>();
  final ViewVideoCubit _viewVideoCubit = instance<ViewVideoCubit>();

  void _openPdfInScreen(String pdfLink, String name) {
    final isPlaying = _videoController?.value.isPlaying ?? false;
    if (isPlaying) {
      setState(() {
        _openedPdfLink = pdfLink;
        _openedPdfName = name;
      });
      return;
    }
    AppFunctions.navigateTo(context, PdfView(pdfLink: pdfLink, name: name));
  }

  @override
  void initState() {
    super.initState();
    if (widget.videoId != null) {
      currentVideoId = widget.videoId;
      _showVideoPlayer = true;
      selectedType = 1;
    }
  }

  @override
  void dispose() {
    _offlineVideoCubit.close();
    _viewVideoCubit.close();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  Future<void> _initializeVideoPlayer(CourseModel? course) async {
    final url = widget.videoUrl ?? course?.videoUrl;
    if (url == null || url.isEmpty) return;

    // New video selected → reset download flag
    if (url != _currentVideoUrl) {
      _hasRequestedDownload = false;
    }

    _currentVideoUrl = url;
    _currentVideoTitle = course?.name ?? '';
    _currentVideoId = (widget.videoId ?? course?.id ?? '').toString();

    _videoController?.dispose();
    _videoController = VideoPlayerController.networkUrl(Uri.parse(url));
    await _videoController!.initialize();
    await _videoController!.setPlaybackSpeed(_playbackSpeed);
    await _videoController!.play();
    if (mounted) {
      setState(() {});
    }
  }

  String _speedLabel(double speed) {
    if (speed == speed.toInt()) {
      return '${speed.toInt()}x';
    }
    return '${speed}x';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          instance<CourseDetailsCubit>()..getCourseDetails(widget.id),
      child: BlocConsumer<CourseDetailsCubit, BaseState<CourseDetailsModel>>(
        listener: (context, state) {
          if (state.isSuccess) {
            _initializeVideoPlayer(state.data?.data);
          }
        },
        builder: (context, state) {
          final courseDetails = state.data?.data;
          return SafeArea(
            child: Scaffold(
              bottomNavigationBar: _subscribeButton(),
              body: Stack(
                children: [
                  state.status == Status.loading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : state.status == Status.failure
                          ? DefaultErrorWidget(
                              errorMessage: state.errorMessage ?? '')
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _youtubePlayer(courseDetails),
                                Expanded(
                                  child: _openedPdfLink != null
                                      ? Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12.w,
                                                  vertical: 8.h),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 40.w,
                                                    height: 4.h,
                                                    decoration: BoxDecoration(
                                                      color: ColorManager
                                                          .grayColor2,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.r),
                                                    ),
                                                  ),
                                                  SizedBox(width: 12.w),
                                                  Expanded(
                                                    child: Text(
                                                      _openedPdfName ?? '',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _openedPdfLink = null;
                                                        _openedPdfName = null;
                                                      });
                                                    },
                                                    icon:
                                                        const Icon(Icons.close),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: SfPdfViewerTheme(
                                                data: SfPdfViewerThemeData(
                                                  backgroundColor: Colors.white,
                                                ),
                                                child: SfPdfViewer.network(
                                                  _openedPdfLink!,
                                                  canShowPaginationDialog:
                                                      false,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : SingleChildScrollView(
                                          physics:
                                              const ClampingScrollPhysics(),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            spacing: 10.h,
                                            children: [
                                              if (_currentVideoUrl != null)
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15.w,
                                                      vertical: 8.h),
                                                  child: BlocBuilder<
                                                      OfflineVideoCubit,
                                                      OfflineVideoState>(
                                                    bloc: _offlineVideoCubit,
                                                    builder: (context,
                                                        offlineState) {
                                                      final isDownloading =
                                                          offlineState
                                                                  is OfflineVideoDownloading &&
                                                              offlineState
                                                                      .videoId ==
                                                                  _currentVideoId;
                                                      final isCompleted = offlineState
                                                              is OfflineVideoDownloadCompleted &&
                                                          offlineState
                                                                  .videoId ==
                                                              _currentVideoId;
                                                      final progress =
                                                          isDownloading
                                                              ? offlineState
                                                                  .progress
                                                              : null;

                                                      final String buttonText;
                                                      if (isDownloading &&
                                                          progress != null) {
                                                        buttonText =
                                                            'Downloading ${progress.percentage}%';
                                                      } else if (isCompleted) {
                                                        buttonText =
                                                            'Downloaded';
                                                      } else {
                                                        buttonText =
                                                            'Download for offline';
                                                      }

                                                      return Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        children: [
                                                          DefaultButtonWidget(
                                                            text: buttonText,
                                                            color: ColorManager
                                                                .primary,
                                                            textColor:
                                                                ColorManager
                                                                    .white,
                                                            onPressed: (isDownloading ||
                                                                    isCompleted)
                                                                ? null
                                                                : _downloadCurrentVideo,
                                                          ),
                                                          if (isDownloading &&
                                                              progress != null)
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                top: 8.h,
                                                              ),
                                                              child:
                                                                  LinearProgressIndicator(
                                                                value: progress
                                                                    .progress,
                                                                backgroundColor:
                                                                    Colors.grey
                                                                        .shade300,
                                                                color:
                                                                    ColorManager
                                                                        .primary,
                                                              ),
                                                            ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ),
                                              if (!_isFullScreen)
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15.w),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    spacing: 3.h,
                                                    children: [
                                                      Gap(10.h),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              courseDetails
                                                                      ?.teacher ??
                                                                  '',
                                                              style: context
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                color: ColorManager
                                                                    .textColor,
                                                                fontSize: 16.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                          courseDetails
                                                                      ?.grade ==
                                                                  null
                                                              ? Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(6
                                                                              .r),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: ColorManager
                                                                        .primary
                                                                        .withValues(
                                                                            alpha:
                                                                                0.3),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.r),
                                                                  ),
                                                                  child: Text(
                                                                    courseDetails
                                                                            ?.grade ??
                                                                        '',
                                                                    style: context
                                                                        .textTheme
                                                                        .bodyMedium!
                                                                        .copyWith(
                                                                      color: ColorManager
                                                                          .primary,
                                                                      fontSize:
                                                                          14.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                )
                                                              : const SizedBox
                                                                  .shrink(),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5.h,
                                                      ),
                                                      Text(
                                                        courseDetails?.name ??
                                                            '',
                                                        style: context.textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                          color: Colors.black,
                                                          fontSize: 20.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5.h,
                                                      ),
                                                      Text(
                                                        courseDetails
                                                                ?.description ??
                                                            '',
                                                        style: context.textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                          color: ColorManager
                                                              .primary,
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        maxLines: 2,
                                                      ),
                                                      SizedBox(
                                                        height: 15.h,
                                                      ),
                                                      RowForBookNumber(
                                                          filesCount: courseDetails
                                                                  ?.filesCount ??
                                                              0,
                                                          lessonsCount:
                                                              courseDetails
                                                                      ?.lessonsCount ??
                                                                  0,
                                                          voiceCount: courseDetails
                                                                  ?.voiceCount ??
                                                              0),
                                                      SizedBox(
                                                        height: 15.h,
                                                      ),
                                                      SelectType(
                                                        addressCallback:
                                                            (selectedValue) {
                                                          setState(() {
                                                            selectedType =
                                                                selectedValue;
                                                          });
                                                        },
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    10.w),
                                                        child: selectedType == 0
                                                            ? CourseDetails(
                                                                text: courseDetails
                                                                        ?.whatYouWillLearn ??
                                                                    '',
                                                                id: courseDetails
                                                                        ?.id ??
                                                                    0,
                                                                course:
                                                                    courseDetails,
                                                                onOpenPdf:
                                                                    _openPdfInScreen,
                                                              )
                                                            : selectedType == 1
                                                                ? BlocProvider
                                                                    .value(
                                                                    value:
                                                                        _viewVideoCubit,
                                                                    child: Builder(
                                                                        builder:
                                                                            (context) {
                                                                      return Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          BlocBuilder<
                                                                              ViewVideoCubit,
                                                                              BaseState>(
                                                                            builder:
                                                                                (context, state) {
                                                                              if (state.status == Status.loading) {
                                                                                return const Padding(
                                                                                  padding: EdgeInsets.only(bottom: 10),
                                                                                  child: LinearProgressIndicator(),
                                                                                );
                                                                              }
                                                                              return const SizedBox.shrink();
                                                                            },
                                                                          ),
                                                                          LecturesWidget(
                                                                            id: courseDetails?.id ??
                                                                                0,
                                                                            lessonId:
                                                                                widget.videoId,
                                                                            onSelected:
                                                                                (lesson) {
                                                                              if (lesson.videoUrl != null) {
                                                                                if (instance<AppPreferences>().getToken().isNotEmpty) {
                                                                                  _viewVideoCubit.viewVideo(lesson.id ?? 0);
                                                                                }
                                                                                _initializeVideoPlayer(courseDetails?.copyWith(videoUrl: lesson.videoUrl));
                                                                                _showVideoPlayer = true;
                                                                                setState(() {});
                                                                              }
                                                                            },
                                                                          ),
                                                                        ],
                                                                      );
                                                                    }),
                                                                  )
                                                                : VoiceNote(
                                                                    id: courseDetails
                                                                            ?.id ??
                                                                        0),
                                                      ),
                                                      Gap(5.h),
                                                      CustomTitle(
                                                          title: AppStrings
                                                              .teacher
                                                              .tr()),
                                                      TeacherView(
                                                        onTap: () {
                                                          _videoController
                                                              ?.pause();
                                                        },
                                                      ),
                                                      Gap(30.h),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                ),
                              ],
                            ),
                  PositionedDirectional(
                    child: IconButton(
                      onPressed: () async {
                        await Future.wait([
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.portraitUp,
                            DeviceOrientation.portraitDown,
                          ]),
                          if (!(defaultTargetPlatform ==
                              TargetPlatform.iOS)) ...[
                            SystemChrome.setPreferredOrientations(
                                DeviceOrientation.values),
                            SystemChrome.setEnabledSystemUIMode(
                              SystemUiMode.manual,
                              overlays: SystemUiOverlay.values,
                            ),
                          ]
                        ]);
                        Navigator.pop(context);
                      },
                      style: const ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(ColorManager.primary),
                      ),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: ColorManager.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _youtubePlayer(CourseModel? course) {
    if (!_showVideoPlayer) {
      return DefaultImageWidget(
        height: MediaQuery.of(context).size.height * .3,
        width: double.infinity,
        image: course?.image ?? '',
      );
    }

    return Stack(
      children: [
        _videoController != null && _videoController!.value.isInitialized
            ? GestureDetector(
                onTap: () {
                  // Toggle controls visibility on tap
                  setState(() {
                    _controlsVisible = !_controlsVisible;
                  });
                },
                child: Stack(
                  children: [
                    Center(
                      child: SizedBox(
                        height: _isFullScreen
                            ? MediaQuery.of(context).size.height
                            : MediaQuery.of(context).size.height * .3,
                        child: AspectRatio(
                          aspectRatio: _videoController!.value.aspectRatio,
                          child: VideoPlayer(_videoController!),
                        ),
                      ),
                    ),
                    // Controls overlay
                    Positioned.fill(
                      child: _buildVideoControls(),
                    ),
                  ],
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  Widget _buildVideoControls() {
    if (_videoController == null || !_videoController!.value.isInitialized) {
      return const SizedBox.shrink();
    }
    if (!_controlsVisible) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      ignoring: false,
      child: ValueListenableBuilder<VideoPlayerValue>(
        valueListenable: _videoController!,
        builder: (context, value, child) {
          final position = value.position;
          final duration = value.duration;
          final bool isPlaying = value.isPlaying;

          double maxSeconds =
              duration.inSeconds > 0 ? duration.inSeconds.toDouble() : 1.0;
          double currentSeconds =
              position.inSeconds.clamp(0, duration.inSeconds).toDouble();

          void seekRelative(int seconds) {
            final target = position + Duration(seconds: seconds);
            Duration clamped;
            if (target < Duration.zero) {
              clamped = Duration.zero;
            } else if (target > duration) {
              clamped = duration;
            } else {
              clamped = target;
            }
            _videoController!.seekTo(clamped);
          }

          Future<void> toggleFullScreen() async {
            if (_isFullScreen) {
              await Future.wait([
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown,
                ]),
                if (!(defaultTargetPlatform == TargetPlatform.iOS)) ...[
                  SystemChrome.setPreferredOrientations(
                      DeviceOrientation.values),
                  SystemChrome.setEnabledSystemUIMode(
                    SystemUiMode.manual,
                    overlays: SystemUiOverlay.values,
                  ),
                ]
              ]);
            } else {
              await Future.wait([
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.landscapeLeft,
                  DeviceOrientation.landscapeRight,
                ]),
                SystemChrome.setEnabledSystemUIMode(
                  SystemUiMode.manual,
                  overlays: const [],
                ),
              ]);
            }
            if (mounted) {
              setState(() {
                _isFullScreen = !_isFullScreen;
              });
            }
          }

          String formatDuration(Duration d) {
            String two(int n) => n.toString().padLeft(2, '0');
            final int minutes = d.inMinutes;
            final int seconds = d.inSeconds.remainder(60);
            return '${two(minutes)}:${two(seconds)}';
          }

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black54,
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.replay_10, color: Colors.white),
                        onPressed: () {
                          seekRelative(10);
                        },
                      ),
                      IconButton(
                        iconSize: 48,
                        color: Colors.white,
                        icon: Icon(
                          isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle,
                        ),
                        onPressed: () {
                          if (isPlaying) {
                            _videoController!.pause();
                          } else {
                            _videoController!.play();
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.forward_10, color: Colors.white),
                        onPressed: () {
                          seekRelative(-10);
                        },
                      ),
                    ],
                  ),
                ),
                // Center play / pause button
                // Expanded(
                //   child: Center(
                //     child:
                //   ),
                // ),
                // Bottom controls: -10, progress, +10, fullscreen
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    //   mainAxisSize: MainAxisSize.min,
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Time + progress + fullscreen
                      Row(
                        children: [
                          Text(
                            formatDuration(position),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                          Expanded(
                            child: Slider(
                              activeColor: Colors.redAccent,
                              inactiveColor: Colors.white38,
                              min: 0,
                              max: maxSeconds,
                              value: currentSeconds,
                              onChanged: (v) {
                                final newPosition =
                                    Duration(seconds: v.toInt());
                                _videoController!.seekTo(newPosition);
                              },
                            ),
                          ),
                          PopupMenuButton<double>(
                            initialValue: _playbackSpeed,
                            color: Colors.black87,
                            onSelected: (speed) async {
                              _playbackSpeed = speed;
                              await _videoController?.setPlaybackSpeed(speed);
                              if (mounted) setState(() {});
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                  value: 0.5,
                                  child: Text('0.5x',
                                      style: TextStyle(color: Colors.white))),
                              PopupMenuItem(
                                  value: 0.75,
                                  child: Text('0.75x',
                                      style: TextStyle(color: Colors.white))),
                              PopupMenuItem(
                                  value: 1.0,
                                  child: Text('1x',
                                      style: TextStyle(color: Colors.white))),
                              PopupMenuItem(
                                  value: 1.25,
                                  child: Text('1.25x',
                                      style: TextStyle(color: Colors.white))),
                              PopupMenuItem(
                                  value: 1.5,
                                  child: Text('1.5x',
                                      style: TextStyle(color: Colors.white))),
                              PopupMenuItem(
                                  value: 2.0,
                                  child: Text('2x',
                                      style: TextStyle(color: Colors.white))),
                            ],
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                _speedLabel(_playbackSpeed),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _isFullScreen
                                  ? Icons.fullscreen_exit
                                  : Icons.fullscreen,
                              color: Colors.white,
                              size: 22,
                            ),
                            onPressed: () {
                              toggleFullScreen();
                            },
                          ),
                        ],
                      ),
                      // +/- 10 seconds row
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _downloadCurrentVideo() {
    if (_currentVideoUrl == null || _currentVideoId == null) return;
    if (_hasRequestedDownload) return;

    final video = DownloadableVideo(
      videoId: _currentVideoId!,
      downloadUrl: _currentVideoUrl!,
      title: _currentVideoTitle?.isNotEmpty == true
          ? _currentVideoTitle!
          : 'Video',
    );

    _offlineVideoCubit.downloadVideo(video);
    _hasRequestedDownload = true;
    AppFunctions.showsToast(
      'Download started',
      ColorManager.primary,
      context,
    );
  }

  double calculateAspectRatio() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return screenHeight / screenWidth;
  }

  _subscribeButton() {
    return BlocBuilder<CourseDetailsCubit, BaseState<CourseDetailsModel>>(
      builder: (context, courseState) {
        if (!courseState.isSuccess || _isFullScreen) {
          return const SizedBox.shrink();
        }
        return StatefulBuilder(
          builder: (context, setState) {
            return courseState.data?.data?.isSubscribed != 1
                ? Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 5.h, 20.w, 20.h),
                    child: BlocProvider(
                      create: (context) => instance<SubscribeTeacherCubit>(),
                      child: BlocConsumer<SubscribeTeacherCubit,
                          BaseState<String>>(
                        listener: (context, state) {
                          if (state.status == Status.success) {
                            if (instance<AppPreferences>()
                                    .getUserIsAppleReview() !=
                                1) {
                              AppFunctions.navigateTo(context,
                                  DigitalPaymentView(url: state.data ?? ''));
                            } else {
                              courseState.data?.data?.isSubscribed = 1;
                              setState(() {});
                            }
                          } else if (state.status == Status.failure) {
                            AppFunctions.showsToast(state.errorMessage ?? '',
                                ColorManager.red, context);
                          }
                        },
                        builder: (context, subscribeState) {
                          return DefaultButtonWidget(
                              text:
                                  "${AppStrings.subscribe.tr()} - ${courseState.data?.data?.price ?? ''} ${AppStrings.pound.tr()}",
                              color: ColorManager.primary,
                              textColor: ColorManager.white,
                              onPressed: () async {
                                if (instance<AppPreferences>()
                                        .getUserIsAppleReview() ==
                                    1) {
                                  try {
                                    await Purchases.purchaseStoreProduct(
                                        const StoreProduct(
                                            "elmotamizon_mon",
                                            "Access Courses for 1 month",
                                            "Access Course - Monthly",
                                            0.99,
                                            "0.99",
                                            "USD"));
                                  } catch (e) {}
                                }
                                context
                                    .read<SubscribeTeacherCubit>()
                                    .subscribeTeacher(
                                      teacherId:
                                          courseState.data?.data?.id ?? 0,
                                    );
                              },
                              isLoading:
                                  subscribeState.status == Status.loading);
                        },
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          },
        );
      },
    );
  }
}

class SelectType extends StatefulWidget {
  const SelectType({
    super.key,
    required this.addressCallback,
  });
  final Function(int selectedValue) addressCallback;
  @override
  State<SelectType> createState() => _SelectTypeState();
}

class _SelectTypeState extends State<SelectType> {
  int selectedValue = 0;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // height: 100,
        // width: context.screenWidth,
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: ColorManager.grayColor2,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          spacing: 15,
          children: [
            Expanded(
              child: Center(
                child: selectedValue == 0
                    ? const ContainerWidget(text: "تفاصيل الكورس")
                    : TypeText(
                        onTap: () {
                          setState(() {
                            selectedValue = 0;
                            widget.addressCallback(0);
                          });
                        },
                        text: "تفاصيل الكورس"),
              ),
            ),
            // const Spacer(),
            Expanded(
              child: Center(
                child: selectedValue == 1
                    ? const ContainerWidget(text: "محاضرات")
                    : TypeText(
                        onTap: () {
                          setState(() {
                            selectedValue = 1;
                            widget.addressCallback(1);
                          });
                        },
                        text: "محاضرات"),
              ),
            ),
            // const Spacer(),
            Expanded(
              child: Center(
                child: selectedValue == 2
                    ? const ContainerWidget(text: "فويس نوت")
                    : TypeText(
                        onTap: () {
                          setState(() {
                            selectedValue = 2;
                            widget.addressCallback(2);
                          });
                        },
                        text: "فويس نوت",
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TypeText extends StatelessWidget {
  const TypeText({
    super.key,
    required this.text,
    required this.onTap,
  });
  final String text;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(maxWidth: 130.w),
        child: Text(
          text,
          style: context.textTheme.bodyMedium!.copyWith(
            color: ColorManager.borderColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
        ),
      ),
    );
  }
}

class ContainerWidget extends StatelessWidget {
  const ContainerWidget({
    super.key,
    required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.r),
      width: 120.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Text(
        text,
        style: context.textTheme.bodyMedium!.copyWith(
          color: ColorManager.textGrayColor,
          fontSize: 13.sp,
          fontWeight: FontWeight.bold,
        ),
        maxLines: 2,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class TextItem extends StatelessWidget {
  const TextItem({
    super.key,
    required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.textTheme.bodyMedium!.copyWith(
        color: ColorManager.textGrayColor,
        fontSize: 15.sp,
        fontWeight: FontWeight.bold,
      ),
      maxLines: 2,
    );
  }
}
