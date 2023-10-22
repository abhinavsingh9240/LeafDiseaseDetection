import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leafcare/src/presentation/pages/camera/bloc/camera_bloc.dart';
import 'package:leafcare/src/presentation/pages/camera/camera.dart';
import 'package:leafcare/src/presentation/pages/home/bloc/home_bloc.dart';
import 'package:leafcare/src/presentation/pages/home/home.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeBloc(),
        ),
        BlocProvider(
          create: (context) => CameraBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'LeafCare',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => HomePage(),
          '/camera': (context) => CameraPage(),
        },
      ),
    );
  }
}
