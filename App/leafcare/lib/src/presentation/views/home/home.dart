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
                return Container(
                  margin: const EdgeInsets.only(top: 20),
                  height: 375.w,
                  width: 375.w,
                  child: Image.file(state.image),
                );
              }
              return Container();
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
                        BlocProvider.of<HomeBloc>(context).add(PickImageFromGallery());
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
