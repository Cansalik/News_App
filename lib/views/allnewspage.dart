import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/breakingnews_model.dart';
import '../models/news_model.dart';
import '../services/breaking.dart';
import '../services/news.dart';
import 'newsdetailscreen.dart';

class AllNews extends StatefulWidget {
  String news;
  AllNews({required this.news});

  @override
  State<AllNews> createState() => _AllNewsState();
}

class _AllNewsState extends State<AllNews> {
  bool _isSearch = false;
  String searchWord = "";
  bool _loading = true;

  List<BreakingModel> sliders =[];
  List<NewsModel> articles  = [];
  List<BreakingModel> filteredSliders = [];
  List<NewsModel> filteredArticles = [];

  @override
  void initState() {
    getBreaking();
    getNews();
    super.initState();
  }
  getNews() async {
    News _news = News();
    await _news.getNews();
    articles =  _news.news;
    setState(() {
      _loading = false;
    });
  }

  getBreaking() async {
    BreakingNews _breakingNews = BreakingNews();
    await _breakingNews.getBreaking();
    sliders =  _breakingNews.breakingList;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isSearch) {
      filteredSliders = sliders
          .where((slider) =>
          slider.title!.toLowerCase().contains(searchWord.toLowerCase()))
          .toList();
      filteredSliders = sliders
          .where((slider) =>
          slider.description!.toLowerCase().contains(searchWord.toLowerCase()))
          .toList();
      filteredArticles = articles
          .where((article) =>
          article.title!.toLowerCase().contains(searchWord.toLowerCase()))
          .toList();
      filteredArticles = articles
          .where((article) =>
          article.description!.toLowerCase().contains(searchWord.toLowerCase()))
          .toList();
    } else {
      filteredSliders = sliders;
      filteredArticles = articles;
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _isSearch ?
        TextField(
          decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.blue,decoration: TextDecoration.underline),
            labelText: "Search Word",
          ),
          onChanged: (searchResult)
          {
            setState(() {
              searchWord = searchResult;
            });
          },
        )
            : Text(widget.news + ' News',style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
        actions: [
          _isSearch ?
          IconButton(
            icon: Icon(Icons.cancel,color: Colors.blue,),
            onPressed: ()
            {
              setState(() {
                _isSearch = false;
                searchWord = "";
              });
            },
          )
              : IconButton(
            icon: Icon(Icons.search,color: Colors.blue,),
            onPressed: ()
            {
              setState(() {
                _isSearch = true;
              });
            },
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: widget.news == 'Breaking'
              ? filteredSliders.length
              : filteredArticles.length,
          itemBuilder: (context, index) {
            return NewsList(
              image: widget.news == 'Breaking'
                  ? filteredSliders[index].urlToImage!
                  : filteredArticles[index].urlToImage!,
              description: widget.news == 'Breaking'
                  ? filteredSliders[index].description!
                  : filteredArticles[index].description!,
              title: widget.news == 'Breaking'
                  ? filteredSliders[index].title!
                  : filteredArticles[index].title!,
              blogUrl: widget.news == 'Breaking'
                  ? filteredSliders[index].url!
                  : filteredArticles[index].url!,
              date: widget.news == 'Breaking'
                  ? filteredSliders[index].publishedAt!
                  : filteredArticles[index].publishedAt!,
            );
          },
        ),
      ),
    );
  }
}


class NewsList extends StatelessWidget {

  String image, description, title, blogUrl, date;
  NewsList({required this.image, required this.description, required this.title, required this.blogUrl, required this.date});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetail(newsUrl: blogUrl)));
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: image,
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  fit: BoxFit.cover,)
            ),
            SizedBox(height: 5,),
            RichText(
              maxLines: 2,
              text: TextSpan(
                text: "$title - ",
                style: TextStyle(
                  color: Colors.black, // Set title color to black
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: DateFormat('dd.MM.yyyy').format(DateTime.parse(date)),
                    style: TextStyle(
                      color: Colors.blue, // Set date color to blue
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                description,
                maxLines: 4,
                style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
