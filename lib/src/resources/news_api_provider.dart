import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'dart:async';
import '../models/item_model.dart';
import 'repository.dart';

class NewsApiProvider implements Source {
  Client client = Client();
  String _root =  "https://hacker-news.firebaseio.com/v0";

  Future<List<int>> fetchTopIds() async {
    final response = await client.get("$_root/topstories.json");
    final List<dynamic> ids = json.decode(response.body);
    return ids.cast<int>();
  }

  Future<ItemModel> fetchItem(int id) async {
    final response = await client.get("$_root/item/$id.json");
    final ItemModel item = ItemModel.fromJson(json.decode(response.body));
    return item;
  }

}