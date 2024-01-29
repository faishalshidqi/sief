import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sief_firebase/common/navigation.dart';
import 'package:sief_firebase/common/styles.dart';
import 'package:sief_firebase/data/model/stock.dart';
import 'package:sief_firebase/data/model/supplier.dart';
import 'package:sief_firebase/firebase_options.dart';
import 'package:sief_firebase/provider/homepage_provider.dart';
import 'package:sief_firebase/provider/login_provider.dart';
import 'package:sief_firebase/provider/report_provider.dart';
import 'package:sief_firebase/provider/stock_detail_provider.dart';
import 'package:sief_firebase/provider/stocks_provider.dart';
import 'package:sief_firebase/provider/supplier_detail_provider.dart';
import 'package:sief_firebase/provider/suppliers_provider.dart';
import 'package:sief_firebase/provider/users_provider.dart';
import 'package:sief_firebase/ui/dashboard_page.dart';
import 'package:sief_firebase/ui/inventory_report_page.dart';
import 'package:sief_firebase/ui/login_page.dart';
import 'package:sief_firebase/ui/stock_detail_page.dart';
import 'package:sief_firebase/ui/stock_form_page.dart';
import 'package:sief_firebase/ui/stocks_list_page.dart';
import 'package:sief_firebase/ui/supplier_detail_page.dart';
import 'package:sief_firebase/ui/supplier_form_page.dart';
import 'package:sief_firebase/ui/suppliers_list_page.dart';
import 'package:sief_firebase/ui/user_form_page.dart';
import 'package:sief_firebase/ui/users_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final _auth = FirebaseAuth.instance;
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => UsersProvider()),
        ChangeNotifierProvider(create: (_) => SuppliersProvider()),
        ChangeNotifierProvider(create: (_) => SupplierDetailProvider()),
        ChangeNotifierProvider(create: (_) => StocksProvider()),
        ChangeNotifierProvider(create: (_) => StockDetailProvider()),
        ChangeNotifierProvider(create: (_) => HomepageProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
      ],
      child: MaterialApp(
        title: 'Sistem Inventaris Erwin Furniture',
        navigatorKey: navigatorKey,
        theme: ThemeData(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: primaryColor,
                onPrimary: Colors.black,
                secondary: secondaryColor,
              ),
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          textTheme: siefTextTheme,
          appBarTheme: const AppBarTheme(elevation: 10),
        ),
        home: EasySplashScreen(
          backgroundColor: primaryColor100,

          /// https://cdn4.iconfinder.com/data/icons/pixel-perfect-at-24px-volume-2/24/2092-1024.png
          logo: Image.asset('assets/storage.png'),
          title: Text(
            'SIEF',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          showLoader: true,
          loadingText: Text(
            'Memuat Sistem...',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          navigator: _auth.currentUser != null
              ? const DashboardPage()
              : const LoginPage(),
          //durationInSeconds: 5,
        ),
        initialRoute: '/',
        routes: {
          LoginPage.routeName: (context) => const LoginPage(),
          DashboardPage.routeName: (context) => const DashboardPage(),
          SuppliersListPage.routeName: (context) => const SuppliersListPage(),
          SupplierFormPage.routeName: (context) => const SupplierFormPage(),
          SupplierDetailPage.routeName: (context) => SupplierDetailPage(
                supplier:
                    ModalRoute.of(context)?.settings.arguments as Supplier,
              ),
          StocksListPage.routeName: (context) => const StocksListPage(),
          StockFormPage.routeName: (context) => const StockFormPage(),
          StockDetailPage.routeName: (context) => StockDetailPage(
                stock: ModalRoute.of(context)?.settings.arguments as Stock,
              ),
          UsersListPage.routeName: (context) => const UsersListPage(),
          UserFormPage.routeName: (context) => const UserFormPage(),
          InventoryReportPage.routeName: (context) =>
              const InventoryReportPage(),
        },
      ),
    );
  }
}
