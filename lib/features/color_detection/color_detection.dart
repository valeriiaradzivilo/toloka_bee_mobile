import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ColorDetection extends StatefulWidget {
  const ColorDetection({super.key});

  @override
  _ColorDetectionState createState() => _ColorDetectionState();
}

class _ColorDetectionState extends State<ColorDetection> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    _controller = CameraController(cameras![0], ResolutionPreset.high);
    await _controller!.initialize();
    setState(() {
      isCameraInitialized = true;
    });
  }

  Future<void> captureAndAnalyzeColor() async {
    if (!_controller!.value.isInitialized) {
      return;
    }

    final image = await _controller!.takePicture();
    final bytes = await image.readAsBytes();
    final response = await http.post(
      Uri.parse('http://192.168.0.106:8080/analyze-color'),
      headers: {'Content-Type': 'application/octet-stream'},
      body: bytes,
    );

    if (response.statusCode == 200) {
      final colorInfo = jsonDecode(response.body);
      print('Detected color: ${colorInfo['color']}');
    } else {
      print('Failed to analyze color');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Color Detection')),
      body: isCameraInitialized
          ? Column(
              children: [
                Expanded(
                  child: CameraPreview(_controller!),
                ),
                ElevatedButton(
                  onPressed: captureAndAnalyzeColor,
                  child: const Text('Capture and Analyze Color'),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
