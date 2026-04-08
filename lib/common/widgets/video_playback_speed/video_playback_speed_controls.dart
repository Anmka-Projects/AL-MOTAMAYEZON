import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'video_playback_speed.dart';

/// Playback speed as a compact dropdown (numeric labels only) + brief overlay on change.
///
/// Place inside a [Stack] above your [VideoPlayer].
class VideoPlaybackSpeedControls extends StatefulWidget {
  const VideoPlaybackSpeedControls({
    super.key,
    required this.controller,
    this.alignment = Alignment.topRight,
    this.padding = const EdgeInsets.all(8),
    this.feedbackDuration = const Duration(milliseconds: 1600),
  });

  final VideoPlayerController controller;

  final Alignment alignment;

  final EdgeInsets padding;

  final Duration feedbackDuration;

  @override
  State<VideoPlaybackSpeedControls> createState() =>
      _VideoPlaybackSpeedControlsState();
}

class _VideoPlaybackSpeedControlsState extends State<VideoPlaybackSpeedControls>
    with SingleTickerProviderStateMixin {
  Timer? _feedbackTimer;
  String? _feedbackText;
  late AnimationController _fadeController;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _fade = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _feedbackTimer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _onSpeedSelected(double? speed) async {
    if (speed == null) return;
    if (!widget.controller.value.isInitialized) return;

    final ok = await VideoPlaybackSpeed.apply(widget.controller, speed);
    if (!mounted || !ok) return;

    _showFeedback(VideoPlaybackSpeed.numericLabel(speed));
  }

  void _showFeedback(String text) {
    _feedbackTimer?.cancel();
    setState(() {
      _feedbackText = text;
    });
    _fadeController.forward(from: 0);
    _feedbackTimer = Timer(widget.feedbackDuration, () {
      if (!mounted) return;
      _fadeController.reverse().then((_) {
        if (mounted) {
          setState(() => _feedbackText = null);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Align(
          alignment: widget.alignment,
          child: Padding(
            padding: widget.padding,
            child: ValueListenableBuilder<VideoPlayerValue>(
              valueListenable: widget.controller,
              builder: (context, value, _) {
                final current = VideoPlaybackSpeed.resolveSupported(
                  value.playbackSpeed,
                );
                return Material(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: const Color(0xFF2C2C2C),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<double>(
                          value: current,
                          borderRadius: BorderRadius.circular(8),
                          dropdownColor: const Color(0xFF2C2C2C),
                          icon: const Icon(
                            Icons.speed_rounded,
                            color: Colors.white70,
                            size: 22,
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          isDense: true,
                          items: VideoPlaybackSpeed.supported
                              .map(
                                (s) => DropdownMenuItem<double>(
                                  value: s,
                                  child: Text(
                                    VideoPlaybackSpeed.numericLabel(s),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: _onSpeedSelected,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        if (_feedbackText != null)
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: FadeTransition(
                  opacity: _fade,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.72),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 16,
                      ),
                      child: Text(
                        _feedbackText!,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
