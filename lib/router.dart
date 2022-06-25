import 'package:camera/camera.dart';
import 'package:camera_preview_croping/camera_result_page.dart';
import 'package:flutter/material.dart';

import 'camera_preview_page.dart';
import 'main.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case 'CameraPreview':
      return MaterialPageRoute<Widget>(
        builder: (context) => CameraPreviewPage(),
      );
    case 'CameraResult':
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute<Widget>(
        builder: (context) => CameraResultPage(
          imagePath: args['imagePath'] as String,
        ),
      );
    default:
      return MaterialPageRoute<Widget>(
        builder: (context) => const HomePage(title: 'title'),
      );
  }
}
