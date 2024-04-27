# flutter_webrtc

A WebRTC P2P Demo with Flutter, Firebase and Riverpod.

## Config

### iOS

Add the following entry to your Info.plist file, located in <project root>/ios/Runner/Info.plist:

```xml
<key>NSCameraUsageDescription</key>
<string>We need access to your camera to enable video calling and conferencing features, allowing you to see and interact with other participants during calls.</string>

<key>NSMicrophoneUsageDescription</key>
<string>This app requires access to your microphone to enable audio calling and conferencing features, allowing you to communicate with other participants during calls.</string>

```

This entry allows the app to access the device's camera and microphone.

### Android

Ensure the following permission is present in your Android Manifest file, located in `<project root>/android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-feature android:name="android.hardware.camera" />
<uses-feature android:name="android.hardware.camera.autofocus" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.CHANGE_NETWORK_STATE" />
<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
```

If you need to use a Bluetooth device, add:

```xml
<uses-permission android:name="android.permission.BLUETOOTH" android:maxSdkVersion="30" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" android:maxSdkVersion="30" />
```

Also you will need to set your build settings to Java 8, because official WebRTC jar now uses static methods in `EglBase` interface. Add this to your app level `build.gradle`:

```groovy
android {
    //...
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
}
```

You might need to increase `minSdkVersion` of the `defaultConfig` to at least `23` in `build.gradle`.

### Multiuser architecture options

- WebRTC Mesh: In a mesh architecture, each participant in the room connects directly to every other participant. This is not scalable, as it requires significant bandwidth and processing power as the number of participants increases. It is suitable for small-scale video chats.

- Selective Forwarding Unit: SFU acts as an intermediary server that receives video streams from participants and selectively forwards them to other participants. It's more scalable than mesh and is the preferred choice for most video conferencing applications. It reduces bandwidth consumption and allows for more significant scalability.
