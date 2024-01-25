import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sief_firebase/common/styles.dart';
import 'package:sief_firebase/common/validators.dart';
import 'package:sief_firebase/components/custom_appbar.dart';
import 'package:sief_firebase/components/custom_coming_soon_dialog.dart';
import 'package:sief_firebase/components/input_layout.dart';
import 'package:sief_firebase/provider/login_provider.dart';
import 'package:sief_firebase/ui/dashboard_page.dart';

class LoginPage extends StatelessWidget {
  static const routeName = '/home';
  static final _auth = FirebaseAuth.instance;
  static final _formKey = GlobalKey<FormState>();
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Halaman Login'),
      body: SafeArea(
        child: Consumer<LoginProvider>(
          builder: (context, state, _) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          InputLayout(
                            'Email',
                            TextFormField(
                              decoration: customInputDecoration(
                                'Alamat email Anda yang terdaftar',
                              ),
                              onChanged: (String value) {
                                state.updateEmail(value);
                              },
                              validator: notEmptyValidator,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          InputLayout(
                            'Kata Sandi',
                            TextFormField(
                              decoration: customInputDecoration(
                                'Kata Sandi Anda',
                                suffixIcon: IconButton(
                                  onPressed: () => state.updatePasswordObscure(
                                    !state.isPasswordObscured,
                                  ),
                                  icon: const Icon(Icons.remove_red_eye),
                                ),
                              ),
                              obscureText: state.isPasswordObscured,
                              onChanged: (String value) {
                                state.updatePassword(value);
                              },
                              validator: notEmptyValidator,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 20),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor100,
                              ),
                              child: Text(
                                'Masuk',
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    await _auth.signInWithEmailAndPassword(
                                      email: state.email!,
                                      password: state.password!,
                                    );
                                    if (!context.mounted) return;
                                    Navigator.pushReplacementNamed(
                                      context,
                                      DashboardPage.routeName,
                                    );
                                  } catch (error) {
                                    customInfoDialog(context: context,
                                        title: 'Error!',
                                        content: error.toString(),);
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
