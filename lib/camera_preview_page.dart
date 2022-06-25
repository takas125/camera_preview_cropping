import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

class CameraPreviewPage extends HookWidget {
  CameraPreviewPage({
    Key? key,
  }) : super(key: key);

  late List<CameraDescription> cameras;
  late CameraDescription useCamera;
  late final CameraController _controller;
  late final Future<void> _initializeControllerFuture;

  @override
  Widget build(BuildContext context) {
    final future = useMemoized(() async {
      return await availableCameras();
    });
    final snapshot = useFuture(future, initialData: null);

    useEffect(
      () {
        if (snapshot.hasData) {
          cameras = snapshot.data!;
          useCamera = cameras.first;
          // 利用可能なカメラのリストから特定のカメラを取得
          for (var camera in cameras) {
            if (camera.lensDirection == CameraLensDirection.front) {
              useCamera = camera;
            }
          }
          _controller = CameraController(
            // カメラを指定
            useCamera,
            // 解像度を定義
            ResolutionPreset.medium,
          );
          _initializeControllerFuture = _controller.initialize();
        }
        return null;
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (snapshot.hasData)
                ? FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return clippedPreview(_controller);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  )
                : const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final image = await _controller.takePicture();
          final resizeImage = await _resizePhoto(image.path);
          Navigator.pushNamed(context, 'CameraResult',
              arguments: {'imagePath': resizeImage});
        },
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // 写真自体はそのままなので、切り抜く
  Future<String> _resizePhoto(String filePath) async {
    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(filePath);
    final height = properties.height;
    final offset = (properties.width!) / 3;

    File croppedFile = await FlutterNativeImage.cropImage(
        filePath,
        //スタートの縦位置
        offset.round(),
        // スタートの横位置
        0,
        // 高さ
        offset.round(),
        // 横幅
        height!.round());

    return croppedFile.path;
  }

  // プレビューを切り抜き
  Widget clippedPreview(CameraController cameraController) {
    return Expanded(
      child: Stack(
        children: <Widget>[
          Container(
            color: Colors.black,
            alignment: Alignment.center,
            child: CameraPreview(cameraController),
          ),
          ClipPath(
            clipper: InvertedCircleClipper(),
            child: Container(
              color: Colors.black.withOpacity(0.98),
            ),
          ),
        ],
      ),
    );
  }
}

class InvertedCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      // 指定した形に切り抜き
      ..addRect(Rect.fromLTWH(0.0, size.height.round() / 3,
          size.width.round().toDouble(), size.height.round() / 4))
      // 全体を覆う
      ..addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
