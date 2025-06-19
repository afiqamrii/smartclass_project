import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

// Note: Before running, you must add these dependencies to your pubspec.yaml file:
// dependencies:
//   flutter:
//     sdk: flutter
//   camera: ^0.10.5+9 // Or the latest version
//   google_mlkit_face_detection: ^0.11.0 // Or the latest version
//   google_mlkit_commons: ^0.8.0 // Or the latest version
//
// And ensure you have configured platform-specific settings for camera usage.

class FaceScannerPage extends StatefulWidget {
  const FaceScannerPage({super.key});

  @override
  State<FaceScannerPage> createState() => _FaceScannerPageState();
}

class _FaceScannerPageState extends State<FaceScannerPage>
    with TickerProviderStateMixin {
  // Camera and Face Detection
  CameraController? _cameraController;
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      performanceMode: FaceDetectorMode.fast, // Try fast mode for debug
      enableClassification: true,
    ),
  );
  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  InputImageRotation? _cameraImageRotation;

  // UI and Animation State
  ScannerStatus _scannerStatus = ScannerStatus.searching;
  Timer? _holdSteadyTimer;
  bool _hasCaptured = false;
  XFile? _capturedImageFile;
  late AnimationController _successAnimationController;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _successAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _holdSteadyTimer?.cancel();
    _cameraController?.dispose();
    _faceDetector.close();
    _successAnimationController.dispose();
    super.dispose();
  }

  // Manages the state of the scanner and updates the UI.
  void _updateScannerStatus(ScannerStatus status) {
    if (mounted && _scannerStatus != status) {
      setState(() {
        _scannerStatus = status;
      });
    }
  }

  // Initializes the camera and starts the image stream for face detection.
  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.veryHigh,
      fps: 120,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21 // for Android
          : ImageFormatGroup.bgra8888, // for iOS
    );

    await _cameraController!.initialize();

    // print("Actual image format group: ${_cameraController!.imageFormatGroup}");

    _cameraImageRotation =
        InputImageRotationValue.fromRawValue(frontCamera.sensorOrientation);

    _cameraController!.startImageStream(_processCameraImage);

    if (mounted) {
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  // Processes each frame from the camera to detect faces.
  Future<void> _processCameraImage(CameraImage image) async {
    if (_isProcessing || !mounted) return;
    _isProcessing = true;

    // print("Processing camera image..."); // DEBUG

    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) {
      // print("Input image is null!"); // DEBUG
      _isProcessing = false;
      return;
    }

    try {
      final faces = await _faceDetector.processImage(inputImage);
      // print("Faces detected: ${faces.length}"); // DEBUG
      if (faces.isNotEmpty && mounted) {
        // Print face bounding box for debug
        // print("First face bounding box: ${faces.first.boundingBox}"); // DEBUG

        // Check if the image is rotated
        final isRotated =
            _cameraImageRotation == InputImageRotation.rotation90deg ||
                _cameraImageRotation == InputImageRotation.rotation270deg;

        final processedImageSize = isRotated
            ? Size(image.height.toDouble(), image.width.toDouble())
            : Size(image.width.toDouble(), image.height.toDouble());

        _handleFaceDetection(faces.first, processedImageSize);
      } else {
        // print("No faces found in this frame."); // DEBUG
        _resetDetection();
      }
    } catch (e) {
      // print("Error processing image: $e");
      _resetDetection();
    } finally {
      _isProcessing = false;
    }
  }

  // Resets the detection state when no face is found.
  void _resetDetection() {
    _holdSteadyTimer?.cancel();
    _updateScannerStatus(ScannerStatus.searching);
  }

  // Handles the logic once a face is detected.
  void _handleFaceDetection(Face face, Size processedImageSize) {
    if (_hasCaptured) return;

    final imageWidth = processedImageSize.width;
    final imageHeight = processedImageSize.height;
    final faceRect = face.boundingBox;

    if (faceRect.width < imageWidth * 0.35) {
      _updateScannerStatus(ScannerStatus.tooFar);
      _holdSteadyTimer?.cancel();
      return;
    }
    if (faceRect.width > imageWidth * 0.80) {
      _updateScannerStatus(ScannerStatus.tooClose);
      _holdSteadyTimer?.cancel();
      return;
    }

    final faceCenterX = faceRect.left + faceRect.width / 2;
    final faceCenterY = faceRect.top + faceRect.height / 2;

    if ((faceCenterX - (imageWidth / 2)).abs() > imageWidth * 0.15 ||
        (faceCenterY - (imageHeight / 2)).abs() > imageHeight * 0.20) {
      _updateScannerStatus(ScannerStatus.moveFace);
      _holdSteadyTimer?.cancel();
      return;
    }

    if (_scannerStatus == ScannerStatus.blinkRequest) {
      final leftEyeOpen = face.leftEyeOpenProbability ?? 0.0;
      final rightEyeOpen = face.rightEyeOpenProbability ?? 0.0;
      if (leftEyeOpen < 0.2 && rightEyeOpen < 0.2) {
        _captureImage();
      }
      return;
    }

    if (_scannerStatus != ScannerStatus.holdSteady) {
      _updateScannerStatus(ScannerStatus.holdSteady);
      _holdSteadyTimer?.cancel();
      _holdSteadyTimer = Timer(const Duration(seconds: 1), () {
        if (mounted) {
          _updateScannerStatus(ScannerStatus.blinkRequest);
        }
      });
    }
  }

  // Captures the image and shows the success animation.
  Future<void> _captureImage() async {
    if (!_cameraController!.value.isInitialized || _hasCaptured) return;
    _holdSteadyTimer?.cancel();
    try {
      await _cameraController!.stopImageStream();
      final image = await _cameraController!.takePicture();
      if (mounted) {
        setState(() {
          _hasCaptured = true;
          _capturedImageFile = image;
          _scannerStatus = ScannerStatus.captured;
        });
        _successAnimationController.forward();
      }
    } catch (e) {
      // print('Error capturing image: $e');
      _resetScanner();
    }
  }

  // Resets the scanner to its initial state.
  void _resetScanner() {
    _holdSteadyTimer?.cancel();
    if (mounted) {
      setState(() {
        _hasCaptured = false;
        _capturedImageFile = null;
        _scannerStatus = ScannerStatus.searching;
      });
      _successAnimationController.reset();
      if (!_cameraController!.value.isStreamingImages) {
        _cameraController!.startImageStream(_processCameraImage);
      }
    }
  }

  // Converts CameraImage to a format that ML Kit can process.
  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_cameraController == null) return null;

    final camera = _cameraController!.description;
    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation? rotation;

    // Determine the image rotation
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation = (sensorOrientation + 360) % 360;
      switch (rotationCompensation) {
        case 0:
          rotation = InputImageRotation.rotation0deg;
          break;
        case 90:
          rotation = InputImageRotation.rotation90deg;
          break;
        case 180:
          rotation = InputImageRotation.rotation180deg;
          break;
        case 270:
          rotation = InputImageRotation.rotation270deg;
          break;
        default:
          rotation = InputImageRotation.rotation0deg;
      }
    }

    if (rotation == null) return null;

    // Get the image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    // Since the format is already NV21, there's no need for manual conversion.
    if (image.planes.length == 1) {
      // On some devices, NV21 is provided as a single plane.
    }

    return InputImage.fromBytes(
      bytes: image.planes[0].bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );
  }

  // Uint8List _concatenatePlanes(List<Plane> planes) {
  //   final WriteBuffer allBytes = WriteBuffer();
  //   for (final plane in planes) {
  //     allBytes.putUint8List(plane.bytes);
  //   }
  //   return allBytes.done().buffer.asUint8List();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (!_isCameraInitialized || _cameraController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final size = MediaQuery.of(context).size;
    final double ovalSize = size.width * 0.75;

    var scale = size.aspectRatio * _cameraController!.value.aspectRatio;
    if (scale < 1) scale = 1 / scale;

    return Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: Transform.scale(
            scale: scale,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(precisionErrorTolerance),
              child: CameraPreview(_cameraController!),
            ),
          ),
        ),
        if (!_hasCaptured)
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.6),
              BlendMode.srcOut,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    backgroundBlendMode: BlendMode.dstOut,
                  ),
                ),
                Center(
                  child: Container(
                    width: ovalSize,
                    height: ovalSize,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(ovalSize / 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (!_hasCaptured)
          Center(
            child: CustomPaint(
              painter: FaceFramePainter(
                status: _scannerStatus,
                ovalSize: ovalSize,
              ),
              child: SizedBox(width: ovalSize, height: ovalSize),
            ),
          ),
        _buildInstructionOrResult(ovalSize),
        if (_hasCaptured)
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Scan Again'),
                onPressed: _resetScanner,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0D1B2A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
          )
      ],
    );
  }

  Widget _buildInstructionOrResult(double ovalSize) {
    if (_hasCaptured && _capturedImageFile != null) {
      return Center(
        child: ClipOval(
          child: SizedBox(
            width: ovalSize,
            height: ovalSize,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(pi),
              child: Image.file(
                File(_capturedImageFile!.path),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    } else {
      return Positioned(
        top: MediaQuery.of(context).size.height * 0.15,
        left: 20,
        right: 20,
        child: Text(
          _scannerStatus.message,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              shadows: [Shadow(blurRadius: 10.0, color: Colors.black54)]),
        ),
      );
    }
  }
}

enum ScannerStatus {
  searching("Position your face in the oval"),
  moveFace("Center your face in the oval"),
  tooClose("You're too close"),
  tooFar("Move a bit closer"),
  holdSteady("Hold steady..."),
  blinkRequest("Now, please blink"),
  captured("Success!");

  const ScannerStatus(this.message);
  final String message;
}

class FaceFramePainter extends CustomPainter {
  final ScannerStatus status;
  final double ovalSize;

  FaceFramePainter({required this.status, required this.ovalSize});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rect =
        Rect.fromCenter(center: center, width: ovalSize, height: ovalSize);

    Color frameColor;
    switch (status) {
      case ScannerStatus.searching:
      case ScannerStatus.moveFace:
      case ScannerStatus.tooClose:
      case ScannerStatus.tooFar:
        frameColor = Colors.white54;
        break;
      case ScannerStatus.holdSteady:
        frameColor = Colors.yellowAccent;
        break;
      case ScannerStatus.blinkRequest:
      case ScannerStatus.captured:
        frameColor = Colors.greenAccent;
        break;
    }

    final framePaint = Paint()
      ..color = frameColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round;

    const sweepAngle = pi / 4;

    canvas.drawArc(
        rect, pi * 1.25, sweepAngle, false, framePaint); // Bottom-left
    canvas.drawArc(
        rect, pi * 1.75, sweepAngle, false, framePaint); // Bottom-right
    canvas.drawArc(rect, pi * 0.25, sweepAngle, false, framePaint); // Top-right
    canvas.drawArc(rect, pi * 0.75, sweepAngle, false, framePaint); // Top-left
  }

  @override
  bool shouldRepaint(covariant FaceFramePainter oldDelegate) {
    return oldDelegate.status != status;
  }
}

extension Nv21Converter on CameraImage {
  Uint8List getNv21Uint8List() {
    var width = this.width;
    var height = this.height;

    var yPlane = planes[0];
    var uPlane = planes[1];
    var vPlane = planes[2];

    var yBuffer = yPlane.bytes;
    var uBuffer = uPlane.bytes;
    var vBuffer = vPlane.bytes;

    var numPixels = (width * height * 1.5).toInt();
    var nv21 = List<int>.filled(numPixels, 0);

    int idY = 0;
    int idUV = width * height;
    var uvWidth = width ~/ 2;
    var uvHeight = height ~/ 2;

    var uvRowStride = uPlane.bytesPerRow;
    var uvPixelStride = uPlane.bytesPerPixel ?? 0;
    var yRowStride = yPlane.bytesPerRow;
    var yPixelStride = yPlane.bytesPerPixel ?? 0;

    for (int y = 0; y < height; ++y) {
      var uvOffset = y * uvRowStride;
      var yOffset = y * yRowStride;

      for (int x = 0; x < width; ++x) {
        nv21[idY++] = yBuffer[yOffset + x * yPixelStride];

        if (y < uvHeight && x < uvWidth) {
          var bufferIndex = uvOffset + (x * uvPixelStride);
          nv21[idUV++] = vBuffer[bufferIndex]; // V first in NV21
          nv21[idUV++] = uBuffer[bufferIndex]; // Then U
        }
      }
    }

    return Uint8List.fromList(nv21);
  }
}
