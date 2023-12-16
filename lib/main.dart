import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:visualizer/screens/floodfill.dart';
import 'package:visualizer/screens/main_screen.dart';
import 'package:visualizer/screens/pathfinder.dart';
import 'package:visualizer/screens/settings.dart';
import 'package:visualizer/screens/sort.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    // Only initialize windowManager if not running on web
    await windowManager.ensureInitialized();

    WindowOptions myOption = const WindowOptions(
        size: Size(1000, 900),
        minimumSize: Size(950, 900),
        center: true,
        title: 'Visualizers',
        titleBarStyle: TitleBarStyle.hidden);

    windowManager.waitUntilReadyToShow(myOption, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  /* runApp(
    MultiProvider(
      providers: const [
        ChangeNotifierProvider(
          create: (context) => PathfinderState(),
        )
      ],
      child: const MainApp(),
    ),
  ); */

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const MainScreen(),
        '/pathfinder': (context) => const Pathfinder(),
        '/sort': (context) => const Sort(),
        '/floodfill': (context) => const FloodFill(),
        '/settings': (context) => const Settings(),
      },
    );
  }
}
