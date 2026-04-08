import 'package:easy_localization/easy_localization.dart';
import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/features/home/details/models/voice_note_model.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VoicePlayer extends StatefulWidget {
  final VoiceNoteModel voiceNote;

  const VoicePlayer({
    super.key,
    required this.voiceNote,
  });

  @override
  State<VoicePlayer> createState() => _VoicePlayerState();
}

class _VoicePlayerState extends State<VoicePlayer> {
  final AudioPlayer _player = AudioPlayer();
  bool isPlaying = false;
  bool isLoading = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();

    // Listen for duration changes
    _player.onDurationChanged.listen((d) {
      setState(() => duration = d);
    });

    // Listen for position changes
    _player.onPositionChanged.listen((p) {
      setState(() => position = p);
    });

    // Listen for player state to manage loading/playing UI
    _player.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
        // Stop loading once player transitions out of loading into any stable state
        if (state == PlayerState.playing ||
            state == PlayerState.paused ||
            state == PlayerState.stopped ||
            state == PlayerState.completed) {
          isLoading = false;
        }
      });
    });

    // When audio completes
    _player.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
        position = Duration.zero;
      });
    });
  }

  Future<void> _togglePlayPause() async {
    try {
      if (widget.voiceNote.isFree == 1 || widget.voiceNote.isSubscribed == 1) {

        if (isPlaying) {
          await _player.pause();
          setState(() {
            isPlaying = false;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = true;
          });
          await _player.play(UrlSource(widget.voiceNote.file ?? ''));
        }
        // isPlaying will be updated via onPlayerStateChanged
      } else {
        AppFunctions.showsToast(
            AppStrings.subscribeFirst.tr(), ColorManager.red, context);
      }
    }catch(e){
      AppFunctions.showsToast(
          AppStrings.downloadFailed.tr(), ColorManager.red, context);
      setState(() {
        isLoading = false;
      });
    }
  }


  String _formatTime(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 12.h),
      elevation: 0,
      child: Row(
        children: [
          // Play / Pause button
          Stack(
            alignment: Alignment.center,
            children: [
              if (isLoading)
                SizedBox(
                  width: 48.r,
                  height: 48.r,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: widget.voiceNote.isFree==1 || widget.voiceNote.isSubscribed==1 ? ColorManager.primary : ColorManager.grey,
                  ),
                ),
              IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause_circle : Icons.play_circle,
                  size: 42.r,
                  color: widget.voiceNote.isFree==1 || widget.voiceNote.isSubscribed==1 ? ColorManager.primary : ColorManager.grey,
                ),
                onPressed: isLoading ? null : _togglePlayPause,
              ),
            ],
          ),

          SizedBox(width: 10.w,),
          // Expanded middle section with title + slider
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.voiceNote.name??'',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    // Current time
                    Text(
                      _formatTime(position),
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 32.h,
                        child: WavyProgress(
                          progress: duration.inMilliseconds == 0
                              ? 0
                              : (position.inMilliseconds /
                                      duration.inMilliseconds)
                                  .clamp(0.0, 1.0),
                          activeColor:
                              Theme.of(context).colorScheme.primary,
                          inactiveColor: Colors.grey.shade300,
                          onSeek: (relative) async {
                            if (duration.inMilliseconds == 0) return;
                            final targetMs =
                                (relative * duration.inMilliseconds).toInt();
                            final newPos =
                                Duration(milliseconds: targetMs.clamp(0, duration.inMilliseconds));
                            await _player.seek(newPos);
                            await _player.resume();
                          },
                        ),
                      ),
                    ),
                    // Total time
                    Text(
                      _formatTime(duration),
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WavyProgress extends StatelessWidget {
  final double progress; // 0..1
  final Color activeColor;
  final Color inactiveColor;
  final ValueChanged<double>? onSeek; // value 0..1

  const WavyProgress({
    super.key,
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
    this.onSeek,
  });

  void _handleSeek(BuildContext context, Offset localPosition, Size size) {
    if (onSeek == null || size.width <= 0) return;
    final clamped = (localPosition.dx / size.width).clamp(0.0, 1.0);
    onSeek!(clamped);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (d) => _handleSeek(
            context,
            d.localPosition,
            Size(constraints.maxWidth, constraints.maxHeight),
          ),
          onHorizontalDragStart: (d) => _handleSeek(
            context,
            d.localPosition,
            Size(constraints.maxWidth, constraints.maxHeight),
          ),
          onHorizontalDragUpdate: (d) => _handleSeek(
            context,
            d.localPosition,
            Size(constraints.maxWidth, constraints.maxHeight),
          ),
          child: CustomPaint(
            painter: _WavyPainter(
              progress: progress.clamp(0.0, 1.0),
              activeColor: activeColor,
              inactiveColor: inactiveColor,
            ),
          ),
        );
      },
    );
  }
}

class _WavyPainter extends CustomPainter {
  final double progress; // 0..1
  final Color activeColor;
  final Color inactiveColor;

  _WavyPainter({
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double amplitude = (size.height / 2) * 0.6; // wave height
    final double baselineY = size.height / 2; // vertical center
    final double wavelength = size.width / 6; // number of waves across

    Path buildWavePath() {
      final path = Path();
      path.moveTo(0, baselineY);
      for (double x = 0; x <= size.width; x += 2) {
        final y = baselineY +
            amplitude *
                (MathUtils.fastSin(2 * 3.141592653589793 * x / wavelength));
        path.lineTo(x, y);
      }
      // bottom close to make a thick stroke-like fill
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
      return path;
    }

    final Path wavePath = buildWavePath();

    final Paint inactivePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = inactiveColor.withValues(alpha: 0.5);

    final Paint activePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = activeColor.withValues(alpha: 0.9);

    // Draw inactive wave across full width
    canvas.drawPath(wavePath, inactivePaint);

    // Clip to progress and draw active wave
    final double clipWidth = size.width * progress;
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, clipWidth, size.height));
    canvas.drawPath(wavePath, activePaint);
    canvas.restore();

    // Draw a thin baseline over it for clarity
    final Paint linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = inactiveColor.withValues(alpha: 0.7);
    canvas.drawLine(Offset(0, baselineY), Offset(size.width, baselineY), linePaint);
  }

  @override
  bool shouldRepaint(covariant _WavyPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor;
  }
}

// Lightweight math utility for fast sine without importing dart:math repeatedly
class MathUtils {
  static const double _pi2 = 6.283185307179586;

  static double fastSin(double x) {
    // Wrap x to -pi..pi for stability
    x = x % _pi2;
    if (x > 3.141592653589793) x -= _pi2;
    if (x < -3.141592653589793) x += _pi2;
    // Bhaskara I's sine approximation (good enough for UI)
    final double a = 16 * x * (3.141592653589793 - x);
    final double b = 5 * 3.141592653589793 * 3.141592653589793 - 4 * x * (3.141592653589793 - x);
    return a / b;
  }
}
