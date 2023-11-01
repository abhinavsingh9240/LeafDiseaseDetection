// ignore_for_file: avoid_unnecessary_containers

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leafcare/src/presentation/views/predict/bloc/predict_bloc.dart';
import 'package:leafcare/src/utils/constants.dart';
import 'package:timelines/timelines.dart';

class PredictionPage extends StatefulWidget {
  const PredictionPage({super.key});

  @override
  State<PredictionPage> createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  List<DropdownMenuItem> items = [];

  @override
  void initState() {
    List<String> categories = [
      'Rice',
      'Cherry',
      'Corn',
      'Apple',
      'Grape',
      'Peach',
      'Potato',
      'Strawberry',
    ];

    for (var i in categories) {
      items.add(
        DropdownMenuItem(
          value: i,
          child: Text(i),
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocConsumer<PredictBloc, PredictState>(
              builder: (context, state) {
                if (state is ImageSelectedState) {
                  return Column(
                    children: [
                      // progressIndicator(),
                      displayImage(state.image),
                      categorySelect(null, state.image),
                    ],
                  );
                } else if (state is SelectCategoryState) {
                  return Column(
                    children: [
                      displayImage(state.image),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: plantNameDropDown(null, state.image),
                      ),
                    ],
                  );
                } else if (state is PredictCategory) {
                  return Column(
                    children: [
                      displayImage(state.image),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: plantNameDropDown(null, state.image),
                      ),
                    ],
                  );
                } else if (state is CategoryPickedState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      displayImage(state.image),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        child: const Text(
                          'Leaf Name:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: plantNameDropDown(state.category, state.image),
                      ),
                      predictButton(state.image, state.category),
                    ],
                  );
                } else if (state is RequestSentState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      displayImage(state.image),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        child: const Text(
                          'Leaf Name:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: plantNameDropDown(state.category, state.image),
                      ),
                      requestSent(),
                    ],
                  );
                } else if (state is ResponseObtainedState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      displayImage(state.image),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        child: const Text(
                          'Leaf Name:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: plantNameDropDown(state.category, state.image),
                      ),
                      showResponse(),
                    ],
                  );
                } else if (state is ReadyToDisplay) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      displayImage(state.image),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        child: const Text(
                          'Leaf Name:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: plantNameDropDown(state.category, state.image),
                      ),
                      Container(
                        height: 40.h,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Disease:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              state.disease,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return Container();
              },
              listener: (context, state) {
                if (state is PredictCategory) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Feature Not Available'),
                        content: Container(
                          height: 105.h,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'This feature is not available right now!!',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Continue to select a name from the list',
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'OR',
                                    style: TextStyle(
                                      // color: Colors.
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Back to Exit the prediction',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              )
                            ],
                          ),
                        ),
                        actions: [
                          GestureDetector(
                            onTap: () {
                              BlocProvider.of<PredictBloc>(context).add(
                                GetCategoryMethod(
                                  image: state.image,
                                  type: CategoryFetchMethod.UserDefined,
                                ),
                              );
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 45.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.green,
                              ),
                              child: const Center(
                                child: Text(
                                  'Continue!!',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 45.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Center(
                                child: Text(
                                  'Back!!',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget progressIndicator() {
    return Container(
      width: 375.w,
      height: 60.h,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Timeline.tileBuilder(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        builder: TimelineTileBuilder.fromStyle(
          connectorStyle: ConnectorStyle.solidLine,
          contentsAlign: ContentsAlign.basic,
          itemCount: 6,
          // contentsBuilder: (context, index) {
          //   bool isDone = (index % 2 == 0) ? true : false;
          //   return progressItem(isDone);
          // },
        ),
      ),
    );
  }

  Widget progressItem(bool isDone) {
    if (isDone) {
      return Container(
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.green,
          ),
        ),
      );
    }
    return Container(
      height: 30.h,
      width: 30.h,
      // padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.green,
      ),
      child: Icon(
        Icons.done,
        color: Colors.white,
        size: 30.h,
      ),
    );
  }

  Widget showResponse() {
    return Container(
      height: 45.h,
      width: 375.w,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Center(
        child: Text('Response obtained....'),
      ),
    );
  }

  Widget requestSent() {
    return Container(
      height: 45.h,
      width: 375.w,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Center(
        child: Text('Waiting for Response....'),
      ),
    );
  }

  Widget displayImage(File image) {
    return Container(
      height: 375.w,
      width: 375.w,
      margin: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'Leaf Image:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Image.file(image),
        ],
      ),
    );
  }

  Widget categorySelect(var value, File image) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: 375.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Plant Name: ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 375.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                predictLeafName(image),
                const Text(
                  'OR',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                plantNameSelect(value, image)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget predictLeafName(File image) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<PredictBloc>(context).add(
          GetCategoryMethod(
            image: image,
            type: CategoryFetchMethod.Predict,
          ),
        );
      },
      child: Container(
        height: 45.h,
        width: 375.w,
        margin: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Center(
          child: Text(
            "I don't know this leaf. Predict using AI !!",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget plantNameSelect(var value, File image) {
    return Container(
      height: 70.h,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'I know this leaf',
            style: TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
          ),
          plantNameDropDown(value, image),
        ],
      ),
    );
  }

  Widget plantNameDropDown(var value, File image) {
    return Container(
      height: 45.h,
      width: 375.w,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButtonHideUnderline(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: DropdownButton(
            hint: const Text(
              'Select a leaf name',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            borderRadius: BorderRadius.circular(15),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 5,
            ),
            dropdownColor: Colors.green,
            isExpanded: false,
            style: const TextStyle(color: Colors.white),
            value: value,
            items: items,
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
            ),
            onChanged: (value) {
              BlocProvider.of<PredictBloc>(context).add(
                GetCategory(
                  image: image,
                  category: value,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget predictButton(File image, String category) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<PredictBloc>(context).add(
          GetPrediction(image: image, category: category),
        );
      },
      child: Container(
        height: 45.h,
        width: 375.w,
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Center(
          child: Text(
            'Check if the leaf is diseased',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
