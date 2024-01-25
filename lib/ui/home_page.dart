import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sief_firebase/common/styles.dart';
import 'package:sief_firebase/components/custom_appbar.dart';
import 'package:sief_firebase/provider/homepage_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Beranda'),
      body: Consumer<HomepageProvider>(
        builder: (context, state, _) {
          state.getAccount();
          return SafeArea(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              children: state.itemList.map((item) {
                return InkWell(
                  child: Card(
                    color: primaryColor100,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        children: [
                          Expanded(
                            child: Icon(
                              item.icon,
                              size: 70,
                            ),
                          ),
                          Text(
                            item.title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, item.routeName);
                  },
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
