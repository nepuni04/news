import 'package:flutter/material.dart';
import 'stories_bloc.dart';
export 'stories_bloc.dart';

class StoriesProvider extends InheritedWidget {
  final StoriesBloc _bloc = StoriesBloc();

  StoriesProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static StoriesBloc of(BuildContext context) {
    StoriesProvider storiesProvider = context.inheritFromWidgetOfExactType(StoriesProvider); 
    return storiesProvider._bloc;
  }
}