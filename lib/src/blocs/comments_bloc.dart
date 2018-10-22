import 'package:rxdart/rxdart.dart';
import 'dart:async';
import '../models/item_model.dart';
import '../resources/repository.dart';

class CommentsBloc {
  Repository _repository = Repository();

  //Stream controllers for comments bloc
  PublishSubject _commentsFetcher = PublishSubject<int>();
  BehaviorSubject _commentsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();

  //Getters for comments bloc
  Observable<Map<int, Future<ItemModel>>> get itemWithComments => _commentsOutput.stream;
  Function(int) get fetchItemWithComments => _commentsFetcher.sink.add;

  CommentsBloc() {
    _commentsFetcher.stream.transform(_streamTransformer()).pipe(_commentsOutput);
  }

  _streamTransformer() {
    return ScanStreamTransformer<int, Map<int, Future<ItemModel>>>(
      (accumulator, currItemId, count) {
        accumulator[currItemId] = _repository.fetchItem(currItemId);
        accumulator[currItemId].then((ItemModel item) {
          item.kids.forEach((kidId) => fetchItemWithComments(kidId));
        });
        return accumulator;
      },
      <int, Future<ItemModel>>{},
    );
  }

  dispose() {
    _commentsFetcher.close();
    _commentsOutput.close();
  }
}
