import 'dart:async';

class LoginValidators {
  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.isEmpty || email.contains("@")) {
      sink.add(email);
    } else {
      sink.addError("Insira um email Valido!");
    }
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.isEmpty || password.length > 4) {
      sink.add(password);
    } else {
      sink.addError("Senha Invalida!, deve contar pelo menos 4 caracteres ");
    }
  });
}
