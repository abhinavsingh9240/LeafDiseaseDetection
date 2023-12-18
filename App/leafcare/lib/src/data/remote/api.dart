import 'dart:io';
import 'package:async/async.dart';
import 'package:http/http.dart';
import 'package:leafcare/src/utils/constants.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class API {
  static getPrediction(String category, File image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ip = '51.20.255.15' ?? '';
    AppStrings.baseUrl = 'http://$ip:8000/api/v1/';
    Uri url = Uri.parse('${AppStrings.baseUrl}${category.toLowerCase()}');
    var stream = ByteStream(DelegatingStream.typed(image.openRead()));
    var length = await image.length();

    var request = MultipartRequest("POST", url);
    request.fields['category'] = category;
    
    var multiPartFile = MultipartFile(
      'file',
      stream,
      length,
      filename: basename(image.path),
      contentType: MediaType('image', 'jpg'),
    );
    request.files.add(multiPartFile);
    StreamedResponse streamResponse = await request.send();
    Response response = await Response.fromStream(streamResponse);
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print(response);
    }
    return response;
  }
}
