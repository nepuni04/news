import 'package:flutter/material.dart';
import '../blocs/stories_provider.dart';
import '../models/item_model.dart';
import '../widgets/loading_container.dart';
import 'dart:async';

class NewsListTile extends StatelessWidget{
  final int id;
  NewsListTile({this.id});

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);

    return StreamBuilder(
      stream: bloc.items,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if(!snapshot.hasData) {
          return LoadingContainer();
        }

        return FutureBuilder(
          future: snapshot.data[id],
          builder: (context, AsyncSnapshot<ItemModel> snapshot) {
            if(!snapshot.hasData) {
              return LoadingContainer();
            }
            return buildItem(snapshot.data);
          },
        );
      }
    );
  }

  Widget buildItem(ItemModel item) {
    return Column(
      children: <Widget>[
        ListTile(
            title: Text('${item.title}'),
            subtitle: Text("${item.score} votes"),
            trailing: Column(
              children: <Widget>[
                Icon(Icons.comment),
                Text("${item.descendants}"),
              ],
            ),
          ),
          Divider(height: 8.0)
      ],
    );
  }
}