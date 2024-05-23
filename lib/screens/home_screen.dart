import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inn/components/category_card.dart';
import 'package:inn/constants/colors.dart';
import 'package:inn/constants/widgets.dart';
import 'package:inn/data/data.dart';
import 'package:inn/models/channel_headlines_model.dart';
import 'package:inn/screens/news_detail_screen.dart';
import 'package:inn/view_model/news_view_model.dart';
import 'package:intl/intl.dart';

// default values
enum FilterChannelList {
  all,
  bbcNews,
  aryNews,
  independent,
  reuters,
  cnn,
  aljazeera
}

// Define the list of categories
final List<String> categories = [
  'all',
  'entertainment',
  'science',
  'health',
  'technology',
  'business',
  'general',
  'sports',
];

// global variables
String? channelName;
String? _selectedLanguage = 'en'; // Default selected language
String? _selectedCategory;
String? _selectedCountry = "in";

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

    FilterChannelList? selectedChannel = FilterChannelList.bbcNews;

    final datetimeFormat = DateFormat("dd MMMM, yyyy");

// get the full height and width of screen
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    int _selectedIndex = 0;

    final List<Widget> _pages = [
      Center(child: Text('Home Page')),
    ];

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
      Navigator.pop(context); // Close the drawer
    }

    Map<String, String> _languages = {
      'en': 'English',
      'hi': 'Hindi',
      'fr': 'French',
    };

    void _onCountryChanged(String? country) {
      setState(() {
        _selectedCountry = country;
      });
      if (kDebugMode) {
        print(_selectedCountry);
      }
    }

    void _onLanguageChanged(String? newLanguage) {
      setState(() {
        _selectedLanguage = newLanguage;
      });
    }

    void _onCategoryTap(String? category) {
      setState(() {
        _selectedCategory = category;
      });
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: cWhite),
        backgroundColor: cRed,
        centerTitle: true,
        title: Text("News",
            style: TextStyle(fontWeight: FontWeight.w700, color: cWhite)),
        actions: [
          PopupMenuButton<FilterChannelList>(
            icon: Icon(
              Icons.more_vert,
              color: cWhite,
            ),
            initialValue: selectedChannel,
            onSelected: (FilterChannelList filterChannel) {
              if (FilterChannelList.all.name == filterChannel.name) {
                channelName = null;
              }

              if (FilterChannelList.bbcNews.name == filterChannel.name) {
                channelName = "bbc-news";
              }
              if (FilterChannelList.aryNews.name == filterChannel.name) {
                channelName = "ary-news";
              }
              if (FilterChannelList.aljazeera.name == filterChannel.name) {
                channelName = "al-jazeera-english";
              }

              setState(() {
                // this is for menu default selection
                selectedChannel = filterChannel;
              });
            },
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<FilterChannelList>>[
              PopupMenuItem<FilterChannelList>(
                value: FilterChannelList.all,
                child: Text("All"),
              ),
              PopupMenuItem<FilterChannelList>(
                value: FilterChannelList.bbcNews,
                child: Text("BBC News"),
              ),
              PopupMenuItem<FilterChannelList>(
                value: FilterChannelList.aryNews,
                child: Text("Ary news"),
              ),
              PopupMenuItem<FilterChannelList>(
                value: FilterChannelList.aljazeera,
                child: Text("Al-jazeera"),
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: cRed,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Menu',
                    style: TextStyle(
                      color: cWhite,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Language',
                        style: TextStyle(
                          color: cWhite,
                          fontSize: 16,
                        ),
                      ),
                      DropdownButton<String>(
                        onChanged: (changedValue) {
                          _onLanguageChanged(changedValue);
                        },
                        value: _selectedLanguage,
                        dropdownColor: cRed,
                        iconEnabledColor: cWhite,
                        style: TextStyle(color: cWhite),
                        items: _languages.keys
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(_languages[
                                value]!), // Display language name instead of code
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: Icon(Icons.flag),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    onChanged: (changedValue) {
                      _onCountryChanged(changedValue);
                    },
                    value: _selectedCountry,
                    dropdownColor: cWhite,
                    iconEnabledColor: cBlack,
                    style: TextStyle(color: cBlack),
                    items: countryCodes.keys
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(countryCodes[
                            value]!), // Display country name instead of code
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Container(
                  height: 40.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          _onCategoryTap(categories[index]);
                        },
                        child: CategoryCard(
                          category: categories[index],
                          selectedCategory: _selectedCategory,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: height,
            width: width,
            child: FutureBuilder<ChannelHeadlinesModel>(
              future: newsViewModel.FetchChannelHeadlinesParse(
                  _selectedLanguage, channelName, _selectedCategory, null),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // show spinner
                  return Center(
                    child: loading_image,
                  );
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    // count total items
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      DateTime publishedDateTime = DateTime.parse(snapshot
                          .data!.articles![index].publishedAt
                          .toString());

                      // img to show
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewsDetailScreen(
                                urlToImage: snapshot
                                    .data!.articles![index].urlToImage
                                    .toString(),
                                newsTitle: snapshot.data!.articles![index].title
                                    .toString(),
                                newsDate: snapshot
                                    .data!.articles![index].publishedAt
                                    .toString(),
                                author: snapshot.data!.articles![index].author
                                    .toString(),
                                description: snapshot
                                    .data!.articles![index].description
                                    .toString(),
                                content: snapshot.data!.articles![index].content
                                    .toString(),
                                source: snapshot
                                    .data!.articles![index].source!.name
                                    .toString(),
                              ),
                            ),
                          );
                        },
                        child: Stack(alignment: Alignment.center, children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                height: height * .3,
                                width: width,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      child: loading_image,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        error_icon,
                                    imageUrl: snapshot
                                        .data!.articles![index].urlToImage
                                        .toString(),
                                  ),
                                ),
                              ),
                              Container(
                                width: width,
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10),
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
                              Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                width: width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        datetimeFormat
                                            .format(publishedDateTime),
                                        style: TextStyle(fontSize: 12)),
                                    Text(
                                      snapshot
                                          .data!.articles![index].source!.name
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ]),
                      );
                    },
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
