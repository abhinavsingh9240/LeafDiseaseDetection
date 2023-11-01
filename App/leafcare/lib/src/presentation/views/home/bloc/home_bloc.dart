// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leafcare/src/utils/camera.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(NoImageState()) {
    on<GetImageEvent>((event, emit) async {
      emit(ImagePickedState(image: event.image));
    });
    on<PickImageFromGallery>(
      (event, emit) async {
        XFile? photo = await ImagePicker.platform
            .getImageFromSource(source: ImageSource.gallery);
        File image = await AppCamera.cropImage(photo!);
        emit(ImagePickedState(image: image));
      },
    );
  }
}
