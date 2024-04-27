import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_demo/services/webrtc_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'renderers.g.dart';

@Riverpod(keepAlive: true)
class LocalRenderer extends _$LocalRenderer {
  @override
  Raw<RTCVideoRenderer> build() {
    _dispose();
    return RTCVideoRenderer();
  }

  void _dispose() {
    final peerConnection =
        ref.read(rtcServiceProvider).requireValue.peerConnection;

    ref.onDispose(() async {
      var stream = state.srcObject;

      if (stream != null) {
        stream.getTracks().forEach(
          (element) async {
            await element.stop();
          },
        );

        await stream.dispose();
        stream = null;
      }

      var senders = await peerConnection.getSenders();

      for (var element in senders) {
        peerConnection.removeTrack(element);
      }

      await state.dispose();
    });
  }

  void openCamera() async {
    final rtcService = ref.read(rtcServiceProvider);

    await state.initialize();

    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'facingMode': 'user',
      }
    };

    MediaStream stream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);
    stream.getTracks().forEach((track) =>
        rtcService.requireValue.peerConnection.addTrack(track, stream));
    state.srcObject = stream;
  }
}

@Riverpod(keepAlive: true)
Raw<RTCVideoRenderer> remoteRenderer(RemoteRendererRef ref) {
  final renderer = RTCVideoRenderer();

  ref.onDispose(() async {
    var stream = renderer.srcObject;
    if (stream != null) {
      stream.getTracks().forEach((element) async {
        await element.stop();
      });

      await stream.dispose();
      stream = null;
    }

    await renderer.dispose();
  });

  return renderer;
}
