// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';

class HomeState {
  List<File> images;
  HomeState({
    required this.images,
  });

  HomeState copyWith({List<File>? images}) {
    return HomeState(
      images: images ?? this.images,
    );
  }
}
