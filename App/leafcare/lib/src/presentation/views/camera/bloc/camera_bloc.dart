import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:leafcare/src/utils/camera.dart';

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
        File cropped = await AppCamera.cropImage(file);
        // var image = resizeImage(XFile(cropped.path));
        await event.controller.dispose();
        emit(Captured(image: cropped));
      },
    );
  }
}
