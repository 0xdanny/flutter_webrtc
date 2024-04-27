import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_demo/constants/config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'webrtc_service.g.dart';

class RTCService {
  final Ref ref;
  final FirebaseFirestore signalServer;
  final RTCPeerConnection peerConnection;

  RTCService({
    required this.ref,
    required this.signalServer,
    required this.peerConnection,
  });

  Future<String> call() async {
    final callDoc = signalServer.collection('calls').doc();
    final offerCandidates = callDoc.collection('offerCandidates');
    final answerCandidates = callDoc.collection('answerCandidates');

    peerConnection.onIceCandidate = (event) {
      if (event.candidate != null) offerCandidates.add(event.toMap());
    };

    callDoc.snapshots().listen(
      (snapshot) async {
        final data = snapshot.data();
        if ((await peerConnection.getRemoteDescription() == null) &&
            data!.containsKey('answer')) {
          final answerDescription = RTCSessionDescription(
              data['answer']['sdp'], data['answer']['type']);
          peerConnection.setRemoteDescription(answerDescription);
        }
      },
    );

    answerCandidates.snapshots().listen(
      (snapshot) async {
        for (var change in snapshot.docChanges) {
          if (change.type == DocumentChangeType.added) {
            final data = change.doc.data()!;
            final candidate = RTCIceCandidate(
                data['candidate'], data['sdpMid'], data['sdpMLineIndex']);
            peerConnection.addCandidate(candidate);
          }
        }
      },
    );

    final description = await peerConnection.createOffer();
    final offer = {
      'offer': {'sdp': description.sdp, 'type': description.type}
    };

    await peerConnection.setLocalDescription(description);
    await callDoc.set(offer);

    return callDoc.id;
  }

  Future<void> answer(String roomID) async {
    final callId = roomID;
    final callDoc = signalServer.collection('calls').doc(callId);
    final answerCandidates = callDoc.collection('answerCandidates');
    final offerCandidates = callDoc.collection('offerCandidates');

    peerConnection.onIceCandidate = (event) {
      if (event.candidate != null) answerCandidates.add(event.toMap());
    };

    final callData = (await callDoc.get()).data();

    final offerDescription = callData!['offer'];
    await peerConnection.setRemoteDescription(RTCSessionDescription(
        offerDescription['sdp'], offerDescription['type']));

    final description = await peerConnection.createAnswer();
    final answer = {
      'answer': {'sdp': description.sdp, 'type': description.type}
    };

    offerCandidates.snapshots().listen(
      (snapshot) async {
        for (var change in snapshot.docChanges) {
          if (change.type == DocumentChangeType.added) {
            final data = change.doc.data()!;
            final candidate = RTCIceCandidate(
                data['candidate'], data['sdpMid'], data['sdpMLineIndex']);
            peerConnection.addCandidate(candidate);
          }
        }
      },
    );

    await peerConnection.setLocalDescription(description);
    await callDoc.update(answer);
  }
}

@riverpod
Future<RTCService> rtcService(RtcServiceRef ref) async {
  final signalServer = FirebaseFirestore.instance;
  final connection = await createPeerConnection(
    Config.webrtcConfig,
    Config.offerSdpConstraints,
  );

  final rtc = RTCService(
    ref: ref,
    signalServer: signalServer,
    peerConnection: connection,
  );

  ref.onDispose(() => rtc.peerConnection.close());

  return rtc;
}
