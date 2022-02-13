
import 'package:flutter/material.dart';
import 'package:flutterassement/data_model/country_model.dart';

class CountriesListView extends StatelessWidget {
  final List<Countries> countryList;
  final String? languageName;
  const CountriesListView({Key? key,required this.countryList,this.languageName = ""}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: countryList.length,
        itemBuilder: (context, index) {
          final countryName = countryList[index].name!;
          return ListTile(
            title: Center(child: Text(countryName)),
            subtitle: Center(child: Text(languageName!)),
          );
        });
  }
}
