// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';

class HomeState {}

class NoImageState extends HomeState {}

class ImagePickedState extends HomeState {
  File image;
  ImagePickedState({
    required this.image,
  });
}
