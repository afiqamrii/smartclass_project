import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:smartclass_fyp_2024/features/student/attendance/services/face_recognition_api.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/models/user.dart'; // Add this for making HTTP requests

// Note: Before running, you must add these dependencies to your pubspec.yaml file:
// dependencies:
//   flutter:
//     sdk: flutter
//   camera: ^0.10.5+9 // Or the latest version
//   google_mlkit_face_detection: ^0.11.0 // Or the latest version
//   google_mlkit_commons: ^0.8.0 // Or the latest version
//   http: ^1.2.1 // Or the latest version
//
// And ensure you have configured platform-specific settings for camera usage.

class FaceScannerPage extends ConsumerStatefulWidget {
  final String studentId;
  final int classId;
  final int initialRemainingTime;

  const FaceScannerPage({
    super.key,
    required this.studentId,
    required this.classId,
    required this.initialRemainingTime,
  });

  @override
  ConsumerState<FaceScannerPage> createState() => _FaceScannerPageState();
}

class _FaceScannerPageState extends ConsumerState<FaceScannerPage>
    with TickerProviderStateMixin {
  // Camera and Face Detection
  CameraController? _cameraController;
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      performanceMode: FaceDetectorMode.fast,
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

  // Countdown Timer
  Timer? _countdownTimer;
  late int _remainingTime;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.initialRemainingTime;
    _initializeCamera();
    _startCountdownTimer();

    _successAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  // Formats time to show 'X:XX' (e.g., '2:05')
  String get _formattedTime {
    final minutes = _remainingTime ~/ 60;
    final seconds = (_remainingTime % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _holdSteadyTimer?.cancel();
    _countdownTimer?.cancel();
    _cameraController?.dispose();
    _faceDetector.close();
    _successAnimationController.dispose();
    super.dispose();
  }

  void _startCountdownTimer() {
    _countdownTimer?.cancel(); // Cancel any existing timer
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        if (mounted) {
          setState(() {
            _remainingTime--;
          });
        }
      } else {
        timer.cancel();
        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      }
    });
  }

  void _updateScannerStatus(ScannerStatus status) {
    if (mounted && _scannerStatus != status) {
      setState(() {
        _scannerStatus = status;
      });
    }
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.high,
      fps: 30,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21 // Required for brightness analysis
          : ImageFormatGroup.bgra8888,
    );

  await _cameraController!.initialize();
    _cameraImageRotation =
        InputImageRotationValue.fromRawValue(frontCamera.sensorOrientation);

    await _cameraController!.setFlashMode(FlashMode.torch);

    // Ensure we start the stream only after initialization
    if (mounted) {
      _cameraController!.startImageStream(_processCameraImage);
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isProcessing || !mounted) return;
    _isProcessing = true;

    //Darkness Detection
    const double brightnessThreshold = 60.0; // Adjust this value as needed
    if (image.format.group == ImageFormatGroup.nv21) {
      final yPlane = image.planes[0];
      double totalY = 0;
      for (int i = 0; i < yPlane.bytes.length; i++) {
        totalY += yPlane.bytes[i];
      }
      final double averageY = totalY / yPlane.bytes.length;

      if (averageY < brightnessThreshold) {
        _updateScannerStatus(ScannerStatus.tooDark);
        _resetDetection(); // Reset timers
        _isProcessing = false;
        return; // Don't process the image for faces if it's too dark
      }
    }

    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) {
      _isProcessing = false;
      return;
    }

    try {
      final faces = await _faceDetector.processImage(inputImage);
      if (faces.isNotEmpty && mounted) {
        final isRotated =
            _cameraImageRotation == InputImageRotation.rotation90deg ||
                _cameraImageRotation == InputImageRotation.rotation270deg;

        final processedImageSize = isRotated
            ? Size(image.height.toDouble(), image.width.toDouble())
            : Size(image.width.toDouble(), image.height.toDouble());

        _handleFaceDetection(faces.first, processedImageSize);
      } else {
        _resetDetection();
      }
    } catch (e) {
      debugPrint("Error processing face: $e");
      _resetDetection();
    } finally {
      _isProcessing = false;
    }
  }

  void _resetDetection() {
    _holdSteadyTimer?.cancel();
    // Only reset to searching if the current state isn't a persistent warning
    if (_scannerStatus != ScannerStatus.tooDark) {
      _updateScannerStatus(ScannerStatus.searching);
    }
  }

  void _handleFaceDetection(Face face, Size processedImageSize) {
    if (_hasCaptured) return;

    final imageWidth = processedImageSize.width;
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

    // Center alignment checks (optional, can be adjusted)
    // final faceCenterX = faceRect.left + faceRect.width / 2;
    // if ((faceCenterX - (imageWidth / 2)).abs() > imageWidth * 0.15) {
    //   _updateScannerStatus(ScannerStatus.moveFace);
    //   _holdSteadyTimer?.cancel();
    //   return;
    // }

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
      _holdSteadyTimer = Timer(const Duration(seconds: 2), () {
        if (mounted) {
          _updateScannerStatus(ScannerStatus.blinkRequest);
        }
      });
    }
  }

  Future<void> _captureImage() async {
    if (!_cameraController!.value.isInitialized || _hasCaptured) return;
    _holdSteadyTimer?.cancel();

    try {
      await _cameraController!.stopImageStream();
      final image = await _cameraController!.takePicture();

      // Brighten the image
      final bytes = await image.readAsBytes();
      img.Image? decoded = img.decodeImage(bytes);
      if (decoded != null) {
        // Increase brightness by adjusting color (amount: -1.0 to 1.0)
        decoded = img.adjustColor(decoded, brightness: 1.4, gamma: 1.1);
        final brightenedBytes = img.encodeJpg(decoded);
        // Save to a temp file
        final tempPath = '${image.path}_bright.jpg';
        final file = await File(tempPath).writeAsBytes(brightenedBytes);
        if (mounted) {
          setState(() {
            _hasCaptured = true;
            _capturedImageFile = XFile(file.path);
            _scannerStatus = ScannerStatus.captured;
          });
          _successAnimationController.forward();
        }
      } else {
        // Fallback to original image if decode fails
        if (mounted) {
          setState(() {
            _hasCaptured = true;
            _capturedImageFile = image;
            _scannerStatus = ScannerStatus.captured;
          });
          _successAnimationController.forward();
        }
      }
    } catch (e) {
      debugPrint("Error capturing image: $e");
      await _resetScanner();
    }
  }

  //Reset the scanner
  Future<void> _resetScanner() async {
    _holdSteadyTimer?.cancel();
    _countdownTimer?.cancel(); // Stop the timer while resetting

    if (mounted) {
      // Show loading indicator while camera re-initializes
      setState(() {
        _hasCaptured = false;
        _capturedImageFile = null;
        _scannerStatus = ScannerStatus.searching;
        _isCameraInitialized = false;
      });

      _successAnimationController.reset();

      // Dispose the old controller and initialize a new one
      await _cameraController?.dispose();
      await _initializeCamera();

      _startCountdownTimer(); // Restart countdown after camera is ready
    }
  }

  Future<void> _useThisImage() async {
    if (_capturedImageFile == null) return;

    final imageFile = File(_capturedImageFile!.path);
    final api = FaceRecognitionApi();

    await api.uploadFaceImage(
      context: context,
      studentId: widget.studentId,
      classId: widget.classId,
      imageFile: imageFile,
    );
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_cameraController == null) return null;

    final camera = _cameraController!.description;
    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation? rotation;
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

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    return InputImage.fromBytes(
      bytes: image.planes.first.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return Scaffold(
      backgroundColor: _hasCaptured ? Colors.white : Colors.black,
      body: buildBody(user),
    );
  }

  Widget buildBody(User user) {
    if (!_isCameraInitialized ||
        _cameraController == null ||
        !_cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    final size = MediaQuery.of(context).size;
    final double ovalSize = size.width * 0.75;

    // This calculation for scale can be tricky. Ensure it fits your needs.
    var scale = size.aspectRatio * _cameraController!.value.aspectRatio;
    if (scale < 1) scale = 1 / scale;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (!_hasCaptured)
          Center(
            child: Transform.scale(
              scale: scale,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(pi),
                child: CameraPreview(
                  _cameraController!,
                ),
              ),
            ),
          ),
        if (!_hasCaptured)
          ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Colors.black, // Changed to black for a cleaner cutout
              BlendMode.srcOut,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors
                        .white, // This is the color that will be "cut out"
                    backgroundBlendMode: BlendMode.dstOut,
                  ),
                ),
                Center(
                  child: Container(
                    width: ovalSize,
                    height: ovalSize,
                    decoration: BoxDecoration(
                      color: Colors.black, // Must match the filter color
                      borderRadius: BorderRadius.circular(ovalSize / 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        Positioned(
          top: 60,
          right: 20,
          child: Text(
            'Remaining : $_formattedTime',
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              shadows: _hasCaptured
                  ? []
                  : [
                      const Shadow(
                        blurRadius: 8.0,
                        color: Colors.black54,
                        offset: Offset(0, 0),
                      ),
                    ],
            ),
          ),
        ),
        if (_hasCaptured)
          Padding(
            padding: const EdgeInsets.only(
              top: 170.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                  ),
                  child: Text(
                    "Hi, Please Cofirm Your Face",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      shadows: _hasCaptured
                          ? []
                          : [
                              const Shadow(
                                blurRadius: 8.0,
                                color: Colors.black54,
                                offset: Offset(0, 0),
                              ),
                            ],
                    ),
                    textAlign: TextAlign.center,
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
            left: 5,
            right: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text(
                    'Scan Again',
                    style: TextStyle(color: Colors.black, fontSize: 11),
                  ),
                  onPressed: _resetScanner, // Calls the new async reset
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF0D1B2A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(color: Color(0xFF0D1B2A)),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text(
                    'Use This Image',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                  onPressed: _useThisImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D1B2A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
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
          style: TextStyle(
            color: _hasCaptured ? Colors.transparent : Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            shadows: const [
              Shadow(
                blurRadius: 8.0,
                color: Colors.black54,
                offset: Offset(0, 0),
              ),
            ],
          ),
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
  tooDark("Please find a brighter location"), // New status
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
      case ScannerStatus.tooDark:
        frameColor = Colors.red; // Use a warning color for darkness
        break;
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

    // Draw arcs for the oval frame
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
