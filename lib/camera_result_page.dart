import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CameraResultPage extends HookWidget {
  const CameraResultPage({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('result')),
      body: Center(child: Image.file(File(imagePath))),
    );
  }
}
