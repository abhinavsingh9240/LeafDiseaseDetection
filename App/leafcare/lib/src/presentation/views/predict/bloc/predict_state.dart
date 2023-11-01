// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'predict_bloc.dart';

class PredictState {}

class InitialState extends PredictState {}

class ImageSelectedState extends PredictState {
  File image;
  ImageSelectedState({
    required this.image,
  });
}

class SelectCategoryState extends PredictState {
  File image;
  SelectCategoryState({
    required this.image,
  });
}

class PredictCategory extends PredictState {
  File image;
  PredictCategory({
    required this.image,
  });
}

class CategoryPickedState extends PredictState {
  String category;
  File image;
  CategoryPickedState({
    required this.category,
    required this.image,
  });
}

class RequestSentState extends PredictState {
  File image;
  String category;
  RequestSentState({
    required this.image,
    required this.category,
  });
}

class ResponseObtainedState extends PredictState {
  File image;
  String category;
  String disease;
  ResponseObtainedState({
    required this.image,
    required this.category,
    required this.disease,
  });
}

class ReadyToDisplay extends PredictState {
  File image;
  String category;
  String disease;
  ReadyToDisplay({
    required this.image,
    required this.category,
    required this.disease,
  });
}
