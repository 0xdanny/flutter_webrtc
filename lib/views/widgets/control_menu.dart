import 'package:flutter/material.dart';
import 'package:flutter_webrtc_demo/constants/colors.dart';

import 'action_button.dart';

class RoomControlMenu extends StatelessWidget {
  final bool isMicEnabled;
  final bool isWebcamEnabled;
  final double iconSize;
  final VoidCallback onCallEndButtonPressed;
  final VoidCallback onMicButtonPressed;
  final VoidCallback onWebcamButtonPressed;

  const RoomControlMenu({
    super.key,
    required this.isMicEnabled,
    required this.isWebcamEnabled,
    required this.onCallEndButtonPressed,
    required this.onMicButtonPressed,
    required this.onWebcamButtonPressed,
    this.iconSize = 30,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: SizedBox(
        width: size.width * 0.85,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // End Call Button
            GestureDetector(
              onTap: onCallEndButtonPressed,
              child: SizedBox(
                width: size.width * 0.2,
                child: ActionButton(
                  backgroundColor: Colors.red,
                  onPressed: onCallEndButtonPressed,
                  icon: Icons.call_end,
                  iconSize: iconSize,
                ),
              ),
            ),

            // Microphone Control
            GestureDetector(
              onTap: onMicButtonPressed,
              child: SizedBox(
                width: size.width * 0.2,
                child: ActionButton(
                  onPressed: onMicButtonPressed,
                  backgroundColor: isMicEnabled
                      ? AppColors.hoverColor
                      : AppColors.secondaryColor.withOpacity(0.8),
                  icon: isMicEnabled ? Icons.mic : Icons.mic_off,
                  iconSize: iconSize,
                ),
              ),
            ),

            // Video Control
            GestureDetector(
              onTap: onWebcamButtonPressed,
              child: SizedBox(
                width: size.width * 0.2,
                child: ActionButton(
                  onPressed: onWebcamButtonPressed,
                  backgroundColor: isWebcamEnabled
                      ? AppColors.hoverColor
                      : AppColors.secondaryColor.withOpacity(0.8),
                  icon: isWebcamEnabled ? Icons.videocam : Icons.videocam_off,
                  iconSize: iconSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
