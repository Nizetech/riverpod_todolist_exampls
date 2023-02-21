import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_todolist/todo_list/todo.dart';
import 'package:riverpod_todolist/todo_list/todo_list_widgets.dart';
import 'package:riverpod_todolist/vandad_tutorials/counter_app/counter_app.dart';

import 'vandad_tutorials/weather_app/weather_app.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: Home(),
      // home: CounterApp(),
      home: WeatherApp(),
    );
  }
}
