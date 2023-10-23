// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';

class HomeState {
  HomeState();
}

class ImagePickState extends HomeState {}

class ImagePickedState extends HomeState {
  List<File> images;
  ImagePickedState({
    required this.images,
  });

  ImagePickedState copyWith({
    List<File>? images,
  }) {
    return ImagePickedState(
      images: images ?? this.images,
    );
  }
}
