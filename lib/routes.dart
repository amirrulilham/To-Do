import 'package:etiqa_todo/pages/homescreen.dart';
import 'package:etiqa_todo/pages/newTodo.dart';
import 'package:etiqa_todo/pages/splashscreen.dart';
import 'package:get/route_manager.dart';

var route = [
  GetPage(name: '/', page: () => SplashScreen()),
  GetPage(name: '/home', page: () => HomeScreen()),
  GetPage(name: '/addNew', page: () => AddNewTodo()),
];
