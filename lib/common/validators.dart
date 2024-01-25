String? notEmptyValidator(value) {
  if (value == null || value.isEmpty) {
    return 'Tidak Boleh Kosong';
  }
  return null;
}

String? comparePassAndRepeatPass(String password, String repeatPassword) {
  if (password != repeatPassword) {
    return 'Kata Sandi Tidak Sama';
  }
  return null;
}
