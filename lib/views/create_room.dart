import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter_webrtc_demo/models/renderers.dart';
import 'package:flutter_webrtc_demo/services/webrtc_service.dart';
import 'package:flutter_webrtc_demo/utils/extensions.dart';
import 'package:flutter_webrtc_demo/views/room.dart';
import 'package:flutter_webrtc_demo/views/widgets/video_renderer.dart';

class CreateRoomView extends StatefulHookConsumerWidget {
  const CreateRoomView({super.key});

  @override
  ConsumerState<CreateRoomView> createState() => _CreateRoomState();
}

class _CreateRoomState extends ConsumerState<CreateRoomView> {
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
            Expanded(
              child: VideoRendererWidget(localRenderer, isMirrored: true),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: TextField(
                      controller: controller,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'RoomID',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: size.height * 0.06,
                    width: size.width * 0.7,
                    child: ElevatedButton(
                      onPressed: () async {
                        String roomId = await rtcService.call();
                        setState(() {
                          controller.text = roomId;
                        });
                      },
                      child: const Text('Call'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: size.height * 0.06,
                    width: size.width * 0.7,
                    child: ElevatedButton(
                      onPressed: () => {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                RoomView(localRenderer.srcObject),
                          ),
                        )
                      },
                      child: const Text('Open Room'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
