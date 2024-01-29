import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sief_firebase/components/custom_appbar.dart';
import 'package:sief_firebase/components/custom_coming_soon_dialog.dart';
import 'package:sief_firebase/ui/login_page.dart';

class SettingsPage extends StatelessWidget {
  static final _auth = FirebaseAuth.instance;
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Halaman Pengaturan'),
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Mode Tampilan Gelap'),
              trailing: Switch.adaptive(
                value: false,
                activeColor: Colors.green,
                onChanged: (value) async {
                  customInfoDialog(context: context);
                },
              ),
            ),
            ListTile(
              title: const Text('Keluar'),
              trailing: const Icon(Icons.logout),
              onTap: () async {
                try {
                  await _auth.signOut();
                  if (!context.mounted) return;
                  Navigator.pushReplacementNamed(context, LoginPage.routeName);
                } catch (error) {
                  final snackBar = SnackBar(
                    content: Text(error.toString()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
