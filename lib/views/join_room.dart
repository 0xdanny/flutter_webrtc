import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter_webrtc_demo/models/renderers.dart';
import 'package:flutter_webrtc_demo/services/webrtc_service.dart';
import 'package:flutter_webrtc_demo/utils/extensions.dart';
import 'package:flutter_webrtc_demo/views/room.dart';
import 'package:flutter_webrtc_demo/views/widgets/video_renderer.dart';

class JoinRoomView extends StatefulHookConsumerWidget {
  const JoinRoomView({super.key});

  @override
  ConsumerState<JoinRoomView> createState() => _JoinRoomViewState();
}

class _JoinRoomViewState extends ConsumerState<JoinRoomView> {
  late RTCVideoRenderer localRenderer;
  late RTCService rtcService;

  @override
  initState() {
    localRenderer = ref.read(localRendererProvider);
    rtcService = ref.read(rtcServiceProvider).requireValue;
    ref.read(localRendererProvider.notifier).openCamera();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final size = context.mediaQuery.size;

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Flexible(
              child: Hero(
                tag: 'localVideo',
                child: VideoRendererWidget(localRenderer, isMirrored: true),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'RoomID',
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: size.height * 0.06,
              width: size.width * 0.7,
              child: ElevatedButton(
                onPressed: () async {
                  String roomId = controller.text;
                  await rtcService.answer(roomId);
                  if (context.mounted) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RoomView(localRenderer.srcObject),
                      ),
                    );
                  }
                },
                child: const Text('Join'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
