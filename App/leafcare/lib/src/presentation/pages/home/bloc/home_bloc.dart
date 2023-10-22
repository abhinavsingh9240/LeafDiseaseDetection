import 'dart:io';
import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image/image.dart' as IMG;

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState(images: [])) {
    on<GetImageEvent>((event, emit) async {
      
      List<File> images = state.images;
      // resizeImage(xf);
      // File f = File(await cropImage(xf));
      images.add(event.image);
      emit(state.copyWith(images: images));
    });
  }

  // 
}
