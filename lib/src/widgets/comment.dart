import 'package:flutter/material.dart';
import 'dart:async';
import '../models/item_model.dart';
import 'loading_container.dart';

class Comment extends StatelessWidget {
  final Map<int, Future<ItemModel>> itemMap;
  final int itemId;
  final int depth;

  Comment({this.itemId, this.itemMap, this.depth});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: itemMap[itemId],
      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        }

        var item = snapshot.data;
        var children = <Widget>[
          ListTile(
            title: item.by == '' ? Text("Deleted") : buildText(item),
            subtitle: item.by == '' ? Text("Deleted") : Text(snapshot.data.by),
            contentPadding: EdgeInsets.only(
              right: 16.0,
              left: (depth + 1) * 16.0
            ),
          ),
          Divider(),
        ];

        item.kids.forEach((kidId) {
          children.add(Comment(itemId: kidId, itemMap: itemMap, depth: depth + 1));
        });

        return Column(children: children);
      },
    );
  }

  Widget buildText(ItemModel item) {
    final text = item.text
        .replaceAll('&#x27;', "'")
        .replaceAll('<p>', '\n\n')
        .replaceAll('&#x2F;', '/')
        .replaceAll('</p>', '');

    return Text(text);
  }
}
