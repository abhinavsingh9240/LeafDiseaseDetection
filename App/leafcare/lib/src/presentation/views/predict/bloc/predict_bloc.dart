import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:leafcare/src/data/remote/api.dart';
import 'package:leafcare/src/utils/constants.dart';
part 'predict_event.dart';
part 'predict_state.dart';

class PredictBloc extends Bloc<PredictEvent, PredictState> {
  PredictBloc() : super(InitialState()) {
    on<GetImage>((event, emit) {
      emit(ImageSelectedState(image: event.image));
    });
    on<GetCategoryMethod>(
      (event, emit) {
        if (event.type == CategoryFetchMethod.UserDefined) {
          emit(SelectCategoryState(image: event.image));
        } else {
          emit(PredictCategory(image: event.image));
        }
      },
    );
    on<GetCategory>((event, emit) {
      emit(CategoryPickedState(category: event.category, image: event.image));
    });
    on<GetPrediction>(
      (event, emit) async {
        emit(RequestSentState(category: event.category, image: event.image));
        Response response = await API.getPrediction(
          event.category,
          event.image,
        );
        var body = jsonDecode(response.body);
        emit(
          ResponseObtainedState(
            category: event.category,
            disease: body['data']['disease'] as String,
            image: event.image,
          ),
        );
        emit(
          ReadyToDisplay(
            category: event.category,
            disease: body['data']['disease'] as String,
            image: event.image,
          ),
        );
      },
    );
  }
}
