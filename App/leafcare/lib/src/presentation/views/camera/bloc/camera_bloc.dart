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

  // resizeImage(XFile xf) async {
  //   await (IMG.Command()
  //         ..decodeJpgFile(xf.path)
  //         ..copyResize(width: 256, height: 256)
  //         ..writeToFile(xf.path))
  //       .executeThread();
  // }

  // Future<File> cropImage(XFile xf) async {
  //   var croppedFile = await ImageCropper.platform.cropImage(
  //     sourcePath: xf.path,
  //     aspectRatioPresets: [CropAspectRatioPreset.square],
  //     uiSettings: [
  //       AndroidUiSettings(
  //         toolbarTitle: 'Cropper',
  //         toolbarColor: Colors.green,
  //         toolbarWidgetColor: Colors.white,
  //         initAspectRatio: CropAspectRatioPreset.square,
  //         lockAspectRatio: true,
  //       )
  //     ],
  //   );
  //   return File(croppedFile!.path);
  // }
}
