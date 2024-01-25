import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/breakingnews_model.dart';

class BreakingNews
{
  List<BreakingModel> breakingList =[];

  Future<void> getBreaking() async
  {
    String url = 'https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=a9338d587115445686748246672271f3';
    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    if(jsonData['status'] == 'ok')
    {
      jsonData['articles'].forEach((element)
      {
        if(element['urlToImage'] != null && element['description'] != null)
        {
          BreakingModel breakingModel = BreakingModel(
              element['author'],
              element['title'],
              element['description'],
              element['url'],
              element['urlToImage'],
              element['content']
          );
          breakingList.add(breakingModel);
        }
      });
    }
  }

}