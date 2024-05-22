import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inn/constants/colors.dart';
import 'package:inn/constants/widgets.dart';
import 'package:inn/models/news_filter_model.dart';
import 'package:inn/view_model/news_view_model.dart';
import 'package:intl/intl.dart';

class FilterNewsScreen extends StatefulWidget {
  const FilterNewsScreen({super.key});

  @override
  State<StatefulWidget> createState() => FilterNewsScreenState();
}

String keywords = "general";

class FilterNewsScreenState extends State {
  @override
  Widget build(BuildContext context) {
    // to get the data from input fields
    final TextEditingController _textEditingController =
        TextEditingController();
    NewsViewModel newsViewModel = NewsViewModel();

    final datetimeFormat = DateFormat("dd MMMM, yyyy");
    // get the full height and width of screen
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: cWhite, // Change your color here
        ),
        backgroundColor: cRed,
        title: TextFormField(
          controller: _textEditingController,
          decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Search...',
              hintStyle: TextStyle(color: cWhite)),
          style: const TextStyle(color: cWhite),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              if (keywords.isNotEmpty) {
                if (kDebugMode) print(keywords);
                setState(() {
                  keywords = _textEditingController.text.toString();
                });
              }
            },
          ),
        ],
      ),
      body: Expanded(
        flex: 1,
        child: FutureBuilder<NewsFilterModel>(
          future: newsViewModel.FetchFilterNewsParse(keywords),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // show spinner
              return const Center(
                child: loading_image,
              );
            } else {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                // count total items
                itemCount: snapshot.data!.articles!.length,
                itemBuilder: (context, index) {
                  DateTime publishedDateTime = DateTime.parse(
                      snapshot.data!.articles![index].publishedAt.toString());

                  // img to show
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          height: height * .3,
                          width: width,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                child: loading_image,
                              ),
                              errorWidget: (context, url, error) => error_icon,
                              imageUrl: snapshot
                                  .data!.articles![index].urlToImage
                                  .toString(),
                            ),
                          ),
                        ),
                        Container(
                          width: width,
                          padding:
                              EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          child: Text(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            snapshot.data!.articles![index].title.toString(),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          width: width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(datetimeFormat.format(publishedDateTime),
                                  style: TextStyle(fontSize: 12)),
                              Text(
                                snapshot.data!.articles![index].source!.name
                                    .toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]);
                },
              );
            }
          },
        ),
      ),
    );
  }
}
