import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter_webrtc_demo/models/renderers.dart';
import 'package:flutter_webrtc_demo/services/webrtc_service.dart';
import 'package:flutter_webrtc_demo/utils/extensions.dart';
import 'package:flutter_webrtc_demo/views/home_screen.dart';
import 'package:flutter_webrtc_demo/views/widgets/control_menu.dart';
import 'package:flutter_webrtc_demo/views/widgets/video_renderer.dart';

class RoomView extends ConsumerStatefulWidget {
  final MediaStream? stream;
  const RoomView(this.stream, {super.key});

  @override
  ConsumerState<RoomView> createState() => _RoomState();
}

class _RoomState extends ConsumerState<RoomView> {
  bool isMicEnabled = true;
  bool isWebCamEnabled = true;
  late RTCPeerConnection peerConnection;
  late RTCVideoRenderer localRenderer;
  late RTCVideoRenderer remoteRenderer;

  @override
  initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    peerConnection = ref.read(rtcServiceProvider).requireValue.peerConnection;
    localRenderer = ref.read(localRendererProvider);
    remoteRenderer = ref.read(remoteRendererProvider);

    await localRenderer.initialize();
    await remoteRenderer.initialize();

    final remoteStreams = peerConnection.getRemoteStreams();

    localRenderer.srcObject = widget.stream;

    if (peerConnection.getRemoteStreams().isEmpty) {
      peerConnection.onAddStream = (stream) {
        stream
            .getTracks()
            .forEach((track) => peerConnection.addTrack(track, stream));
        remoteRenderer.srcObject = stream;

        setState(() {});
      };
    } else {
      remoteRenderer.srcObject = remoteStreams[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = context.mediaQuery.size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.8,
                child: Column(
                  children: [
                    Expanded(
                      child: VideoRendererWidget(
                        localRenderer,
                        isMirrored: true,
                      ),
                    ),
                    Expanded(
                      child: VideoRendererWidget(
                        remoteRenderer,
                      ),
                    ),
                  ],
                ),
              ),
              RoomControlMenu(
                iconSize: 24,
                isMicEnabled: isMicEnabled,
                isWebcamEnabled: isWebCamEnabled,
                onCallEndButtonPressed: () async {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                },
                onMicButtonPressed: () async {
                  final stream = localRenderer.srcObject;
                  if (stream != null) {
                    stream.getTracks().forEach(
                      (track) {
                        if (track.kind == 'audio') {
                          track.enabled = !track.enabled;
                        }
                      },
                    );

                    setState(() {
                      isMicEnabled = !isMicEnabled;
                    });
                  }
                },
                onWebcamButtonPressed: () async {
                  final stream = localRenderer.srcObject;
                  if (stream != null) {
                    stream.getTracks().forEach(
                      (track) {
                        if (track.kind == 'video') {
                          track.enabled = !track.enabled;
                        }
                      },
                    );
                    setState(() {
                      isWebCamEnabled = !isWebCamEnabled;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
