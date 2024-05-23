import 'package:inn/fetch_from_api/fetch_news.dart';
import 'package:inn/models/channel_headlines_model.dart';
import 'package:inn/models/news_filter_model.dart';

class NewsViewModel {
  final dataFromApi = FetchNews();
// get data and return
  Future<ChannelHeadlinesModel> FetchChannelHeadlinesParse(String? language, String? source, String? category,String? q) async {

    final response =
        await dataFromApi.FetchChannelHeadlines(language, source, category,q);
    return response;
    
  }

// get data and return
  Future<NewsFilterModel> FetchFilterNewsParse(String keywords) async {
    final response = await dataFromApi.FetchNewsFilter(keywords);
    return response;
  }
}
