import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key, required this.cameras}) : super(key: key);

  final List<CameraDescription>? cameras;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _cameraController;
  bool _isRearCameraSelected = true;
  bool _isFlashModeSelected = false;
  double _currentZoomLevel = 1.0;
  double _maxZoomLevel = 1.0;
  late XFile picture;
  String? _imagePath;
  Offset? _focusPoint;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    initCamera(widget.cameras![0]);
  }

  @override
  void dispose() {
    _cameraController.dispose();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  Future<void> takePicture() async {
    if (!_cameraController.value.isInitialized) {
      debugPrint('Camera is not initialized.');
      return;
    }
    if (_cameraController.value.isTakingPicture) {
      debugPrint('A picture is already being taken.');
      return;
    }
    try {
      await _cameraController.setFlashMode(FlashMode.off);
      final XFile capturedPicture = await _cameraController.takePicture();
      setState(() {
        _imagePath = capturedPicture.path;
        picture = capturedPicture;
      });
    } on CameraException catch (e) {
      debugPrint('Error occurred while taking picture: $e');
    } catch (e) {
      debugPrint('Unexpected error: $e');
    }
  }

  Future<void> initCamera(CameraDescription cameraDescription) async {
    _cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.veryHigh,
      imageFormatGroup: ImageFormatGroup.jpeg,
      enableAudio: false,
    );
    try {
      if (await Permission.camera.request().isGranted) {
        await _cameraController.initialize();
        _maxZoomLevel = await _cameraController.getMaxZoomLevel();
        if (mounted) setState(() {});
      } else {
        debugPrint("Camera permission denied. Redirecting to app settings.");
        openAppSettings();
      }
    } on CameraException catch (e) {
      debugPrint("Camera error: $e");
    } catch (e) {
      debugPrint("Unexpected error during camera initialization: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _imagePath == null ? buildCameraView() : buildPreviewView(),
      ),
    );
  }

  Widget buildCameraView() {
    return Stack(
      children: [
        (_cameraController.value.isInitialized)
            ? GestureDetector(
                onTapDown: (TapDownDetails details) async {
                  final RenderBox box = context.findRenderObject() as RenderBox;
                  final Offset tapPosition =
                      box.globalToLocal(details.globalPosition);
                  final Size previewSize = box.size;

                  final double x = tapPosition.dx / previewSize.width;
                  final double y = tapPosition.dy / previewSize.height;

                  setState(() {
                    _focusPoint = tapPosition;
                  });

                  await _cameraController.setFocusPoint(Offset(x, y));

                  // Remove the focus box after a short delay
                  Future.delayed(const Duration(seconds: 2), () {
                    setState(() {
                      _focusPoint = null;
                    });
                  });
                },
                child: Container(
                  color: Colors.black,
                  child: Stack(
                    children: [
                      Center(child: CameraPreview(_cameraController)),
                      if (_focusPoint != null)
                        Positioned(
                          left: _focusPoint!.dx - 25,
                          top: _focusPoint!.dy - 25,
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.yellow, width: 2),
                              shape: BoxShape.rectangle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              )
            : Container(
                color: Colors.black,
                child: const Center(child: CircularProgressIndicator())),
        Positioned(
          top: 10,
          left: 10,
          child: 
          FloatingActionButton(
             onPressed: () => Navigator.of(context).pop(),
              heroTag: 'arrowBack',
              backgroundColor: Colors.white54,
              child:
                  const Icon(Icons.arrow_back, color: Colors.white, size: 24),
            ),
         
        ),
        Positioned(
          right: 10,
          top: MediaQuery.of(context).size.height * 0.3,
          bottom: MediaQuery.of(context).size.height * 0.3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RotatedBox(
                quarterTurns: 3,
                child: Slider(
                  value: _currentZoomLevel,
                  min: 1.0,
                  max: _maxZoomLevel,
                  onChanged: (value) async {
                    setState(() => _currentZoomLevel = value);
                    await _cameraController.setZoomLevel(value);
                  },
                  activeColor: Colors.white,
                  inactiveColor: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${_currentZoomLevel.toStringAsFixed(1)}x',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.10,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  color: Colors.black,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: 30,
                            icon: Icon(
                              _isRearCameraSelected
                                  ? CupertinoIcons.switch_camera
                                  : CupertinoIcons.switch_camera_solid,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() =>
                                  _isRearCameraSelected = !_isRearCameraSelected);
                              initCamera(
                                  widget.cameras![_isRearCameraSelected ? 0 : 1]);
                            },
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            onPressed: takePicture,
                            iconSize: 50,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.camera_alt, color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: 30,
                            icon: Icon(
                              _isFlashModeSelected
                                  ? Icons.flash_on
                                  : Icons.flash_off,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              if (_isRearCameraSelected) {
                                setState(() =>
                                    _isFlashModeSelected = !_isFlashModeSelected);
                                if (_isFlashModeSelected) {
                                  _cameraController.setFlashMode(FlashMode.torch);
                                } else {
                                  _cameraController.setFlashMode(FlashMode.off);
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildPreviewView() {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          Center(
            child: Image.file(File(_imagePath!)),
          ),
          Positioned(
           top: 10,
          left: 10,
            child: FloatingActionButton(
              onPressed: () => setState(() {
                _imagePath = null;
                _focusPoint = null;
                _currentZoomLevel = 1.0;
                initCamera(widget.cameras![_isRearCameraSelected ? 0 : 1]);
              }),
              heroTag: 'arrowBack',
              backgroundColor: Colors.white54,
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, picture);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: TextStyle(fontSize: 18, color: Colors.black),
              ),
              child: const Text("Use Photo",
                  style: TextStyle(
                    color: Colors.white,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
