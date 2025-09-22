import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thanette/src/providers/auth_provider.dart';
import 'package:thanette/src/providers/notes_provider.dart';
import 'package:thanette/src/screens/login_screen.dart';
import 'package:thanette/src/screens/note_detail_screen.dart';
import 'package:thanette/src/screens/notes_list_screen.dart';
import 'package:thanette/src/screens/splash_screen.dart';

class ThanetteApp extends StatelessWidget {
  const ThanetteApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = const Color(0xFF7B61FF);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NotesProvider()..bootstrap()),
      ],
      child: MaterialApp(
        title: 'thanette',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: baseColor,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF5F5F7),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
            elevation: 0,
            centerTitle: false,
          ),
        ),
        initialRoute: SplashScreen.route,
        routes: {
          SplashScreen.route: (_) => const SplashScreen(),
          LoginScreen.route: (_) => const LoginScreen(),
          NotesListScreen.route: (_) => const NotesListScreen(),
          NoteDetailScreen.route: (ctx) {
            final args =
                ModalRoute.of(ctx)!.settings.arguments as NoteDetailArgs?;
            return NoteDetailScreen(args: args ?? const NoteDetailArgs());
          },
        },
      ),
    );
  }
}
