import 'package:etiqa_todo/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  //NOTE: google_fonts license.
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  //NOTE: init getstorage to be used.
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      //NOTE: all routes in routes.dart
      getPages: route,
      //NOTE: Define Theme.
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey[200],
          textTheme: GoogleFonts.asapTextTheme()),
    );
  }
}
