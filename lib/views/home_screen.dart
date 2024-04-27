import 'package:flutter/material.dart';
import 'package:flutter_webrtc_demo/utils/extensions.dart';
import 'package:flutter_webrtc_demo/views/create_room.dart';
import 'package:flutter_webrtc_demo/views/join_room.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = context.mediaQuery.size;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.06,
                width: size.width * 0.7,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CreateRoomView(),
                    ),
                  ),
                  child: const Text('Create Room'),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: size.height * 0.06,
                width: size.width * 0.7,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const JoinRoomView(),
                    ),
                  ),
                  child: const Text('Join Room'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
