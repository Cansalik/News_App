import 'dart:convert';

import '../models/news_model.dart';
import 'package:http/http.dart' as http;


class News
{
  List<NewsModel> news =[];

  Future<void> getNews() async
  {
    String url = 'https://newsapi.org/v2/everything?q=tesla&from=2023-12-25&sortBy=publishedAt&apiKey=a9338d587115445686748246672271f3';
    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    if(jsonData['status'] == 'ok')
    {
      jsonData['articles'].forEach((element)
      {
        if(element['urlToImage'] != null && element['description'] != null)
        {
          NewsModel newsModel = NewsModel(
              element['author'],
              element['title'],
              element['description'],
              element['url'],
              element['urlToImage'],
              element['content'],
              element['publishedAt']
          );
          news.add(newsModel);
        }
      });
    }
  }

}