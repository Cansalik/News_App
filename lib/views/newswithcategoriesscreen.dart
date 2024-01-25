import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/views/newsdetailscreen.dart';
import '../models/newswithcategories_model.dart';
import '../services/newswithcategories.dart';

class NewsWithCategory extends StatefulWidget {

  String categoryName;
  NewsWithCategory(this.categoryName);

  @override
  State<NewsWithCategory> createState() => _NewsWithCategoryState();
}

class _NewsWithCategoryState extends State<NewsWithCategory> {

  List<NewsWithCategoriesModel> categories = [];
  bool _loading = true;

  @override
  void initState() {
    getCategory();
    super.initState();
  }

  getCategory() async {
    NewsWithCategories newsWithCategories = NewsWithCategories();
    await newsWithCategories.getCategory(widget.categoryName.toLowerCase());
    categories = newsWithCategories.categoriesList;
    setState(() {
      _loading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.categoryName,style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
            Text(' News'),
          ],
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: categories.length,
            itemBuilder: (context, index)
            {
              return NewsList(
                  image: categories[index].urlToImage!,
                  description: categories[index].description!,
                  title:categories[index].title!,
                  blogUrl: categories[index].url!
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

