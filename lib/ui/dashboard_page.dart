import 'package:flutter/material.dart';
import 'package:sief_firebase/common/styles.dart';
import 'package:sief_firebase/ui/home_page.dart';
import 'package:sief_firebase/ui/settings_page.dart';

class DashboardPage extends StatefulWidget {
  static const routeName = '/dashboard';
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _bottamNavIndex = 0;
  final List<BottomNavigationBarItem> _bottomNavBarItem = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home_filled),
      label: 'Beranda',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Pengaturan',
    ),
  ];
  final List<Widget> _widgetList = [
    const HomePage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetList[_bottamNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 30,
        backgroundColor: Colors.white,
        currentIndex: _bottamNavIndex,
        selectedItemColor: primaryColor500,
        items: _bottomNavBarItem,
        onTap: (selected) => setState(() {
          _bottamNavIndex = selected;
        }),
      ),
    );
  }
}
