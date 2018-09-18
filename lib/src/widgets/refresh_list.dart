import 'package:flutter/material.dart';
import '../blocs/stories_provider.dart';

class RefreshList extends StatelessWidget {
  final Widget child;
  RefreshList({ @required this.child }); 
 
  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);

    return RefreshIndicator(
      child: child,
      onRefresh: () async {
        await bloc.clear();
        await bloc.fetchTopIds();
        print("Successfully refreshed the list");
      },
    );
  }
}