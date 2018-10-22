import '../models/item_model.dart';
import 'dart:async';
import 'news_api_provider.dart';
import 'news_db_provider.dart';

class Repository {
  List<Source> sources = [
    NewsDbProvider(),
    NewsApiProvider()
  ];

  List<Cache> caches = [
    NewsDbProvider()
  ];
  
  Future<ItemModel> fetchItem(int id) async {
    ItemModel item;
    var source;

    for(source in sources) {
      item = await source.fetchItem(id);
      if(item != null) break;
    }

    if(item != null) {
      for(var cache in caches) {
        if(cache != source) {
          cache.addItem(item);  
        }
      }
    }

    return item;
  }

  Future<List<int>> fetchTopIds() {
    return sources[1].fetchTopIds();
  }

  Future<dynamic> clearCache() async {
    for(var cache in caches) {
      await cache.clear();
    }
  }
}

abstract class Source {
  Future<List<int>> fetchTopIds();
  Future<ItemModel> fetchItem(int id);
}

abstract class Cache {
  Future<int> addItem(ItemModel item);
  Future<int> clear();
}