import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

class InputImageConverter {
  InputImageConverter({
    required this.sensorOrientation,
    required this.lensDirection,
    required this.deviceOrientation,
  });

  final int sensorOrientation;
  final CameraLensDirection lensDirection;
  final DeviceOrientation deviceOrientation;

  static const _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  InputImage? fromCameraImage(CameraImage image) {
    final rotation = _rotationFromCameraImage();
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null ||
        (_isAndroid && format != InputImageFormat.nv21) ||
        (_isIOS && format != InputImageFormat.bgra8888)) {
      return null;
    }

    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  bool get _isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  bool get _isIOS => !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  InputImageRotation? _rotationFromCameraImage() {
    if (_isIOS) {
      return InputImageRotationValue.fromRawValue(sensorOrientation);
    }

    if (!_isAndroid) return null;

    var rotationCompensation = _orientations[deviceOrientation];
    if (rotationCompensation == null) return null;

    if (lensDirection == CameraLensDirection.front) {
      rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
    } else {
      rotationCompensation =
          (sensorOrientation - rotationCompensation + 360) % 360;
    }

    return InputImageRotationValue.fromRawValue(rotationCompensation);
  }
}
