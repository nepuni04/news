import 'package:rxdart/rxdart.dart';
import '../resources/repository.dart';
import '../models/item_model.dart';
import 'dart:async';

class StoriesBloc {
  final _repository = Repository();
  PublishSubject _topIds = PublishSubject<List<int>>();
  PublishSubject _itemsFetcher = PublishSubject<int>();
  BehaviorSubject _itemsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();

  StoriesBloc() {
    _itemsFetcher.stream.transform(_itemTransformer()).pipe(_itemsOutput);
  }

  Observable<List<int>> get topIds => _topIds.stream;
  Observable<Map<int, Future<ItemModel>>> get items => _itemsOutput.stream;

  Future<dynamic> fetchTopIds() async {
    var topIds = await _repository.fetchTopIds();
    _topIds.sink.add(topIds);
  }  

  Function(int) get fetchItem => _itemsFetcher.sink.add;

  _itemTransformer() {
    return ScanStreamTransformer(
      (Map<int, Future<ItemModel>> cache, int id, index) {
        cache[id] = _repository.fetchItem(id);
        return cache;
      }, 
      <int, Future<ItemModel>> {});
  }

  Future<dynamic> clear() async {
    return _repository.clearCache();
  }

  dispose() {
    _topIds.close();
    _itemsFetcher.close();
    _itemsOutput.close();
  }
}