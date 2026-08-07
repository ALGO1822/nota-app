import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nota_app/data/repositories/local_file_repository_impl.dart';
import 'package:nota_app/data/repositories/note_repository_impl.dart';
import 'package:nota_app/services/hive_service.dart';
import 'package:nota_app/ui/core/themes/app_theme.dart';
import 'package:nota_app/ui/library/cubit/library_cubit.dart';
import 'package:nota_app/ui/library/view/library_screen.dart';
import 'config/app_config.dart';

void startupApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final hiveService = HiveService();
  await hiveService.init();

  runApp(MyApp(hiveService: hiveService));
}

class MyApp extends StatelessWidget {
  final HiveService hiveService;
  const MyApp({super.key, required this.hiveService});

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.instance;

    return MultiBlocProvider(
      providers: [
        BlocProvider<LibraryCubit>(
          create: (context) => LibraryCubit(
            LocalFileRepositoryImpl(),
            NoteRepositoryImpl(hiveService),
          )..loadNotes(),
        ),
      ],
      child: MaterialApp(
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
      ),
    );
  }
}
