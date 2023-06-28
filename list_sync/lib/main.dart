import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:list_sync/db/db_helper.dart';
import 'package:list_sync/services/theme_services.dart';
import 'package:list_sync/ui/home_page.dart';
import 'package:list_sync/ui/theme.dart';
import 'package:get/get.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
     theme: Themes.light,
     darkTheme: Themes.dark,
     themeMode: ThemeService().theme,

      home: const HomePage(),
    );
  }
}


