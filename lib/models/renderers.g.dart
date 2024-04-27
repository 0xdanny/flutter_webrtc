// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'renderers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$remoteRendererHash() => r'e18c47ca242cce1d2ff90ce9f2db2c86b81d1587';

/// See also [remoteRenderer].
@ProviderFor(remoteRenderer)
final remoteRendererProvider = Provider<Raw<RTCVideoRenderer>>.internal(
  remoteRenderer,
  name: r'remoteRendererProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$remoteRendererHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RemoteRendererRef = ProviderRef<Raw<RTCVideoRenderer>>;
String _$localRendererHash() => r'19001e8015bc5231bc07964a5a1a211c510e7bd4';

/// See also [LocalRenderer].
@ProviderFor(LocalRenderer)
final localRendererProvider =
    NotifierProvider<LocalRenderer, Raw<RTCVideoRenderer>>.internal(
  LocalRenderer.new,
  name: r'localRendererProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$localRendererHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LocalRenderer = Notifier<Raw<RTCVideoRenderer>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
