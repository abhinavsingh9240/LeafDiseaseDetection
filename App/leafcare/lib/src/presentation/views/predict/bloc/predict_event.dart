// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'predict_bloc.dart';

class PredictEvent {}

class GetImage extends PredictEvent {
  File image;
  GetImage({
    required this.image,
  });
}

class GetCategoryMethod extends PredictEvent {
  File image;
  CategoryFetchMethod type;
  GetCategoryMethod({
    required this.image,
    required this.type,
  });
}

class GetCategory extends PredictEvent {
  File image;
  String category;
  GetCategory({
    required this.image,
    required this.category,
  });
}

class GetPrediction extends PredictEvent {
  File image;
  String category;
  GetPrediction({
    required this.image,
    required this.category,
  });
}
