import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_sample/src/providers/auth_provider.dart';
import 'package:flutter_sample/src/screens/auth/login_screen.dart';
import 'package:flutter_sample/src/screens/auth/password_reset_screen.dart';
import 'package:flutter_sample/src/screens/auth/register/register_confirm_screen.dart';
import 'package:flutter_sample/src/screens/auth/register/register_input_screen.dart';
import 'package:flutter_sample/src/screens/home/home_detail_screen.dart';
import 'package:flutter_sample/src/screens/home/home_screen.dart';
import 'package:flutter_sample/src/screens/setting/setting_account_edit_screen.dart';
import 'package:flutter_sample/src/screens/setting/setting_phone_number_edit_screen.dart';
import 'package:flutter_sample/src/screens/setting/setting_screen.dart';
import 'package:flutter_sample/src/screens/setting/setting_withidraw_screen.dart';
import 'package:flutter_sample/src/screens/splash_screen.dart';
import 'package:flutter_sample/src/themes/app_theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(ChangeNotifierProvider(
    create: (conntext) => AuthProvider(),
    child: const MyApp(),
  ));
}

// ルート定義
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/register/input': (context) => const RegisterInputScreen(),
        '/register/confirm': (context) {
          final Map<String, String> arguments = ModalRoute.of(context)!
              .settings
              .arguments as Map<String, String>;
          return RegisterComfirmScreen(arguments: arguments);
        },
        '/password/reset': (context) => const PasswordResetScreen(),
        '/home': (context) => const HomeScreen(),
        '/home/detail': (context) {
          final int id = ModalRoute.of(context)!.settings.arguments as int;
          return HomeDetailScreen(id: id);
        },
        '/setting': (context) => SettingScreen(),
        '/setting/account/edit': (context) =>
            const SettingAccountEditScreen(),
        '/setting/phone/edit': (context) => const SettingPhoneNumberEditScreen(),
        '/setting/withdraw': (context) => const SettingWithidrawScreen(),
      }
    );
  }
}
