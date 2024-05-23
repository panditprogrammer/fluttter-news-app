import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inn/constants/colors.dart';
import 'package:inn/constants/widgets.dart';
import 'package:intl/intl.dart';

class NewsDetailScreen extends StatefulWidget {
  String urlToImage, newsTitle, newsDate, author, description, content, source;

  NewsDetailScreen(
      {super.key,
      required this.urlToImage,
      required this.newsTitle,
      required this.newsDate,
      required this.author,
      required this.description,
      required this.content,
      required this.source});

  @override
  State<StatefulWidget> createState() => NewsDetailScreenState();
}

// extend to access variables
class NewsDetailScreenState extends State<NewsDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final datetimeFormat = DateFormat("dd MMMM, yyyy");
// get the full height and width of screen
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.source != "null" ? widget.source : widget.newsTitle,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
      ),
      body: Stack(
        children: [
          Container(
            width: width,
            height: height * 0.35,
            child: CachedNetworkImage(
              imageUrl: widget.urlToImage,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                child: loading_image,
              ),
              errorWidget: (context, url, error) => error_icon,
            ),
          ),
          Container(
            height: height * 0.65,
            width: width,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: height * 0.35),
            child: ListView(
              children: [
                Text(
                  widget.newsTitle,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          datetimeFormat
                              .format(DateTime.parse(widget.newsDate)),
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      Text(
                        widget.source,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    widget.description,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    widget.content != "null" ? widget.content : " ",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
