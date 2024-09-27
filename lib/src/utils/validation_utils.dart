class ValidationUtils {
  // 名前のバリデーション
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nameを入力してください';
    } else if (value.length > 64) {
      return 'Nameは64文字以内で入力してください';
    }
    return null;
  }

  // メールアドレスのバリデーション
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Emailを入力してください';
    }
    String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regExp = RegExp(emailPattern);
    if (!regExp.hasMatch(value)) {
      return 'Emailの形式が正しくありません';
    }
    return null;
  }

  // 電話番号のバリデーション
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone Numberを入力してください';
    }
    String phonePattern = r'^[0-9]+$';
    RegExp regExp = RegExp(phonePattern);
    if (!regExp.hasMatch(value)) {
      return 'Phone Numberは数字のみで入力してください';
    }
    return null;
  }

  // パスワードのバリデーション
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Passwordを入力してください';
    }
    return null;
  }

  // パスワード確認のバリデーション
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Confirm Passwordを入力してください';
    } else if (value != password) {
      return 'Passwordが一致しません';
    }
    return null;
  }
}