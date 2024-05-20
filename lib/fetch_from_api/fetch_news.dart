import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:inn/models/channel_headlines_model.dart';
import 'package:http/http.dart' as http;

class FetchNews {
  // this future function has return type 'ChannelHeadlinesModel'

  Future<ChannelHeadlinesModel> FetchChannelHeadlines() async {
    String api_url =
        "https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=471f9439090e487aa3337c0aa53ed3da";

    final response = await http.get(Uri.parse(api_url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if(kDebugMode){
      print(data);
    }
      // return data from json to model 
      return ChannelHeadlinesModel.fromJson(data);
    }
    throw Exception("Unable to fetch");
  }
}
