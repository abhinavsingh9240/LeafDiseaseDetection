// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leafcare/src/presentation/views/camera/bloc/camera_bloc.dart';
import 'package:leafcare/src/presentation/views/camera/camera.dart';
import 'package:leafcare/src/presentation/views/home/bloc/home_bloc.dart';
import 'package:leafcare/src/presentation/views/home/home.dart';
import 'package:leafcare/src/presentation/views/predict/bloc/predict_bloc.dart';
import 'package:leafcare/src/presentation/views/predict/predict_page.dart';
import 'package:leafcare/src/utils/constants.dart';

class AppRouter {
  static List<AppRoute> routes() => [
        AppRoute(
          route: AppRouteStrings.home,
          view: const HomePage(),
          bloc: BlocProvider(
            create: (context) => HomeBloc(),
          ),
        ),
        AppRoute(
          route: AppRouteStrings.camera,
          view: const CameraPage(),
          bloc: BlocProvider(
            create: (context) => CameraBloc(),
          ),
        ),
        AppRoute(
          route: AppRouteStrings.predict,
          view: const PredictionPage(),
          bloc: BlocProvider(
            create: (context) => PredictBloc(),
          ),
        ),
      ];

  static MaterialPageRoute onGenerateRoute(RouteSettings settings) {
    if (settings.name != null) {
      var results = routes().where((element) => element.route == settings.name);
      if (results.isNotEmpty) {
        return MaterialPageRoute(builder: (context) => results.first.view);
      }
      return MaterialPageRoute(builder: (context) => const BadRoute());
    }
    return MaterialPageRoute(builder: (context) => const BadRoute());
  }

  static allBlocProviders() {
    List blocProviders = [];
    for (var i in routes()) {
      blocProviders.add(i.bloc);
    }
    return blocProviders;
  }
}

class BadRoute extends StatelessWidget {
  const BadRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 500,
        width: 375.w,
        child: Column(
          children: [
            const Text('Something went wrong!'),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, AppRouteStrings.home);
              },
              child: Container(
                height: 45.h,
                width: 180.w,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                  child: Text('Back to Home'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppRoute {
  String route;
  Widget view;
  dynamic bloc;
  AppRoute({
    required this.route,
    required this.view,
    required this.bloc,
  });
}
