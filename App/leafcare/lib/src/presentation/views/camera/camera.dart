
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leafcare/src/presentation/views/camera/bloc/camera_bloc.dart';
import 'package:leafcare/src/presentation/views/home/bloc/home_bloc.dart';


class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late double deviceHeight, deviceWidth;

  @override
  void initState() {
    BlocProvider.of<CameraBloc>(context).add(ShowCameraPreview());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<CameraBloc, CameraState>(
      builder: (context, state) {
        if (state is Loading) {
          return Scaffold(
            body: SizedBox(
              height: deviceHeight,
              width: deviceWidth,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.green,
                  ),
                  Text(
                    "Loading Camera...",
                    style: TextStyle(color: Colors.black),
                  )
                ],
              ),
            ),
          );
        } else if (state is Loaded) {
          return Scaffold(
            body: SizedBox(
              height: deviceHeight,
              width: deviceWidth,
              child: CameraPreview(state.controller),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: GestureDetector(
              onTap: () {
                context
                    .read<CameraBloc>()
                    .add(CaptureImageEvent(controller: state.controller));
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          );
        } else if (state is Captured) {
          BlocProvider.of<HomeBloc>(context)
              .add(GetImageEvent(image: state.image));
          return Scaffold(
            body: Container(
              height: deviceHeight,
              width: deviceWidth,
              child: Center(
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Back"),
                ),
              ),
            ),
          );
        }
        return SizedBox(
          height: deviceHeight,
          width: deviceWidth,
          child: const Center(
            child: Text("Bad State"),
          ),
        );
      },
    );
  }
}
