import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leafcare/src/presentation/pages/home/bloc/home_bloc.dart';
import 'package:leafcare/src/presentation/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          List<File> images = state.images;
          // print(images.first.path);
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              (images.isNotEmpty)
                  ? Container(
                      height: 200,
                      width: 200,
                      child: Image.file(images.last),
                    )
                  : Container(
                      child: const Text('Click on the take photo button'),
                    ),
              Center(
                child: getImage(context),
              ),
            ],
          );
        },
      ),
    );
  }
}
