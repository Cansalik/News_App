import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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

  bool _loading = true;
  List<BreakingModel> sliders =[];
  List<NewsModel> articles  = [];

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
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.news + ' News',style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
          ],
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child:ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: widget.news == 'Breaking' ? sliders.length : articles.length,
            itemBuilder: (context, index)
            {
              return NewsList(
                  image: widget.news == 'Breaking' ? sliders[index].urlToImage! : articles[index].urlToImage!,
                  description: widget.news == 'Breaking' ? sliders[index].description! : articles[index].description!,
                  title:widget.news == 'Breaking' ? sliders[index].title! : articles[index].title!,
                  blogUrl: widget.news == 'Breaking' ? sliders[index].url! : articles[index].url!,
              );
            }),
      ),
    );
  }
}


class NewsList extends StatelessWidget {

  String image, description, title, blogUrl;
  NewsList({required this.image, required this.description, required this.title, required this.blogUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetail(newsUrl: blogUrl)));
      },
      child: Container(
        child: Column(
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
            Text(
              title,
              maxLines: 2,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold
              ),
            ),
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
