import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import 'package:elmotamizon/features/offline_video/domain/entities/encrypted_video_metadata.dart';
import 'package:elmotamizon/features/offline_video/presentation/cubit/offline_video_cubit.dart';

/// Plays an offline (decrypted) video from a temp file and deletes the file on dispose.
/// Call [prepareAndPlay] with the metadata; the cubit will resolve the temp path.
class OfflineVideoPlayerWidget extends StatefulWidget {
  const OfflineVideoPlayerWidget({
    super.key,
    required this.metadata,
    required this.cubit,
  });

  final EncryptedVideoMetadata metadata;
  final OfflineVideoCubit cubit;

  @override
  State<OfflineVideoPlayerWidget> createState() =>
      _OfflineVideoPlayerWidgetState();
}

class _OfflineVideoPlayerWidgetState extends State<OfflineVideoPlayerWidget> {
  VideoPlayerController? _controller;
  String? _tempFilePath;
  bool _preparing = true;
  String? _error;
  bool _controlsVisible = true;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _prepareAndPlay();
  }

  Future<void> _prepareAndPlay() async {
    try {
      final path = await widget.cubit.preparePlaybackPath(widget.metadata);
      if (!mounted) return;
      _tempFilePath = path;
      _controller = VideoPlayerController.file(File(path));
      await _controller!.initialize();
      if (!mounted) return;
      setState(() {
        _preparing = false;
        _error = null;
      });
      await _controller!.play();
    } catch (e) {
      if (mounted) {
        setState(() {
          _preparing = false;
          _error = e.toString();
        });
      }
    }
  }

  @override
  void dispose() {
    _exitFullScreenIfNeeded();
    _controller?.dispose();
    _controller = null;
    if (_tempFilePath != null) {
      try {
        final file = File(_tempFilePath!);
        if (file.existsSync()) file.deleteSync();
      } catch (_) {}
      _tempFilePath = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 8),
              Text(_error!, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }
    if (_preparing || _controller == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _controlsVisible = !_controlsVisible;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: VideoPlayer(_controller!),
            ),
          ),
          if (_controlsVisible) _buildVideoControls(),
        ],
      ),
    );
  }

  Widget _buildVideoControls() {
    final controller = _controller!;

    return Positioned.fill(
      child: IgnorePointer(
        ignoring: false,
        child: Container(
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
          child: ValueListenableBuilder<VideoPlayerValue>(
            valueListenable: controller,
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
                controller.seekTo(clamped);
              }

              String formatDuration(Duration d) {
                String two(int n) => n.toString().padLeft(2, '0');
                final int minutes = d.inMinutes;
                final int seconds = d.inSeconds.remainder(60);
                return '${two(minutes)}:${two(seconds)}';
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.replay_10, color: Colors.white),
                          onPressed: () {
                            seekRelative(10);
                          },
                        ),
                        IconButton(
                          iconSize: 56,
                          color: Colors.white,
                          icon: Icon(
                            isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_filled,
                          ),
                          onPressed: () {
                            if (isPlaying) {
                              controller.pause();
                            } else {
                              controller.play();
                            }
                          },
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.forward_10, color: Colors.white),
                          onPressed: () {
                            seekRelative(-10);
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
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
                              final newPosition = Duration(seconds: v.toInt());
                              controller.seekTo(newPosition);
                            },
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
                          onPressed: _toggleFullScreen,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _toggleFullScreen() async {
    if (_isFullScreen) {
      await Future.wait([
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]),
        SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.manual,
          overlays: SystemUiOverlay.values,
        ),
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

    if (!mounted) return;
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
  }

  Future<void> _exitFullScreenIfNeeded() async {
    if (!_isFullScreen) return;
    await Future.wait([
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]),
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      ),
    ]);
  }
}
