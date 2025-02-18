import 'dart:typed_data';

import 'package:absen_smkn1_punggelan/app/module/use_case/photo_get_bytes.dart';
import 'package:absen_smkn1_punggelan/core/network/data_state.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceRecognitionNotifier extends ChangeNotifier {
  final PhotoGetBytesUseCase _photoGetBytes;
  final FaceDetector _faceDetector;
  CameraController? _cameraController;
  bool _isInitialized = false;
  bool _isBusy = false;
  List<Face>? _faces;
  String? _message;
  Uint8List? _photoBytes;

  bool get isInitialized => _isInitialized;
  bool get isBusy => _isBusy;
  List<Face>? get faces => _faces;
  String? get message => _message;
  Uint8List? get photoBytes => _photoBytes;
  CameraController? get cameraController => _cameraController;
  double get percentMatch => (_faces?.length ?? 0) > 0 ? 100.0 : 0.0;
  Photo? get currentImage {
    return _photoBytes != null ? Photo(id: 1, type: 'image', url: '', createdAt: '', updatedAt: '') : null;
  }

  FaceRecognitionNotifier(this._photoGetBytes)
      : _faceDetector = FaceDetector(
          options: FaceDetectorOptions(
            enableLandmarks: true,
            enableClassification: true,
            enableTracking: true,
          ),
        );

  Future<void> getPhoto(int photoId) async {
    _isBusy = true;
    _message = null;
    notifyListeners();

    final response = await _photoGetBytes.execute(photoId);
    if (response is SuccessState && response.data != null) {
      _photoBytes = Uint8List.fromList(response.data!);
    } else if (response is ErrorState) {
      _message = response.message;
    } else {
      _message = 'Failed to get photo';
    }

    _isBusy = false;
    notifyListeners();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      _message = 'No camera found';
      notifyListeners();
      return;
    }

    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await _cameraController!.initialize();
      _isInitialized = true;
      notifyListeners();
      _startImageStream();
    } catch (e) {
      _message = 'Failed to initialize camera: $e';
      notifyListeners();
    }
  }

  void _startImageStream() {
    _cameraController?.startImageStream((image) {
      if (_isBusy) return;
      _processImage(image);
    });
  }

  Future<void> _processImage(CameraImage image) async {
    _isBusy = true;
    notifyListeners();

    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());

    final camera = _cameraController?.description;
    final imageRotation =
        InputImageRotationValue.fromRawValue(camera?.sensorOrientation ?? 0) ??
            InputImageRotation.rotation0deg;

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(image.format.raw) ??
            InputImageFormat.bgra8888;

    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    _faces = await _faceDetector.processImage(inputImage);
    _isBusy = false;
    notifyListeners();
  }

  Uint8List? getCurrentPhoto() {
    return _photoBytes;
  }

  @override
  void dispose() {
    _faceDetector.close();
    _cameraController?.dispose();
    super.dispose();
  }
}
