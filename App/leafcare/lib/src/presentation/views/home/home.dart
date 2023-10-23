import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leafcare/src/presentation/views/home/bloc/home_bloc.dart';
import 'package:leafcare/src/presentation/widgets/home_widgets.dart';
import 'package:leafcare/src/utils/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height: 180.h,
              color: Colors.green,
            ),
            drawerButton('Account', Icons.person),
            drawerButton('Settings', Icons.settings),
            drawerButton('Feedback', Icons.feedback),
          ],
        ),
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          List<File> images = [];
          return Container(
            width: 375.w,
            // color: Colors.amber,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                (images.isNotEmpty)
                    ? Container(
                        height: 200,
                        width: 200,
                        child: Image.file(images.last),
                      )
                    : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    getImage(
                      () {
                        Navigator.pushNamed(context, AppRouteStrings.camera);
                      },
                      ' Take Picture',
                      Icons.camera_alt,
                    ),
                    getImage(
                      () {},
                      ' Upload Picture',
                      Icons.upload,
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
