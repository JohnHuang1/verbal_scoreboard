import 'package:flutter/material.dart';
import 'package:verbal_scoreboard/shared/routes.dart';
import 'package:verbal_scoreboard/shared/style.dart';

import 'game/game_page.dart';
import 'game_list/list_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: _routeFactory(),
      theme: _theme(),
    );
  }

  RouteFactory _routeFactory(){
    return (settings) {
      Map<String, dynamic> arguments = settings.arguments;
      Widget screen;
      switch(settings.name){
        case ListPageRoute:
          screen = ListPage();
          break;
        case GamePageRoute:
          screen = GamePage(arguments['id']);
          break;
        default:
          return null;
      }
      return MaterialPageRoute(builder: (BuildContext context) => screen);
    };
  }

  ThemeData _theme(){
    return ThemeData(
        appBarTheme: AppBarTheme(
          textTheme: TextTheme(headline6: AppBarTextStyle),
        ),
        textTheme: TextTheme(
          headline6: TitleTextStyle,
          bodyText2: BodyText2TextStyle,
          subtitle2: SubTitle2TextStyle,
          caption: CaptionTextStyle,
        )
    );
  }
}