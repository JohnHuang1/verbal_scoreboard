import 'package:flutter/material.dart';
import 'package:verbal_scoreboard/shared/routes.dart';


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
      dynamic arguments = settings.arguments;
      Widget screen;
      switch(settings.name){
        case ListPageRoute:
          screen = ListPage();
          break;
        case GamePageRoute:
          screen = GamePage();
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