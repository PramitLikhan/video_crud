import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/constants.dart';

class CameraScreen extends StatefulWidget {
//  final List<CameraDescription> cameras;
  static var routeName = '/camera';

  const CameraScreen({
    Key? key,
  }) : super(key: key);
  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  late CameraDescription backCamera, frontCamera;
  IconData cameraButtonIcon = Icons.camera_alt;

  @override
  void initState() {
    getAvailableCamera();

    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void getAvailableCamera() async {
    for (var i = 0; i < cameras.length; i++) {
      var camera = cameras[i];
      if (camera.lensDirection == CameraLensDirection.back) {
        backCamera = camera;
      }
      if (camera.lensDirection == CameraLensDirection.front) {
        frontCamera = camera;
      }
    }
    backCamera ??= cameras.first;
    frontCamera ??= cameras.last;
    _cameraController = CameraController(backCamera, ResolutionPreset.medium);

    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraController.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CameraPreview(_cameraController),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              backgroundColor: Colors.blue,
              child: Icon(cameraButtonIcon),
              onPressed: () async {
                if (cameraButtonIcon == Icons.camera_alt) {
                  _cameraController.startVideoRecording();
                  cameraButtonIcon = Icons.stop;
                  setState(() {});
                } else if (cameraButtonIcon == Icons.stop) {
                  _cameraController.stopVideoRecording().then((value) {
                    cameraButtonIcon = Icons.camera_alt;
                    Navigator.pop(context, value.path);
                  });
                }
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(right: 5.0),
              child: FloatingActionButton(
                backgroundColor: Colors.blue,
                child: const Icon(Icons.flip_camera_android),
                onPressed: () {
                  if (_cameraController.description.lensDirection == CameraLensDirection.back) {
                    _cameraController = CameraController(frontCamera, ResolutionPreset.medium);
                  } else {
                    _cameraController = CameraController(backCamera, ResolutionPreset.medium);
                  }

                  _cameraController.initialize().then((_) {
                    if (!mounted) {
                      return;
                    }
                    setState(() {});
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
