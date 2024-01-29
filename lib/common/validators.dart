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

String? validateEmail(value) {
  validateNotEmpty(value);
  RegExp regExp = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );
  if (!regExp.hasMatch(value)) {
    return 'Masukkan Alamat Email Yang Valid';
  } else {
    return null;
  }
}

String? validatePhoneNumber(value) {
  validateNotEmpty(value);
  RegExp regExp =
      RegExp(r'(^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$)');
  if (!regExp.hasMatch(value)) {
    return 'Masukkan Nomor Telepon Yang Valid';
  } else {
    return null;
  }
}
