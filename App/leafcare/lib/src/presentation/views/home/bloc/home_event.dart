// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';

abstract class HomeEvent {}

class GetImageEvent extends HomeEvent {
  File image;

  GetImageEvent({
    required this.image,
  });
}

class PickImageFromGallery extends HomeEvent {}
