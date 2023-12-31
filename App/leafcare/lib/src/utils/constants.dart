// ignore_for_file: constant_identifier_names

class AppRouteStrings {
  static String home = '/';
  static String camera = '/camera';
  static String predict = '/predict';
  static String settings = '/settings';
}

class AppStrings {
  static String ip = '';
  static String baseUrl = 'http://$ip:8000/api/v1/';
}

enum CategoryFetchMethod {
  Predict,
  UserDefined;
}
