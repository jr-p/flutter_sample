import 'package:flutter_sample/src/providers/auth_provider.dart';
import 'package:flutter_sample/src/utils/dialog_utils.dart';
import 'package:flutter_sample/src/utils/route_utils.dart';
import 'package:flutter_sample/src/utils/snackbar_utils.dart';
import 'package:flutter_sample/src/widgets/common_app_bar.dart';
import 'package:flutter_sample/src/widgets/common_app_icon.dart';
import 'package:flutter_sample/src/widgets/common_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 登録確認画面
class RegisterComfirmScreen extends StatefulWidget {
  final Map<String, String> arguments;

  const RegisterComfirmScreen({
    super.key,
    required this.arguments
  });

  @override
  State<RegisterComfirmScreen> createState() => _RegisterComfirmScreenState();
}

class  _RegisterComfirmScreenState extends State<RegisterComfirmScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    // 各 Controller に初期値を設定
    _nameController = TextEditingController(text: widget.arguments['name']);
    _emailController = TextEditingController(text: widget.arguments['email']);
    _phoneNumberController = TextEditingController(text: widget.arguments['phone_number']);
    _passwordController = TextEditingController(text: widget.arguments['password']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }
  
  // パスワードの表示を隠すために、最後の文字以外を*に変換する
  String _maskPassword(String password) {
    return '*' * (password.length);
  } 

  @override
  Widget build(BuildContext context) {
    // 登録処理
    void register() async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final name = _nameController.text;
      final email = _emailController.text;
      final phoneNumber = _phoneNumberController.text;
      final password = _passwordController.text;

      // ローディングダイアログを表示
      DialogUtils.showLoadingDialog(context);
      // 登録メソッドを呼び出す
      await authProvider.register(name, email, phoneNumber, password);

      if (!context.mounted) return;
      // エラーメッセージがある場合は、SnackBar で表示
      if (authProvider.message != null) {
        SnackbarUtils.showSnackbar(context, authProvider.message!);
      } else {
        RouteUtils.navigateToAuthWrapper(context);
      }
    }

    return Scaffold(
      appBar: const CommonAppBar(title: 'Register Confrim'),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const CommonAppIcon(size: 100),
            const SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildConfirmationRow('Name', _nameController.text),
                  const SizedBox(height: 15),
                  _buildConfirmationRow('Email', _emailController.text),
                  const SizedBox(height: 15),
                  _buildConfirmationRow('Phone Number', _phoneNumberController.text),
                  const SizedBox(height: 15),
                  _buildConfirmationRow('Password', _maskPassword(_passwordController.text)),
                  const SizedBox(height: 50),
                  CommonButton(
                    text: 'Register',
                    onPressed: register,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // 確認画面の行を作成する
  Widget _buildConfirmationRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ],
      )
    );
  }
}
