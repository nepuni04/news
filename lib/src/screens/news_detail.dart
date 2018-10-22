import 'package:flutter/material.dart';
import 'dart:async';
import '../models/item_model.dart';
import '../blocs/comments_provider.dart';
import '../widgets/comment.dart';

class NewsDetail extends StatelessWidget {
  final int itemId;
  NewsDetail({@required this.itemId});

  @override
  Widget build(BuildContext context) {
    CommentsBloc bloc = CommentsProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("News Detail"),
      ),
      body: _buildBody(bloc),
    );
  }

  Widget _buildBody(CommentsBloc bloc) {
    return StreamBuilder(
      stream: bloc.itemWithComments,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        return FutureBuilder(
          future: snapshot.data[itemId],
          builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return CircularProgressIndicator();
            }

            return _buildList(itemSnapshot.data, snapshot.data);
          },
        );
      },
    );
  }

  Widget _buildList(ItemModel item, Map<int, Future<ItemModel>> itemMap) {
    final children = <Widget>[];
    children.add(_buildTitle(item));

    item.kids.forEach((kidId) {
      children.add(Comment(itemId: kidId, itemMap: itemMap, depth: 0));
    });

    return ListView(children: children);
  }

  Widget _buildTitle(ItemModel item) {
    return Container(
      margin: EdgeInsets.all(10.0),
      alignment: Alignment.topCenter,
      child: Text(
        item.title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
