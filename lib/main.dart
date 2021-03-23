import 'package:flutter/material.dart';
import 'package:github_users/ui/pages/home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'resources/repository.dart';

Future main() async {
  // load environment variables (github client_id and client_secret)
  await DotEnv.load(); // fileName: ".env" - by default, so
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  )); // make the status bar transparent
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<Repository>(
      create: (c) => Repository(),
      child: MaterialApp(
        title: 'Github Users',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
