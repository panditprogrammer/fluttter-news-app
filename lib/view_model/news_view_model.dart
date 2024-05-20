import 'package:inn/fetch_from_api/fetch_news.dart';
import 'package:inn/models/channel_headlines_model.dart';

class NewsViewModel {
  final dataFromApi = FetchNews();
// get data and return 
  Future<ChannelHeadlinesModel> FetchChannelHeadlinesParse() async {

    final response =  await dataFromApi.FetchChannelHeadlines();
    return response;
  }
}
