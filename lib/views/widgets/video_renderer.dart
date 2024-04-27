import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoRendererWidget extends StatefulWidget {
  final RTCVideoRenderer videoRenderer;
  final double height;
  final bool isMirrored;

  const VideoRendererWidget(
    this.videoRenderer, {
    super.key,
    this.height = 210,
    this.isMirrored = false,
  });

  @override
  State<VideoRendererWidget> createState() => _VideoRendererWidgetState();
}

class _VideoRendererWidgetState extends State<VideoRendererWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Container(
        margin: const EdgeInsets.fromLTRB(1.0, 1.0, 3.0, 1.0),
        decoration: const BoxDecoration(color: Colors.black),
        child: RTCVideoView(
          widget.videoRenderer,
          mirror: widget.isMirrored,
        ),
      ),
    );
  }
}
