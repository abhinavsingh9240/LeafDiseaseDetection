// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'camera_bloc.dart';

class CameraState {}

class Initial extends CameraState {}

class Loading extends CameraState {}

class Loaded extends CameraState {
  CameraController controller;
  Loaded({
    required this.controller,
  });
}

class Captured extends CameraState {
  File image;
  Captured({
    required this.image,
  });
}
