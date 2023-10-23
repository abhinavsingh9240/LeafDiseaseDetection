// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leafcare/src/presentation/views/camera/bloc/camera_bloc.dart';
import 'package:leafcare/src/presentation/views/camera/camera.dart';
import 'package:leafcare/src/presentation/views/home/bloc/home_bloc.dart';
import 'package:leafcare/src/presentation/views/home/home.dart';
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
    return const Scaffold();
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
