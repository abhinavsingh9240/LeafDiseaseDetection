// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'camera_bloc.dart';

abstract class CameraEvent {}

class ShowCameraPreview extends CameraEvent {}

class CaptureImageEvent extends CameraEvent {
  CameraController controller;
  CaptureImageEvent({
    required this.controller,
  });
}
