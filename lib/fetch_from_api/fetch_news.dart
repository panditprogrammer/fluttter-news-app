import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:inn/models/channel_headlines_model.dart';
import 'package:http/http.dart' as http;
import 'package:inn/models/news_filter_model.dart';

class FetchNews {
  // this future function has return type 'ChannelHeadlinesModel'
  Future<ChannelHeadlinesModel> FetchChannelHeadlines(String? country,
      String? language, String? source, String? category, String? q) async {
    String base_url;

    if (language != null && source != null && category != null && q != null) {
      base_url =
          "https://newsapi.org/v2/everything?country=in&apiKey=471f9439090e487aa3337c0aa53ed3da";
    } else {
      base_url =
          "https://newsapi.org/v2/top-headlines?apiKey=471f9439090e487aa3337c0aa53ed3da";
    }

    if (source != null) {
      base_url + "&source=$source";
    }

    if (country != null) {
      base_url + "&country=$country";
    }

    if (language != null) {
      base_url + "&language=$language";
    }

    if (category != null) {
      base_url + "&category=$category";
    }

    if (q != null) {
      base_url + "&q=$q";
    }

    print(base_url);

    final response = await http.get(Uri.parse(base_url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // return data from json to model
      return ChannelHeadlinesModel.fromJson(data);
    }
    if (response.statusCode == 429) {
      print(response.body);
    }
    throw Exception("Unable to fetch");
  }

// filter , search news
  Future<NewsFilterModel> FetchNewsFilter(String keywords) async {
    String api_url =
        "https://newsapi.org/v2/everything?q=$keywords&apiKey=471f9439090e487aa3337c0aa53ed3da";

    final response = await http.get(Uri.parse(api_url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (kDebugMode) {
        print(data);
        print(keywords);
      }
      // return data from json to model
      return NewsFilterModel.fromJson(data);
    }
    throw Exception("Unable to fetch");
  }
}
