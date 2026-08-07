import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nota_app/ui/core/themes/app_theme.dart';
import 'package:nota_app/ui/library/view/library_screen.dart';
import 'config/app_config.dart';

void startupApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.instance;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConfig.instance.appTitle,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const LibraryScreen(),

      builder: (context, child) {
        if (config.isDev) {
          return Banner(
            message: "DEV",
            location: BannerLocation.bottomEnd,
            color: Colors.red,
            child: child,
          );
        }
        return child!;
      },
    );
  }
}
