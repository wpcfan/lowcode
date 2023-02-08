import 'package:admin/constants.dart';
import 'package:admin/routes/router_config.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Admin Panel',
      theme: ThemeData.dark(useMaterial3: false).copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
        dataTableTheme: DataTableThemeData(
          headingRowColor: MaterialStateProperty.all(secondaryColor),
          dataRowColor: MaterialStateProperty.all(secondaryColor),
          dividerThickness: 0,
        ),
      ),
      routerConfig: routerConfig,
    );
  }
}
