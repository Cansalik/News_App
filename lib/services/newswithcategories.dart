import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/models/newswithcategories_model.dart';

class NewsWithCategories
{
  List<NewsWithCategoriesModel> categoriesList = [];

  Future<void> getCategory(String categoryName) async
  {
    String url = 'https://newsapi.org/v2/top-headlines?country=us&category=$categoryName&apiKey=a9338d587115445686748246672271f3';
    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    if(jsonData['status'] == 'ok')
    {
      jsonData['articles'].forEach((element)
      {
        if(element['urlToImage'] != null && element['description'] != null)
        {
          NewsWithCategoriesModel newsWithCategoriesModel = NewsWithCategoriesModel(
              element['author'],
              element['title'],
              element['description'],
              element['url'],
              element['urlToImage'],
              element['content']
          );
          categoriesList.add(newsWithCategoriesModel);
        }
      });
    }
  }

}