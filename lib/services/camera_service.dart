import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import '../utils/platform_utils.dart';

class CameraService {
  CameraController? _controller;
  CameraDescription? _description;
  bool _isStreaming = false;
  bool _isProcessingFrame = false;
  DateTime? _lastProcessedAt;

  static const frameThrottle = Duration(milliseconds: 700);

  CameraController? get controller => _controller;
  CameraDescription? get description => _description;
  bool get isInitialized => _controller?.value.isInitialized ?? false;
  bool get isStreaming => _isStreaming;

  Future<void> initialize() async {
    if (!isMobilePlatform) {
      throw UnsupportedError('Camera is only supported on Android and iOS.');
    }

    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      throw CameraException('noCamera', 'No cameras found on this device.');
    }

    _description = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    final isAndroid =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

    final controller = CameraController(
      _description!,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup:
          isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
    );

    await controller.initialize();
    _controller = controller;
  }

  Future<void> startImageStream(
    Future<void> Function(CameraImage image) onFrame,
  ) async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    if (_isStreaming) return;

    await controller.startImageStream((image) async {
      if (_isProcessingFrame) return;

      final now = DateTime.now();
      if (_lastProcessedAt != null &&
          now.difference(_lastProcessedAt!) < frameThrottle) {
        return;
      }

      _isProcessingFrame = true;
      _lastProcessedAt = now;
      try {
        await onFrame(image);
      } finally {
        _isProcessingFrame = false;
      }
    });

    _isStreaming = true;
  }

  Future<void> stopImageStream() async {
    final controller = _controller;
    if (controller == null || !_isStreaming) return;

    try {
      if (controller.value.isStreamingImages) {
        await controller.stopImageStream();
      }
    } catch (_) {}
    _isStreaming = false;
  }

  Future<void> toggleTorch() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    final current = controller.value.flashMode;
    await controller.setFlashMode(
      current == FlashMode.torch ? FlashMode.off : FlashMode.torch,
    );
  }

  Future<void> dispose() async {
    await stopImageStream();
    await _controller?.dispose();
    _controller = null;
    _description = null;
  }
}
