import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:inn/constants/colors.dart';
import 'package:inn/constants/widgets.dart';
import 'package:inn/models/channel_headlines_model.dart';
import 'package:inn/view_model/news_view_model.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      title: "IIN",
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<StatefulWidget> createState() => HomepageState();
}

class HomepageState extends State {
  @override
  Widget build(BuildContext context) {
// create instance to access function
    NewsViewModel newsViewModel = NewsViewModel();

    final datetimeFormat = DateFormat("dd MMMM, yyyy");

// get the full height and width of screen
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: cRed,
          centerTitle: true,
          leading: IconButton(
            color: cWhite,
            icon: Icon(Icons.grid_view_outlined),
            onPressed: () {},
          ),
          title: Text(
            "News",
            style: TextStyle(fontWeight: FontWeight.w700, color: cWhite),
          )),
      body: ListView(
        children: [
          SizedBox(
            height: height * 0.41,
            width: width,
            child: FutureBuilder<ChannelHeadlinesModel>(
              future: newsViewModel.FetchChannelHeadlinesParse(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // show spinner
                  return Center(
                    child: loading_image,
                  );
                } else {
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      // count total items
                      itemCount: snapshot.data!.articles!.length,
                      itemBuilder: (context, index) {
                        DateTime publishedDateTime = DateTime.parse(snapshot
                            .data!.articles![index].publishedAt
                            .toString());

                        // img to show
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                                width: width,
                                padding: EdgeInsets.all(width*0.02),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.fitWidth,
                                        placeholder: (context, url) =>
                                            Container(
                                          child: loading_image,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            error_icon,
                                        imageUrl: snapshot
                                            .data!.articles![index].urlToImage
                                            .toString(),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 8,bottom: 5),
                                      child: Text(
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        snapshot.data!.articles![index].title
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            datetimeFormat
                                                .format(publishedDateTime),
                                            style: TextStyle(fontSize: 12)),
                                        Text(
                                          snapshot.data!.articles![index]
                                              .source!.name
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                          ],
                        );
                      });
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
