import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

enum ExerciseType { sitUps, jumps, shuttleRuns, height }

class ExerciseTrackerScreen extends StatefulWidget {
  final List<dynamic> cameras;
  const ExerciseTrackerScreen({super.key, required this.cameras});

  @override
  State<ExerciseTrackerScreen> createState() => _ExerciseTrackerScreenState();
}

class _ExerciseTrackerScreenState extends State<ExerciseTrackerScreen> {
  CameraController? _controller;
  final PoseDetector _poseDetector = PoseDetector(options: PoseDetectorOptions());
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  ExerciseType _currentExercise = ExerciseType.sitUps;
  int _repCount = 0;
  int _elapsedTime = 0;
  String _formStatus = 'Good Form';
  late Stopwatch _stopwatch;
  late Timer _timer;

  bool _isUpPosition = true;
  double _prevHipY = 0.0;
  double _minHipY = double.infinity;
  double _maxHipY = double.negativeInfinity;
  bool _directionLeft = true;
  double _prevHipX = 0.0;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _elapsedTime = _stopwatch.elapsed.inSeconds;
        });
      }
    });
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;
    
    final camera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );
    
    _controller = CameraController(camera, ResolutionPreset.medium);
    await _controller!.initialize();
    _controller!.startImageStream(_processCameraImage);
    _stopwatch.start();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _canProcess = false;
    _controller?.dispose();
    _poseDetector.close();
    _stopwatch.stop();
    _timer.cancel();
    super.dispose();
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (!_canProcess || _isBusy) return;
    _isBusy = true;

    final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
    final camera = _controller!.description;
    final imageRotation = InputImageRotationValue.fromRawValue(camera.sensorOrientation) ?? InputImageRotation.rotation0deg;
    final inputImageFormat = InputImageFormatValue.fromRawValue(image.format.raw) ?? InputImageFormat.nv21;

    final inputImage = InputImage.fromBytes(
      bytes: image.planes.fold<Uint8List>(Uint8List(0), (bytes, plane) => Uint8List.fromList([...bytes, ...plane.bytes])),
      metadata: InputImageMetadata(
        size: imageSize,
        rotation: imageRotation,
        format: inputImageFormat,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );

    final poses = await _poseDetector.processImage(inputImage);

    if (poses.isNotEmpty) {
      _customPaint = CustomPaint(
        painter: PosePainter(
          poses,
          imageSize,
          imageRotation,
          camera.lensDirection,
        ),
      );
      _trackExercise(poses.first);
    } else {
      _customPaint = null;
    }

    if (mounted) setState(() {});
    _isBusy = false;
  }

  void _trackExercise(Pose pose) {
    final landmarks = pose.landmarks;
    final shoulder = landmarks[PoseLandmarkType.leftShoulder];
    final elbow = landmarks[PoseLandmarkType.leftElbow];
    final hip = landmarks[PoseLandmarkType.leftHip];
    final knee = landmarks[PoseLandmarkType.leftKnee];
    final ankle = landmarks[PoseLandmarkType.leftAnkle];

    if (shoulder == null || elbow == null || hip == null || knee == null || ankle == null) return;

    double calculateAngle(PoseLandmark p1, PoseLandmark p2, PoseLandmark p3) {
      final a = math.atan2(p3.y - p2.y, p3.x - p2.x) - math.atan2(p1.y - p2.y, p1.x - p2.x);
      return (a * 180 / math.pi).abs();
    }

    double torsoAngle = calculateAngle(shoulder, hip, knee);
    double legAngle = calculateAngle(hip, knee, ankle);

    bool formCorrect = true;
    switch (_currentExercise) {
      case ExerciseType.sitUps:
        final isDown = torsoAngle > 90;
        if (_isUpPosition && isDown) {
          _isUpPosition = false;
        } else if (!_isUpPosition && torsoAngle < 30) {
          _repCount++;
          _isUpPosition = true;
        }
        formCorrect = torsoAngle > 80 && torsoAngle < 100;
        break;
      case ExerciseType.jumps:
        final currentHipY = hip.y;
        if (_prevHipY == 0.0) _prevHipY = currentHipY;
        if (currentHipY > _prevHipY + 50) {
          _repCount++;
        }
        _prevHipY = currentHipY;
        formCorrect = legAngle > 150;
        break;
      case ExerciseType.shuttleRuns:
        final currentHipX = hip.x;
        final previewSize = _controller!.value.previewSize;
        if (previewSize != null) {
          final centerX = previewSize.width / 2;
          if (_prevHipX == 0.0) _prevHipX = currentHipX;
          if ((_directionLeft && currentHipX > centerX) || (!_directionLeft && currentHipX < centerX)) {
            _repCount++;
            _directionLeft = !_directionLeft;
          }
          _prevHipX = currentHipX;
        }
        formCorrect = true;
        break;
      case ExerciseType.height:
        _minHipY = math.min(_minHipY, hip.y);
        _maxHipY = math.max(_maxHipY, hip.y);
        final estimatedHeight = (_maxHipY - _minHipY) * 0.01;
        _repCount = estimatedHeight.round();
        formCorrect = true;
        break;
    }

    _formStatus = formCorrect ? 'Good Form!' : 'Adjust Form';
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${_currentExercise.name.toUpperCase()} Tracker'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () => _stopwatch.start(),
          ),
          IconButton(
            icon: const Icon(Icons.stop),
            onPressed: () => _stopwatch.stop(),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_controller!),
          if (_customPaint != null) _customPaint!,
          Positioned(
            top: 50,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Reps: $_repCount', style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                Text('Time: $_elapsedTime s', style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                Text(_formStatus, style: TextStyle(fontSize: 18, color: _formStatus.contains('Good') ? Colors.green : Colors.red)),
              ],
            ),
          ),
          Positioned(
            bottom: 50,
            right: 20,
            child: DropdownButton<ExerciseType>(
              value: _currentExercise,
              items: ExerciseType.values.map((type) => DropdownMenuItem(value: type, child: Text(type.name))).toList(),
              onChanged: (value) => setState(() => _currentExercise = value!),
              dropdownColor: Colors.black54,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class PosePainter extends CustomPainter {
  PosePainter(this.poses, this.absoluteImageSize, this.rotation, this.cameraLensDirection);

  final List<Pose> poses;
  final Size absoluteImageSize;
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..color = Colors.green;

    final landmarkPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.red;

    for (final pose in poses) {
      pose.landmarks.forEach((_, landmark) {
        final x = landmark.x * size.width / absoluteImageSize.width;
        final y = landmark.y * size.height / absoluteImageSize.height;
        canvas.drawCircle(Offset(x, y), 6.0, landmarkPaint);
      });

      void paintLine(PoseLandmarkType type1, PoseLandmarkType type2) {
        final landmark1 = pose.landmarks[type1];
        final landmark2 = pose.landmarks[type2];
        if (landmark1 != null && landmark2 != null) {
          final x1 = landmark1.x * size.width / absoluteImageSize.width;
          final y1 = landmark1.y * size.height / absoluteImageSize.height;
          final x2 = landmark2.x * size.width / absoluteImageSize.width;
          final y2 = landmark2.y * size.height / absoluteImageSize.height;
          canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
        }
      }

      paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder);
      paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow);
      paintLine(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist);
      paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow);
      paintLine(PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist);
      paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip);
      paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip);
      paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.rightHip);
      paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee);
      paintLine(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle);
      paintLine(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee);
      paintLine(PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle);
    }
  }

  @override
  bool shouldRepaint(PosePainter oldDelegate) => true;
}