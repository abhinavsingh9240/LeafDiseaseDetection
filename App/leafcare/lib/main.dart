import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leafcare/src/config/global.dart';
import 'package:leafcare/src/config/router.dart';
import 'package:leafcare/src/config/themes.dart';
import 'package:leafcare/src/utils/constants.dart';

void main() {
  Global.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: MultiBlocProvider(
        providers: [...AppRouter.allBlocProviders()],
        child: MaterialApp(
          title: 'LeafCare',
          theme: AppThemes.light,
          debugShowCheckedModeBanner: false,
          initialRoute: AppRouteStrings.home,
          onGenerateRoute: AppRouter.onGenerateRoute,
        ),
      ),
    );
  }
}
