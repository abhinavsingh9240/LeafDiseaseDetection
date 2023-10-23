import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class AppCamera {
  static Future<File> cropImage(XFile xf) async {
    var croppedFile = await ImageCropper.platform.cropImage(
      sourcePath: xf.path,
      aspectRatioPresets: [CropAspectRatioPreset.square],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.green,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        )
      ],
    );
    return File(croppedFile!.path);
  }
}
