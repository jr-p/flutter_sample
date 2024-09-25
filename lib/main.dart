import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_sample/src/providers/auth_provider.dart';
import 'package:flutter_sample/src/screens/auth/login_screen.dart';
import 'package:flutter_sample/src/screens/auth/register_confirm_screen.dart';
import 'package:flutter_sample/src/screens/auth/register_input_screen.dart';
import 'package:flutter_sample/src/screens/home/home_detail_screen.dart';
import 'package:flutter_sample/src/screens/home/home_screen.dart';
import 'package:flutter_sample/src/screens/setting/setting_account_edit_screen.dart';
import 'package:flutter_sample/src/screens/setting/setting_screen.dart';
import 'package:flutter_sample/src/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(ChangeNotifierProvider(
    create: (conntext) => AuthProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
        routes: {
          '/login': (context) => LoginScreen(),
          '/register-input': (context) => const RegisterInputScreen(),
          '/register-confirm': (context) {
            final Map<String, String> arguments =
                ModalRoute.of(context)!.settings.arguments as Map<String, String>;
            return RegisterComfirmScreen(arguments: arguments);
          },
          '/home': (context) => const HomeScreen(),
          '/home/detail': (context) {
            final int id = ModalRoute.of(context)!.settings.arguments as int;
            return HomeDetailScreen(id: id);
          },
          '/setting': (context) => SettingScreen(),
          '/setting/account/edit': (context) => const SettingAccountEditScreen(),
        });
  }
}
