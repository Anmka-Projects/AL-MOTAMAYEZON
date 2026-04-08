import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'video_playback_speed.dart';

/// Numeric-only speed dropdown for [YoutubePlayerController] (embedded iframe player).
class YoutubePlaybackSpeedDropdown extends StatelessWidget {
  const YoutubePlaybackSpeedDropdown({
    super.key,
    required this.controller,
  });

  final YoutubePlayerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<YoutubePlayerValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        if (!value.isReady) {
          return const SizedBox.shrink();
        }
        final current = VideoPlaybackSpeed.resolveSupported(value.playbackRate);

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
                  onChanged: (speed) {
                    if (speed == null) return;
                    if (!VideoPlaybackSpeed.isAllowed(speed)) return;
                    controller.setPlaybackRate(speed);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
