import 'package:flutter/material.dart';
import 'blocs/stories_provider.dart';
import 'screens/news_list.dart';
import 'screens/news_detail.dart';
import 'blocs/comments_provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoriesProvider(
      child: CommentsProvider(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Hacker News",
          onGenerateRoute: _buildRoutes,
        ),
      ),
    );
  }

  Route _buildRoutes(RouteSettings settings) {
    if (settings.name == "/") {
      return MaterialPageRoute(
        builder: (context) {
          final StoriesBloc bloc = StoriesProvider.of(context);
          bloc.fetchTopIds();

          return NewsList();
        },
      );
    } else {
      return MaterialPageRoute(builder: (context) {
        final itemId = int.parse(settings.name.replaceFirst('/', ''));
        final CommentsBloc commentsBloc = CommentsProvider.of(context);
        commentsBloc.fetchItemWithComments(itemId);

        return NewsDetail(itemId: itemId);
      });
    }
  }
}
