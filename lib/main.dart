import 'package:camera/camera.dart';
import 'package:camera_preview_croping/router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // デバイスで使用可能なカメラのリストを取得
  final cameras = await availableCameras();

  // 利用可能なカメラのリストから特定のカメラを取得
  CameraDescription useCamera = cameras.first;
  for (var camera in cameras) {
    if (camera.lensDirection == CameraLensDirection.back) {
      useCamera = camera;
    }
  }

  // 取得できているか確認
  if (kDebugMode) {
    print('検知したカメラis$useCamera');
  }

  runApp(const CameraPreviewCropApp());
}

class CameraPreviewCropApp extends HookWidget {
  const CameraPreviewCropApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      onGenerateRoute: generateRoute,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(
        title: 'Flutter Camera Preview Cropping Home Page',
      ),
    );
  }
}

class HomePage extends HookWidget {
  const HomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final counter = useState(0);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'This is camera preview app,\n tap camera button then open preview screen',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            'CameraPreview',
          );
        },
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
