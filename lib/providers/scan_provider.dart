import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/platform_utils.dart';
import '../services/camera_service.dart';
import '../services/input_image_converter.dart';
import '../services/ocr_service.dart';
import 'currency_provider.dart';

enum ScanStatus {
  initializing,
  scanning,
  found,
  notFound,
  error,
  unsupported,
}

class ScanState {
  const ScanState({
    required this.status,
    this.detectedPrice,
    this.detectedProductName,
    this.rawOcrText,
    this.errorMessage,
    this.cameraController,
  });

  final ScanStatus status;
  final double? detectedPrice;
  final String? detectedProductName;
  final String? rawOcrText;
  final String? errorMessage;
  final CameraController? cameraController;

  ScanState copyWith({
    ScanStatus? status,
    double? detectedPrice,
    String? detectedProductName,
    String? rawOcrText,
    String? errorMessage,
    CameraController? cameraController,
    bool clearDetectedPrice = false,
    bool clearDetectedProductName = false,
    bool clearRawOcrText = false,
    bool clearErrorMessage = false,
  }) {
    return ScanState(
      status: status ?? this.status,
      detectedPrice:
          clearDetectedPrice ? null : (detectedPrice ?? this.detectedPrice),
      detectedProductName: clearDetectedProductName
          ? null
          : (detectedProductName ?? this.detectedProductName),
      rawOcrText: clearRawOcrText ? null : (rawOcrText ?? this.rawOcrText),
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      cameraController: cameraController ?? this.cameraController,
    );
  }
}

class ScanNotifier extends AutoDisposeNotifier<ScanState> {
  CameraService? _cameraService;
  OcrService? _ocrService;
  var _initialized = false;

  @override
  ScanState build() {
    if (!isMobilePlatform) {
      return const ScanState(status: ScanStatus.unsupported);
    }

    ref.onDispose(() {
      _cleanup();
    });

    ref.listen(currencyProvider, (_, _) {});

    if (!_initialized) {
      _initialized = true;
      Future.microtask(_initialize);
    }

    return const ScanState(status: ScanStatus.initializing);
  }

  Future<void> _initialize() async {
    _cameraService = CameraService();
    _ocrService = OcrService();

    try {
      await _cameraService!.initialize();

      final controller = _cameraService!.controller!;

      state = ScanState(
        status: ScanStatus.scanning,
        cameraController: controller,
      );

      await _cameraService!.startImageStream(_processFrame);
    } on CameraException catch (e) {
      state = ScanState(
        status: ScanStatus.error,
        errorMessage: _mapCameraError(e),
      );
    } catch (e) {
      state = ScanState(
        status: ScanStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> _processFrame(CameraImage image) async {
    if (_ocrService == null) return;

    final controller = _cameraService?.controller;
    final description = _cameraService?.description;
    if (controller == null || description == null) return;

    final inputImage = InputImageConverter(
      sensorOrientation: description.sensorOrientation,
      lensDirection: description.lensDirection,
      deviceOrientation: controller.value.deviceOrientation,
    ).fromCameraImage(image);
    if (inputImage == null) return;

    final currency = ref.read(currencyProvider);
    final result = await _ocrService!.scanFrame(
      inputImage,
      currency: currency,
    );

    if (result != null) {
      state = state.copyWith(
        status: ScanStatus.found,
        detectedPrice: result.price,
        detectedProductName: result.productName,
        rawOcrText: result.rawPriceText,
        clearErrorMessage: true,
      );
    } else if (state.status != ScanStatus.found) {
      state = state.copyWith(
        status: ScanStatus.notFound,
        clearDetectedPrice: true,
        clearDetectedProductName: true,
        clearRawOcrText: true,
      );
    }
  }

  void resetDetection() {
    state = state.copyWith(
      status: ScanStatus.scanning,
      clearDetectedPrice: true,
      clearDetectedProductName: true,
      clearRawOcrText: true,
      clearErrorMessage: true,
    );
  }

  Future<void> toggleTorch() async {
    await _cameraService?.toggleTorch();
  }

  Future<void> _cleanup() async {
    await _cameraService?.dispose();
    await _ocrService?.close();
    _cameraService = null;
    _ocrService = null;
  }

  String _mapCameraError(CameraException e) {
    switch (e.code) {
      case 'CameraAccessDenied':
        return 'Camera access was denied. Enable it in Settings.';
      case 'CameraAccessDeniedWithoutPrompt':
        return 'Please enable camera access in Settings.';
      case 'CameraAccessRestricted':
        return 'Camera access is restricted on this device.';
      default:
        return e.description ?? 'Camera error: ${e.code}';
    }
  }
}

final scanProvider =
    NotifierProvider.autoDispose<ScanNotifier, ScanState>(ScanNotifier.new);
