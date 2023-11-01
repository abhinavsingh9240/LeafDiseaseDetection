import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leafcare/src/presentation/views/home/bloc/home_bloc.dart';
import 'package:leafcare/src/presentation/views/predict/bloc/predict_bloc.dart';
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
        elevation: 0,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height: 180.h,
              color: Colors.green,
            ),
            // drawerButton('Account', Icons.person),
            drawerButton('Settings', Icons.settings),
            drawerButton('Feedback', Icons.feedback),
          ],
        ),
      ),
      body: Column(
        children: [
          BlocConsumer<HomeBloc, HomeState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is ImagePickedState) {
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 18,
                      ),
                      height: 375.w,
                      width: 375.w,
                      child: Image.file(state.image),
                    ),
                    GestureDetector(
                      onTap: () {
                        BlocProvider.of<PredictBloc>(context).add(
                          GetImage(image: state.image),
                        );
                        Navigator.pushNamed(context, AppRouteStrings.predict);
                      },
                      child: Container(
                        height: 45.h,
                        width: 375.w,
                        margin: const EdgeInsets.symmetric(horizontal: 18),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.online_prediction),
                            Text(
                              ' Detect Leaf Disease',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              return Container(
                margin: const EdgeInsets.only(top: 20),
                height: 375.w,
                width: 375.w,
                child: const Center(
                  child: Text('Take a picture or select from gallery'),
                ),
              );
            },
          ),
          Container(
            width: 375.w,
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                      () {
                        BlocProvider.of<HomeBloc>(context)
                            .add(PickImageFromGallery());
                      },
                      ' Upload Picture',
                      Icons.upload,
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
