import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/models/breakingnews_model.dart';
import 'package:news_app/services/data.dart';
import 'package:news_app/services/news.dart';
import 'package:news_app/services/breaking.dart';
import 'package:news_app/views/allnewspage.dart';
import 'package:news_app/views/newsdetailscreen.dart';
import 'package:news_app/views/newswithcategoriesscreen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../models/categroy_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<CategoryModel> categories =[];
  List<BreakingModel> sliders =[];
  List<NewsModel> articles  = [];

  bool _loading = true;
  int activeIndex = 0;

  @override
  void initState() {
    categories = getCategories();
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
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('See'),
            Text('News',style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),)
          ],
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body:_loading ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 10.0),
                height: 70,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index)
                    {
                      return CategoriesTile(image: categories[index].image,categroyName: categories[index].categoryName);
                    }
                    ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Breaking News!',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        fontFamily: 'LibreBaskerville'
                      ),
                    ),
                    GestureDetector(
                      onTap: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> AllNews(news: 'Breaking')));
                      },
                      child: const Text('View All',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              CarouselSlider.builder(itemCount: 5, itemBuilder: (context, index, realIndex)
              {
                late String image = sliders[index].urlToImage!;
                late String name = sliders[index].title!;
                return buildSlider(image, index, name);
              }, options: CarouselOptions(
                  height: 250,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                onPageChanged: (index, reason)
                {
                  setState(() {
                    activeIndex = index;
                  });
                }
              )),
              SizedBox(height: 30,),
              Center(child: indicator()),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Trending News!',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'LibreBaskerville'
                      ),
                    ),
                    GestureDetector(
                      onTap: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> AllNews(news: 'Trending')));
                      },
                      child: const Text('View All',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 20
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                child: ListView.builder(
                  shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: articles.length,
                    itemBuilder: (context, index)
                    {
                      return TrendingNews(
                        blogUrl: articles[index].url!,
                        imageUrl: articles[index].urlToImage!,
                        title: articles[index].title!,
                        description: articles[index].description!,
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget buildSlider(String image, int index, String name) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 5.0),
    child: Stack(
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: image,
              height: 250,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,)
        ),
        Container(
          height: 250,
          padding: EdgeInsets.only(left: 10),
          child: Text(name, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
          decoration: const BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
          ),
          margin: const EdgeInsets.only(top: 170),
          width: MediaQuery.of(context).size.width,
        ),
      ],
    ),
  );
  Widget indicator() => AnimatedSmoothIndicator(
    activeIndex: activeIndex,
    count: 5,
    effect: SlideEffect(dotWidth: 15, dotHeight: 15, activeDotColor: Colors.blue),
  );
}

class TrendingNews extends StatelessWidget {
  String imageUrl, title, description, blogUrl;
  TrendingNews({ required this.imageUrl, required this.title, required this.description, required this.blogUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetail(newsUrl: blogUrl)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Material(
            elevation: 3,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,)
                    ),
                  ),
                  SizedBox(width: 5),
                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width/1.9,
                        child: Text(title,
                          maxLines: 2,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Container(
                        width: MediaQuery.of(context).size.width/1.9,
                        child: Text(description,
                          maxLines: 3,
                          style: const TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: 16
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CategoriesTile extends StatelessWidget {
  final image, categroyName;
  CategoriesTile({this.image, this.categroyName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (context) => NewsWithCategory('$categroyName')));
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                image,
                width: 120,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: 120,
              height: 70,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.black38
              ),
              child: Center(
                child: Text(
                  categroyName,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
