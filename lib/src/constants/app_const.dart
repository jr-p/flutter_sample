import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConst {
  static final String appName = dotenv.env['APP_NAME'] ?? 'Flutter App';
  static final String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:3000';
  static final String baseApiUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000/api';

  static final String mockEmail = dotenv.env['MOCK_EMAIL'] ?? '';
  static final String mockPassword = dotenv.env['MOCK_PASSWORD'] ?? '';
  static final String mockToken = dotenv.env['MOCK_TOKEN'] ?? '';
}