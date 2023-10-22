import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as IMG;
import 'package:image_cropper/image_cropper.dart';

part 'camera_event.dart';
part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraBloc() : super(Initial()) {
    on<ShowCameraPreview>(
      (event, emit) async {
        emit(Loading());
        var cameras = await availableCameras();
        CameraController controller = CameraController(
          cameras[0],
          ResolutionPreset.high,
          enableAudio: false,
        );
        await controller.initialize();
        emit(Loaded(controller: controller));
      },
    );
    on<CaptureImageEvent>(
      (event, emit) async {
        XFile file = await event.controller.takePicture();
        File cropped = await cropImage(file);
        var image = resizeImage(XFile(cropped.path));
        print(image.runtimeType);
        emit(Captured(image: cropped));
      },
    );
  }

  resizeImage(XFile xf) async {
    await (IMG.Command()
          ..decodeJpgFile(xf.path)
          ..copyResize(width: 500, height: 500)
          ..writeToFile(xf.path))
        .executeThread();
  }

  Future<File> cropImage(XFile xf) async {
    var croppedFile = await ImageCropper.platform.cropImage(
      sourcePath: xf.path,
      aspectRatioPresets: [CropAspectRatioPreset.square],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        )
      ],
    );
    return File(croppedFile!.path);
  }
}
