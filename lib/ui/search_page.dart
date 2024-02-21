import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sief_firebase/common/styles.dart';
import 'package:sief_firebase/common/validators.dart';
import 'package:sief_firebase/components/custom_appbar.dart';
import 'package:sief_firebase/components/input_layout.dart';
import 'package:sief_firebase/provider/search_provider.dart';

class SearchPage extends StatelessWidget {
  static const routeName = '/search';
  static final _formKey = GlobalKey<FormState>();
  final String sourceRouteName;
  const SearchPage({super.key, required this.sourceRouteName});

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, state, _) {
        return Scaffold(
          appBar: customAppBar(title: 'Pencarian'),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      decoration: customInputDecoration('Pencarian'),
                      validator: validateNotEmpty,
                      onChanged: (String query) {
                        state.updateQuery(query);
                      },
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 15),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor100,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.pushReplacementNamed(
                            context,
                            sourceRouteName,
                            arguments: state.query,
                          );
                        }
                      },
                      child: const Text('Cari'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
