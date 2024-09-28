class Validator {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'O nome é obrigatório.';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    final cleanValue = value?.replaceAll(RegExp(r'\D'), '');

    if (cleanValue == null || cleanValue.length != 11) {
      return 'Telefone inválido.';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || !value.contains('@') || !value.contains('.')) {
      return 'E-mail inválido.';
    }
    return null;
  }
}
