String? validateNotEmpty(value) {
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

String? validateLength(String? value, int? length) {
  validateNotEmpty(value);
  if (value!.length == length!) {
    return 'Tidak Boleh Lebih Dari $length karakter';
  }
  return null;
}
