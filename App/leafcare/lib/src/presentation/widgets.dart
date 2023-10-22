// Home.dart

import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:leafdiseasedetectionapp/src/presentation/pages/camera/camera.dart';
// import 'package:leafdiseasedetectionapp/src/presentation/pages/home/bloc/home_bloc.dart';

Widget getImage(BuildContext context) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 15),
    child: MaterialButton(
      onPressed: () {
        Navigator.pushNamed(context, '/camera');
      },
      color: Colors.blue,
      height: 55,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      minWidth: double.maxFinite,
      child: const Text(
        'Take Picture',
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}
