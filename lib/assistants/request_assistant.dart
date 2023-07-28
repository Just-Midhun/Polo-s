import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestAssistant {
  static Future<dynamic> getRequest(url) async {
    http.Response httpResponse = await http.get(url as Uri);
    try {
      if (httpResponse.statusCode == 200) {
        //success
        String responseData = httpResponse.body; //json response
        var decodeResponseData = jsonDecode(responseData);
        return decodeResponseData;
      } else {
        return "Error occurred, No response";
      }
    } catch (exp) {
      return "Error occurred, No response";
    }
  }
}
